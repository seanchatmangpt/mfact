# WASM4PM Autonomic Exploration

## Scope

Read-only exploration of `~/wasm4pm` (github.com/seanchatmangpt/wasm4pm), a mature,
unrelated-repo-scoped Rust/TS project, from this mfact session. Prompted by the user
asking specifically for concrete code/patterns to adapt or refactor into mfact's own
autonomic dogfood loop (`MFACT_SELF_IMPROVEMENT_LOOP.md`, currently paused, cron jobs
currently deleted pending review). Same read-only boundary this session already applies
to `~/praxis` under AGENTS.md section 3: nothing under `~/wasm4pm` was written, edited,
or committed. Every finding below cites a literal command run or a `file:line` read.
This report proposes changes to mfact only, never to wasm4pm.

## 1. Executive summary

wasm4pm already learned, the hard way, exactly the lesson mfact's brand-new loop is about
to skip: an autonomic loop that logs "item picked, fix applied, verification ran, commit
made" with no before/after delta co-located in that same record cannot prove it is
converging (`autonomic-observability-gaps-audit.json`, 3 CRITICAL gaps, fixed in commit
`8c006c82d` two weeks later). Before resuming, mfact's loop should add: (1) a per-firing
receipt with a before/after delta field living in the same record as the commit hash, (2)
a rolling convergence/stuck-item tracker over firings, not just per-fix evidence, (3) a
hard rule that the gap-ledger `Status` field updates atomically in the same commit as the
fix (wasm4pm's own gap-tracking docs went stale for weeks because this discipline was
absent), and (4) a Rank-tagged, non-self-referential verification gate before any item is
marked closed. None of this requires RL, OTEL, or wasm4pm's dependencies — the reusable
part is data-structure shape and discipline, not machinery, and mfact already has a
stronger `GAP_LEDGER_v26.7.12.md` (Selection law, wave-based closing runs, Status legend)
than anything wasm4pm's own gap tracking ever achieved, so most of the work is wiring
mfact's existing artifacts together rather than importing new ones.

## 2. Findings

### 2.1 Directly portable code

**F1 — `ActionHistory` rolling-window stuck-item guard.**
Evidence: `wasm4pm/src/rl_orchestrator.rs:428-516` defines `ActionHistoryEntry {action,
reward_before, reward_after, successful, timestamp}` in a `VecDeque` capped at 100
(`record_action_entry`, lines 465-470); `get_success_rate()` (494-506) and
`get_action_stats()` (1120-1155) return per-action `(total, successful, rate)`. The
repetition guard at 1553-1569: `if current_action_count > 7 { ... -0.1 }` over the last 10
entries, logged as "action diversity penalty applied: policy may be locked."
mfact action: port `ActionHistoryEntry`/`ActionHistory` near-verbatim, replacing
`action: String` with the gap-ledger item ID. If the same item is picked in >70% of the
last 10 firings without a `successful` outcome, skip it and log a "may be stuck" warning.
This is the single most direct fix for a loop with no stuck-item detection.

**F2 — BLAKE3-hashed, tamper-detecting checkpoint format.**
Evidence: `wasm4pm/src/policy_persistence.rs:32-140`. `PolicyCheckpoint::new()` hashes a
canonical JSON of its own fields with `blake3::hash()` and stores the hex digest as
`blake3_hash` (78-103); `load()` (117-140) re-verifies. `test_corrupt_hash_detection`
(246-272) confirms tampering `checkpoint_epoch` after save makes `load()` return `Err`
containing "Hash mismatch."
mfact action: wrap each loop-cycle record (gap item, commit sha, fix score, timestamp) in
the same ~15-line shape: hash the record's canonical JSON with BLAKE3, store the digest
alongside it, verify on read. No new dependency beyond the `blake3` crate mfact likely
already links via `.ggen-v2`.

**F3 — `oracle_validator.rs` Rank-1..4 hierarchy, Rank-5 forbidden.**
Evidence: `wasm4pm/wasm4pm/tests/oracle_validator.rs:14-230`. Full `Rank` enum and
`OracleValidator::validate`/`validate_rank1..4`. Rank-1 = mathematical (external theorem),
Rank-2 = domain contract/invariant, Rank-3 = metamorphic, Rank-4 = statistical (>=50
cycles, >=5 seeds). Rank-5 (code-derived/self-referential oracle) is hard-rejected via a
`forbidden_keywords` set (`computed_same_formula`, `impl_variable`, `code_path`,
`state_machine`, `test_derives`). Only `std::collections::HashSet` — no external deps.
mfact action: port the enum and forbidden-keyword guard almost verbatim as a closure-
evidence classifier for `GAP_LEDGER_v26.7.12.md`: Rank-1 = Lean theorem name / clean
`#print axioms` / Mathlib lemma cite; Rank-2 = a `STANDING.md` invariant restated; Rank-3
= property-based perturbation claim; Rank-4 = N-firing statistical convergence. Reject any
closure whose only evidence is the loop's own success flag (Rank-5).

**F4 — `_shared.ts` atomic-write receipt primitive.**
Evidence: `wasm4pm/apps/wasm4pm/src/receipts/_shared.ts:16-96`. `atomicWriteSync()` writes
to `${target}.${pid}.${rand}.tmp` then `renameSync`; `CommandReceipt` interface (run_id,
command, input_hash, output_hash, status: success|partial|failed, timestamp, summary?);
`validateCommandReceipt()` throws on bad shape (caller only warns); `saveCommandReceipt()`
writes both `<run_id>.json` and atomically overwrites `latest.json`. Verified against 5
sampled real receipts, e.g. `.wasm4pm/receipts/008a484b-...json`.
mfact action: port near-verbatim as a ~40-line bash/python helper, called once per cron
firing: `run_id=$(uuidgen)`, `input_hash` = hash of the gap-ledger item text being worked,
`output_hash` = hash of the resulting diff/commit, `status`, `summary = {gap_id,
commit_sha, duration_ms}`. Write to `.mfact/receipts/<run_id>.json` +
`.mfact/receipts/latest.json`. `.ggen-v2/receipt-log.jsonl` only covers `ggen.sync` build
activity, not loop firings — this is a genuinely new, currently-missing artifact.

