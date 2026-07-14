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

- **2026-07-13T16:59:52Z (run `20260713T165952Z`, firing 4) -- SUCCESS, second
  real gap closed.** Collision guard passed cleanly again. Picked
  `scripts/stuck_item_guard.py`'s missing wiring (`PRAXIS_SELF_AUDIT.md` PC6/PD4,
  new ledger entry G50). Re-verified still open: `grep -n stuck_item_guard
  justfile MFACT_SELF_IMPROVEMENT_LOOP.md` returned nothing despite the script
  working standalone. Added a `just stuck-item-guard` recipe and a
  cross-reference in this file's own Stuck-item guard section above.
  Re-verification (STEP 5) caught a real bug before commit: the recipe first
  passed the receipts path positionally, matching the neighboring
  `trajectory-annotate` recipe, but `stuck_item_guard.py`'s `argparse` requires
  `--receipts DIR` -- first run failed with `unrecognized arguments`. Fixed,
  re-ran, confirmed exit 0 with correct output. `oracle_rank: 1`. G50 added to
  `GAP_LEDGER_v26.7.12.md`, `CLOSED` in the same commit (`c636fd3`). Receipt:
  `.mfact/receipts/20260713T165952Z.json`. `axiom_count` is still `null` this
  firing -- pass 7's audit (`PRAXIS_SELF_AUDIT.md`) resolved *why* no binary
  appears at the expected path last firing: `AxiomAudit.lean` has no
  `main`/entry point and is correctly declared `[[lean_lib]]`, not
  `[[lean_exe]]`, in both `mfact/` and `procint/` lakefiles -- there was never a
  binary to find, so that was not a bug. The real, smaller gap: no script in
  this repo actually computes an `axiom_count` metric yet (parsing `lake build
  AxiomAudit` stdout would be the real fix) -- fuel for a future firing, not
  attempted here to stay scoped to the picked item.

- **2026-07-13T17:30:45Z (run `20260713T173045Z`, firing 5) -- SUCCESS, G51
  closed.** Added the `[lints.clippy]` gate to `crates/mfact-core/Cargo.toml`
  (todo/unimplemented/dbg_macro deny; unwrap_used/expect_used warn -- all 5
  existing unwraps are in `#[cfg(test)]`, exempt per house style) and a `just
  clippy-core` recipe. Two notable events: (1) the `.claude/hooks/
  require-just.sh` guardrail blocked this firing's first bare `cargo clippy`
  call -- worked as designed, forced the recipe to exist; (2) verification used
  a real negative control: an injected `dbg!` failed the gate (`-D
  clippy::dbg-macro`), the reverted tree passes clean. Recipe scoped to
  `--lib --bin turbulence` because `src/main.rs`/`sse_transport_test.rs` are
  G2/G11 dead-pile files failing compile independent of lints. `oracle_rank:
  1`. Commit `0639081`; receipt `.mfact/receipts/20260713T173045Z.json`.

- **2026-07-13T17:57:00Z (run `20260713T175700Z`, firing 6) -- COLLISION, no
  action taken.** Delta-based guard found 7 new paths outside the tolerated
  baseline: `ontology/fortune5-cloud-architecture.ttl`,
  `PRAXIS_SELF_AUDIT.md`, `procint/ProcInt/MFW/Residue/Tenancy.lean`,
  `procint/ProcInt/MFW/Termination/`, `procint/ProcInt/Playground/Glue/`,
  `procint/ProcInt/Playground/Multifractal/UniformWitness.lean`,
  `procint/ProcInt/Playground/Swarm11/Correspondence/LedgerBridge.lean`. All
  attributable to a separately-launched 10-agent construction workflow (task
  `wkw4npeny`, user-directed, implementing an approved plan to connect mfact's
  independent Lean layers) still mid-flight in the Construct phase -- no
  foreign commits, HEAD unchanged at `5dc2f5c`. This is exactly the scenario
  the v3 redesign anticipated: a large, legitimate, concurrent effort that
  simply hasn't committed yet. Wrote receipt
  `.mfact/receipts/20260713T175700Z.json` with `collision: true`, and stopped.
  Next firing should re-check whether `wkw4npeny` has committed by then.

