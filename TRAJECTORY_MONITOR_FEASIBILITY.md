# Trajectory Monitor Feasibility

Assesses whether a real-time "prefix monitor" -- predicting, from partial progress, whether a
run is trending toward failure, evaluated by precision/recall/lead-time against a `t_lock`
ground truth -- is honestly buildable today for mfact's self-improvement loop
(`MFACT_SELF_IMPROVEMENT_LOOP.md`, cron job `0e35feb8`). Last updated 2026-07-12.

## Bottom line

**Not buildable today.** mfact's loop has zero receipts written under the schema a monitor
would train or evaluate against, and at most one real, timestamped, trajectory-shaped failure
incident anywhere in this repo. Building a statistical predictor on that would be exactly the
fake stand-in `AGENTS.md`'s Combinatorial Maximalism Mandate forbids -- a trained model needs
examples to generalize from, and there is nothing here to generalize from yet.

What *is* honestly buildable today is a narrower thing: a deterministic, cross-firing
repetition rule with its own real justification, independent of any statistical fit. That rule
is specified in prose already (`MFACT_SELF_IMPROVEMENT_LOOP.md`, "Stuck-item guard") and is now
also implemented as real, tested code: `scripts/stuck_item_guard.py`. See "What is buildable
today" below for what it does and does not claim.

## What the paper's RQ1 monitor requires

arXiv:2607.09510 ("Failure as a Process: An Anatomy of CLI Coding Agent Trajectories", Zhao et
al.) evaluates its prefix-based failure monitor against **2,659 labeled prefixes drawn from 600
annotated trajectories**, each trajectory carrying ground-truth `t_err`/`t_lock`/`t_obs`
timestamps and a root-cause label from its Table II taxonomy. Precision, recall, and lead-time
are all computed against that labeled set. A monitor with anything close to that paper's
reported performance needs a comparably-sized, comparably-labeled corpus to fit and validate
against -- there is no way to shortcut labeled-example volume with cleverer modeling when the
claim being made is "this generalizes to future runs."

## What mfact has today

