## 2026-07-07T19:08:28Z
Your working directory is: /Users/sac/mfact/.agents/teamwork_preview_worker_finalize_gen2/
The project repository root is: /Users/sac/mfact

Please finalize Ticket 020 by performing the following actions:
1. Run `just check` to verify that the entire pipeline builds and passes.
2. Run `just release` to build, certify, and package the release.
3. If both commands pass successfully, commit all changes in the working tree using:
   `just commit "Ticket 020: praxis-graphlaw and rslab Paper Prose"`
4. Re-cut the certified release tag pointing directly to this new commit using:
   `just recut-tag v26.7.7-procint-certified`
5. Run `just status` and `just doctor` to verify the final status and that the tag gate is green.
6. Write your findings to `/Users/sac/mfact/.agents/teamwork_preview_worker_finalize_gen2/handoff.md`.
7. Once finished, send a message back to the parent (conversation ID: 6b5e83bd-0355-4ec4-a8f4-22be6eca6a88) with the path to your handoff report.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.
