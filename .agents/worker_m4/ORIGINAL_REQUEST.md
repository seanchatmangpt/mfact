## 2026-07-08T00:30:40Z

Your identity: teamwork_preview_worker (worker_m4).
Your working directory is: /Users/sac/mfact/.agents/worker_m4.

Your task is to finalize the project (Milestones 4 and 5):

1. Verify that `just check` and `just release` both run successfully and exit 0.
2. Run the Standing Guard MCP server's scan tool:
   - Call the `scan()` tool from `mpops.standing_guard.server` (either via a python script or command).
   - Save the scan findings to `/Users/sac/mfact/.agents/worker_m4/final_scan_results.json`.
   - Verify that there are zero "BLOCKER" findings in the output.
3. Re-cut the release tag `v26.7.7-procint-certified` to point to current HEAD (the clean release commit):
   - Run: `git tag -d v26.7.7-procint-certified`
   - Run: `git tag v26.7.7-procint-certified HEAD`
4. Verify the tag and repository status:
   - Run: `git tag --list v26.7.7-procint-certified`
   - Run: `git status --short`
5. Report back when done with the findings and logs.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.
