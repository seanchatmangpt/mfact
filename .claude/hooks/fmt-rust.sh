#!/bin/bash
# PostToolUse hook (matcher: Edit|Write). Auto-formats a just-touched .rs
# file with rustfmt, matching the house-style pattern found in this
# project's sibling repos (praxis auto-runs cargo fmt on edited .rs files
# via an identical PostToolUse hook). Never blocks — formatting failures
# are reported but do not fail the tool call.
set -uo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [[ "$file_path" == *.rs && -f "$file_path" ]]; then
  if command -v rustfmt >/dev/null 2>&1; then
    rustfmt --edition 2021 "$file_path" >/dev/null 2>&1 || true
  fi
fi

exit 0
