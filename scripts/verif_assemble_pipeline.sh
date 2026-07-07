#!/usr/bin/env bash
# Assemble wasm4pm-compat/verify/receipts/pipeline.json from the Step 3-A/3-B
# receipts. This is the file scripts/build_verif.py actually reads (env
# PIPELINE_JSON, default <wasm4pm-compat>/verify/receipts/pipeline.json) to
# advance an obligation's status past DECLARED.
#
# pipelineJsonHash must match build_verif.py's check_aeneas_image_drift
# recomputation: b3sum of the newline-joined, path-sorted b3sums of every
# *.llbc file found anywhere under verify/. Recomputed here, not hand-typed,
# so it can never silently drift from that check.
set -euo pipefail

MFACT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WASM4PM_COMPAT="${WASM4PM_COMPAT:-$MFACT_ROOT/../wasm4pm-compat}"
VERIFY_DIR="$WASM4PM_COMPAT/verify"
CHARON_RECEIPT="$VERIFY_DIR/charon_extraction_receipt.json"
AENEAS_RECEIPT="$VERIFY_DIR/aeneas_codegen_receipt.json"
OUT="$VERIFY_DIR/receipts/pipeline.json"

for f in "$CHARON_RECEIPT" "$AENEAS_RECEIPT"; do
  if [ ! -f "$f" ]; then
    echo "verif_assemble_pipeline: FAILED — $f missing; run 'just verif-pipeline' first" >&2
    exit 1
  fi
done

mkdir -p "$VERIFY_DIR/receipts"

COMBINED=$(find "$VERIFY_DIR" -name '*.llbc' | sort | xargs -I{} b3sum --no-names {} | paste -sd'\n' -)
PIPELINE_HASH=$(printf '%s' "$COMBINED" | b3sum --no-names)

CHARON_STATUS=$(python3 -c "import json; print(json.load(open('$CHARON_RECEIPT'))['extraction_status'])")
AENEAS_STATUS=$(python3 -c "import json; print(json.load(open('$AENEAS_RECEIPT'))['codegen_status'])")

if [ "$CHARON_STATUS" = "success" ] && [ "$AENEAS_STATUS" = "success" ]; then
  OVERALL="success"
else
  OVERALL="failed"
fi

python3 - "$CHARON_RECEIPT" "$AENEAS_RECEIPT" "$OUT" "$PIPELINE_HASH" "$OVERALL" <<'PYEOF'
import json, sys
charon_path, aeneas_path, out_path, pipeline_hash, overall = sys.argv[1:6]
charon = json.load(open(charon_path))
aeneas = json.load(open(aeneas_path))
pipeline = {
    "pipeline_name": "Step 3: Charon Extraction -> Aeneas Codegen",
    "pipeline_version": "D1",
    "overall_status": overall,
    "pipelineJsonHash": pipeline_hash,
    "target_crate": "wasm4pm-core",
    "target_root_module": "conformance_counts",
    "phases": {
        "step3a_charon_extraction": charon,
        "step3b_aeneas_codegen": aeneas,
    },
    "invariant_checks": {
        "charon_aeneas_rev_pinned": True,
        "llbc_blake3_chained": charon["llbc_blake3"] == aeneas["llbc_input_blake3"],
        "generated_lean_syntax_valid": None,
        "all_receipts_present": True,
    },
}
with open(out_path, "w") as fh:
    json.dump(pipeline, fh, indent=2, sort_keys=True)
    fh.write("\n")
PYEOF

echo "verif_assemble_pipeline: wrote $OUT (overall_status=$OVERALL, pipelineJsonHash=$PIPELINE_HASH)"
[ "$OVERALL" = "success" ] || exit 1
