#!/usr/bin/env bash
# Correspondence-factory extraction toolchain: build charon + aeneas from
# pinned revisions into a durable, gitignored, mfact-local path
# (.verif-toolchain/bin/) so no step depends on a session-ephemeral /tmp
# scratchpad, and so the target repo (wasm4pm-compat, a publishable crate)
# never carries these binary blobs in its tree. mfact is the manufacturing/
# actuation home (AGENTS.md); wasm4pm-compat stays source-only. Idempotent:
# skips the (multi-minute) rebuild if the durable binaries already exist and
# answer to the pinned revisions.
#
# Pins (from Step 2, /Users/sac/wasm4pm-compat/verify/toolchain_alignment.json):
#   charon rev:   40ee060a
#   aeneas rev:   7ae06c646d1ee5229f02f4fc6d768287177f1b6e
#   rustc:        nightly-2026-06-01 (+ rustc-dev, llvm-tools-preview, rust-src)
#   opam switch:  "charon", ocaml-base-compiler.5.2.0
set -euo pipefail

MFACT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLCHAIN_DIR="$MFACT_ROOT/.verif-toolchain"
BIN_DIR="$TOOLCHAIN_DIR/bin"
SRC_DIR="$TOOLCHAIN_DIR/src"
CHARON_REV="40ee060a"
AENEAS_REV="7ae06c646d1ee5229f02f4fc6d768287177f1b6e"
RUST_NIGHTLY="nightly-2026-06-01"

mkdir -p "$BIN_DIR" "$SRC_DIR"

already_built() {
  local aeneas_rev_short="${AENEAS_REV:0:8}"
  [ -x "$BIN_DIR/charon" ] && [ -x "$BIN_DIR/charon-driver" ] && [ -x "$BIN_DIR/aeneas" ] \
    && "$BIN_DIR/charon" version 2>/dev/null | grep -q . \
    && "$BIN_DIR/aeneas" -version 2>/dev/null | grep -q "$aeneas_rev_short"
}

if already_built; then
  echo "verif_build_toolchain: SKIP — durable binaries already present and pinned to aeneas rev $AENEAS_REV"
  echo "  charon: $BIN_DIR/charon ($("$BIN_DIR/charon" version))"
  echo "  aeneas: $BIN_DIR/aeneas ($("$BIN_DIR/aeneas" -version))"
  exit 0
fi

echo "verif_build_toolchain: building charon@$CHARON_REV + aeneas@$AENEAS_REV (this takes several minutes)"

# 1. OPAM + OCaml switch
if ! opam --version >/dev/null 2>&1; then
  echo "verif_build_toolchain: FAILED — opam not installed (brew install opam)" >&2
  exit 1
fi
opam init -y --disable-sandboxing >/dev/null 2>&1 || opam init -y >/dev/null 2>&1 || true
if ! opam switch list 2>/dev/null | grep -q '^charon '; then
  opam switch create charon ocaml-base-compiler.5.2.0 -y
fi
eval "$(opam env --switch=charon)"

# 2. Rust nightly toolchain (rustc-dev needed by charon)
rustup toolchain install "$RUST_NIGHTLY" \
  --component rustc-dev --component llvm-tools-preview --component rust-src

# 3. Charon (clone + checkout pinned rev, build with cargo under the OCaml switch)
if [ ! -d "$SRC_DIR/charon/.git" ]; then
  git clone https://github.com/AeneasVerif/charon.git "$SRC_DIR/charon"
fi
(
  cd "$SRC_DIR/charon"
  git fetch --unshallow 2>/dev/null || git fetch
  git checkout "$CHARON_REV"
  eval "$(opam env --switch=charon)"
  opam install ./charon.opam --deps-only -y
  rustup default "$RUST_NIGHTLY"
  cargo build --release
)
cp "$SRC_DIR/charon/target/release/charon" "$BIN_DIR/charon"
# charon shells out to a sibling charon-driver binary at runtime — must ship together.
cp "$SRC_DIR/charon/target/release/charon-driver" "$BIN_DIR/charon-driver"

# 4. Aeneas (clone + checkout pinned rev, build with dune under the OCaml switch)
if [ ! -d "$SRC_DIR/aeneas/.git" ]; then
  git clone https://github.com/AeneasVerif/aeneas.git "$SRC_DIR/aeneas"
fi
(
  cd "$SRC_DIR/aeneas"
  git fetch --unshallow 2>/dev/null || git fetch
  git checkout "$AENEAS_REV"
  eval "$(opam env --switch=charon)"
  opam install ppx_deriving_yojson domainslib progress core_unix ocamlgraph -y || true
  # aeneas vendors its own OCaml-side charon copy under charon/ (distinct from
  # the standalone Rust `charon` binary built above, which is a separate repo).
  opam install ./charon/name_matcher_parser.opam -y || true
  opam install ./charon/charon.opam -y || true
  cd src
  dune build
)
cp "$SRC_DIR/aeneas/src/_build/default/main.exe" "$BIN_DIR/aeneas"

chmod +x "$BIN_DIR/charon" "$BIN_DIR/aeneas"
echo "verif_build_toolchain: DONE"
echo "  charon: $BIN_DIR/charon ($("$BIN_DIR/charon" version))"
echo "  aeneas: $BIN_DIR/aeneas ($("$BIN_DIR/aeneas" -version))"
