-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.

/-!
# ProcInt.Playground.Trajectory.RootCause

Root-cause taxonomy from Table II of Zhao et al., "Failure as a Process: An
Anatomy of CLI Coding Agent Trajectories" (arXiv:2607.09510) -- an empirical
study of coding-agent failure trajectories, no theorems or formal content of
its own. This file constructs the taxonomy as a real Lean type, not a
description of one: 9 root-cause constructors grouped into 3 categories by a
total, kernel-checked classifier, matching the paper's own grouping exactly.

Per `AGENTS.md` section 4 (No Ambient Theorem Authority): this file exhibits
a *type* whose shape mirrors the paper's Table II. It does not thereby prove
anything about mfact's own autonomic loop -- the paper's findings gain
standing over mfact's cron-fired fix/audit loops (`0e35feb8`, `9bab36de`)
only once that loop's own trajectories are actually classified against this
taxonomy, which is a separate, unstarted measurement.

Category weights reported by the paper (for reference, not encoded in the
types below -- percentages are measurement outcomes, not part of the
combinatorial structure): Epistemic 57.9% (false premise 30.7%,
specification neglect 14.9%, output misreading 4.4%, ignored signal 4.1%,
premature action 3.7%); Competence 32.8% (knowledge gap 24.0%, capability
limitation 8.8%); Environment 9.4% (environment blocker 8.8%, other 0.6%).
-/

namespace ProcInt.Playground.Trajectory

/-- The 9 root-cause constructors of Table II, in the paper's own order:
the 5 epistemic causes, then the 2 competence causes, then the 2 environment
causes. -/
inductive RootCauseType where
  /-- Acted on a belief about the system/task state that was false. -/
  | falsePremise
  /-- Overlooked or misapplied an explicit requirement in the spec. -/
  | specificationNeglect
  /-- Observed correct output/signal but drew the wrong conclusion from it. -/
  | outputMisreading
  /-- A signal indicating trouble was available but not acted on. -/
  | ignoredSignal
  /-- Acted before gathering evidence that a careful agent would have. -/
  | prematureAction
  /-- Lacked the factual/domain knowledge the task required. -/
  | knowledgeGap
  /-- Had the knowledge but not the tool/action capability to apply it. -/
  | capabilityLimitation
  /-- Blocked by the external environment (missing tool, permissions, etc). -/
  | environmentBlocker
  /-- Root cause outside the other 8 buckets. -/
  | other
  deriving DecidableEq, Repr, BEq

/-- The 3 root-cause categories of Table II. -/
inductive RootCauseCategory where
  | epistemic
  | competence
  | environment
  deriving DecidableEq, Repr, BEq

namespace RootCauseType

/-- The paper's own grouping of root-cause constructors into categories
(Table II): the 5 epistemic causes, the 2 competence causes, the 2
environment causes. A total function -- Lean's elaborator rejects this
definition outright if any of the 9 constructors is left unmatched, so
totality is enforced at definition time, not merely claimed. -/
def category : RootCauseType → RootCauseCategory
  | .falsePremise => .epistemic
  | .specificationNeglect => .epistemic
  | .outputMisreading => .epistemic
  | .ignoredSignal => .epistemic
  | .prematureAction => .epistemic
  | .knowledgeGap => .competence
  | .capabilityLimitation => .competence
  | .environmentBlocker => .environment
  | .other => .environment

/-- Every constructor of `RootCauseType` maps to exactly one category, and
that category is the specific one Table II assigns it -- not merely "some
category or other". Stated as an explicit conjunction of all 9 constructor
mappings (rather than left implicit in `category`'s definition) so that a
future edit to `category` which silently changes one constructor's group
fails this proof, not just a review. Kernel-checked via `decide` against the
`DecidableEq RootCauseCategory` instance derived above -- no `sorry`. -/
theorem category_total :
    falsePremise.category = .epistemic ∧
    specificationNeglect.category = .epistemic ∧
    outputMisreading.category = .epistemic ∧
    ignoredSignal.category = .epistemic ∧
    prematureAction.category = .epistemic ∧
    knowledgeGap.category = .competence ∧
    capabilityLimitation.category = .competence ∧
    environmentBlocker.category = .environment ∧
    other.category = .environment := by
  decide

/-- Restated as universal totality-into-the-codomain: for every constructor,
`category` lands in one of the 3 declared categories (no partiality, no
escape to a 4th case). Exhaustive `cases` split, one `rfl` per constructor --
the same guarantee `category_total` gives constructively, checked here by
case analysis instead of by `decide` so both proof techniques the task
allows are exhibited as real, independent kernel checks. -/
theorem category_mem (t : RootCauseType) :
    t.category = .epistemic ∨ t.category = .competence ∨ t.category = .environment := by
  cases t <;> simp [category]

end RootCauseType

end ProcInt.Playground.Trajectory
