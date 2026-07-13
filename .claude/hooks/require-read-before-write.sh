#!/bin/bash
# PreToolUse hook (matcher: Write). Blocks Write to an existing, non-empty
# file that this session has not Read first. Rationale: this exact failure
# class — a process opening an existing file in blind write/truncate mode
# without checking current content — is implicated in a real incident in
# this repo (16 tracked Lean files found zeroed with no attributable
# cause). arXiv:2607.09510 independently found "false premise" (acting on
# an unverified assumption when the correcting information was already
# available) is the single largest cause of coding-agent decisive errors
# (30.7%). This hook makes that specific premise structurally unavailable
# to skip, rather than relying on prose discipline in agent instructions.
#
# The Edit tool already enforces read-before-edit internally; this hook
# closes the equivalent gap for Write, which does not.
set -uo pipefail

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [ -z "$file_path" ]; then
  exit 0
fi

# New or already-empty file: nothing to lose, allow.
if [ ! -s "$file_path" ]; then
  exit 0
fi

reads_file="/tmp/claude-mfact-hooks/reads-${session_id}.txt"
if [ -f "$reads_file" ] && grep -qxF "$file_path" "$reads_file"; then
  exit 0
fi

cat >&2 <<EOF
Blocked: '$file_path' already exists with content and has not been Read in
this session. This repo had a real incident where files were silently
truncated by a write that never checked existing content first — don't
repeat it. Read the file first (or use Edit if you're modifying rather
than replacing it), then retry the write.
EOF
exit 2
