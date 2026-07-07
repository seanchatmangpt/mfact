#!/usr/bin/env bash
# Verif-gate negative controls: poisoned copies must REFUSE with the
# right refusal names. Never touches the real fragments or receipts.
# Part of correspondence-factory Step 5 (refusal-by-evidence discipline).
set -u -o pipefail
BUILDER=/Users/sac/mfact/scripts/build_verif.py
REAL_VERIF_TTL=/Users/sac/mfact/packs/lean-math-pack/fragments/verif.ttl
REAL_VERIF_STATUS=/Users/sac/mfact/packs/lean-math-pack/fragments/verif-status.generated.ttl
REAL_OUT_RECEIPT=/Users/sac/mfact/release/verif-receipt.json
SCRATCH=$(mktemp -d)
export PYTHONPATH=/Users/sac/mfact:${PYTHONPATH:-}
PASS=0; FAIL=0
say() { echo "$1"; }

echo "=== Verif negative controls ($(cd /Users/sac/mfact && git rev-parse --short HEAD)) ==="

# ────────────────────────────────────────────────────────────────────────────
# Test (a): Poison verif-status.generated.ttl to PROVEN in a scratch copy.
# Expected: build_verif.py re-derives the status from evidence and REFUSES
# the overwrite if the evidence doesn't support PROVEN (refuse-by-evidence).
# If no pipeline.json exists yet, status should be DECLARED, not PROVEN.
# ────────────────────────────────────────────────────────────────────────────
echo ""
say "=== Test (a): Poison verif-status.generated.ttl to PROVEN ==="

# Set up scratch directories with environment variable overrides
SCRATCH_A="$SCRATCH/test_a"
mkdir -p "$SCRATCH_A/packs/lean-math-pack/fragments" "$SCRATCH_A/release"

# Copy real TTL to scratch
cp "$REAL_VERIF_TTL" "$SCRATCH_A/packs/lean-math-pack/fragments/verif.ttl"

# Create a poisoned verif-status fragment claiming PROVEN when evidence only supports DECLARED
cat > "$SCRATCH_A/packs/lean-math-pack/fragments/verif-status.generated.ttl" <<'TTL_A'
@prefix verif: <https://mfact.dev/verif#> .

# POISONED: claim PROVEN when evidence doesn't support it
verif:Obl_token_replay_counts_corr verif:status "PROVEN" .
TTL_A

# Run build_verif.py with scratch paths (no pipeline.json, so evidence should only support DECLARED)
unset PIPELINE_JSON LEAN_PKG_DIR LAKE
export MFACT_ROOT="$SCRATCH_A"
export VERIF_TTL="$SCRATCH_A/packs/lean-math-pack/fragments/verif.ttl"
export OUT_FRAGMENT="$SCRATCH_A/packs/lean-math-pack/fragments/verif-status.generated.ttl"
export OUT_RECEIPT="$SCRATCH_A/release/verif-receipt.json"
export WASM4PM_COMPAT="$SCRATCH_A/wasm4pm-compat"
python3 "$BUILDER" > "$SCRATCH_A/output.txt" 2>&1
rc=$?

# Check exit code and message
if [ $rc -eq 2 ] && grep -q "PROOF_STATUS_MISMATCH_REFUSED" "$SCRATCH_A/output.txt"; then
  say "CONTROL_A(poison PROVEN→evidence): PASS - builder refused with PROOF_STATUS_MISMATCH_REFUSED"; PASS=$((PASS+1))
else
  say "CONTROL_A(poison PROVEN→evidence): FAIL - exit=$rc, expected exit 2 with PROOF_STATUS_MISMATCH_REFUSED"; FAIL=$((FAIL+1))
  cat "$SCRATCH_A/output.txt"
fi

# ────────────────────────────────────────────────────────────────────────────
# Test (b): Poison a hash in pipeline.json (if it exists, or create a fake one).
# Expected: build_verif.py detects hash mismatch and refuses with
# AENEAS_IMAGE_DRIFT_REFUSED.
# ────────────────────────────────────────────────────────────────────────────
echo ""
say "=== Test (b): Poison pipelineJsonHash in pipeline.json ==="

# Set up scratch directories for test B
SCRATCH_B="$SCRATCH/test_b"
mkdir -p "$SCRATCH_B/packs/lean-math-pack/fragments" "$SCRATCH_B/release" "$SCRATCH_B/wasm4pm-compat/verify/receipts"

# Copy real TTL to scratch
cp "$REAL_VERIF_TTL" "$SCRATCH_B/packs/lean-math-pack/fragments/verif.ttl"

# Create initial verif-status (DECLARED, since pipeline.json will have wrong hash)
cat > "$SCRATCH_B/packs/lean-math-pack/fragments/verif-status.generated.ttl" <<'TTL_B'
@prefix verif: <https://mfact.dev/verif#> .

verif:Obl_token_replay_counts_corr verif:status "DECLARED" .
TTL_B

# Create a poisoned pipeline.json with wrong pipelineJsonHash (deadbeef is wrong, actual will differ)
cat > "$SCRATCH_B/wasm4pm-compat/verify/receipts/pipeline.json" <<'JSON_B'
{
  "status": "success",
  "pipelineJsonHash": "deadbeef00000000000000000000000000000000000000000000000000000000",
  "charon_exit_code": 0,
  "aeneas_exit_code": 0,
  "timestamp": "2026-07-07T00:00:00Z"
}
JSON_B

# Create a fake .llbc file to have evidence files
mkdir -p "$SCRATCH_B/wasm4pm-compat/verify/llbc"
echo "fake llbc content" > "$SCRATCH_B/wasm4pm-compat/verify/llbc/fake.llbc"