| Data source | Real count | Is it a labeled trajectory prefix? |
|---|---|---|
| `.mfact/receipts/*.json` (the loop's own schema) | 0 | N/A -- none exist yet |
| `GAP_LEDGER_v26.7.12.md` entries | 48 (23 OPEN, 14 BLOCKED, 10 CLOSED, 1 PARTIAL) | No -- static ledger items, no per-firing timestamps |
| `PRAXIS_SELF_AUDIT.md` REFUTED verdicts (pass 1 + pass 2) | 22 (15 of 45 findings pass 1, 7 of 23 findings pass 2) | No -- point-in-time audit verdicts about claims, not a trajectory with a start/error/lock/observe timeline |
| Genuine full-trajectory incidents with real `t_err`/`t_obs`/`t_lock`-shaped timestamps | **1** | Yes -- the sole example is below |

The one genuine example: the 2026-07-12 `research-papers/` truncation. 16 tracked Lean files
zeroed, filesystem mtime `2026-07-12 17:12:27 PDT` (candidate `t_err`, confirmed via `stat`),
discovered during a self-audit pass (`wc4q0d7ld`) starting around `23:12 PDT` (candidate
`t_obs`, roughly six hours later), recovered via `git checkout --` at approximately
`23:44 PDT`. Cause never conclusively identified; three untracked scripts in `research-papers/`
were investigated and ruled out. This is documented in `MFACT_SELF_IMPROVEMENT_LOOP.md` and is
also the incident `scripts/trajectory_annotate.py`'s module docstring is grounded in.

Every other entry in the table above is real and worth tracking, but none of them is a labeled
*trajectory* in the paper's sense: they lack a start point, a decisive-error point, and an
observation point on a shared timeline. They are audit findings about the state of files and
claims, not records of an agent run unfolding in time.

## The gap, stated as a ratio

mfact has 1 labeled trajectory-shaped incident against the paper's 600 (600x short), and 0
receipts against the paper's 2,659 labeled prefixes. This is not "somewhat under-provisioned" --
it is off by roughly three orders of magnitude on the corpus a monitor would need, and a sample
size of 1 cannot support any precision/recall/lead-time estimate regardless of method: with one
positive example and zero negatives, every possible classifier has undefined or degenerate
recall, and lead-time has no distribution to describe.

## What to log now, so this becomes buildable later

One concrete, minimal schema addition -- not a wishlist. `scripts/trajectory_annotate.py`
already reads an optional `root_cause_type` field from each receipt (`r.get("root_cause_type")`)
and reports a breakdown only when it is present, specifically so this addition would not require
touching that script again. The field does not yet exist on any real receipt because none exist,
and no receipt has ever set it.

The taxonomy to draw that value from already exists as a real, kernel-checked Lean type --
`ProcInt.Playground.Trajectory.RootCauseType` in
`procint/ProcInt/Playground/Trajectory/RootCause.lean` (9 constructors, `category : RootCauseType
→ RootCauseCategory` a total function, `category_total`/`category_mem` proved by `decide` and
`cases ... <;> simp` respectively, no `sorry`; confirmed building today via `lake build
ProcInt.Playground.Trajectory.RootCause` -- "Build completed successfully"). It is wired into the
default `Playground` target via `ProcInt/Playground.lean`'s import list, so it is reachable, not
orphaned. That file is currently staged, uncommitted, from the same session that produced this
document -- it is real source, not a plan for one.

**Addition:** when the loop writes a receipt with `status: "failed"` or `status: "partial"`,
require a `root_cause_type` value corresponding to one of that type's 9 constructors. The receipt
schema is JSON, so the field is necessarily a string, not a Lean term -- but per
`MFACT_SELF_IMPROVEMENT_LOOP.md` (line 60-63, already shipped) the JSON string is required to be
the *exact* Lean constructor name, not a re-spelled (e.g. snake_case) alias: this is a real
declared correspondence, not an assumed-identical dialect (per `AGENTS.md` section 4's predicate
namespace separation), and choosing identical spellings is what makes the correspondence
mechanically checkable rather than merely documented. `scripts/trajectory_annotate.py`'s
`ROOT_CAUSE_CATEGORY` dict already keys on these exact camelCase strings with no normalization
step -- a receipt spelled any other way (e.g. `"false_premise"`) would silently fail to match and
fall out of every category breakdown, so the table below states the one correct spelling, not a
translation between two:

| JSON `root_cause_type` value | `RootCauseType` constructor | Table II category |
|---|---|---|
| `"falsePremise"` | `.falsePremise` | Epistemic |
| `"specificationNeglect"` | `.specificationNeglect` | Epistemic |
| `"outputMisreading"` | `.outputMisreading` | Epistemic |
| `"ignoredSignal"` | `.ignoredSignal` | Epistemic |
| `"prematureAction"` | `.prematureAction` | Epistemic |
| `"knowledgeGap"` | `.knowledgeGap` | Competence |
| `"capabilityLimitation"` | `.capabilityLimitation` | Competence |
| `"environmentBlocker"` | `.environmentBlocker` | Environment |
| `"other"` | `.other` | Environment |

This is a closed nine-value enum, filled in by whatever reviews the receipt (today: a human;
later, possibly the loop itself if a defensible auto-classifier is ever built on enough labeled
examples). A companion type for Table III, `RecoveryBehavior` (5 constructors, same file
location's sibling `RecoveryBehavior.lean`, also builds clean), exists for a possible future
`recovery_behavior` field on `failed` receipts -- not proposed as part of this addition, since the
brief calls for one minimal field, not two; noted here only so a later pass does not have to
rediscover that the vocabulary is already built. Once on the order of tens to hundreds of
receipts carry `root_cause_type`, `scripts/trajectory_annotate.py --json` already aggregates it,
and at that point -- not before -- a real precision/recall/lead-time evaluation against a
held-out slice becomes an honest thing to attempt.

## What is buildable today: a static stuck-item guard

`scripts/stuck_item_guard.py` implements, verbatim, the "Stuck-item guard" already specified in
`MFACT_SELF_IMPROVEMENT_LOOP.md`: if one `gap_id` appears in more than 7 of the last 10 receipts
with no `status: "success"` among those attempts, flag it. This is a **deterministic repetition
rule, not a trajectory predictor**:

- It never estimates precision, recall, or lead-time -- there is no labeled corpus to score
  those against, so it makes no such claim.
- Its justification does not depend on arXiv:2607.09510 at all: if the loop has failed to close
  the same item 8+ times running, attempting it a 9th time unchanged is very unlikely to differ,
  so continuing to retry it is waste, independent of any paper's findings about *why* agents
  fail.
- It operates on real fields already in the documented receipt schema (`gap_id`, `status`,
  `run_id`) -- no field or data that does not exist was assumed.

It was verified against three constructed fixture cases (kept outside the repo, in the session
scratchpad, so as not to pollute the real `.mfact/receipts/` log with synthetic data):

| Fixture | Firings | Result |
|---|---|---|
| 8x `failed`, same `gap_id`, 0 successes | `find_stuck_gap_ids` | flags it (8 > 7, no success) |
| 7x `failed` + 1x `success`, same `gap_id` | `find_stuck_gap_ids` | does not flag (a success exists) |
| 7x `failed`, same `gap_id` (below threshold) | `find_stuck_gap_ids` | does not flag (7 is not > 7) |

Run against the real (currently empty) receipts directory, it reports the honest empty case
rather than fabricating a verdict:

```
$ python3 scripts/stuck_item_guard.py
0 receipts found under /Users/sac/mfact/.mfact/receipts. Nothing to check -- this guard
operates on real receipts only; it will not fabricate a verdict from an empty input.
```

## What this is not

This guard is not, and is not presented as, an implementation of the paper's RQ1 monitor. It
does not use partial-trajectory evidence to predict an outcome before it happens within a single
firing; it only ever fires *between* firings, after several have already completed and been
logged. It has no notion of lead-time because it does not predict anything -- it observes a
pattern that has already fully occurred. Closing that gap for real requires the receipt volume
and labeling discussed above, not a cleverer rule.

## See Also

- `MFACT_SELF_IMPROVEMENT_LOOP.md` -- receipt schema, stuck-item guard prose, collision guard
- `scripts/trajectory_annotate.py` -- derives `t_err`/`t_lock`/`t_obs`-equivalent timestamps
  per receipt from the schema that exists today; the `root_cause_type` hook this document's
  logging addition targets already lives there
- `scripts/stuck_item_guard.py` -- the static heuristic this document describes
- `procint/ProcInt/Playground/Trajectory/RootCause.lean` -- kernel-checked `RootCauseType`
  taxonomy (Table II) the "what to log now" field is drawn from
- `procint/ProcInt/Playground/Trajectory/RecoveryBehavior.lean` -- kernel-checked
  `RecoveryBehavior` taxonomy (Table III), a real but not-yet-proposed companion field
- `PRAXIS_SELF_AUDIT.md` -- the 22 REFUTED-verdict audit findings counted above
- `GAP_LEDGER_v26.7.12.md` -- the 48-entry gap ledger counted above
- `AGENTS.md` section 4 -- why the paper's Table II/III figures are not applied to mfact's own
  loop until mfact's own receipts are actually classified against them
