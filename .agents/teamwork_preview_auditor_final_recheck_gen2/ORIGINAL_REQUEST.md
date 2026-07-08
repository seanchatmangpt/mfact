## 2026-07-08T02:37:24Z

Your working directory is: /Users/sac/mfact/.agents/teamwork_preview_auditor_final_recheck_gen2/
The project repository root is: /Users/sac/mfact

Please conduct the final independent audit of the repository to verify the following items:
1. Git status is completely clean (except for agent files in `.agents/`).
2. `release/standing.env` has no duplicate keys.
3. Standing Guard scan has zero BLOCKER findings.
4. `just check` passes.
5. `just release` passes.
6. `just regen-check` passes.
7. `just paper-check` passes.
8. No handcoded benchmark metrics appear in `paper/main.tex` (empirical metrics must only come from generated fragments).
9. rslab raw outputs came from real praxis commands.
10. Receipt hashes in `rslab/receipts/praxis_graphlaw_benchmark_receipt.toml` match the BLAKE3 hashes of raw files.
11. Generated LaTeX fragments match the processed results in `rslab/experiments/praxis_graphlaw/processed/results.json`.
12. The final tag `v26.7.7-procint-certified` points directly to the final clean commit.
13. Write your detailed findings to `/Users/sac/mfact/.agents/teamwork_preview_auditor_final_recheck_gen2/analysis.md`.
14. Write a handoff report at `/Users/sac/mfact/.agents/teamwork_preview_auditor_final_recheck_gen2/handoff.md` with your final verdict (CLEAN or VIOLATION).
15. Once finished, send a message back to the parent (conversation ID: 6b5e83bd-0355-4ec4-a8f4-22be6eca6a88) with the path to your handoff report.
