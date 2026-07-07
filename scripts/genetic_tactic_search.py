#!/usr/bin/env python3
"""Genetic tactic search — exploratory, off-ledger. See docs/genetic-tactic-search.md.

Evolves short Lean 4 tactic sequences against a single named warm-up target
in procint/ProcInt/Playground/TacticSearchWarmup.lean (or another file passed
via --file). Fitness is binary Lean-kernel acceptance of a scratch candidate
file, invoked via `lake env lean` — never an LLM self-report or heuristic
estimate. A secondary shaping term breaks ties among kernel-accepted
candidates in favor of shorter sequences drawn more heavily from
EXPERT_WEIGHTED tactics (the tactics reported to correlate with proof success
in arXiv:2604.24354 — a shaping preference only, not a substitute signal).

This script never writes to packs/*/fragments/*.ttl and never promotes a
target's status. It only reports kernel-accepted tactic sequences for a
human to review and, if warranted, hand-splice into the ledgered source.

Usage:
    python3 scripts/genetic_tactic_search.py <target-id> [options]

    target-id    the id after "SEARCH_TARGET:" in the target file, e.g.
                 nat_add_comm, list_length_append, reach_refl

Options:
    --file PATH        target file, relative to procint/
                        (default: ProcInt/Playground/TacticSearchWarmup.lean)
    --population N      genomes per generation (default: 12)
    --generations N      generation count (default: 8)
    --max-len N          max tactics per genome (default: 3)
    --seed N            RNG seed for reproducible runs (default: unset/random)
    --out PATH           run log (default: .tactic-search/<target-id>.jsonl)
"""
import argparse
import json
import os
import random
import re
import subprocess
import sys
import uuid

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROCINT_DIR = os.path.join(ROOT, "procint")
LAKE = "/Users/sac/.elan/bin/lake"  # absolute elan shim, off $PATH by design

# Small, hand-vetted vocabulary — no LLM-proposed tactics in v1 (see
# docs/genetic-tactic-search.md on the Lean 3/4 syntax-confusion risk in
# LLM-generated tactic text, arXiv:2503.13620).
TACTIC_VOCAB = [
    "aesop", "simp", "omega", "decide", "rfl", "trivial",
    "constructor", "intro x", "rcases x with x | x",
]

# Tactics weighted higher in the tie-breaking shaping term, per the
# expert-pattern-conformance finding in arXiv:2604.24354.
EXPERT_WEIGHTED = {"aesop", "simp", "omega"}

SEARCH_TARGET_RE = re.compile(r"^-- SEARCH_TARGET: (\S+)\s*$")


def find_target(file_text, target_id):
    """Locate the theorem block for `target_id`: returns (before, indent, after)
    where `before` + <tactics> + `after` reconstructs the file with the
    theorem's `sorry` body replaced."""
    lines = file_text.splitlines(keepends=True)
    marker_idx = None
    for i, line in enumerate(lines):
        m = SEARCH_TARGET_RE.match(line.strip("\n"))
        if m and m.group(1) == target_id:
            marker_idx = i
            break
    if marker_idx is None:
        raise SystemExit(f"REFUSED: no SEARCH_TARGET marker '{target_id}' found")

    # Find the "by\n  sorry" (or "by sorry") block after the marker.
    sorry_idx = None
    for i in range(marker_idx, len(lines)):
        if re.search(r"\bsorry\b", lines[i]):
            sorry_idx = i
            break
    if sorry_idx is None:
        raise SystemExit(f"REFUSED: no 'sorry' found after SEARCH_TARGET '{target_id}'")

    indent_match = re.match(r"^(\s*)", lines[sorry_idx])
    indent = indent_match.group(1) if indent_match else "  "
    before = "".join(lines[:sorry_idx])
    after = "".join(lines[sorry_idx + 1:])
    return before, indent, after


def random_genome(max_len, rng):
    n = rng.randint(1, max_len)
    return [rng.choice(TACTIC_VOCAB) for _ in range(n)]


def mutate(genome, max_len, rng):
    genome = list(genome)
    op = rng.choice(["replace", "add", "remove"])
    if op == "replace" and genome:
        i = rng.randrange(len(genome))
        genome[i] = rng.choice(TACTIC_VOCAB)
    elif op == "add" and len(genome) < max_len:
        genome.insert(rng.randrange(len(genome) + 1), rng.choice(TACTIC_VOCAB))
    elif op == "remove" and len(genome) > 1:
        del genome[rng.randrange(len(genome))]
    return genome


