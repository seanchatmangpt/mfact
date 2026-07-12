## 2026-07-08T00:44:54Z
You are a worker agent. Your working directory is /Users/sac/mfact/.agents/worker_step1.
Your task is to implement the Ticket 015 Governance Reconciliation and Re-Certification requirements:
1. Modify `justfile` to:
   - Fix the `standing.env` deduplication bug in the `test` recipe (change basic `grep -v` to `grep -vE` or `grep -E -v` on line 156).
   - Add a `commit` recipe:
     ```just
     [group('git')]
     commit message:
         git add -A
         git commit -m "{{message}}"
     ```
   - Add a `recut-tag` recipe:
     ```just
     [group('git')]
     recut-tag name:
         git tag -d {{name}} || true
         git tag {{name}}
     ```
2. Re-run the full certification pipeline using just recipes:
   `just render`
   `just build`
   `just audit`
   `just manifest`
   `just certify`
   `just test` (Check that this successfully deduplicates and cleans up `release/standing.env` so that it has no duplicate keys!)
   `just regen-check`
3. Commit all changes (staged changes plus your justfile fix) using the new `just commit "Ticket 015: Governance Reconciliation and Re-Certification"` recipe.
4. Re-cut the certified release tag `v26.7.7-procint-certified` using the new `just recut-tag v26.7.7-procint-certified` recipe.
5. Verify the tag and git status:
   `git tag --list v26.7.7-procint-certified`
   `git status --short`
   (Note: you can run these command lines via the run_command tool as long as they are for verification/inspection and not final actuation, but for final actuation like commit and tag, use the just recipes you created).

MANDATORY INTEGRITY WARNING: DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Document your commands, results, and the contents of `release/standing.env` in /Users/sac/mfact/.agents/worker_step1/handoff.md and send me a handoff message when done.
