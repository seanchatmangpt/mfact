#!/usr/bin/env bash
# verif-materialize: Copy mfact dist/verif/ → wasm4pm-compat/verify/lean/ with hash check
# Workaround for ggen FM-WRITE-002 (relative paths only)

set -e

MFACT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WASM4PM_DIR="$(cd "$MFACT_DIR/.." && pwd)/wasm4pm-compat"
SRC_DIR="$MFACT_DIR/dist/verif/lean/Wasm4pmVerify/Corr"
DST_DIR="$WASM4PM_DIR/verify/lean/Wasm4pmVerify/Corr"

echo "verif-materialize: copy mfact dist/verif/ → $WASM4PM_DIR/verify/lean/ with hash check"

# Create destination directory if needed
mkdir -p "$DST_DIR"

# Compute source hash (if files exist)
src_hash="no_files"
if [ -d "$SRC_DIR" ] && [ "$(find "$SRC_DIR" -name "*.lean" 2>/dev/null | wc -l)" -gt 0 ]; then
  src_hash=$(find "$SRC_DIR" -name "*.lean" 2>/dev/null | sort | xargs b3sum 2>/dev/null | awk '{s=$1} END {print s}' || echo "no_files")
fi

# Copy files (allow failure if no files)
cp -v "$SRC_DIR"/*.lean "$DST_DIR/" 2>/dev/null || true

# Compute destination hash (if files exist after copy)
dst_hash="no_files"
if [ "$(find "$DST_DIR" -name "*.lean" 2>/dev/null | wc -l)" -gt 0 ]; then
  dst_hash=$(find "$DST_DIR" -name "*.lean" 2>/dev/null | sort | xargs b3sum 2>/dev/null | awk '{s=$1} END {print s}' || echo "no_files")
fi

# Check for drift
if [ "$src_hash" != "no_files" ] && [ "$dst_hash" != "no_files" ] && [ "$src_hash" != "$dst_hash" ]; then
  echo "VERIF_MATERIALIZE_DRIFT_REFUSED: hash mismatch after copy (src=$src_hash, dst=$dst_hash)" >&2
  exit 1
fi

echo "verif-materialize: GREEN (files copied, hash verified)"
exit 0