**F5 — PostToolUse per-action append-only event log.**
Evidence: `wasm4pm/.claude/hooks/post_tool_use_emitter.sh:7-33` writes one JSONL line per
tool call to `.claude/evidence/events.jsonl` (`work_unit_id`, `timestamp`, `tool_name`,
`file_path`, `command_preview`, `git_head`). Live-verified: `grep -c '"work_unit_id"'
.claude/evidence/events.jsonl` = 6816 events. Rotation in `session-end.sh`: `if
"$line_count" -gt 50000; then tail -n 50000 ... > tmp && mv`.
mfact action: add an equivalent PostToolUse-style append to `.mfact/evidence/events.jsonl`
during each loop firing (work_unit_id, timestamp, action taken, file_path, git_head), with
the same tail-based rotation. Cheapest possible receipts directory — no hashing required,
just an append-only trail binding every mutation to the commit it happened at.

**F6 — `ggen` binary is already installed and has an unused receipt chain.**
Evidence: `which ggen` -> `/Users/sac/.cargo/bin/ggen`; `ggen --version` -> `ggen 26.7.4`.
`ls -la /Users/sac/mfact/.ggen` -> no such directory (mfact has never run `ggen sync`).
Compare `wasm4pm/.ggen/receipts/sync-20260520-070811.json`: `input_hashes` (BLAKE3 of every
ontology/manifest file + actuator version), `output_hashes` (hash of every generated
file), `signature`, `previous_receipt_hash` forming a chain. `ggen receipt verify`
recomputes and verifies the BLAKE3 chain; `ggen receipt history` verifies the full chain
in `.ggen-v2/receipt-log.jsonl`.
mfact action: mfact already links this exact receipt-chain machinery via `.ggen-v2/` for
build provenance. Either run `ggen sync` regularly so the loop gets a real receipt chain
for free, or mirror the schema (`operation_id`, `timestamp`, `input_hashes`,
`output_hashes`, `previous_receipt_hash`) for a loop-specific ledger distinct from ggen's
build-provenance one.

**F7 — `process_tree.rs` (wasm4pm main, not wasm4pm-compat) is the fuller correspondence
source for `procint/ProcInt/Models/ProcessTree.lean`.**
Evidence: `wasm4pm/wasm4pm/src/process_tree.rs:116-257` defines `ProcessTreeOperator` and
`ProcessTree` with doc-comment citations to Leemans et al. 2013 SS2 Def 2.1 and a language-
semantics table (seqLang / xor-union / interleave / loop); `grep '#\[test\]'` on the file
returns 23 matches. `procint/ProcInt/Models/ProcessTree.lean:8-11` already says "Ported
from wasm4pm-compat process_tree.rs (structure-only shape canon)" — but wasm4pm-compat's
553-line version is a *different*, thinner canon than wasm4pm main's fuller one (different
operator naming: `Xor`/`Silent` vs. main's `ExclusiveChoice`).
mfact action: when strengthening `ProcessTree.lean` beyond structure-only shape, cross-
check against `wasm4pm/wasm4pm/src/process_tree.rs`'s test fixtures (seqLang, LoopLang,
interleavings) as the fuller oracle, and update the doc comment to distinguish which of
the two wasm4pm repos each proof obligation actually corresponds to.

**F8 — `8c006c82d`'s `tracing::field::Empty` + `record()` convergence-field pattern.**
Evidence: `git -C ~/wasm4pm show 8c006c82d -- wasm4pm/src/rl_orchestrator.rs`. Span fields
`td_error`, `q_value_max`, `convergence_signal` declared as `tracing::field::Empty` at span
creation, then `tracing::Span::current().record("td_error", td_error_linucb)` etc. once the
downstream computation is available; `convergence_signal` derived as `"learning"` vs.
`"converged"` from `td_error_linucb.abs() > 0.1`. Puts the causal proof and the action that
produced it in one record instead of two log lines an operator must join by hand.
mfact action: declare a `convergence_signal` (and a `verify_delta`) field on each loop-
firing's structured log entry up front, compute the before/after delta once the fix lands
and the verification command re-runs, and record both into that same entry — not a
separately emitted metric.

### 2.2 Patterns to reimplement

**F9 — Reward as a pure, bounded, LUT-driven scalar (no RL needed for the shape).**
Evidence: `rl_orchestrator.rs:274-392`, `RewardParameters` and
`compute_reward_with_momentum()`; documented bounded range "approximately [-5.5, +1.6]"
(line 259); `const HEALTH_DELTA: [f32; 3] = [-1.0, 1.0, 0.2];` (336); momentum bonus
`0.05_f32 * capped_successes` capped at 10 cycles (371-386).
mfact action: write `compute_fix_score(FixOutcome) -> f32` with the same shape — named
signals (tests_passed, caused_regression, lint_clean, cycles_since_last_success) through
small const lookup tables, `debug_assert` bounds, a doc comment stating min/max. Log it in
every cycle record exactly as `run_cycle` logs `reward`.

**F10 — Pseudo-TD-error as a cheap "surprise" signal without a policy model.**
Evidence: `rl_orchestrator.rs:1045-1058`, `linucb_update()`: `let td_error = reward -
ucb_score_before;` guarded by `debug_assert!(td_error.abs() < 100.0)`.
mfact action: mfact has no value function, so keep it structural only: an exponential
moving average of the last N fix-scores as `expected_score`, then `pseudo_td_error =
fix_score - expected_score`. A large positive/negative value is "this fix worked much
better/worse than the loop's recent norm" — cheap, no RL, and gives the loop something to
plot for "is it actually improving," which the current design has none of.

**F11 — `RlStabilityMonitor`: convergence/divergence/chaos trackers on rolling windows.**
Evidence: `wasm4pm/src/rl_stability_monitor.rs:1-180`. `TdErrorStats.convergence_ratio`
("mean(last 10)/mean(first 10) ... <1.0 indicates convergence", 24-26);
`QValueDivergenceMonitor.is_diverging` (">50% growth in the last 50 cycles", 53-67);
`LearningCurveSmoothness.is_chaotic` (">20% of deltas classified as jumps", 79-83);
`RewardScalingValidator.has_extreme_outliers` (">5 sigma from mean", 104-109). Wired into
`run_cycle` at 1396-1398, reported on the cycle span at 1444-1447.
mfact action: build a `SelfImprovementStabilityMonitor` with the same 4-5 sub-trackers fed
mfact numbers — rolling fix_score history to convergence_ratio, rolling cycle-latency to a
divergence flag, rolling pseudo_td_error (F10) to a chaotic-jump flag. This is the single
most direct fix for "no convergence/learning signal" — wasm4pm's file is close to a ready-
made spec, and none of the trackers require RL to reimplement.

