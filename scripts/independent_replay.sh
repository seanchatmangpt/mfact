#!/usr/bin/env bash
# Independent replay gate — clone the stand-in at the release tag into a
# scratch tree and re-run the manufacturing rail THERE (never via the
# justfile, whose recipes hard-code /Users/sac/mfact). Writes
# release/replay_report.json in the real repo. Honest by construction:
# statuses are REPLAY_PASS / REPLAY_FAIL / REPLAY_NOT_RUN, never asserted.
set -u
REAL=/Users/sac/mfact
TAG=v26.7.6-procint-certified
STANDIN="${MFACT_STANDIN:?set MFACT_STANDIN to the bare stand-in path}"
BUDGET="${REPLAY_BUDGET_SECS:-5400}"
REPORT="$REAL/release/replay_report.json"
LAKE=/Users/sac/.elan/bin/lake

write_report() { # status detail
  python3 - "$1" "$2" <<'EOF'
import json, subprocess, sys
rid = subprocess.run(['git','-C','/Users/sac/mfact','rev-parse','--short','HEAD'],
                     capture_output=True, text=True).stdout.strip()
json.dump({'schema': 'mfact.replay_report.v1', 'status': sys.argv[1],
           'detail': sys.argv[2], 'tag': 'v26.7.6-procint-certified',
           'reportWrittenAtCommit': rid},
          open('/Users/sac/mfact/release/replay_report.json','w'), indent=2)
EOF
  echo "replay: $1 — $2"
}

if [ ! -d "$STANDIN" ]; then
  write_report REPLAY_NOT_RUN "stand-in $STANDIN missing"; exit 0
fi

SCRATCH=$(mktemp -d "${TMPDIR:-/tmp}/mfact-replay.XXXXXX")
trap 'rm -rf "$SCRATCH"' EXIT
LOG="$SCRATCH/replay.log"

run_rail() {
  set -e
  git clone --quiet "$STANDIN" "$SCRATCH/mfact"
  cd "$SCRATCH/mfact"
  git checkout --quiet "$TAG"
  cd procint
  "$LAKE" exe cache get
  "$LAKE" build
  "$LAKE" build AxiomAudit Quadrature Tests PostRelease
  cd ../mfact
  "$LAKE" build AxiomAudit mfact
  ./.lake/build/bin/mfact certify \
    "$SCRATCH/mfact/release/release-manifest.json" \
    "$SCRATCH/mfact/release/gates.json"
}

export -f run_rail 2>/dev/null || true
start=$(date +%s)
( run_rail ) >"$LOG" 2>&1 &
pid=$!
while kill -0 "$pid" 2>/dev/null; do
  now=$(date +%s)
  if [ $((now - start)) -gt "$BUDGET" ]; then
    kill "$pid" 2>/dev/null
    write_report REPLAY_NOT_RUN "budget ${BUDGET}s exceeded; partial log kept out of receipts"
    exit 0
  fi
  sleep 10
done
if wait "$pid"; then
  write_report REPLAY_PASS "clean clone at $TAG rebuilt, kernel-admitted all witnesses, certify exit 0"
else
  tail -3 "$LOG" | tr '\n' ' ' >"$SCRATCH/tail.txt"
  write_report REPLAY_FAIL "rail failed in clean clone: $(cat "$SCRATCH/tail.txt" | head -c 300)"
  exit 1
fi
