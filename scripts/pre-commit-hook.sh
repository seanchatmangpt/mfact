#!/usr/bin/env bash
# Admission law: generated output may only change alongside a source change.
set -u

log_line() {
  # Best-effort audit log of hatch/whitening events. Never blocks or fails the commit.
  local reason="$1"
  mkdir -p .mfact 2>/dev/null
  printf '{"ts":"%s","reason":"%s","hatch_used":%s,"ttl_staged":%s,"generated_changed":%s,"source_changed":%s}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$reason" "$hatch_used" "$ttl_staged" "$generated_changed" "$source_changed" \
    >> .mfact/hook-events.jsonl 2>/dev/null || true
}

changed="$(git diff --cached --name-only)"
source_changed=false
generated_changed=false
ttl_staged=false
hatch_used=false
for f in $changed; do
  case "$f" in
    scripts/*|ontology/*|ggen.toml|*.ttl) source_changed=true ;;
    procint/ProcInt/Playground.lean|procint/ProcInt/Playground/*) ;;
    procint/ProcInt/MFW/*) ;;
    procint/ProcInt/*|procint/AxiomAudit.lean|procint/ProcInt.lean|paper/generated/*|release/release-manifest.json|release/quadrature.*) generated_changed=true ;;
  esac
  case "$f" in
    *.ttl) ttl_staged=true ;;
  esac
done
# Pack sources live in the praxis repo; allow via env when a pack change drove this.
if [ "${MFACT_SOURCE_CHANGED:-}" = "1" ]; then source_changed=true; hatch_used=true; fi
if [ "$hatch_used" = true ]; then log_line "mfact_source_changed_hatch"; fi
if [ "$generated_changed" = true ] && [ "$ttl_staged" = true ]; then log_line "ttl_staged_whitened_generated_change"; fi
if [ "$generated_changed" = true ] && [ "$source_changed" = false ]; then
  echo "REFUSED: HAND_CODED_GENERATED_OUTPUT — generated output changed without a source/template change."
  echo "Edit the declaration/template (praxis packs, scripts/) and rerun ggen; or set MFACT_SOURCE_CHANGED=1 if the source change is in the praxis packs repo."
  exit 1
fi
exit 0