**F12 — OBS-GAP-2's category-threading + match-based correctness check.**
Evidence: `git show 8c006c82d -- wasm4pm/src/lib.rs`. `spc_rule_types: Vec<&'static str>`
pushed at 6 detection sites, then at action-selection: `let action_matches_spc_rule =
match (spc_primary_rule_type, action_label.as_str()) { ("rule_1_outlier", "Retry" |
"Scale") => true, ... _ => false };` recorded on the span.
mfact action: carry the gap-ledger lens/category (rust-build, lean-procint, reachability,
etc. — see `GAP_LEDGER_v26.7.12.md`'s ten lenses) through to the commit log entry, and
compute a `fix_matches_gap_category` boolean the same way, so a reviewer can query the
loop's own log for category mismatches instead of re-deriving them from the diff.

**F13 — OBS-GAP-3's cross-cycle correlation boolean.**
Evidence: `git show 8c006c82d -- wasm4pm/src/lib.rs`. `let circuit_recovery_signal =
circuit_state.contains("Closed") && circuit_allowed;` recorded on the same
`autonomic.decision_action_selected` span that already carries `health`.
mfact action: because mfact's loop is git-commit-based and single-repo, the analogous
blind spot is a fix committed in cycle N whose value only shows up when the *next* cron
firing's verification runs. Add a `prior_cycle_outcome_confirmed` boolean, set on the next
firing when it re-checks whether the previous commit's claimed fix actually held.

**F14 — Three-layer evidence gate, fail-fast in order.**
Evidence: `wasm4pm/wasm4pm/tests/chicago_tdd_auditor.rs:29-35` (`AuditLayer`: OtelSpan,
TestAssertion, SchemaConformance) and `:137-179` (`validate_three_layer_evidence`, short-
circuits at the first failing layer, with unit tests for each failure mode).
mfact action: replace "fixed it, logged it" with a three-layer gate: (1) artifact-exists /
builds, (2) independent re-derived verification assertion (not reuse of the fix's own
output), (3) log-schema conformance for the ledger entry. Close the item only if all three
pass in that order.

**F15 — Numbered fail-fast gate sequence (G0..G6) with ALIVE/BLOCKED printouts.**
Evidence: `/Users/sac/chicago-tdd-tools/scripts/otel-workflow.sh:9-56`
(`G0_WEAVER_BINARY_AVAILABLE` through `G5_GENERATED_BINDINGS_COMPILE`, `ART_DIGEST=$(shasum
-a 256 ...)`). Confirmed run: `weaver-reports/report.json` (7153 bytes, dated Jul 10).
mfact action: give each firing the same shape — G0=gap item selected, G1=artifact
identified, G2=fix applied, G3=build green, G4=no new `sorry`/axiom, G5=independent re-
check of the specific defect, G6=commit+receipt written. Print ALIVE/BLOCKED per gate;
hard-stop on the first BLOCKED instead of logging "done."

**F16 — Idempotency/replay receipt: hash inputs+trace, rerun, assert identical hash.**
Evidence: `wasm4pm/src/powl_execution.rs:228-236` builds `chain_hash` via BLAKE3 over
`powl_str` + `op_trace` + `topo_order`; `crates/wasm4pm-planner/tests/aurora_loop.rs:393-
400` calls `execute_powl_string` twice on identical input and asserts the two
`chain_hash`es match, commented "proof-carrying execution must be replayable."
mfact action: after picking a gap-ledger item and generating a fix, hash (gap-id + Lean
proof-state text + resulting diff) with sha256, append to `.mfact/receipts/`, and assert
that re-running the same pre-commit state reproduces the same hash — a cheap regression
signal the loop currently has none of.

**F17 — Traceability assertion: decision must appear verbatim in execution's record.**
Evidence: `crates/wasm4pm-planner/tests/aurora_loop.rs:406-423`: for every `step` in
`plan.steps`, asserts `fired.iter().any(|f| *f == id || f.starts_with(&id))` — the planned
step must show up in the executor's OCEL record or the test fails.
mfact action: assert the analogous thing — the specific gap-ledger item id chosen this
firing must appear verbatim in the resulting commit message/diff before the loop is
allowed to mark that item done. Nothing currently enforces that the logged "fix" and the
actual git diff correspond.

**F18 — Determinism gate: rerun the same reasoning call twice, assert byte-identical.**
Evidence: `crates/wasm4pm-planner/tests/aurora_loop.rs:348-353`: `assert_eq!(
serde_json::to_string(&ltl_out).unwrap(), serde_json::to_string(&ltl_again).unwrap(),
"breed deliberation must be deterministic");`
mfact action: add a one-line regression check — feed the same gap-ledger item + repo
state into the fix-proposal step twice in-process, assert the proposed diff text is byte-
identical. Catches LLM-nondeterminism-driven flakiness in what gets committed, currently
unguarded.

**F19 — `stop-proof-gate.sh`: Stop hook blocking on a typed verdict, not exit code.**
Evidence: `wasm4pm/.claude/hooks/stop-proof-gate.sh:41` `CRITICAL_FILES=(...)`; `:55`
`git status --short -- "${CRITICAL_FILES[@]}"`; `:90-92` `AUDIT_VERDICT=$(echo
"$AUDIT_JSON" | jq -r '.payload.final_verdict // empty')`; only `exit 0` if
`$AUDIT_VERDICT = "Accepted"`. Doctrine comment: "Agent narration has no authority. Disk
proof is authority."
mfact action: add a Stop hook listing critical loop files (the loop doc, the gap-ledger
file, any Lean files the loop may touch); on a `git status` hit, require a verifier
command to print a specific machine-checkable verdict field before the agent may stop.
Directly enforces "no receipt, no claim" (already AGENTS.md-adjacent language) with actual
tooling instead of convention.

**F20 — `metrics-track.sh`: post-commit longitudinal snapshot, independent of narration.**
Evidence: `wasm4pm/.claude/hooks/metrics-track.sh:9-11`
`METRICS_LOG=".wasm4pm/metrics-history.jsonl"`; `:40-60` appends `{timestamp, git_head,
git_branch, healthy, doctor:{pass,warn,fail}, compiler_warnings:{rust,typescript}}` per
commit.
mfact action: create `.mfact/metrics-history.jsonl`, append one snapshot per cron firing:
git head, gap-ledger items remaining/closed, Lean build pass/fail, `sorry`/axiom counts
(mfact's compiler-warning analogue), which item was closed. This is the single most direct
fix for "no convergence/learning signal" at the loop-history level — without it there is
no way to tell whether 20 firings made monotonic progress or oscillated on the same items.

**F21 — PreToolUse guards that permanently block reintroduction of a fixed defect.**
Evidence: `wasm4pm/.claude/hooks/cognition-contract-guard.sh:62-70` blocks edits matching
`.exit_code`, citing "Reference: crates/wasm4pm-cognition/src/wasm.rs:182-190\nAudit
finding: CRITICAL-1", `exit 2`. Four such guards target four separately-cited findings.
mfact action: when the loop closes a gap-ledger item, also emit a pre-commit guard keyed
to that gap — grep the diff for the exact anti-pattern that caused the original defect and
hard-block its reintroduction, citing the item id and the fixing commit. Nothing currently
prevents a later firing (or human edit) from silently undoing a prior fix.

**F22 — Finite state vocabulary + copy-paste "Required Final Proof Block" template.**
Evidence: `wasm4pm/AGENTS.md:61-71` (State Classification Table: Closed / PrePublishOnly /
EvidenceIncomplete / InfrastructureBlocked / ReceiptTheaterDetected / ...) and `:394-432`
(Proof Block: State / Commit / Tree / Commands / Artifacts / Receipts / Verifier Output /
Remaining Blockers / Next Command).
mfact action: give the loop its own small finite state vocabulary (LoopFired / GapClosed /
GapAttemptedNotClosed / LeanBuildBroken / LedgerExhausted / NoOpCycle) and require each
firing's log entry to fill a fixed template (state / commit hash / files touched / build
result / next item) rather than free-text narration. Needs no code, only discipline mfact's
loop doc does not currently impose.

**F23 — `andon-stop.md`: named halt signals + explicit "what not to do" list.**
Evidence: `wasm4pm/.claude/skills/andon-stop.md:15-21` (regex signal table: `error[E`,
`test.*FAILED`, `panicked at`, `FM-5 violation`) and `:23-31` (bans `#[allow(...)]`
silencing, `|| true` suppression, deferring fixes to "later").
mfact action: add a Lean/mfact-specific andon table (`sorry`, `error:`, unresolved-goal
markers, failing `lake build`) with the same anti-pattern list — no suppressing warnings,
no deferring gap-ledger items, no marking a firing complete while the build is red.

**F24 — Honest, partially-failing self-audit test suite published with root causes.**
Evidence: `wasm4pm/docs/reports/lsp318-ogse-coverage.md:219-267`: 20 tests, "14 PASS / 6
FAIL," each failure's root cause identified and a shared root cause named across all 6.
mfact action: build a `dogfood_self_improvement_loop` check (Lean or shell) that exercises
the loop's own claims — does the gap-ledger actually shrink after a firing, does the
logged fix correspond to a real diff, does `lake build` pass at the logged commit — and
publish honest pass/fail counts with root-cause notes rather than only narrative logs.

**F25 — `wip-config.json` + `wip-check.sh`: config-driven, non-blocking governance knob.**
Evidence: `wasm4pm/.wasm4pm/wip-config.json:1-6` (`max_concurrent_prs`,
`max_review_hours`, `escalation_hours`, `merge_block_hours`); consumed by
`wasm4pm/.claude/hooks/wip-check.sh:5-29`, warns without blocking.
mfact action: mfact's loop is commit-based, not PR-based — port the shape, not the `gh pr`
mechanics: a `.mfact/loop-config.json` with `max_gaps_per_day`, `escalation_hours`
(how long a ledger item can sit before the cron prompt should flag it loudly), consulted
before picking the next item. Gives the loop an explicit, editable governance knob instead
of hardcoding "one item per firing" in prose.

**F26 — Length-prefixed, domain-separated BLAKE3 hashing to avoid a canonicalization
collision.**
Evidence: `wasm4pm/crates/wasm4pm-cognition/src/autosystems/receipt.rs:1-30`. Encoding is
`domain_tag(16) || version_le(4) || step_le(8) || ihash_len_le(4) || ihash_bytes || ...`
explicitly to prevent the attack where `("ab","cd")` and `("a","bcd")` hash identically
under naive string concatenation; backed by
`tests/autosystems_receipt_v2_collision.rs`.
mfact action: if/when a loop receipt chain (F4, F6, F16) needs tamper-evident linking,
adopt length-prefix-before-concatenation. Worth checking whether `.ggen-v2/receipt-
log.jsonl`'s existing `chain_hash_hex` construction concatenates raw strings without
length prefixes (a plausible latent bug class, not confirmed here — not checked in this
pass).

**F27 — Selection law already exists in mfact; it just needs to be invoked.**
Evidence: `GAP_LEDGER_v26.7.12.md:49-67` — an explicit `e* = argmax` formula over
`UnlockMass * StandingCriticality * ScenarioCoverage / ClosureMass` with a frontier-closed
precondition. `wasm4pm/PROJECT_GAPS_INVENTORY.md` (63 lines) has no comparable section; its
closest analog, `ML_PIPELINE_AUDIT_REPORT.json:101-104`'s HIGH/MEDIUM/LOW list, is not even
carried into the `.md` aggregation.
mfact action: no import needed — wire the cron prompt to explicitly apply mfact's own
existing Selection law text rather than picking the next OPEN item arbitrarily.

**F28 — Inline gap-ID comment at the fix site, independent of the ledger doc.**
Evidence: `git grep -n 'OBS-GAP' -- wasm4pm/src/lib.rs wasm4pm/src/rl_orchestrator.rs` = 13
hits, each an inline `// OBS-GAP-N` or `// OBS-GAP-N FIX` comment at the changed line
(e.g. `lib.rs:1242 // OBS-GAP-2 FIX: track classified rule types...`).
mfact action: `grep -rn 'G[0-9]\+ FIX'` across mfact's `.rs`/`.lean`/`.py`/`.ts` sources
currently returns nothing. Require a `-- GNN FIX: <one-line reason>` (or `// GNN FIX:` per
language) comment at each touched site, so the code itself becomes independently greppable
for gap-ID provenance, separate from and more durable than the ledger doc.

**F29 — Named typed-refusal enum instead of free-text failure notes.**
Evidence: `wasm4pm-compat/src/law.rs:52-77`: `pub enum PetriRefusal { MissingInitial
Marking, MissingFinalMarking, DeadTransition, UnsafeNet, UnboundedNet }` with a `Display`
impl. Note this type exists only in wasm4pm-compat, not wasm4pm main (`grep -rln
"PetriRefusal"` across wasm4pm returns zero hits).
mfact action: define a small named-refusal enum for the loop (e.g. `GapRefusal:
NoTestCoverage | NoConvergenceSignal | DuplicatePick | NoReceiptWritten`) with a `Display`
impl, so "why didn't this firing count as progress" is a typed, greppable value instead of
prose.

**F30 — `ggen doctor run --autonomic`: drift/staleness check already built into the tool.**
Evidence: `ggen --help` lists `--autonomic` ("Enable autonomic features and output
structured errors") as a global flag; `ggen doctor --help` -> `doctor run`: "Check
lockfile/pack drift, orphaned generated artifacts, and receipt-vs-disk staleness." Not
invoked anywhere in wasm4pm's or wasm4pm-compat's scripts (declared, unused).
mfact action: have the loop shell out to `ggen doctor run --autonomic --format json`
(once mfact runs `ggen sync`, F6) as a pre-existing "is anything stale/drifted" check
before picking a gap-ledger item, rather than reimplementing drift detection.

### 2.3 Cautionary examples

**F31 — Gap-tracking doc went stale for 15+ days after the fix landed.**
Evidence: `autonomic-observability-gaps-audit.json` still reads `"status": "GAP-1 OPEN"`,
`"GAP-2 OPEN"`, `"GAP-3 OPEN"` at HEAD (lines 115/121/127), even though commit
`8c006c82d` (2026-06-02) closed exactly those three gaps. The audit file's own git history
(`git log --follow`) shows exactly one commit, `faa1e68fb` (2026-05-19) — never touched
again. `PROJECT_GAPS_INVENTORY.md`, committed `825d81ac7` on 2026-06-17 (15 days after the
fix), still lists OBS-GAP-1/2/3 as open, sourced straight from the stale JSON.
mfact action: the loop must update the gap-ledger `Status` field in the *same commit* as
the fix, not as a separate step — and re-verify a picked item is still actually open
(re-run the failing check) immediately before starting work, never trust a stored Status
blindly. This is the highest-priority cautionary finding in this report.

**F32 — External audit was required; the RL loop never self-detected its own blind spot.**
Evidence: commit `8c006c82d` fixed OBS-GAP-1/2/3 fourteen days after the audit dated
2026-05-19 that found them — but the fix is a dedicated, separately-scoped commit driven
by a written audit artifact, not something the autonomic loop itself produced.
mfact action: don't assume logging "item picked / done / verified / committed" means the
loop is improving *itself*. Add a recurring, separately-tracked pass that re-audits the
loop's own logging schema (not just the target gaps it fixes) on a fixed cadence.

**F33 — Even the audit-driven fix commit shipped a small defect: a duplicated comment.**
Evidence: `git show 8c006c82d -- wasm4pm/src/rl_orchestrator.rs` shows the "OBS-GAP-1 FIX"
comment block pasted twice verbatim in sequence in the added lines.
mfact action: add a lightweight self-diff-review step (even a grep for duplicated adjacent
comment/log lines, or the existing code-review skill) on the loop's own commits before
logging them "done" — a well-intentioned observability fix can itself carry small defects
when the fixer optimizes for closing the ticket over reviewing the diff.

**F34 — 8D state-space coverage histogram is a poor structural fit for a finite ledger.**
Evidence: `rl_orchestrator.rs:522-613` (`StateCoverage`, hashing 8 quantized dims into a
u32) and `src/lib.rs:2303` ("5 x 8 x 8 x 4 x 3 x 8 x 3 x 4 = 368,640 states // requires
function approximation").
mfact action: do not port the bin-hashing machinery — mfact's gap ledger is small,
finite, and enumerable, so a simple histogram (which categories/severities were picked how
many times in the last N firings, with a "never touched" flag) is a more honest analog
than reconstructing coverage-percentage math for a continuous space.

**F35 — FM-1: self-referential bootstrapping from a no-op state transition can diverge.**
Evidence: `rl_orchestrator.rs:1371-1381`: "an undifferentiated state transition carries no
information about future value," fixed via `let effective_done = done || (state ==
next_state);`.
mfact action: no literal Bellman update to port, but the lesson holds — a firing whose
fix produces zero measurable effect (same score before/after, no commit diff) should be
logged as a distinct "no-op cycle" outcome, not silently folded into success/failure,
otherwise a stuck-item detector (F1) could read a no-op streak as "stable" rather than
"stalled."

**F36 — `autonomic_execute_cycle` has no internal loop despite being named/documented as
one; the real "loop" is external re-invocation.**
Evidence: `wasm4pm/crates/wasm4pm-cli/src/commands/autoprocess.rs` has no `while`/`loop`
construct (confirmed via `grep -n "loop\|interval\|watch\|cron\|sleep"` = no matches); the
CLI subcommand `Autoprocess` (`main.rs:38-49`) has no `--watch`/`--interval` flag, even
though `lib.rs:892-900` calls it "the complete 4-layer autonomic control loop."
mfact action: don't chase wasm4pm for an internal iteration-with-termination-condition to
port — there isn't one. This validates keeping mfact's loop cron-driven, with the cycle
body a pure, standalone, cron-independent function.

**F37 — `wpm lean` is Lean Six Sigma manufacturing-waste auditing, unrelated to Lean4.**
Evidence: `wasm4pm/crates/wasm4pm-cli/src/commands/lean.rs:14-52` checks
`.wasm4pm/results` artifact count and a `/tmp/wasm-server.sock` warm-cache marker — no
proof-assistant code anywhere in the file.
mfact action: a false-friend naming collision, not a source of portable ideas for mfact's
Lean4 proof-checking step — don't spend time looking here for theorem-prover patterns.

**F38 — mfact's existing receipt files are structurally unlike a per-firing receipt and
unlike each other; neither is directly reusable as the loop's receipt store.**
Evidence: `.ggen-v2/receipt-log.jsonl` is a single hash-chained log of whole-build
`ggen.sync` events (`chain_hash_hex`/`prev_chain_hash_hex` linking huge per-file hash
maps); `.mfact/artifacts.toml` is a flat generated manifest of `[[artifact]]` entries
(path/producer/pack/content_hash), generated by `scripts/build_ledger.py`. Neither is "one
entry per unit of autonomous work."
mfact action: give the loop its own receipt stream (F4); if chaining is wanted, borrow
only the `chain_hash_hex`/`prev_chain_hash_hex` idea already proven in `receipt-
log.jsonl`, don't try to overload either existing file for a different purpose.

**F39 — Heavy instrumentation volume does not imply useful instrumentation.**
Evidence: `wasm4pm/.wasm4pm/sessions/tasks.jsonl:1-8` has consistently empty
`description`/`task_type` fields; `.wasm4pm/sessions/subagents.jsonl` interleaves records
of the shape `{agent_type:'unknown', agent_id:'', status:'unknown', duration_ms:null}`
with properly populated ones.
mfact action: when adding checkpoint/receipt logging (F4, F5, F20), make sure every field
the schema declares is actually populated at the write site — don't let a hook emit a
schema with placeholder empty/null fields that never get filled in.

**F40 — Unused, over-provisioned subsystems: an empty `results/` dir, an unused signing-
key pair.**
Evidence: `ls -la wasm4pm/.wasm4pm/results/` -> `total 0`. A dedicated Ed25519 signing
keypair exists at `.wasm4pm/keys/{signing.key (0600), signing.pub}` separate from both
receipt mechanisms found (F4, F6), generated by
`apps/wasm4pm/src/nouns/evidence/keygen.ts:26-27`.
mfact action: start the loop's `.mfact/` state directory with just receipts (F4) and
checkpoints; add more subsystems (e.g. a `results/` dir or signing keys) only when a
concrete need appears — don't preemptively provision what wasm4pm itself never ended up
using.

**F41 — wasm4pm's own gap inventory is thinner than mfact's, not more mature.**
Evidence: `PROJECT_GAPS_INVENTORY.md` (63 lines) has no `Status` field, no per-gap
`Verdict`/`Evidence`, no severity in the `.md` body (severity lives only in the source
JSONs and is dropped on aggregation), and no dependency/blocking graph. Compare
`GAP_LEDGER_v26.7.12.md:14-22` (Status legend) and `:78-98` (per-gap Verdict + Evidence +
Fix, 1024 lines total, explicit blocking graph).
mfact action: no change needed — do not downgrade mfact's ledger format toward wasm4pm's
flatter style when the loop writes future entries.

**F42 — Every audit-source file the inventory aggregates from was touched exactly once,
never regenerated.**
Evidence: `git log --follow` on each of 7 source files (`ML_PIPELINE_AUDIT_REPORT.json`,
`DETERMINISM_AUDIT_SUMMARY.txt`, `KERNEL_AUDIT_SUMMARY.txt`, etc.) returns exactly one
commit apiece, each landed inside a large, otherwise-unrelated batch commit. No re-audit
cadence exists anywhere in the repo.
mfact action: wasm4pm never built "gaps get closed by an automated process" — its
inventory is one-shot, hand-aggregated audit dumps. Do not treat it as a template; mfact's
existing wave-based, worktree-isolated, ledger-updating-in-place workflow
(`GAP_LEDGER_v26.7.12.md:24-47`, commit `9983df2`) is already a more advanced version of
what wasm4pm attempted only once, manually.

**F43 — A repo with a 521-line AGENTS.md banning aspirational completion claims still has
a live roadmap page written entirely in future tense about its own dogfooding story.**
Evidence: `wasm4pm/apps/playground-web/ROADMAP.md:10,315` describes a "Receipt timeline
page" only in future tense ("mines the playground's own run history"), headed "Source:
Engineering gap"; zero code exists for it, despite `AGENTS.md:86` explicitly forbidding
future-tense completion claims like "will be produced after publish."
mfact action: having strict anti-overclaiming rules (mfact's own AGENTS.md Combinatorial
Maximalism / "no vacuous tautologies") did not prevent wasm4pm from producing this exact
pattern elsewhere in the same repo. Check `MFACT_SELF_IMPROVEMENT_LOOP.md` itself against
this failure mode before resuming: a loop description that reads as done/self-auditing in
prose but has no artifact (no metrics history, no receipts, no self-audit test) is this
same pattern.

**F44 — A missing citation: wasm4pm's own compliance-standard doc does not exist on disk.**
Evidence: `wasm4pm/.claude/rules/_core/absolute.md:18` cites
`~/.claude/rules/process-mining-chicago-tdd.md`; `find /Users/sac/wasm4pm -iname
"chicago-tdd*"` returns nothing; `ls -la ~/.claude/rules/` shows only `no-overclaiming-
rust.md` and `tools.md`. The enforceable rules actually live scattered across test files
(`oracle_validator.rs`, `chicago_tdd_auditor.rs`) and `fm5-linter.sh`, not in the named doc.
mfact action: don't let `MFACT_SELF_IMPROVEMENT_LOOP.md` name a "compliance standard" file
as its authority unless that file exists and is co-located with enforcement code. Keep the
rank/verification vocabulary defined where the enforcing code lives, cross-referenced from
`AGENTS.md`/`STANDING.md`, rather than inventing a doc that can silently go missing while
still being cited.

**F45 — Two projects both use the "pi" prefix for incompatible ontologies.**
Evidence: `wasm4pm-compat/ggen/ontology/process-intelligence.ttl:1` declares `@prefix pi:
<https://wasm4pm.org/process-intelligence#>` (note `.org`, different path) — distinct from
`wasm4pm/ggen/ontology/algorithms.ttl:3`'s `@prefix pi: <https://wasm4pm.dev/pi#>`, which
is the one mfact's `ggen.toml`/`ontology/procint-schema.ttl` actually consumes.
mfact action: when documenting the `compat:`/`pi:` provenance link (see PURE_CONTEXT
below), explicitly note which repo each prefix comes from, to prevent a future contributor
from wiring mfact's `pi=` to the wrong ontology.

**F46 — mfact does not use ggen's declarative rule pipeline the way wasm4pm does.**
Evidence: `wasm4pm/ggen.toml` has `[[packs]]` array-of-tables plus 5+ `[[generation.
rules]]` blocks (SPARQL query -> Tera template -> `output_file`, `mode="Overwrite"`).
`mfact/ggen.toml:17-19` has a bare `[packs]` table with no `[[generation.rules]]`
anywhere in the file.
mfact action: mfact likely relies on ad hoc scripts/edits to render pack templates rather
than `ggen sync` doing the writes. Adopting `[[generation.rules]]` for loop-generated
artifacts (gap-ledger status files, Lean proof stubs) would let `ggen sync` produce the
receipt chain (F6) automatically instead of the loop writing files and separately logging
what it did — noted as a real gap in mfact's current ggen usage, not a copy target.

### 2.4 Pure context

**F47 — wasm4pm's cycle is event/call-driven; scheduling is entirely external.**
Evidence: `grep -n "loop\|interval\|watch\|cron\|sleep"` on
`crates/wasm4pm-cli/src/commands/autoprocess.rs` returns no matches; `autonomic_
execute_cycle` is invoked once per call from that file's `run()`.
mfact action: validates mfact's architecture choice — keep cron as the sole cadence
driver, structure the cycle body as a standalone, cron-independent function.

**F48 — Rank-N, CONFIRMED/REFUTED/DRIFTED, and Standing are three orthogonal axes, not a
hierarchy to merge.**
Evidence: `PRAXIS_SELF_AUDIT.md:19-24` (CONFIRMED/REFUTED/DRIFTED/UNVERIFIABLE); `AGENTS.
md:39-56` (`NoAmbientEpistemicAuthority`, `TransferableStanding_I(B)`, Standing PROVEN);
`wasm4pm/wasm4pm/tests/oracle_validator.rs:14-25` (Rank enum).
mfact action: do not merge Rank-N into CONFIRMED/REFUTED or into Standing — add Rank as a
third, orthogonal tag on gap-ledger closures. A claim can be "CONFIRMED, Standing=PROVEN,
oracle=Rank-2" simultaneously; the loop should log all three independently instead of one
ad hoc "fixed it" boolean.

**F49 — wasm4pm never solved "gap ledger wired to an autonomic loop" either.**
Evidence: `git grep -ln "PROJECT_GAPS_INVENTORY" -- .` in wasm4pm returns nothing; `grep
-rl "OBS-GAP\|G-ML-00\|GAP-1\|GAP-2\|GAP-3" .wasm4pm/` returns nothing. The RL loop and
the gap inventory are two fully disconnected subsystems in that codebase.
mfact action: mfact should not assume a mature reference implementation exists to port for
the loop-to-ledger linkage itself — this part of mfact's design is attempting something
wasm4pm never built, not re-deriving something it already solved.

**F50 — mfact's one real gap-closing episode is already more systematic than wasm4pm's.**
Evidence: across wasm4pm's full 3533-commit history, `git log --all --oneline -E --grep=
'OBS-GAP|G-ML-00|KERNEL-GAP|DET-GAP|BC-GAP|SEC-GAP'` returns exactly one hit
(`8c006c82d`). mfact's wave-based run closed 7 gaps in one pass across isolated worktrees
(`GAP_LEDGER_v26.7.12.md:24-29`, commit `9983df2`).
mfact action: preserve and extend mfact's existing wave-based workflow rather than
replacing it with anything from wasm4pm — it is already the stronger pattern.

**F51 — procint already cites wasm4pm-compat as its ground-truth correspondence source.**
Evidence: `procint/ProcInt/Models/ProcessTree.lean:8-9` ("Ported from wasm4pm-compat
process_tree.rs"); `procint/ProcInt/Ocpq/Query.lean:8-9` cites `wasm4pm-compat/src/
ocpq.rs`. `wasm4pm/crates/ocpq/Cargo.toml:17` depends on `wasm4pm-compat` as a workspace
crate; `wasm4pm/crates/ocpq/src/lib.rs:1-19` is itself a paper-grounded (Kusters & van der
Aalst arXiv:2506.11541v1) implementation built on `wasm4pm_compat::ocel::OCEL`.
mfact action: when procint cites a wasm4pm-compat source as an oracle, that citation
points at the canonical, actively-depended-upon implementation — the loop can trust it
without re-verifying provenance each firing.

**F52 — OCEL is likely over-engineered relative to mfact's near-term needs.**
Evidence: `wasm4pm/.wasm4pm/ocel/cognition/fuzzy_logic.jsonl:1-4` — a 4-event OCEL trace
(`ocel:eid`, `ocel:activity`, `ocel:omap` with shared `case_id`, `ocel:vmap`).
mfact action: treat as pure context — if mfact ever wants a replayable "case" trace for
one gap-ledger item's lifecycle, the 4-field shape is a reasonable minimal template, but
the receipt/checkpoint mechanisms (F4, F5) already cover the near-term need without a full
OCEL log.

**F53 — mfact's `compat:`/`pi:` ontology prefixes are verbatim, undocumented snapshots.**
Evidence: `mfact/ontology/procint-schema.ttl:9,15-19` matches `wasm4pm-compat/ggen/
ontology-breeds/breed-vocabulary.ttl:4,23-30` byte-for-byte on `compat:Breed_abductive_
ibe` (breedId/breedLabel/citation). `mfact/ontology/procint-schema.ttl:373,384` matches
`wasm4pm/ggen/ontology/algorithms.ttl:3,14-26` on `pi:Algo_a_star`. `mfact/ggen.toml:10-11`
declares both prefixes pointing at the `wasm4pm.dev` namespaces.
mfact action: add a provenance comment block at the top of `procint-schema.ttl` citing
the exact source file + commit/version it was frozen from, and a gap-ledger check that
diffs mfact's `compat:`/`pi:` blocks against the live source files to detect drift.

**F54 — wasm4pm's RL/autonomic subsystem is a frozen ~3-week-old reference, not a live
target.**
Evidence: `git -C wasm4pm log --since="7 days ago" --oneline | wc -l` = 1 (and that one
commit only adds `#![cfg(feature = "cloud")]` gates, per `git show b6fedcbef`). `git log
-1 --format="%ai" -- '**/rl_orchestrator.rs'` = 2026-06-22; for `self_healing.rs` =
2026-06-25. Meanwhile `git log --since="30 days ago" --oneline | wc -l` = 720 overall.
mfact action: treat wasm4pm's autonomic design as a stable architecture safe to mine
patterns from, but verify any adapted pattern still compiles/behaves as described rather
than assuming ongoing upstream maintenance — and anchor any cited pattern to a specific
commit hash, since the working tree currently has 164 uncommitted, unrelated cleanup
changes (`git status --porcelain | wc -l` = 164, none touching the autonomic files).

## 3. Redesign proposal for MFACT_SELF_IMPROVEMENT_LOOP.md

Ordered so the next session can implement it directly, strongest findings first:

1. **Receipt per firing.** Add `.mfact/receipts/<run_id>.json` +
   `.mfact/receipts/latest.json`, atomic-write per F4: `{run_id, gap_id, input_hash
   (hash of gap-ledger item text before the fix), output_hash (hash of the resulting
   diff/commit), status: success|partial|failed|no_op, timestamp, summary: {commit_sha,
   duration_ms}}`.

2. **Before/after delta in the same record as the commit hash (F8, F31).** Add one
   required field to every receipt: `verify_delta` — e.g. `verify_command_exit_before ->
   verify_command_exit_after`, or `gap_count_before -> gap_count_after` in the ledger.
   This is the direct fix for the GAP-1-shaped blind spot: an outcome computed but never
   co-located with the action that produced it.

3. **Update `GAP_LEDGER_v26.7.12.md`'s `Status` field atomically in the same commit as
   the fix (F31, highest-priority cautionary finding).** Never a separate follow-up step
   — this is the exact failure mode that let wasm4pm's own gap docs stay wrong for weeks.

4. **Re-verify before starting, not just before closing (F31).** Immediately before
   working a picked item, re-run the failing check that originally opened it; do not
   trust the stored `Status` blindly.

5. **Wire the cron prompt to mfact's own existing Selection law (F27,
   `GAP_LEDGER_v26.7.12.md:49-67`)** instead of picking the next `OPEN` item arbitrarily.

6. **Add a stuck-item / diversity guard (F1).** Track the last 10 picks; if the same
   item was picked in >70% of them without a `successful` receipt, skip it and log "may
   be stuck on this item."

7. **Add a distinct `no_op` outcome (F35).** A firing whose fix produces zero measurable
   effect (identical `verify_delta`, no commit diff) is logged as `no_op`, never folded
   into success/failure — otherwise the stuck-item guard (step 6) can't tell "stable"
   from "stalled."

8. **Add a rolling metrics-history snapshot (F20, F11).** Append to
   `.mfact/metrics-history.jsonl` once per firing: `{timestamp, git_head, gaps_open,
   gaps_closed_this_firing, lake_build_pass, sorry_count, axiom_count}`. Compute a simple
   `convergence_ratio` (mean of last 10 vs. first 10 `verify_delta`s) over this file —
   the loop's actual answer to "is it converging."

9. **Rank-tag every closure (F3).** Add `oracle_rank: 1|2|3|4` to the ledger's Evidence
   line; forbid closing on a self-referential oracle (the loop's own "done" flag with no
   independent re-check counts as Rank-5 and is rejected).

10. **Require an inline `-- GNN FIX: <reason>` comment at each touched code site (F28).**
    Makes the fix independently greppable in the code itself, not only in the ledger doc.

11. **Add a Stop-hook-equivalent gate (F19).** Before the loop may log a firing as done,
    an independently re-run verifier must print a specific machine-checkable verdict —
    not merely exit 0.

12. **Split "propose+commit" from "audit/verify" into two callable steps (F14, wasm4pm's
    Autoprocess/Audit CLI split).** Lets the verify step be re-run independently against
    past commits, and lets step 4/11 reuse it.

13. **Schedule a separate, lower-frequency self-audit of the loop's own logging schema
    (F32).** Not just the gaps it targets — wasm4pm shows this requires an explicit,
    separately-tracked pass, since the loop's own instrumentation drifted (F39) even in a
    codebase that took observability seriously.

14. **Keep cron as the sole cadence driver (F36, F47).** No internal loop/interval inside
    the cycle body — one firing, one pure function call, testable and replayable outside
    cron.

## 4. Cross-references

- **`GAP_LEDGER_v26.7.12.md`.** The Selection law (lines 49-67) and Status legend (lines
  14-22) are already stronger than anything wasm4pm built for its own gap tracking (F27,
  F41, F42, F50) — the redesign proposal wires the loop to *use* these existing artifacts
  rather than importing new ones. F31's staleness lesson (gap doc silently wrong for
  weeks) is the sharpest warning for the ledger's `Status`-update discipline specifically,
  since `GAP_LEDGER_v26.7.12.md` already states Verdict/Evidence must be freshly re-run —
  F31 shows what happens when that discipline lapses at the tracking-doc level.

- **`PRAXIS_SELF_AUDIT.md`.** Its CONFIRMED/REFUTED/DRIFTED/UNVERIFIABLE axis (lines
  19-24) and its 30-minute recurring self-audit cadence are the closest existing mfact
  analog to wasm4pm's `metrics-track.sh` (F20) and its "re-audit the loop's own schema"
  need (F32) — F48 argues these should stay orthogonal to a new Rank-N tag rather than be
  merged into it. The self-improvement loop's redesign (step 13) should reuse this
  existing cadence/discipline rather than inventing a second recurring self-check
  mechanism from scratch.

- **`PRAXIS_DOGFOODING_EXPLORATION.md`.** Its edge-classification vocabulary
  (`REAL_EDGE`/`PARTIAL_REAL_EDGE`/`TEST_ONLY_EDGE`/`MISSING_EDGE`/`REFUSED_EDGE`) is the
  same shape of typed-vocabulary discipline this report recommends for `GapRefusal` (F29)
  and the loop's finite state vocabulary (F22) — both are precedents for turning prose
  claims into a small closed enum with a `Display`/rendering rule. Its central warning
  (don't re-derive formal specifications for a system that already runs elsewhere without
  citing it) is the same lesson as F7 and F51: procint's `ProcessTree.lean` and
  `Ocpq/Query.lean` already cite wasm4pm-compat as their correspondence source, and F7
  specifically identifies wasm4pm main's fuller `process_tree.rs` as a stronger oracle
  than the wasm4pm-compat version currently cited.
