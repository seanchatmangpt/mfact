# Trajectory Case Study: The research-papers/ Truncation Incident (2026-07-12)

Applies the two taxonomies built this session --
`procint/ProcInt/Playground/Trajectory/RootCause.lean` (Table II root-cause types) and
`procint/ProcInt/Playground/Trajectory/RecoveryBehavior.lean` (Table III recovery
behaviors), both from Zhao et al., "Failure as a Process: An Anatomy of CLI Coding Agent
Trajectories" (arXiv:2607.09510, an empirical study, no theorems of its own) -- to the one
real, timestamped, trajectory-shaped incident in this repo: the 2026-07-12 mass
truncation of 16 tracked Lean files under `research-papers/`.

Per `AGENTS.md` section 4 (No Ambient Theorem Authority): arXiv:2607.09510 is empirical
and supports the *shape* of the vocabulary used below (the three-timestamp decomposition,
the 9-way root-cause split, the 5-way recovery-behavior split). It does not, by citation
alone, establish that this incident fits any category well -- every classification below
is argued from this repo's own evidence and is marked as either directly evidenced or
inferred. Where a fact could not be independently reproduced against the live tree, it is
marked as such rather than asserted.

## Source facts and confirmation status

| Fact | Value | Status |
|---|---|---|
| Truncation mtime (`t_err` candidate) | 2026-07-12 17:12:27 PDT | Confirmed: quoted identically in `PRAXIS_SELF_AUDIT.md` findings PA37 and PB1 (`stat` output on the affected files), and independently reproduced here (see Timeline) |
| Files affected | 16 tracked `.lean` files under `research-papers/` | Confirmed: `git diff --stat -- research-papers/` at the time of PB1 reported "16 files changed, 216 deletions(-)"; the same 16 paths are listed in this session's own `git status` at start |
| Concurrent `.ggen-v2` receipt regeneration, same second | `.ggen-v2/receipt.json`, `.ggen-v2/receipt-log.jsonl` both mtime 17:12:27 | Confirmed: reproduced live with `stat -f "%Sm" .ggen-v2/receipt.json .ggen-v2/receipt-log.jsonl` during this task |
| Concurrent 7-worktree activity in the same 5-minute window | `wf_24b4eb65-119-{5,6,10,11,16,17,19}` | Confirmed by PB1's evidence trail (`git worktree list`); not independently re-run here since those worktrees are transient session state, not repo history |
| Discovery task | `wc4q0d7ld`, self-audit pass 2, launch "around 23:12 PDT" | Task-briefing and `TRAJECTORY_MONITOR_FEASIBILITY.md` (written earlier this session) both cite this identically; no independent artifact (e.g. a logged task-start timestamp) exists in-repo to re-derive it from, so it is taken as given, not independently reproduced |
| Discovery pass duration | "roughly 15 minutes" | Task-briefing only; not independently reproduced |
| Recovery time | "approximately 23:44 PDT" | Task-briefing and `TRAJECTORY_MONITOR_FEASIBILITY.md` cite this identically -- but see below, this **disagrees with a live re-check performed in this task** |
| Recovery mechanism | `git checkout -- <paths>` | Confirmed: `git diff --stat HEAD -- research-papers/` is empty right now, i.e. the working tree exactly matches the last-committed blobs, which is exactly what `git checkout --` produces (no new commit) |
| Loop pause / resume at "23:47:32 PDT" | -- | **Not independently confirmed.** Grepped `PRAXIS_SELF_AUDIT.md`, `MFACT_SELF_IMPROVEMENT_LOOP.md`, `WASM4PM_AUTONOMIC_EXPLORATION.md`, and the whole repo for `23:47:32`; zero matches anywhere. Taken as given from the task briefing only. |
| Root trigger mechanism | Never identified; 3 untracked scripts (`process.py`, `update_exports.py`, `summarize_tickets.py`) investigated and ruled out | Confirmed as a negative result only -- see Root cause section |

**Discrepancy found and left unreconciled, not silently resolved:** a live `stat` on all
16 previously-truncated files, run during this task, shows a uniform mtime of
`2026-07-12 23:31:49 PDT` across every one of them -- e.g.:

```
$ stat -f "%Sm %N" research-papers/random_walk/RandomWalk.lean \
    research-papers/quantum_hall/QuantumHall.lean \
    research-papers/smfdcca/Smfdcca.lean
Jul 12 23:31:49 2026 research-papers/random_walk/RandomWalk.lean
Jul 12 23:31:49 2026 research-papers/quantum_hall/QuantumHall.lean
Jul 12 23:31:49 2026 research-papers/smfdcca/Smfdcca.lean
```