# Run build_verif.py with scratch paths
unset LEAN_PKG_DIR LAKE
export MFACT_ROOT="$SCRATCH_B"
export VERIF_TTL="$SCRATCH_B/packs/lean-math-pack/fragments/verif.ttl"
export OUT_FRAGMENT="$SCRATCH_B/packs/lean-math-pack/fragments/verif-status.generated.ttl"
export OUT_RECEIPT="$SCRATCH_B/release/verif-receipt.json"
export WASM4PM_COMPAT="$SCRATCH_B/wasm4pm-compat"
export PIPELINE_JSON="$SCRATCH_B/wasm4pm-compat/verify/receipts/pipeline.json"
python3 "$BUILDER" > "$SCRATCH_B/output.txt" 2>&1
rc=$?

# Check exit code and message for AENEAS_IMAGE_DRIFT_REFUSED
if [ $rc -eq 2 ] && grep -q "AENEAS_IMAGE_DRIFT_REFUSED" "$SCRATCH_B/output.txt"; then
  say "CONTROL_B(poison pipeline.json hash): PASS - drift detection refused with AENEAS_IMAGE_DRIFT_REFUSED"; PASS=$((PASS+1))
else
  say "CONTROL_B(poison pipeline.json hash): FAIL - exit=$rc, expected exit 2 with AENEAS_IMAGE_DRIFT_REFUSED"; FAIL=$((FAIL+1))
  cat "$SCRATCH_B/output.txt"
fi

# ────────────────────────────────────────────────────────────────────────────
# Test (c): Dangling leanDecl in a scratch fragment.
# Add a correspondence obligation with leanDecl="ProcInt.NonExistent" that
# doesn't exist in procint's catalog.
# Expected: build_verif.py detects the dangling reference and refuses with
# CORRESPONDENCE_DANGLING_REFUSED.
# ────────────────────────────────────────────────────────────────────────────
echo ""
say "=== Test (c): Dangling leanDecl in correspondence obligation ==="

# Set up scratch directories for test C
SCRATCH_C="$SCRATCH/test_c"
mkdir -p "$SCRATCH_C/packs/lean-math-pack/fragments" "$SCRATCH_C/release"

# Create a verif.ttl with a dangling leanDecl (that won't be found in procint source)
cat > "$SCRATCH_C/packs/lean-math-pack/fragments/verif.ttl" <<'TTL_C'
@prefix procint: <https://mfact.dev/procint#> .
@prefix verif: <https://mfact.dev/verif#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

# Fake obligation with dangling leanDecl that doesn't exist in procint
verif:Obl_fake_dangling_corr a verif:CorrespondenceObligation ;
  verif:corrOrder 999 ;
  verif:corrName "fake_dangling_corr" ;
  verif:rustSymbol "fake::symbol" ;
  verif:rustFile "fake/path.rs" ;
  verif:leanDecl "ProcInt.NonExistent.Declaration" ;
  verif:aeneasModule "Wasm4pmVerify.Fake" ;
  verif:aeneasDecl "FakeDecl" ;
  verif:obligationStatement """theorem fake_dangling : True := trivial""" ;
  verif:note "This obligation references a non-existent Lean declaration." .
TTL_C

# Create initial verif-status for the fake obligation (DECLARED)
cat > "$SCRATCH_C/packs/lean-math-pack/fragments/verif-status.generated.ttl" <<'TTL_C_STATUS'
@prefix verif: <https://mfact.dev/verif#> .

verif:Obl_fake_dangling_corr verif:status "DECLARED" .
TTL_C_STATUS

# Run build_verif.py with scratch paths — it should detect dangling leanDecl and refuse
unset PIPELINE_JSON LEAN_PKG_DIR LAKE
export MFACT_ROOT="$SCRATCH_C"
export VERIF_TTL="$SCRATCH_C/packs/lean-math-pack/fragments/verif.ttl"
export OUT_FRAGMENT="$SCRATCH_C/packs/lean-math-pack/fragments/verif-status.generated.ttl"
export OUT_RECEIPT="$SCRATCH_C/release/verif-receipt.json"
export WASM4PM_COMPAT="$SCRATCH_C/wasm4pm-compat"
python3 "$BUILDER" > "$SCRATCH_C/output.txt" 2>&1
rc=$?

# Check exit code and message for CORRESPONDENCE_DANGLING_REFUSED
if [ $rc -eq 2 ] && grep -q "CORRESPONDENCE_DANGLING_REFUSED" "$SCRATCH_C/output.txt"; then
  say "CONTROL_C(dangling leanDecl): PASS - dangling ref detection refused with CORRESPONDENCE_DANGLING_REFUSED"; PASS=$((PASS+1))
else
  say "CONTROL_C(dangling leanDecl): FAIL - exit=$rc, expected exit 2 with CORRESPONDENCE_DANGLING_REFUSED"; FAIL=$((FAIL+1))
  cat "$SCRATCH_C/output.txt"
fi

# ────────────────────────────────────────────────────────────────────────────
# Summary
# ────────────────────────────────────────────────────────────────────────────
echo ""
say "=== Verif negative controls summary ==="
say "PASS=$PASS, FAIL=$FAIL"
if [ "$FAIL" -eq 0 ]; then
  say "verif-negative-controls: GREEN (all refusals fired as expected)"
  rm -rf "$SCRATCH"
  exit 0
else
  say "verif-negative-controls: REFUSED — $FAIL control(s) failed to refuse"
  rm -rf "$SCRATCH"
  exit 1
fi
