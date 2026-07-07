-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Planning.Pddl

Classical (STRIPS/PDDL 3.1) planning semantics: ground actions as precondition/add/delete triples over a Finset of atoms, single-step state transition, and fold-based sequential plan validity. Fikes, R. E., & Nilsson, N. J. (1971). STRIPS: A New Approach to the Application of Theorem Proving to Problem Solving. Artificial Intelligence, 2(3-4), 189-208. -/

namespace ProcInt

/-- A ground STRIPS/PDDL action: precondition atoms that must all hold
before firing, plus add/delete effect sets applied to the world state on
execution (Fikes & Nilsson 1971; PDDL 3.1 `:strips` requirement). -/
structure PddlAction (Atom : Type u) where
  pre : Finset Atom
  add : Finset Atom
  del : Finset Atom

/-- An action is applicable in state `s` iff every precondition atom
already holds. -/
def PddlAction.applicable {Atom : Type u} [DecidableEq Atom]
    (s : Finset Atom) (a : PddlAction Atom) : Prop :=
  a.pre ⊆ s

/-- Single-step STRIPS state transition: remove the delete set, then union
in the add set. Does not check applicability — callers combine this with
`PddlAction.applicable` (mirrors `PddlPlan.validCheck` below). -/
def PddlAction.apply {Atom : Type u} [DecidableEq Atom]
    (s : Finset Atom) (a : PddlAction Atom) : Finset Atom :=
  (s \ a.del) ∪ a.add

/-- Every atom in an action's add set is present in the resulting state,
matching STRIPS's `add`-effect semantics (Fikes & Nilsson 1971). -/
theorem PddlAction.mem_add_mem_apply {Atom : Type u} [DecidableEq Atom]
    (s : Finset Atom) (a : PddlAction Atom) {x : Atom} (hx : x ∈ a.add) :
    x ∈ PddlAction.apply s a := by
  simp only [PddlAction.apply, Finset.mem_union]
  exact Or.inr hx

/-- A sequential plan: an ordered list of ground actions (PDDL 3.1
`:strips`-fragment sequential plan, no concurrency). -/
def PddlPlan (Atom : Type u) := List (PddlAction Atom)

/-- Boolean-decidable plan-validity check: fold `PddlAction.apply` over
`p` from `s0`, checking applicability at every step, and require the final
state to contain every goal atom. Computable (not noncomputable), so it is
directly `#eval`/`decide`-able — mirrors `ProcInt.fitness`'s
computable-over-`Finsupp`/`Finset` style in `Conformance.TokenReplay`. -/
def PddlPlan.validCheck {Atom : Type u} [DecidableEq Atom]
    (s0 sGoal : Finset Atom) (p : PddlPlan Atom) : Bool :=
  match p with
  | [] => decide (sGoal ⊆ s0)
  | a :: rest =>
      decide (a.pre ⊆ s0) && PddlPlan.validCheck (PddlAction.apply s0 a) sGoal rest

/-- Prop-valued plan validity: `p` is valid from `s0` reaching `sGoal`
iff `validCheck` returns `true`. Automatically decidable since it unfolds
to `Bool` equality (PDDL 3.1 sequential-plan validity, Ghallab, Nau &
Traverso, Automated Planning: Theory and Practice, 2004, Ch. 2). -/
def PddlPlan.valid {Atom : Type u} [DecidableEq Atom]
    (s0 sGoal : Finset Atom) (p : PddlPlan Atom) : Prop :=
  PddlPlan.validCheck s0 sGoal p = true


end ProcInt
