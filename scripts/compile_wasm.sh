#!/usr/bin/env bash
set -euo pipefail

# Compile WASM module
PATH="/Users/sac/mfact/.venv/bin:$PATH" emcc --no-entry -O3 \
  -sEXPORTED_FUNCTIONS="['_execute', '_alloc', '_dealloc']" \
  -I /Users/sac/.elan/toolchains/leanprover--lean4---v4.31.0/include \
  -o /Users/sac/mfact/web/mfact-ui/src/assets/AtomVM_bridge.wasm \
  /Users/sac/mfact/procint/.lake/build/ir/ProcInt/Petri/Computable.c /Users/sac/mfact/procint/c/wasm_bridge.c

echo "WASM compiled successfully to web/mfact-ui/src/assets/AtomVM_bridge.wasm"