def crossover(a, b, rng):
    if not a or not b:
        return list(a or b)
    cut_a = rng.randrange(len(a))
    cut_b = rng.randrange(len(b))
    return a[:cut_a] + b[cut_b:]


def shaping_score(genome):
    """Tie-breaker only: never overrides kernel accept/reject. Rewards
    shorter genomes drawn more heavily from EXPERT_WEIGHTED tactics."""
    expert_frac = sum(1 for t in genome if t in EXPERT_WEIGHTED) / len(genome)
    return expert_frac - 0.05 * len(genome)


def check_candidate(before, indent, after, tactics, procint_relpath):
    """Splice `tactics` into a scratch copy of the target file and check
    kernel acceptance via `lake env lean`. Returns (accepted: bool, stderr: str)."""
    body = "\n".join(f"{indent}{t}" for t in tactics)
    candidate_text = before + body + "\n" + after

    scratch_name = f"_scratch_{uuid.uuid4().hex[:12]}.lean"
    scratch_relpath = os.path.join(os.path.dirname(procint_relpath), scratch_name)
    scratch_abspath = os.path.join(PROCINT_DIR, scratch_relpath)
    with open(scratch_abspath, "w") as f:
        f.write(candidate_text)

    try:
        proc = subprocess.run(
            [LAKE, "env", "lean", scratch_relpath],
            cwd=PROCINT_DIR,
            capture_output=True,
            text=True,
            timeout=120,
        )
        return proc.returncode == 0, proc.stderr.strip()
    except subprocess.TimeoutExpired:
        return False, "TIMEOUT"
    finally:
        os.remove(scratch_abspath)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("target_id")
    ap.add_argument("--file", default="ProcInt/Playground/TacticSearchWarmup.lean")
    ap.add_argument("--population", type=int, default=12)
    ap.add_argument("--generations", type=int, default=8)
    ap.add_argument("--max-len", type=int, default=3)
    ap.add_argument("--seed", type=int, default=None)
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    rng = random.Random(args.seed)

    target_abspath = os.path.join(PROCINT_DIR, args.file)
    if not os.path.exists(target_abspath):
        raise SystemExit(f"REFUSED: target file not found: {args.file}")
    file_text = open(target_abspath).read()
    before, indent, after = find_target(file_text, args.target_id)

    out_path = args.out or os.path.join(ROOT, ".tactic-search", f"{args.target_id}.jsonl")
    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    population = [random_genome(args.max_len, rng) for _ in range(args.population)]
    best = None  # (genome, shaping_score)
    accepted_count = 0

    with open(out_path, "w") as log:
        for gen in range(args.generations):
            scored = []
            for genome in population:
                accepted, stderr = check_candidate(before, indent, after, genome, args.file)
                score = None
                if accepted:
                    accepted_count += 1
                    score = shaping_score(genome)
                scored.append((genome, accepted, score))
                log.write(json.dumps({
                    "generation": gen,
                    "target": args.target_id,
                    "genome": genome,
                    "kernel_accepted": accepted,
                    "shaping_score": score,
                    "stderr_head": stderr[:300] if not accepted else "",
                }) + "\n")
                log.flush()
                if score is not None and (best is None or score > best[1]):
                    best = (genome, score)

            print(f"generation {gen}: {sum(1 for _, a, _ in scored if a)}/{len(scored)} kernel-accepted"
                  f"{'  best so far: ' + ' '.join(best[0]) if best else ''}")

            if best is not None:
                break  # stop at first kernel-accepted candidate; this is a warm-up search, not exhaustive optimization

            # Next generation: mutate/crossover survivors (here: whole population, since none accepted yet)
            next_population = []
            while len(next_population) < args.population:
                a, b = rng.choice(population), rng.choice(population)
                child = mutate(crossover(a, b, rng), args.max_len, rng)
                next_population.append(child)
            population = next_population

    print(f"\nlog: {out_path}")
    if best is not None:
        print(f"KERNEL_ACCEPTED: {' '.join(best[0])}")
        print("This is a Candidate, not an Admission — promotion to the ledger "
              "(TTL status stated->proven) requires human review, see "
              "docs/genetic-tactic-search.md.")
        return 0
    else:
        print(f"NO_ACCEPTED_CANDIDATE after {args.generations} generations "
              f"({accepted_count} total kernel-accepts across all attempts)")
        return 1


if __name__ == "__main__":
    sys.exit(main())