The same command against the remaining 13 files (the `Basic.lean` variants) returns the
identical timestamp. A single uniform mtime across all 16 files is exactly what a single
`git checkout -- research-papers/` invocation produces, so this is very likely the actual
recovery instant -- roughly 12-13 minutes earlier than the "~23:44 PDT" figure repeated in
both the task briefing and `TRAJECTORY_MONITOR_FEASIBILITY.md`. This case study uses the
live-verified `23:31:49` as the primary recovery timestamp and reports the briefing's
`23:44` figure alongside it rather than discarding it, since its origin (a rounder, later
number repeated identically in two places) could not be traced to a command output in this
task's own tool history.

## Timeline

| Event | Timestamp | Source |
|---|---|---|
| `t_err` -- files truncated to 0 bytes | 2026-07-12 17:12:27 PDT | `stat`, confirmed live |
| Soft signal, not escalated -- commit `e248101`'s own message notes "every .lean file in research-papers/* is empty right now" | 2026-07-12 22:30:33 PDT | `git log -1 --format=%B e248101`, confirmed live |
| `t_obs` window opens -- self-audit pass `wc4q0d7ld` launches | ~2026-07-12 23:12 PDT | Task briefing + `TRAJECTORY_MONITOR_FEASIBILITY.md` |
| `t_obs` window closes -- pass completes, PB1 finding written (`CONFIRMED`, critical) | ~2026-07-12 23:27 PDT | Task briefing ("roughly 15 minutes later") |
| Recovery -- `git checkout --` restores all 16 files | 2026-07-12 23:31:49 PDT | `stat`, confirmed live (see discrepancy note above; briefing says ~23:44) |
| Loops paused, investigation, redesign, resume | ~2026-07-12 23:47:32 PDT (unconfirmed) | Task briefing only |

Computed intervals (using the live-verified 17:12:27 / 23:12 / 23:31:49 anchors):

- **`t_err` to soft signal (`e248101`):** 5h 18m 6s
- **Soft signal to `t_obs` window open:** 41m 27s
- **Observability lag, `t_err` to `t_obs` open (the paper's own vocabulary for how long a
  decisive error goes unobserved):** 5h 59m 33s -- rounds to "roughly six hours," matching
  the task briefing's own framing
- **`t_err` to `t_obs` close:** 6h 14m 33s
- **`t_obs` close to recovery:** 4m 49s -- once the pass-2 audit finished writing its
  finding, the fix itself was almost immediate, because the fix was mechanical
  (`git checkout --`) rather than diagnostic
- **Fix window, `t_err` to recovery (live-verified):** 6h 19m 22s
- **Fix window, `t_err` to recovery (briefing figure, ~23:44):** 6h 31m 33s -- the two fix-
  window figures differ by about 12 minutes; both are reported above rather than only one

## `t_err` / `t_lock` / `t_obs`, applied

`t_err` and `t_obs` map cleanly onto this incident's real timestamps, above. `t_lock` --
the paper's "point of no recovery" -- does not map onto a single given timestamp, and
needs two separate readings to state honestly rather than one glossed-over answer:

**Reading 1 -- `t_lock` for the artifact (the data).** By this reading, `t_lock` never
occurred. Git's content-addressed object store retained the last-committed blob for every
one of the 16 files throughout the entire ~6-hour window; recovery via `git checkout --`
was structurally available at every instant from `t_err` onward, and in fact succeeded
exactly as cleanly at 23:31:49 as it would have at 17:13. The ~6-hour gap was purely an
*observability* gap, not a *recoverability* gap -- nothing about the data became harder or
impossible to restore as time passed. This is the incident's most important structural
fact and the reason recovery was "exact and lossless": the failure mode here was silence,
not damage.

**Reading 2 -- `t_lock` for the causing trajectory.** This is the reading closer to the
paper's own usage (a point within *an agent's own run* after which that run's specific
chance to self-correct is gone). This reading is **UNVERIFIABLE** here, not because the
concept doesn't apply but because the causing trajectory's own identity, start time, and
end time are unknown -- exactly the gap the Root cause section below states plainly. The
best available inference, marked explicitly as inference: a 0-byte file is the direct,
mechanical result of a process that opened these files in truncating write mode and never
completed (or never attempted) the subsequent write of real content. Nothing in the
6-hour window between `t_err` and discovery shows any further activity touching those 16
specific files' *content* (only `e248101`'s CI-workflow commit touches the surrounding
`research-papers/<pkg>/.github/workflows/` paths, not the `.lean` sources themselves), so
if a causing trajectory's own self-correction window existed at all, the evidence is
consistent with it closing at or within seconds of `t_err` itself -- i.e. `t_lock ≈ t_err`
for the causing trajectory, because nothing after that instant shows the trajectory
revisiting its own output. This is an inference from absence of contrary evidence, not a
confirmed fact.

