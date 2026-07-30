#!/usr/bin/env bash
# verif-materialize: Copy the complete mfact-generated verifier projection into
# wasm4pm-compat with a deterministic tree hash check. Workaround for ggen
# FM-WRITE-002 (relative output paths only).

set -euo pipefail

MFACT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WASM4PM_DIR="${WASM4PM_COMPAT_DIR:-$(cd "$MFACT_DIR/.." && pwd)/wasm4pm-compat}"
SRC_ROOT="$MFACT_DIR/dist/verif/lean/Wasm4pmVerify"
DST_ROOT="$WASM4PM_DIR/verify/lean/Wasm4pmVerify"

tree_hash() {
  local root="$1"
  if [ ! -d "$root" ] || [ "$(find "$root" -type f -name '*.lean' | wc -l)" -eq 0 ]; then
    printf 'no_files\n'
    return
  fi
  (
    cd "$root"
    find . -type f -name '*.lean' -print0 \
      | sort -z \
      | xargs -0 b3sum \
      | b3sum \
      | awk '{print $1}'
  )
}

echo "verif-materialize: $SRC_ROOT -> $DST_ROOT"

if [ ! -d "$SRC_ROOT" ]; then
  echo "VERIF_GENERATED_TREE_MISSING: $SRC_ROOT" >&2
  exit 1
fi

src_hash="$(tree_hash "$SRC_ROOT")"
if [ "$src_hash" = "no_files" ]; then
  echo "VERIF_GENERATED_TREE_EMPTY" >&2
  exit 1
fi

while IFS= read -r -d '' source; do
  relative="${source#"$SRC_ROOT"/}"
  destination="$DST_ROOT/$relative"
  mkdir -p "$(dirname "$destination")"
  cp "$source" "$destination"
done < <(find "$SRC_ROOT" -type f -name '*.lean' -print0 | sort -z)

dst_hash="$(tree_hash "$DST_ROOT")"
if [ "$src_hash" != "$dst_hash" ]; then
  echo "VERIF_MATERIALIZE_DRIFT_REFUSED: src=$src_hash dst=$dst_hash" >&2
  exit 1
fi

printf 'verif-materialize: GREEN tree_hash=%s\n' "$src_hash"
