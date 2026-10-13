#!/usr/bin/env python3
"""lean-witness/v1 producer (L139): emits /Users/sac/mfact/witnesses.jsonl.

For each Petri module's main theorem, runs a tiny Lean driver through
`lake env lean` whose only job is `#print axioms <theorem>` — the axiom
footprint comes from Lean itself, never a hardcoded list. Emits one JSON
line per theorem: schema, theorem, axioms, source_sha256 (sha256 of the
module .lean file), toolchain (from lean-toolchain).

Validation step mirrors the castle adapter gate: every line's axioms must
be a subset of {propext, Classical.choice, Quot.sound}; any extra axiom
(e.g. sorryAx) fails the run.

Usage: python3 scripts/witness_receipt.py
       python3 scripts/witness_receipt.py --ocel witnesses_ocel.json

Additive OCEL emission (L188): `--ocel PATH` also writes an OcelEvent batch
alongside the lean-witness JSONL — one `lean.witness` event per witness line,
same source of truth (the same 5-6 witness dicts), with
attributes {theorem, axioms_count, source_sha256} and a `module`
relationship. `--from-jsonl PATH` re-emits the OCEL batch from an existing
witnesses.jsonl without re-running the Lean driver.

Usage: python3 scripts/witness_receipt.py --from-jsonl witnesses.jsonl --ocel out.json
"""
import argparse
import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PROCINT = ROOT / "procint"
TOOLCHAIN = (PROCINT / "lean-toolchain").read_text().strip()

ADMITTED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}

# module -> main theorem
# (module, fully-qualified theorem)
TARGETS = [
    ("ProcInt.Petri.PN64Conservation", "ProcInt.PN64.pn64_sequence_conserves"),
    ("ProcInt.Petri.ForkChoice", "ProcInt.head_unique"),
    ("ProcInt.Petri.NetLaws", "ProcInt.StrataNet.mempool_capacity"),
    ("ProcInt.Petri.JournalReplay", "ProcInt.StrataStore.recover_after_crash"),
    ("ProcInt.Petri.LedgerConservation", "ProcInt.StrataLedger.strata_ledger_total_value_conserved"),
    ("ProcInt.Petri.MerkleCompleteness", "ProcInt.StrataMerkle.merkle_inclusion_complete"),
]

WITNESS_FILE = ROOT / "witnesses.jsonl"


def procint_run(cmd: list[str]) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, cwd=PROCINT, capture_output=True, text=True, timeout=600)


def run_lean_driver(module: str, theorem: str) -> str:
    """Run `#print axioms <theorem>` for a module via lake env lean; return output."""
    driver_path = PROCINT / ".witness_driver.lean"
    driver_path.write_text(f"import {module}\n#print axioms {theorem}\n")
    try:
        proc = procint_run(["lake", "env", "lean", str(driver_path)])
    finally:
        driver_path.unlink(missing_ok=True)
    if proc.returncode != 0:
        raise RuntimeError(
            f"lean driver failed for {module}#{theorem} (rc={proc.returncode}):\n"
            f"{proc.stdout}\n{proc.stderr}"
        )
    return proc.stdout + proc.stderr


def parse_axioms(output: str, theorem: str) -> list[str]:
    """Parse `#print axioms` output: "'thm' depends on axioms: [a, b]" or
    "'thm' does not depend on any axioms"."""
    for line in output.splitlines():
        line = line.strip()
        if f"'{theorem}' does not depend on any axioms" in line:
            return []
        if line.startswith(f"'{theorem}' depends on axioms:"):
            body = line.split("depends on axioms:", 1)[1].strip()
            if body.startswith("[") and body.endswith("]"):
                body = body[1:-1]
            return [a.strip() for a in body.split(",") if a.strip()]
    raise RuntimeError(f"no #print axioms line for {theorem} in:\n{output}")


def module_sha256(module: str) -> str:
    path = ROOT / "procint" / "ProcInt" / "Petri" / (module.rsplit(".", 1)[1] + ".lean")
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_witnesses() -> list[dict]:
    witnesses = []
    for module, theorem in TARGETS:
        output = run_lean_driver(module, theorem)
        axioms = parse_axioms(output, theorem)
        witnesses.append(
            {
                "schema": "lean-witness/v1",
                "theorem": theorem,
                "axioms": axioms,
                "source_sha256": module_sha256(module),
                "toolchain": TOOLCHAIN,
            }
        )
    return witnesses


def validate(witnesses: list[dict]) -> None:
    for w in witnesses:
        extra = set(w["axioms"]) - ADMITTED_AXIOMS
        if extra:
            raise RuntimeError(
                f"AXIOM GATE FAIL {w['theorem']}: extra axioms {sorted(extra)} "
                f"(not subset of {sorted(ADMITTED_AXIOMS)})"
            )


def module_for_theorem(theorem: str) -> str:
    for module, thm in TARGETS:
        if thm == theorem:
            return module
    raise RuntimeError(f"no module known for theorem {theorem}")


def ocel_batch(witnesses: list[dict]) -> dict:
    """Project the same witness dicts into an OcelEvent batch (lean.witness
    event family). One event per witness line; the module relationship gives
    the process object the event belongs to."""
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    events = []
    for w in witnesses:
        theorem = w["theorem"]
        events.append(
            {
                "event_id": f"lean.witness:{theorem}",
                "event_type": "lean.witness",
                "event_time": now,
                "attributes": {
                    "theorem": theorem,
                    "axioms_count": len(w["axioms"]),
                    "source_sha256": w["source_sha256"],
                },
                "relationships": [
                    {"qualifier": "module", "object_id": module_for_theorem(theorem)}
                ],
            }
        )
    return {"events": events}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ocel", metavar="PATH", help="also write an OcelEvent batch (lean.witness) to PATH")
    parser.add_argument(
        "--from-jsonl",
        metavar="PATH",
        help="re-emit the OCEL batch from an existing witnesses.jsonl instead of re-running Lean",
    )
    args = parser.parse_args()

    if not args.ocel:
        # Legacy behavior unchanged: run the Lean driver, write witnesses.jsonl.
        witnesses = build_witnesses()
        validate(witnesses)
        WITNESS_FILE.write_text(
            "".join(json.dumps(w, separators=(",", ":")) + "\n" for w in witnesses)
        )
        print(f"wrote {len(witnesses)} witnesses to {WITNESS_FILE}")
        for w in witnesses:
            print(json.dumps(w, separators=(",", ":")))
        return 0

    if args.from_jsonl:
        witnesses = [
            json.loads(line)
            for line in Path(args.from_jsonl).read_text().splitlines()
            if line.strip()
        ]
    else:
        witnesses = build_witnesses()
        validate(witnesses)
        WITNESS_FILE.write_text(
            "".join(json.dumps(w, separators=(",", ":")) + "\n" for w in witnesses)
        )

    batch = ocel_batch(witnesses)
    Path(args.ocel).write_text(json.dumps(batch, indent=2) + "\n")
    print(f"wrote {len(batch['events'])} lean.witness OcelEvents to {args.ocel}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
