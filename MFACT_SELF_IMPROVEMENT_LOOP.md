# mfact Self-Improvement Loop

Continuity ledger for the recurring, cron-driven fix loop (paired with the separate
audit-only loop that produces `PRAXIS_SELF_AUDIT.md`). This loop does not audit; it
picks one open item from `GAP_LEDGER_v26.7.12.md` / `PRAXIS_SELF_AUDIT.md` /
`PRAXIS_DOGFOODING_EXPLORATION.md` / `WASM4PM_AUTONOMIC_EXPLORATION.md` per firing,
constructs a real fix, independently re-verifies it, and commits locally (never
pushes). See `AGENTS.md` for the construction discipline this enforces.

Design v2 (this file's first version), redesigned before first firing per
`WASM4PM_AUTONOMIC_EXPLORATION.md` section 3 -- v1 never fired. The redesign exists
because `~/wasm4pm`'s own autonomic loop learned, the hard way
(`autonomic-observability-gaps-audit.json`, 3 CRITICAL gaps, fixed in commit
`8c006c82d` but whose own status docs stayed wrong for two weeks after), that a loop
logging only "item picked, fix applied, commit made" cannot prove it is converging,
and that status-doc updates separated from the fix they describe silently rot. Both
lessons are load-bearing here after this session's own truncation incident: 16
tracked Lean files in `research-papers/` were found zeroed with no attributable
cause, days into an unaudited window -- exactly the "epistemic error persists
undetected" failure mode arxiv:2607.09510 documents empirically across coding-agent
trajectories.

## Receipt schema

One JSON file per firing at `.mfact/receipts/<run_id>.json`, plus
`.mfact/receipts/latest.json` (same content, overwritten each firing, for fast
last-run lookup):

```json
{
  "run_id": "20260713T001200Z",
  "gap_id": "G11",
  "input_hash": "sha256 of the gap-ledger item text as read at pick time",
  "output_hash": "sha256 of the resulting diff (git show --stat <sha>)",
  "status": "success | partial | failed | no_op",
  "timestamp": "2026-07-13T00:12:00Z",
  "verify_delta": {
    "before": "literal output of the failing/target check, pre-fix",
    "after": "literal output of the same check, post-fix"
  },
  "commit_sha": "abc1234 or null if no_op/failed",
  "duration_ms": 184000,
  "oracle_rank": 1,
  "collision": false,
  "root_cause_type": "falsePremise | specificationNeglect | outputMisreading | ignoredSignal | prematureAction | knowledgeGap | capabilityLimitation | environmentBlocker | other (OPTIONAL -- only when status is failed or partial)",
  "root_cause_category": "epistemic | competence | environment (OPTIONAL -- only when status is failed or partial; must equal RootCauseType.category of root_cause_type)",
  "recovery_behavior": "givesUpImmediately | repairsWrongProblem | keepsRepeatingApproach | performsUselessChecks | fabricatesSuccess (OPTIONAL -- only when status is failed or partial)"
}
```

`oracle_rank`: 1 = independently re-run command with a machine-checkable pass/fail
(build exit code, `#print axioms` output, test count). 2 = independently re-run
command whose output requires reading to interpret. 3 = static check only (grep,
file existence). 4 = no independent re-check -- **a firing may not close an item at
rank 4**; log it `partial` and leave the item open instead.

`root_cause_type` / `root_cause_category` / `recovery_behavior`: OPTIONAL fields,
populated only when `status` is `"failed"` or `"partial"` -- a `"success"` or
`"no_op"` receipt has nothing to classify, so the fields are omitted rather than
set to null. Values are the exact Lean constructor names from `RootCauseType`,
`RootCauseCategory`, and `RecoveryBehavior` in
`procint/ProcInt/Playground/Trajectory/RootCause.lean` and
`RecoveryBehavior.lean`, so a receipt's string can be checked against the
kernel-checked type by name instead of re-derived informally. Per arXiv:2607.09510
(Zhao et al.), these fields exist to let this loop's own record validate *how* and
*when* a firing went wrong, not only whether it did: the paper's t_err/t_lock/t_obs
decomposition is built precisely because judging a trajectory by final outcome
alone lets a decisive error go unobserved for long stretches, which is the same
failure mode this loop's own truncation incident exhibited.

`.mfact/metrics-history.jsonl`: one line appended per firing (not per item), never
rewritten:

```json
{"timestamp": "...", "git_head": "abc1234", "gaps_open": 41, "gaps_closed_this_firing": 1, "lake_build_pass": true, "sorry_count": 0, "axiom_count": 3}
```

`convergence_ratio` (computed at read time, not stored): mean `gaps_closed` over the
most recent 10 lines vs. the first 10 lines on record. A loop reading this file
before picking an item can tell "still closing gaps" from "flatlined" without
re-deriving it from raw ledger diffs.

## Stuck-item guard

Before picking, read the last 10 receipts' `gap_id` fields. If one `gap_id` appears
in more than 7 of them with no `status: success` among those attempts, skip it and
log a `no_op` receipt with `"collision": false` and a note that it may be stuck --
do not retry it again this run.

## Collision guard

Unchanged from v1: check `git status --porcelain` and `git log -5` before touching
anything; if state is unexplained (not this loop's own last logged commit), write a
receipt with `"status": "failed", "collision": true` and do no other work that
firing.

## Run log

(Awaiting first firing under this design. Prior design, v1, was created and paused
before ever firing -- no entries carry over.)
