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

Implemented for real at `scripts/stuck_item_guard.py`, wired into `just
stuck-item-guard` -- a deterministic cross-firing repetition check, explicitly
**not** the arXiv:2607.09510 real-time trajectory-prefix monitor (that needs
~600 labeled trajectories to fit/evaluate; this repo has three receipts total as
of this writing -- see `TRAJECTORY_MONITOR_FEASIBILITY.md` for why that monitor
is not honestly buildable yet). A firing may run `just stuck-item-guard` as part
of STEP 2 instead of re-deriving the check by hand from raw receipt files.

## Collision guard

**v3 (current), delta-based against `.mfact/known-persistent-drift.txt`.** v1/v2's
guard compared against an absolute clean tree and collided identically on every
firing (runs 1 and 2, both real collisions logged below) against this repo's
static pile of pre-existing uncommitted/untracked files -- correct behavior per
its own literal spec, but it meant the loop could never get past STEP 1 as long
as that pile existed, which it always would. v3 instead diffs live
`git status --porcelain` against a baseline snapshot
(`.mfact/known-persistent-drift.txt`, generated once from PRAXIS_SELF_AUDIT.md
pass 4's PD6-corrected file list) and only treats paths NOT in that baseline as a
real collision. `git log -5` foreign-commit detection is unchanged. Touching a
baseline-listed file to do real gap-closing work is allowed; its pre-existing
diff just doesn't block starting.

## Run log

- **2026-07-13T07:15:16Z (run `20260713T071516Z`, firing 1) -- COLLISION, no action
  taken.** `git status --porcelain` showed staged (`A`/`M`) changes from an
  uncommitted in-flight workflow (task `w3xrg1r0m`: the two new Trajectory Lean
  files, this file's own schema section, the two new scripts, and edits to
  `AGENTS.md`/`justfile`/`Playground.lean`), plus the long-standing unattributed
  modifications to `.ggen-v2/*`, `.mfact/artifacts.toml`, `validate.rs`,
  `ggen.lock`, `release/standing.env`, `web/mfact-ui` already flagged across
  `PRAXIS_SELF_AUDIT.md` passes 1-3. None of this is this loop's own prior work
  (this is firing 1). Per the collision guard, touched nothing, wrote receipt
  `.mfact/receipts/20260713T071516Z.json` with `collision: true`, and stopped.
  Next firing should re-check whether `w3xrg1r0m` has committed by then.

- **2026-07-13T07:43:50Z (run `20260713T074350Z`, firing 2) -- COLLISION again, no
  action taken.** `w3xrg1r0m` had committed by this firing (HEAD = `c741d46`, this
  loop's own prior commit -- no unexpected new commits), so firing 1's specific
  blocker is gone. But the guard still tripped: 8 persistent, unattributed modified
  files (`.ggen-v2/*`, `artifacts.toml`, `validate.rs`, `ggen.lock`,
  `release/standing.env`, `web/mfact-ui`) remain uncommitted since before this
  session's work began, plus a large untracked pile including this session's own
  not-yet-committed report docs and `.claude/` additions. **Design note, not a bug
  in this firing's behavior:** the guard as specified compares against "any
  uncommitted state," not a delta from the last check -- as long as this static
  pile exists uncommitted, every future firing will collide identically regardless
  of whether anything new actually happened. The guard is doing exactly what it
  was told to do; what it was told to do may need revisiting (e.g. snapshot-diff
  against the last collision's file list, not an absolute clean-tree requirement)
  if the loop is ever to get past STEP 1. Wrote receipt
  `.mfact/receipts/20260713T074350Z.json` with `collision: true`, and stopped.

- **2026-07-13T16:31:30Z (run `20260713T163130Z`, firing 3) -- SUCCESS, first real
  gap closed.** v3's delta-based collision guard passed cleanly (`comm -23` output
  empty; the only uncommitted state was the known baseline). Picked the mfact-core
  `turbulence` build break (not previously ledger-tracked -- added as new entry
  G49). Re-verified still open (`cargo check --all-targets` reproduced the exact
  E0425 error). Root cause: `simulate_workload` was called but never defined; the
  removed doc comment's claim that it was "removed in favor of empirical
  ingestion" had zero supporting evidence anywhere in the crate (grepped, found
  nothing) -- a stale, unfalsifiable claim, not a real migration. Implemented a
  real `simulate_workload` (genuine scalar CPU loop, `std::hint::black_box`
  guarding against optimization), not a stub. `oracle_rank: 1` --
  `cargo check --bin turbulence` before/after (fail → exit 0), plus a 10s sanity
  run confirming the binary actually executes rather than merely compiling. G49
  added to `GAP_LEDGER_v26.7.12.md` and marked `CLOSED` in the same commit as the
  fix (`eabe589`). Receipt: `.mfact/receipts/20260713T163130Z.json`. Metrics:
  `gaps_open: 23`, `sorry_count: 16` (raw grep across `procint/ProcInt`, not a
  kernel-level check), `axiom_count: null` (an `AxiomAudit` build attempt
  succeeded per its own log but produced no binary at the expected path --
  deliberately not chased further this firing to avoid repairing a second,
  unrelated problem; worth a future firing's attention).