## Root cause classification (`RootCauseType`)

**Trigger-mechanism level: UNVERIFIABLE.** The task briefing is explicit that the direct
cause was never conclusively identified, and this session's own investigation (reported
by a sibling agent this run) ruled out the three untracked scripts in `research-papers/`
(`process.py`, `update_exports.py`, `summarize_tickets.py` -- none of them write to the
paths that were truncated) without identifying a positive replacement cause. This case
study adds one further, honest gap: the investigation ruled out those three scripts but
never examined -- neither confirmed nor excluded -- the `.ggen-v2` render/receipt pipeline
itself, despite that pipeline's receipt files sharing the exact same 17:12:27 mtime as the
truncated Lean sources (see Timeline). Absence of an examination is not evidence the
pipeline is exonerated; it is simply the honest boundary of what was checked. No
`RootCauseType` constructor can be assigned at the trigger-mechanism level without
inventing a cause the evidence does not support.

**What a process would have needed to do wrong, inferred from the physical evidence
(not confirmed):** two `RootCauseType` constructors from
`procint/ProcInt/Playground/Trajectory/RootCause.lean` fit the observable symptom --
16 files reduced to exactly 0 bytes, no error surfaced anywhere in the record, correlated
in wall-clock time with both a receipt regeneration and concurrent multi-worktree merge
activity:

1. **`capabilityLimitation` (primary candidate).** Zero-byte output with no thrown error
   is the textbook signature of a write path that lacks atomic-write semantics -- i.e.
   `open(path, "w")` (which truncates immediately on open) followed by a content-write
   step that never ran to completion, rather than the safer write-to-temp-then-rename
   pattern. This does not require any single actor to have made a bad *decision*; it only
   requires the tool doing the writing to lack a capability (crash-safe writes) that this
   incident shows was needed. The concurrent 7-worktree merge activity in the same
   5-minute window (PB1's evidence) is a plausible source of the interruption -- resource
   contention or an interrupted process during concurrent merges -- though which merge, if
   any, is the proximate cause is itself unconfirmed.
2. **`prematureAction` (secondary candidate).** If the write was instead a deliberate
   regenerate-in-place step (consistent with the same-second `.ggen-v2` receipt
   correlation), then truncating the destination file *before* the new content was ready
   to write -- rather than writing to a staging location first -- is acting before the
   evidence (a successful render) was in hand. This constructor and `capabilityLimitation`
   are not mutually exclusive: one describes a design decision (start the write early),
   the other describes the tool's missing safety net (no rollback when the write doesn't
   finish); the same incident can exhibit both.

Both are stated here as inferences from the shape of the damage, explicitly weighted
(primary/secondary), not as a confirmed classification -- consistent with the trigger
mechanism itself being UNVERIFIABLE.

