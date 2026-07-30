#!/usr/bin/env python3
"""Static refusal checks for the wasm4pm correspondence projection."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / "ggen.toml"
CATALOG = ROOT / "packs/lean-math-pack/fragments/verif.ttl"
TEMPLATES = [
    ROOT / "packs/lean-math-pack/templates/verif_model.lean.tmpl",
    ROOT / "packs/lean-math-pack/templates/verif_abs.lean.tmpl",
    ROOT / "packs/lean-math-pack/templates/corr_module.lean.tmpl",
]
SOURCE_COMMIT = "bec4087ad8a91d314e07d03b04303a215a4722a3"
VERIF_ONTOLOGY = "packs/lean-math-pack/fragments/verif.ttl"


def refuse(condition: bool, code: str) -> None:
    if condition:
        print(code, file=sys.stderr)
        raise SystemExit(1)


def main() -> int:
    config = CONFIG.read_text(encoding="utf-8")
    refuse(VERIF_ONTOLOGY not in config, "VERIF_ONTOLOGY_NOT_ADMITTED")

    catalog = CATALOG.read_text(encoding="utf-8")
    refuse("verif:obligationStatement" in catalog, "HANDWRITTEN_PROOF_BODY_REFUSED")
    refuse(
        'verif:proofPattern "ReplayCountsExactFitness"' not in catalog,
        "PROOF_PATTERN_MISSING",
    )
    refuse(
        f'verif:sourceCommit "{SOURCE_COMMIT}"' not in catalog,
        "SOURCE_COMMIT_UNPINNED",
    )

    outputs: set[str] = set()
    for template in TEMPLATES:
        refuse(not template.is_file(), f"TEMPLATE_MISSING:{template.name}")
        text = template.read_text(encoding="utf-8")
        refuse("ReplayCountsExactFitness" not in text, f"PATTERN_NOT_CONSUMED:{template.name}")
        refuse(
            "{% for row in obligation %}" not in text,
            f"SPARQL_ROW_NOT_ITERATED:{template.name}",
        )
        output_lines = [line for line in text.splitlines() if line.startswith('to: "')]
        refuse(len(output_lines) != 1, f"OUTPUT_OWNERSHIP_INVALID:{template.name}")
        output = output_lines[0]
        refuse(output in outputs, f"DUPLICATE_OUTPUT_OWNER:{output}")
        outputs.add(output)

    materializer = (ROOT / "scripts/verif_materialize.sh").read_text(encoding="utf-8")
    refuse("SRC_ROOT" not in materializer, "PARTIAL_TREE_MATERIALIZER_REFUSED")
    refuse("VERIF_MATERIALIZE_DRIFT_REFUSED" not in materializer, "DRIFT_GATE_MISSING")

    print("verif-codegen-contract: GREEN")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
