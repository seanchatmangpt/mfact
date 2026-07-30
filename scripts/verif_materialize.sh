#!/usr/bin/env bash
# verif-materialize: Copy the complete mfact-generated verifier projection into
# wasm4pm-compat with a deterministic projection hash check. Hand-maintained
# verifier files outside the generated manifest are preserved and excluded from
# the projection receipt. Workaround for ggen FM-WRITE-002 (relative paths only).

set -euo pipefail

MFACT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WASM4PM_DIR="${WASM4PM_COMPAT_DIR:-$(cd "$MFACT_DIR/.." && pwd)/wasm4pm-compat}"
SRC_ROOT="$MFACT_DIR/dist/verif/lean/Wasm4pmVerify"
DST_ROOT="$WASM4PM_DIR/verify/lean/Wasm4pmVerify"
MANIFEST="$(mktemp)"
trap 'rm -f "$MANIFEST"' EXIT

projection_hash() {
  local root="$1"
  (
    while IFS= read -r -d '' relative; do
      if [ ! -f "$root/$relative" ]; then
        printf 'PROJECTION_MEMBER_MISSING:%s\n' "$relative" >&2
        return 1
      fi
      printf '%s\0' "$relative"
      b3sum "$root/$relative" | awk '{print $1}'
    done < "$MANIFEST"
  ) | b3sum | awk '{print $1}'
}

echo "verif-materialize: $SRC_ROOT -> $DST_ROOT"

if [ ! -d "$SRC_ROOT" ]; then
  echo "VERIF_GENERATED_TREE_MISSING: $SRC_ROOT" >&2
  exit 1
fi

(
  cd "$SRC_ROOT"
  find . -type f -name '*.lean' -print0 | sort -z > "$MANIFEST"
)

if [ ! -s "$MANIFEST" ]; then
  echo "VERIF_GENERATED_TREE_EMPTY" >&2
  exit 1
fi

while IFS= read -r -d '' relative; do
  source="$SRC_ROOT/$relative"
  destination="$DST_ROOT/$relative"
  mkdir -p "$(dirname "$destination")"
  cp "$source" "$destination"
done < "$MANIFEST"

src_hash="$(projection_hash "$SRC_ROOT")"
dst_hash="$(projection_hash "$DST_ROOT")"
if [ "$src_hash" != "$dst_hash" ]; then
  echo "VERIF_MATERIALIZE_DRIFT_REFUSED: src=$src_hash dst=$dst_hash" >&2
  exit 1
fi

printf 'verif-materialize: GREEN projection_hash=%s\n' "$src_hash"
