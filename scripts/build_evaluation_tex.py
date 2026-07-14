#!/usr/bin/env python3
"""Regenerate paper/evaluation.tex's derived tables/numbers from
release/release-manifest.json.

Never hand-edit paper/evaluation.tex's tables or foldHash mention directly
(see AGENTS.md: "Never manually write release counts... these come only
from generated files"). This script is the missing builder that
paper/evaluation.tex's own header comment already asks for
("If this file is stale relative to release-manifest.json, regenerate
before submission") — previously undocumented/unimplemented.

Only rewrites the two derived tables (corpus size, axiom footprint) and the
foldHash mention in the Certification paragraph. Leaves the free-form
prose paragraphs (stated declarations, fixtures, wall-clock narrative)
untouched, since those describe specific historical events, not values
purely computed from the current manifest snapshot.
"""

import collections
import json
import os
import re
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(ROOT, "release/release-manifest.json")
EVAL_TEX = os.path.join(ROOT, "paper/evaluation.tex")


def lines_of_lean() -> int:
    out = subprocess.run(
        ["find", os.path.join(ROOT, "procint/ProcInt"), "-name", "*.lean"],
        capture_output=True, text=True, check=True,
    ).stdout.splitlines()
    total = 0
    for path in out:
        with open(path, encoding="utf-8") as f:
            total += sum(1 for _ in f)
    return total


def module_count() -> int:
    ontology = os.path.join(ROOT, "packs/lean-math-pack/ontology.ttl")
    with open(ontology, encoding="utf-8") as f:
        text = f.read()
    return len(set(re.findall(r"procint:moduleId\s+\"([^\"]+)\"", text)))


def axiom_label(axioms: tuple[str, ...]) -> str:
    if not axioms:
        return "No axioms"
    return ", ".join(f"\\texttt{{{a}}}" for a in axioms)


def main() -> None:
    with open(MANIFEST, encoding="utf-8") as f:
        manifest = json.load(f)

    artifacts = manifest["artifacts"]
    proven = [a for a in artifacts if a["proven"]]
    stated = manifest["statedNotProven"]
    total_decls = len(artifacts)
    n_proven = len(proven)
    n_stated = len(stated)
    n_defs = total_decls - n_proven - n_stated

    axiom_groups = collections.Counter(tuple(sorted(a["axioms"])) for a in proven)
    unauthorized = sum(
        1 for a in proven
        if any(ax not in ("propext", "Classical.choice", "Quot.sound") for ax in a["axioms"])
    )

    fold_hash = manifest["foldHash"]
    fold_prefix_short = fold_hash[:8]
    fold_prefix_long = fold_hash[:16]

    axiom_rows = "\n".join(
        f"{axiom_label(k)} & {v} \\\\"
        for k, v in sorted(axiom_groups.items(), key=lambda kv: (len(kv[0]), kv[0]))
    )

    with open(EVAL_TEX, encoding="utf-8") as f:
        text = f.read()

    # --- Table 1: corpus size ---
    text = re.sub(
        r"(Declarations recorded in the ontology & )\d+( \\\\)",
        rf"\g<1>{total_decls}\g<2>",
        text,
    )
    text = re.sub(
        r"(Modules & )\d+( \\\\)",
        rf"\g<1>{module_count()}\g<2>",
        text,
    )
    text = re.sub(
        r"(Theorems kernel-admitted and axiom-audited \(\\emph\{proven\}\) & )\d+( \\\\)",
        rf"\g<1>{n_proven}\g<2>",
        text,
    )
    text = re.sub(
        r"(Statements formalized but not discharged \(\\emph\{stated\}\) & )\d+( \\\\)",
        rf"\g<1>{n_stated}\g<2>",
        text,
    )
    text = re.sub(
        r"(Definitions, structures, and test oracles & )\d+( \\\\)",
        rf"\g<1>{n_defs}\g<2>",
        text,
    )
    text = re.sub(
        r"(Lines of Lean \(\\texttt\{ProcInt/\}\) & )[\d{,}]+( \\\\)",
        rf"\g<1>{lines_of_lean():,}".replace(",", "{,}") + r"\g<2>",
        text,
    )

    # --- Table 2: axiom footprint (rebuild the four data rows in full) ---
    # Use a function repl, not a string: axiom_rows contains literal LaTeX
    # backslashes (`\texttt{...}`), and re.sub's *string* repl argument
    # decodes backslash-escapes (`\t` -> tab), silently corrupting them.
    text = re.sub(
        r"(Axiom footprint of proven theorems & Count \\\\\n\\midrule\n).*?(\n\\midrule)",
        lambda m: f"{m.group(1)}{axiom_rows}{m.group(2)}",
        text,
        flags=re.DOTALL,
    )
    text = re.sub(
        r"(Total proven & )\d+( \\\\)",
        rf"\g<1>{n_proven}\g<2>",
        text,
    )
    text = re.sub(
        r"(Unauthorized axioms found & )\d+( \\\\)",
        rf"\g<1>{unauthorized}\g<2>",
        text,
    )
    text = re.sub(
        r"(Axiom-audit result over all )\d+( proven theorems\.)",
        rf"\g<1>{n_proven}\g<2>",
        text,
    )

    # --- Certification paragraph: foldHash mention ---
    text = re.sub(
        r"(folded over all )\d+( artifact hashes)",
        rf"\g<1>{total_decls}\g<2>",
        text,
    )
    # The seed string embeds the release version (mirroring build_manifest.py's
    # `f'mfact-{RELEASE}-genesis'`, exactly) and must be re-derived from the
    # manifest on every regen, not just the trailing hash — otherwise the
    # paper misstates the actual construction formula used to fold the hash.
    text = re.sub(
        r"(BLAKE3, folded over all \d+ artifact hashes\s*\n?in name order, seed \\texttt\{\")"
        r"mfact-v[\d.]+-genesis"
        r"(\"\}\) is\s*\n?\\texttt\{)[0-9a-f.]+(\})",
        rf"\g<1>mfact-{manifest['release']}-genesis\g<2>{fold_prefix_short}...{fold_hash[-6:]}\g<3>",
        text,
    )

    with open(EVAL_TEX, "w", encoding="utf-8") as f:
        f.write(text)

    print(
        f"evaluation.tex regenerated: total_decls={total_decls} proven={n_proven} "
        f"stated={n_stated} defs={n_defs} foldHash={fold_prefix_long}..."
    )


if __name__ == "__main__":
    main()