**A separate, directly evidenced classification -- not the trigger, the response to it.**
Commit `e248101` (2026-07-12 22:30:33 PDT, ~5h18m after `t_err`, ~41m before the `t_obs`
window opens) states in its own message, verbatim: "every `.lean` file in
`research-papers/*` is empty right now... matching pre-existing dirty state from before
this session." This is a directly quoted, positively confirmed fact (`git log -1
--format=%B e248101`), not an inference: whoever/whatever authored that commit had
already *seen* the truncated state, formed a hypothesis about it ("pre-existing," "not
this session's problem"), and explicitly scoped it as "not fixed... outside the scope of
a CI-wiring change" rather than escalating it. That is a clean, directly evidenced fit
for `RootCauseType.ignoredSignal` ("a signal indicating trouble was available but not
acted on") -- applied not to the original truncation trigger, but to the ~41-minute window
in which a partial signal existed and was explicitly noted, then set aside, before the
pass-2 audit escalated the same underlying fact into a critical finding.

## Recovery behavior classification (`RecoveryBehavior`)

All 5 constructors in `procint/ProcInt/Playground/Trajectory/RecoveryBehavior.lean`
describe failure modes in *how* an agent responds to trouble. This session's actual
response -- pause both cron loops, investigate the candidate causes, recover via `git
checkout --`, redesign the loop's collision guard and receipt schema before resuming --
does not fit any of the 5. That is the correct, informative reading of a failure
taxonomy: a well-scoped recovery is evidenced by *not* instantiating any of its
documented anti-patterns, not by the taxonomy having "nothing to say."

Walking all 5 explicitly, each with the evidence for why it does not apply:

- **`givesUpImmediately`.** Does not apply. The response did not abandon the task after
  discovery; pausing the two cron loops was a deliberate containment step (verified live:
  `.mfact/receipts/` is empty, so the fix loop has not fired since being redesigned,
  consistent with a real pause, not merely a claimed one), and investigation continued
  after the pause rather than stopping there.
- **`repairsWrongProblem`.** Does not apply, and for a specific reason worth stating: the
  fix (`git checkout --`) was scoped honestly to what it actually repaired -- the
  *symptom* (16 empty files) -- and was never represented as having found or fixed the
  *trigger* (which this case study, above, states is UNVERIFIABLE). Misrepresenting a
  symptom-fix as a root-cause-fix is what would make this constructor apply; that
  misrepresentation did not happen here.
- **`keepsRepeatingApproach`.** Does not apply. The recovery was a single `git checkout --`
  action, not a repeated failing retry, and the follow-on loop redesign
  (`MFACT_SELF_IMPROVEMENT_LOOP.md`'s v2 schema: per-firing receipts with a before/after
  verify delta, a stuck-item guard, an explicit collision guard) is a documented change to
  the approach, not a repetition of whatever the pre-incident loop was doing.
- **`performsUselessChecks`.** Does not apply. This is the first of the two the task asked
  to address explicitly: the post-checkout verification (confirming file sizes went from
  0 bytes back to real content, and that `git diff --stat HEAD -- research-papers/` came
  back empty) was not decorative. Its outcome could have changed the response -- if the
  checkout had *not* restored real content (e.g. if the last-committed blob had itself
  been corrupted, or if the paths had never been tracked), the correct next step would
  have been different (escalate as unrecoverable data loss, not declare the incident
  closed). The check was load-bearing precisely because its possible failure would have
  changed what happened next.
- **`fabricatesSuccess`.** Does not apply, and this is the second constructor the task
  asked to address explicitly. The distinguishing fact is ordering: verification (file
  sizes, `git diff`) happened *before* any claim that the incident was resolved, not after
  or instead of one. `fabricatesSuccess` describes claiming success without, or ahead of,
  genuine verification; here the verification is what the "recovered" claim is built on,
  and is independently reproducible right now by anyone re-running the same `git diff
  --stat HEAD -- research-papers/` command (confirmed empty in this task, see Source
  facts table).

## What this case study does and does not establish

This is a single incident (n=1). Nothing here generalizes to a claim about mfact's
autonomic loops' overall failure rate, recovery quality, or root-cause distribution --
that would require classifying a real population of trajectories against this taxonomy,
which `TRAJECTORY_MONITOR_FEASIBILITY.md` (written earlier this session) already states
plainly is not buildable today (0 receipts, 1 trajectory-shaped incident, against the
source paper's own 2,659-prefix/600-trajectory evaluation corpus). What this document
does establish, each independently: a taxonomy-consistent, three-timestamp account of one
real incident with the observability lag and fix window computed in hours; an honest
two-reading treatment of `t_lock` where a single glossed answer would have overstated
confidence; a root-cause classification that is explicit about which layer is inferred
(the trigger) versus directly evidenced (the ignored soft signal in `e248101`); and a
recovery-behavior classification whose informative content is that none of five
documented failure patterns fit, argued constructor-by-constructor rather than asserted.

Per `AGENTS.md` section 4: none of the above transfers standing to mfact's cron loops in
general. It is standing for exactly the one incident analyzed.

## See Also

- `procint/ProcInt/Playground/Trajectory/RootCause.lean` -- the `RootCauseType` taxonomy
  applied above
- `procint/ProcInt/Playground/Trajectory/RecoveryBehavior.lean` -- the `RecoveryBehavior`
  taxonomy applied above
- `TRAJECTORY_MONITOR_FEASIBILITY.md` -- why a statistical monitor over this taxonomy is
  not buildable yet, and what corpus size the source paper actually used
- `PRAXIS_SELF_AUDIT.md` (findings PA37, PB1, PB2) -- the pass-1/pass-2 audit evidence this
  case study's timeline is built from
- `MFACT_SELF_IMPROVEMENT_LOOP.md` -- the redesigned loop this incident's lessons fed into
- `scripts/trajectory_annotate.py` -- per-receipt `t_err`/`t_lock`/`t_obs` proxy tooling
  for future firings, grounded in the same incident this document analyzes