- **2026-07-13T18:26:57Z (run `20260713T182657Z`, firing 7) -- COLLISION
  again, no action taken; correction noted.** `wkw4npeny` had committed
  Waves 1-5 by this firing (`69df262`, `250fcc7`, `d6fc2a3`, `782bf6c`,
  `6270a44`, all real, none foreign). The 7 remaining paths -- Wave 6's
  `procint/ProcInt/MFW/Termination/*.lean`, Wave 7's `OrientedSwap.lean`, the
  `Playground.lean` import edit, and `ROADMAP_MATH_SPINE.md` -- are Waves 6/7
  still mid-integration, correctly identified precisely (pass 11's audit,
  `PRAXIS_SELF_AUDIT.md` PK9, flagged firing 6 for attributing all 7 of its
  paths to the construction workflow when one, `PRAXIS_SELF_AUDIT.md` itself,
  was actually this audit loop's own pass-9 output -- this firing's receipt
  double-checked attribution precisely against `git log` rather than
  assuming). Wrote receipt `.mfact/receipts/20260713T182657Z.json` with
  `collision: true`, and stopped.

- **2026-07-13T18:57:04Z (run `20260713T185704Z`, firing 8) -- COLLISION, no
  action taken.** `wkw4npeny` finished (waves 0-7 all landed, pass 10
  independently confirmed 9/10 CONFIRMED). New collision: `ROADMAP_SOC2_MATH.md`,
  a fresh file from a separately-launched SOC2 Trust-Services-Criteria
  correspondence workflow (task `w3uu76xt9`), Draft phase just completed.
  The coordinating session owes this file a scope-correction pass (two
  post-dispatch user clarifications: praxis owns any Rust/runtime
  correspondence work, not mfact; the validated Lake>Lean4>TTL>ggen chain is
  mfact's complete boundary, no FFI-closing machinery belongs here) before it
  should be treated as settled. No foreign commits. Wrote receipt
  `.mfact/receipts/20260713T185704Z.json` with `collision: true`, and
  stopped.

- **2026-07-13T19:26:56Z (run `20260713T192656Z`, firing 9) -- COLLISION, no
  action taken.** New path: `procint/ProcInt/Playground/SOC2/`, from the SOC2
  flow-test construction workflow (task `wfigivqnl`, Build phase writing
  `AuditFlow.lean`/`AuditFlowViolation.lean` -- concrete Lean witnesses
  composing Waves 1-7's already-proven theorems on a two-tenant audit
  scenario; pass 13 confirmed zero files as of ~12:14 PDT, this firing sees
  the directory created ~12 minutes later, i.e. genuinely in-progress, not
  stalled). No foreign commits. Wrote receipt
  `.mfact/receipts/20260713T192656Z.json` with `collision: true`, and
  stopped.

- **2026-07-13T20:05:05Z (run `20260713T200505Z`, firing 10) -- SUCCESS,
  third real gap closed.** First clean pass since firing 5 (5 consecutive
  collisions in between, all correctly diagnosed as legitimate concurrent
  work per pass 13). Picked G11 (mfact-core dead/fake FFI subsystem).
  Re-verified still open: none of the 4 named files (`broker.rs`,
  `thermo.rs`, `transport.rs`, `lean.rs`) referenced from `lib.rs`. Applied
  the ledger's own "Fix (b), Abandon it" path fully -- deleted those 4 plus
  `lean_ffi_wrapper.c` (PA24's fake stand-ins), `main.rs` (broken caller of
  the deleted `transport` module, independently missing `tokio`), and the
  two orphaned integration tests that imported the deleted modules. All 8
  were untracked, so deletion produced no git diff of its own -- only the
  ledger update is a real commit. `just clippy-core` exit 0 before and after,
  confirming zero build impact (genuinely dead code). Delete-not-wire-in
  follows this session's scope clarification: a real FFI binding would
  itself be "implement the code," out of mfact's scope. One residual
  explicitly left open, not silently dropped: `web/mfact-ui`'s dead
  `EventSource` reference (TypeScript, different domain, noted in G11's
  closure evidence for a future pass). `oracle_rank: 1`. Commit `108bf5b`;
  receipt `.mfact/receipts/20260713T200505Z.json`.

- **2026-07-13T20:27:33Z (run `20260713T202733Z`, firing 11) -- COLLISION, one
  self-cleanup landed first.** Before this firing, an independent audit pass
  (pass 15, finding PO1) had caught that firing 10's G11 closure left a
  landmine: `crates/mfact-core/build.rs` still referenced the just-deleted
  `lean_ffi_wrapper.c` via `cc::Build`, undetected because this sandbox's
  PATH lacks `lean` so `build.rs` bails out before reaching that call. That
  was fixed directly (outside this firing, same session): `build.rs` reduced
  to `fn main() {}`, unused `cc` build-dep dropped from `Cargo.toml`, G11's
  ledger entry corrected with a dated note rather than silently amending
  firing 10's original claim (commit `5608deb`). This firing's own STEP 1
  delta check then caught a genuine leftover from that work: `Cargo.lock`'s
  matching `cc`-entry removal had never been staged. Confirmed by diff that
  its only change matched the already-committed `Cargo.toml` edit exactly --
  self-attributable, not a collision -- so it was committed separately
  (`05f64df`) before re-running the delta. The re-run still showed 2 new
  paths: `procint/ProcInt/Playground.lean` (import registration) and the new
  `procint/ProcInt/Playground/Glue/OrientedSwapReplay.lean` (11.5KB) --
  both the still-running 10-agent Lean-testing-landscape workflow's (task
  `wup6bpemk`) just-completed first build spec. Legitimate concurrent work
  mid-flight (its own Verify+Integrate phase hasn't run yet), not a foreign
  actor; `git log -5` showed no commit outside this session. Per the guard,
  touched nothing further, wrote receipt `.mfact/receipts/20260713T202733Z.json`
  with `collision: true`, and stopped.

- **2026-07-13T21:27:03Z (run `20260713T212703Z`, firing 13) -- COLLISION, no
  action taken.** Note on numbering: firing 12 ran its STEP 0/1 checks while
  the coordinating session was in plan mode and could not write a receipt or
  append here -- that gap is being backfilled out of order by a separately
  launched workflow (task `wsr99yw42`'s Wave 4c) and may land after this
  entry rather than before it; this is a cosmetic ordering artifact of two
  concurrent writers, not a data-loss risk (Read-then-Edit throughout).
  This firing's own delta check found 2 new untracked paths:
  `release/certify.log` (0 bytes) and `release/certify.stderr` (87 bytes),
  mtime 14:10 PDT. Both are process-output artifacts from a real `mfact
  certify` invocation a concurrent workflow's verify agent ran directly
  (task `wnz6xi5ce`, a release-ARD/PRD synthesis, now completed) while
  independently re-checking a PRD claim about the certify gate's current
  failure state -- not a foreign/uncoordinated actor. Per STEP 1's
  unconditional rule (any non-empty delta is a real collision, no carve-out
  for "looks like harmless log output"), this firing did not judge the
  paths further or attempt to route around the rule. A second workflow
  (task `wsr99yw42`, implementing a testing-atlas integration plan --
  most recent commit `e590d1b`, mid-Wave-3 of 4) is also still actively
  running, reinforcing that staying conservative here was correct. `git log
  -8` showed no foreign commits. Wrote receipt
  `.mfact/receipts/20260713T212703Z.json` with `collision: true`, and
  stopped.

- **2026-07-13T20:56:40Z (run `20260713T205640Z`, firing 12) -- DEFERRED, no
  action taken; backfilled after firing 13.** STEP 0 (deadline check) passed:
  `date` showed 2026-07-13 13:56:40 PDT, well before the 2026-07-13 16:49:04
  PDT deadline -- not a self-terminate case. STEP 1 (delta-based collision
  guard) also passed clean: `git status --porcelain | sed -E "s/^.{3}//" |
  sort` piped through `comm -23` against `.mfact/known-persistent-drift.txt`
  was empty -- firing 11's collision (task `wup6bpemk`) had committed by then
  as `84ab3de`, and `git log -5 --oneline` showed no foreign commits. But the
  coordinating session was in plan mode at firing time, which by design
  cannot write receipts, commit, or append to this log -- so STEPS 2-7 (pick
  a gap, fix, verify, commit, write receipt) never ran: no gap was picked,
  nothing was touched, and no commit belongs to this firing itself. Not a
  failure (nothing was attempted and botched) and not a success/no_op (no
  check ran to report on) -- receipt uses a new `status: "deferred"` value
  (see Receipt schema above). Written once plan mode lifted, out of run_id
  order: this entry lands after firing 13's above rather than before it, the
  same ordering artifact firing 13's own entry already anticipated. Receipt:
  `.mfact/receipts/20260713T205640Z.json`. The firing that actually resumes
  STEPS 2-7 should proceed normally from a clean STEP 0/1 baseline.

- **2026-07-13T21:57:46Z (run `20260713T215746Z`, firing 14) -- COLLISION,
  no action taken.** Delta-based guard found 4 new paths:
  `PRAXIS_SELF_AUDIT.md` (a concurrent audit workflow's Pass-17 flush,
  task `w08jbbeij`, caught mid-edit -- modified, not yet committed) and
  `release/certify.log` / `release/gates.json` / `release/release-
  manifest.json` (regeneration output from a second concurrent workflow,
  task `wdwi5dj1x`, working the v26.7.13 release's 80/20 -- it had just
  landed a second real fix, `ca3cf5c` "strip literal backslash-n escape
  from axiom names in build_manifest.py", on top of an earlier one,
  `0e99a2b`, and appears to be re-running certify/manifest regeneration to
  verify). Not foreign actors -- both are workflows launched earlier this
  session; `git log -6` showed no commit outside either of them. Per
  STEP 1's unconditional rule, touched nothing further. Wrote receipt
  `.mfact/receipts/20260713T215746Z.json` with `collision: true`, and
  stopped.

- **2026-07-13T22:26:46Z (run `20260713T222646Z`, firing 15) -- COLLISION,
  no action taken; real progress landed elsewhere.** Delta-based guard
  found 1 new path: `procint/ProcInt/Playground/Swarm11Verifier.lean`,
  modified but uncommitted -- task `w5wz0xlhz` (a session-user-directed
  repair of GAP_LEDGER's G53, the `ManufactureStep`-tenancy soundness
  gap) mid-way through its second phase, wiring `ManufactureTenancyGap
  .checks` into the SOC2 verifier fold. Not a foreign actor. Notable
  since the last firing: G53 itself is already closed (`11b03d2`,
  "compose ManufactureStep with tenant residue"), and the audit loop's
  Pass 18 landed cleanly with a self-describing commit message
  (`4b76101`) -- confirming a prior firing's diagnosed git-index-race
  fix (making the flush commit message self-identify) worked as
  intended this time. Per STEP 1's unconditional rule, touched nothing
  further. Wrote receipt `.mfact/receipts/20260713T222646Z.json` with
  `collision: true`, and stopped.

- 2026-07-13 ~16:34 PDT (cron f6a6cd52, firing 16, run_id 20260713T233418Z): **no_op --
  G50 re-verified already closed; trigger candidate list stale.** Delta
  guard empty, git log all session-attributable (Dogfood Waves 0-5 landed
  since firing 15: `46f81ee`..`81fbbad`, G54-G57 opened and CLOSED,
  swarm11-verify now 59 checks 0 failures). Per STEP 3, re-ran G50's
  original flagging check instead of trusting the candidate list:
  `grep -n stuck justfile` finds the `stuck-item-guard` recipe at
  justfile:238-239, the loop doc cross-references it at :90-95, and the
  ledger entry is Status: CLOSED with a prior firing's closure evidence
  -- the wiring the candidate list calls missing exists. G1 deliberately
  not taken: its honest closure needs the fresh `just certify` re-run the
  in-flight release-80/20 workflow (wv5ynj9fq) owns per Pass 19 PS4's
  caveat. Rust candidates unreachable at oracle rank 1-3 (hook blocks
  cargo). Receipt `.mfact/receipts/20260713T233418Z.json`, oracle_rank 3.
  Final firing inside the window (deadline 16:49:04 PDT) -- the next cron
  fire self-terminates the loop per STEP 0.

- 2026-07-13 16:58 PDT (cron f6a6cd52): **LOOP COMPLETE (deadline reached).** STEP 0
  fired at 16:58:07 PDT, past the 16:49:04 PDT bound; CronDelete f6a6cd52 executed.
  Whole-run summary from the Run log and the 17 receipts on disk: 16 firings across
  the two granted windows. Outcomes: 5 success (G49 eabe589, G50 c636fd3, G51 0639081,
  G11 in two stages 108bf5b + 5608deb), 1 no_op (firing 16: G50 re-verified already
  closed -- the trigger's candidate list had gone stale), 1 deferred (firing 12, plan
  mode blocked writes; backfilled by a334ff5), and 10 collision stops -- every one of
  which was the delta guard working as designed against this session's own concurrent
  workflows (atlas integration, G53 repair, release-80/20, audit passes), never a
  foreign actor. Notable loop-produced diagnoses that outlived the loop: the
  git-index race (fixed by surgical pathspec commits, confirmed working from Pass 18
  onward), the PO1 build.rs landmine fix, and the candidate-list staleness pattern
  (three trigger candidates -- stuck-item-guard wiring, G1 certify, G50 -- were closed
  by other actors while the list kept offering them; STEP 3's re-verify-before-trust
  rule caught all three). The loop leaves no stuck items: no gap_id appears in more
  than 7 of the last 10 receipts. Companion loops (audit 9bab36de, release 76f42877)
  remain active and are not governed by this deadline.

- 2026-07-13 ~17:20 PDT (audit Pass 21 correction, PU2): the LOOP COMPLETE tally above
  conflated receipts with firings. Correct arithmetic: 17 receipts = 16 firings + 1
  out-of-band receipt (20260713T211642Z, the PO1 build.rs fix firing 11 attributed to
  "outside this firing"); per-firing successes are 4 (firings 3, 4, 5, 10), not 5 -- the
  fifth success receipt was the out-of-band action. Totals otherwise stand.
