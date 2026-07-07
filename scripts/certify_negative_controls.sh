#!/usr/bin/env bash
# Certify-gate negative controls: poisoned copies must REFUSE with the
# right exit codes. Appended to release/certify.log by `just certify`.
# Never touches the real manifest or gates.
set -u
BIN=/Users/sac/mfact/mfact/.lake/build/bin/mfact
MAN=/Users/sac/mfact/release/release-manifest.json
GATES=/Users/sac/mfact/release/gates.json
SCRATCH=$(mktemp -d "${TMPDIR:-/tmp}/mfact-certify-controls.XXXXXX")
trap 'rm -rf "$SCRATCH"' EXIT

echo "=== Negative control 1: gates.json with sorryFree=false ==="
python3 -c "import json; g = json.load(open('$GATES')); g['sorryFree'] = False; json.dump(g, open('$SCRATCH/gates_bad.json', 'w'))"
"$BIN" certify "$MAN" "$SCRATCH/gates_bad.json" > /dev/null 2> "$SCRATCH/err1.txt"; rc=$?
cat "$SCRATCH/err1.txt"; echo "exit=$rc"
[ "$rc" -eq 1 ] || { echo "REFUSED: NEGATIVE_CONTROL_FAILED — control 1 exited $rc, expected 1"; exit 1; }

echo "=== Negative control 2: malformed manifest JSON ==="
head -c 200 "$MAN" > "$SCRATCH/manifest_bad.json"
"$BIN" certify "$SCRATCH/manifest_bad.json" "$GATES" > /dev/null 2> "$SCRATCH/err2.txt"; rc=$?
sed "s|$SCRATCH|<scratch>|" "$SCRATCH/err2.txt"; echo "exit=$rc"
[ "$rc" -eq 2 ] || { echo "REFUSED: NEGATIVE_CONTROL_FAILED — control 2 exited $rc, expected 2"; exit 1; }
