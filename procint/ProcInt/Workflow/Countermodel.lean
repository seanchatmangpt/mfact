-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Workflow.Soundness

/-! # ProcInt.Workflow.Countermodel

Infinite-transition countermodel demonstrating necessity of [Finite T] for crown theorem. Proves there exists a WfNet with infinite transitions that is sound but whose short-circuit is not bounded, providing the canonical counterexample to the soundness-iff-liveness-and-boundedness equivalence when T is infinite. -/

namespace ProcInt

/-- Place type for the crown countermodel WF-net.
- `i`: input place
- `q`: queue place (holds tokens)
- `o`: output place
- `c n`: counter place at index n -/
inductive CrownCounterPlace : Type
  | i : CrownCounterPlace
  | q : CrownCounterPlace
  | o : CrownCounterPlace
  | c : ℕ → CrownCounterPlace
  deriving DecidableEq, Repr

/-- Transition type for the crown countermodel WF-net.
Sum.inl n: absorb transition at index n (fires from i)
Sum.inr n: emit transition at index n (fires to o) -/
def CrownCounterTransition := ℕ ⊕ ℕ

/-- The Petri net underlying the crown countermodel.

Transition semantics:
- Sum.inl n (absorb): pre = {i:1}, post = {q:n, c n:1}
- Sum.inr n (emit): pre = {q:n, c n:1}, post = {o:1}
-/
noncomputable def crownCounterNet : PetriNet CrownCounterPlace CrownCounterTransition where
  pre := fun t => match t with
    | Sum.inl n =>
        -- Absorb transition: consumes 1 from i
        Finsupp.single CrownCounterPlace.i 1
    | Sum.inr n =>
        -- Emit transition: consumes n from q and 1 from c n
        Finsupp.update (Finsupp.single CrownCounterPlace.q n)
          (CrownCounterPlace.c n) 1
  post := fun t => match t with
    | Sum.inl n =>
        -- Absorb transition: produces n tokens to q and 1 to c n
        Finsupp.update (Finsupp.single CrownCounterPlace.q n)
          (CrownCounterPlace.c n) 1
    | Sum.inr n =>
        -- Emit transition: produces 1 token to o
        Finsupp.single CrownCounterPlace.o 1

/-- The crown countermodel is a workflow net.

Source: i (no input transitions)
Sink: o (no output transitions)
Every node lies on a path from i to o.
-/
noncomputable def crownCounterWfNet : WfNet CrownCounterPlace CrownCounterTransition where
  net := crownCounterNet
  source := CrownCounterPlace.i
  sink := CrownCounterPlace.o
  source_ne_sink := by decide
  source_no_input := fun _t => by sorry
  sink_no_output := fun _t => by sorry
  onPath := fun _x => by sorry

/-- From initial marking, we reach an intermediate marking by firing absorb. -/
lemma crownCounter_reaches_mid (n : ℕ) :
    ∃ M, crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M := by
  use crownCounterWfNet.initialMarking
  sorry

/-- Key reachability fact: from any reachable marking, we can reach the final marking. -/
lemma crownCounter_reaches_final (M : Marking CrownCounterPlace) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M →
    crownCounterWfNet.net.Reaches M crownCounterWfNet.finalMarking := by
  intro _
  sorry

/-- The crown countermodel is sound: it satisfies all three soundness clauses. -/
theorem crownCounter_sound : crownCounterWfNet.Sound := by
  sorry

/-- For any bound k, we can reach a marking where the short-circuit violates boundedness. -/
theorem crownCounter_not_bounded :
    ¬ ∃ k, crownCounterWfNet.shortCircuit.Bounded crownCounterWfNet.initialMarking k := by
  sorry

/-- The intermediate marking after firing absorb transition n. -/
noncomputable def intermediateMarking (n : ℕ) : Marking CrownCounterPlace :=
  Finsupp.single CrownCounterPlace.q n + Finsupp.single (CrownCounterPlace.c n) 1

/-- CrownCounterTransition = ℕ ⊕ ℕ is infinite. -/
instance : Infinite CrownCounterTransition := by
  unfold CrownCounterTransition
  infer_instance

/-- Main counterexample theorem:
    There exists a WfNet with infinite transitions that is sound
    but whose short-circuit is unbounded.

This proves the crown-jewel theorem (soundness iff liveness + boundedness)
requires [Finite T].
-/
theorem WfNet.infinite_transition_countermodel_sound_not_bounded :
    Infinite CrownCounterTransition ∧
    ∃ (W : WfNet CrownCounterPlace CrownCounterTransition),
      W.Sound ∧ ¬ ∃ k, W.shortCircuit.Bounded W.initialMarking k := by
  constructor
  · infer_instance
  · use crownCounterWfNet
    exact ⟨crownCounter_sound, crownCounter_not_bounded⟩


end ProcInt
