#!/bin/bash
# PreToolUse hook (matcher: Bash). Blocks bare lake/cargo build-affecting
# commands that bypass this repo's `just` recipes. Rationale: `just _lake`
# wraps lake invocations in a lock (/tmp/mfact-lake.lock) so concurrent
# sessions and cron-driven loops don't corrupt the shared .lake/build cache
# — a real risk in this repo, not a hypothetical one. Bare cargo calls
# similarly bypass any workspace-level lint/fmt gate this repo may add.
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [ -z "$command" ]; then
  exit 0
fi

# Already routed through just (any form) — allow.
if echo "$command" | grep -qE '(^|[;&|]\s*)just(\.exe)?\s'; then
  exit 0
fi

if echo "$command" | grep -qE '(^|[;&|]\s*)(lake\s+(build|exe|env)|cargo\s+(build|test|clippy|check))\b'; then
  cat >&2 <<'EOF'
Blocked: this repo requires build/test commands to go through `just`, not a
bare `lake`/`cargo` call.

For Lean: use the lock-wrapped recipe, e.g.
  just _lake "cd procint && lake build ProcInt.Foo"
(direct `lake build` can corrupt the shared .lake/build cache if a cron loop
or another session is building concurrently).

For Rust: check `just --list` for the matching cargo recipe in this repo's
justfile before falling back to a direct cargo call.
EOF
  exit 2
fi

exit 0
