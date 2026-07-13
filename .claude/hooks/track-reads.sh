#!/bin/bash
# PostToolUse hook (matcher: Read). Records which files this session has
# actually read, so require-read-before-write.sh can enforce read-before-
# write on the Write tool. State is session-scoped and lives outside the
# repo (never committed, never part of git state).
set -uo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [ -n "$file_path" ]; then
  mkdir -p /tmp/claude-mfact-hooks
  echo "$file_path" >> "/tmp/claude-mfact-hooks/reads-${session_id}.txt"
fi

exit 0
