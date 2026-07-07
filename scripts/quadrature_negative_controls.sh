#!/usr/bin/env bash
# Quadrature negative controls: prove the quadrature gate can fail.
# All poisoning happens on COPIES (env-override surfaces); the real release
# surfaces are untouched. A control PASSES iff the builder REFUSES (exit 2)
# with the expected orphan class — a crash or a silent pass is a FAIL.
set -u
BUILDER=/Users/sac/mfact/scripts/build_quadrature.py
LOG=/Users/sac/mfact/release/quadrature-negative-controls.log
SCRATCH=$(mktemp -d)
export MFACT_ROOT=/Users/sac/mfact
PASS=0; FAIL=0
say() { echo "$1" | tee -a "$LOG"; }

echo "=== Quadrature negative controls ($(git -C /Users/sac/mfact rev-parse --short HEAD)) ===" > "$LOG"

# Control 1: corrupt one evaluation number (proven count 145 -> 144) in a COPY.
sed 's/145/144/g' /Users/sac/mfact/paper/evaluation.tex > "$SCRATCH/eval.tex"
QUAD_EVAL_TEX="$SCRATCH/eval.tex" QUAD_OUT="$SCRATCH/q1.ttl" python3 "$BUILDER" >> "$LOG" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q 'unsupported_eval' "$LOG"; then
  say "CONTROL1(corrupt eval number): PASS - typed refusal exit 2, unsupported_eval detected"; PASS=$((PASS+1))
else
  say "CONTROL1(corrupt eval number): FAIL - exit=$rc, expected typed refusal 2"; FAIL=$((FAIL+1))
fi

# Control 2: inject a fake paper claim with EMPTY evidence into a builder copy.
sed "s|('C1', 'mfact framework|('C0', 'fake unsupported claim', ''),\n    ('C1', 'mfact framework|" \
  "$BUILDER" > "$SCRATCH/b2.py"
QUAD_OUT="$SCRATCH/q2.ttl" python3 "$SCRATCH/b2.py" >> "$LOG" 2>&1
rc=$?
if [ -f "$SCRATCH/q2.ttl" ] && grep -q 'quad:result "FAIL"' "$SCRATCH/q2.ttl" && ! grep -q 'quad:orphanPaperClaims 0 ;' "$SCRATCH/q2.ttl"; then
  say "CONTROL2(fake claim, no evidence): PASS - claim_to_evidence edge FAIL + orphan_paper_claims > 0"; PASS=$((PASS+1))
else
  say "CONTROL2(fake claim, no evidence): FAIL - exit=$rc, orphan not reflected in graph"; FAIL=$((FAIL+1))
fi

# Control 3: fake proven TTL decl with no rendered Lean symbol (catalog COPY).
cp /Users/sac/praxis/packs/lean-math-pack/ontology.ttl "$SCRATCH/catalog.ttl"
cat >> "$SCRATCH/catalog.ttl" <<'TTL'

procint:Decl_fake_orphan a procint:Decl ;
  procint:inModule "Petri.Net" ;
  procint:declOrder 999 ;
  procint:declName "ProcInt.fake_orphan_theorem_zzz" ;
  procint:declKind "theorem" ;
  procint:status "proven" ;
  procint:auditMsg "'ProcInt.fake_orphan_theorem_zzz' does not depend on any axioms" ;
  procint:leanCode """theorem fake_orphan_theorem_zzz : True := trivial""" .
TTL
QUAD_ONTOLOGY="$SCRATCH/catalog.ttl" QUAD_OUT="$SCRATCH/q3.ttl" python3 "$BUILDER" >> "$LOG" 2>&1
rc=$?
if [ $rc -eq 2 ] && grep -q 'ttl_without_lean' "$LOG"; then
  say "CONTROL3(fake proven TTL decl): PASS - typed refusal exit 2, ttl_without_lean orphan"; PASS=$((PASS+1))
else
  say "CONTROL3(fake proven TTL decl): FAIL - exit=$rc"; FAIL=$((FAIL+1))
fi

say "controls: $PASS refused correctly, $FAIL failed to refuse"
rm -rf "$SCRATCH"
[ "$FAIL" -eq 0 ] || exit 1
