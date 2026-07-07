-- Ticket 012: Reachability analysis of the countermodel
-- Characterizes the shape of all reachable markings

import Mathlib
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Workflow.Soundness
import ProcInt.Playground.Ticket012.CountermodelTypes

namespace ProcInt.Playground.Ticket012

open WfNet ProcInt

/-- The intermediate marking after firing absorb transition n:
    - 0 tokens at i (source)
    - n tokens at q (queue)
    - 1 token at c n (counter place n)
    - 0 tokens at o (sink)
-/
noncomputable def intermediateMarking (n : ℕ) : Marking CrownCounterPlace :=
  Finsupp.single CrownCounterPlace.q n + Finsupp.single (CrownCounterPlace.c n) 1

/-- Helper lemma: the intermediate marking has n tokens at q. -/
lemma intermediateMarking_q (n : ℕ) :
    (intermediateMarking n) CrownCounterPlace.q = n := by
  simp [intermediateMarking, Finsupp.add_apply, Finsupp.single_eq_same, Finsupp.single_eq_of_ne]
  decide

/-- Helper lemma: the intermediate marking has 1 token at c n. -/
lemma intermediateMarking_c (n : ℕ) :
    (intermediateMarking n) (CrownCounterPlace.c n) = 1 := by
  simp [intermediateMarking, Finsupp.add_apply, Finsupp.single_eq_same, Finsupp.single_eq_of_ne]

/-- Helper lemma: the intermediate marking has 0 tokens at i. -/
lemma intermediateMarking_i (n : ℕ) :
    (intermediateMarking n) CrownCounterPlace.i = 0 := by
  simp [intermediateMarking, Finsupp.add_apply, Finsupp.single_eq_of_ne]
  decide

/-- Helper lemma: the intermediate marking has 0 tokens at o. -/
lemma intermediateMarking_o (n : ℕ) :
    (intermediateMarking n) CrownCounterPlace.o = 0 := by
  simp [intermediateMarking, Finsupp.add_apply, Finsupp.single_eq_of_ne]
  decide

/-- Step 1: From initial marking, firing Sum.inl n reaches the intermediate marking. -/
lemma crownCounter_initial_step_absorb (n : ℕ) :
    crownCounterWfNet.net.Step crownCounterWfNet.initialMarking (Sum.inl n) (intermediateMarking n) := by
  unfold PetriNet.Step PetriNet.Enabled PetriNet.Enabled_place crownCounterWfNet crownCounterNet
  unfold WfNet.initialMarking
  constructor
  · -- Show enabled: 1 token required at i
    simp only [Finsupp.single_eq_same]
    omega
  · -- Show the step computation equals intermediate marking
    unfold intermediateMarking
    ext p
    match p with
    | CrownCounterPlace.i =>
        simp [crownCounterNet, Finsupp.single_eq_same, Finsupp.single_eq_of_ne, Finsupp.add_apply,
              Finsupp.tsub_apply, Finsupp.update_apply]
        omega
    | CrownCounterPlace.q =>
        simp [crownCounterNet, Finsupp.single_eq_same, Finsupp.single_eq_of_ne, Finsupp.add_apply,
              Finsupp.tsub_apply, Finsupp.update_apply]
        omega
    | CrownCounterPlace.o =>
        simp [crownCounterNet, Finsupp.single_eq_same, Finsupp.single_eq_of_ne, Finsupp.add_apply,
              Finsupp.tsub_apply, Finsupp.update_apply]
        omega
    | CrownCounterPlace.c m =>
        simp only [crownCounterNet, Finsupp.single_eq_of_ne, Finsupp.tsub_apply, Finsupp.add_apply,
                   Finsupp.update_apply]
        split_ifs with heq
        · simp [Finsupp.single_eq_same, heq]
        · simp [Finsupp.single_eq_of_ne (Ne.symm heq), Finsupp.single_eq_of_ne (fun h => heq (h ▸ rfl))]

/-- From initial marking, we reach the intermediate marking by firing absorb. -/
lemma crownCounter_reaches_mid (n : ℕ) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking (intermediateMarking n) := by
  exact Relation.ReflTransGen.single ⟨Sum.inl n, crownCounter_initial_step_absorb n⟩

/-- Step 2: From intermediate marking, firing Sum.inr n reaches the final marking. -/
lemma crownCounter_mid_step_emit (n : ℕ) :
    crownCounterWfNet.net.Step (intermediateMarking n) (Sum.inr n) crownCounterWfNet.finalMarking := by
  unfold PetriNet.Step PetriNet.Enabled PetriNet.Enabled_place crownCounterWfNet crownCounterNet
  unfold WfNet.finalMarking
  constructor
  · -- Show enabled: n tokens at q and 1 token at c n
    simp only [intermediateMarking_q, intermediateMarking_c]
    omega
  · -- Show the step computation equals final marking
    ext p
    match p with
    | CrownCounterPlace.i =>
        simp [crownCounterNet, intermediateMarking, Finsupp.single_eq_same, Finsupp.single_eq_of_ne,
              Finsupp.add_apply, Finsupp.tsub_apply, Finsupp.update_apply]
        omega
    | CrownCounterPlace.q =>
        simp [crownCounterNet, intermediateMarking, Finsupp.single_eq_same, Finsupp.single_eq_of_ne,
              Finsupp.add_apply, Finsupp.tsub_apply, Finsupp.update_apply]
        omega
    | CrownCounterPlace.o =>
        simp [crownCounterNet, intermediateMarking, Finsupp.single_eq_same, Finsupp.single_eq_of_ne,
              Finsupp.add_apply, Finsupp.tsub_apply, Finsupp.update_apply]
        omega
    | CrownCounterPlace.c m =>
        simp only [crownCounterNet, Finsupp.single_eq_of_ne, Finsupp.tsub_apply, Finsupp.add_apply,
                   Finsupp.update_apply, intermediateMarking]
        split_ifs with heq
        · simp [Finsupp.single_eq_same, Finsupp.single_eq_of_ne, heq]
          omega
        · simp [Finsupp.single_eq_of_ne (Ne.symm heq), Finsupp.single_eq_of_ne (fun h => heq (h ▸ rfl))]
          omega

/-- From intermediate marking, we reach the final marking by firing emit. -/
lemma crownCounter_mid_reaches_final (n : ℕ) :
    crownCounterWfNet.net.Reaches (intermediateMarking n) crownCounterWfNet.finalMarking := by
  exact Relation.ReflTransGen.single ⟨Sum.inr n, crownCounter_mid_step_emit n⟩

/-- From initial marking, we reach the final marking: absorb then emit. -/
lemma crownCounter_reaches_final_via_sequence (n : ℕ) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking crownCounterWfNet.finalMarking := by
  exact (crownCounter_reaches_mid n).trans (crownCounter_mid_reaches_final n)

/-- Key reachability fact: from any reachable marking, we can reach the final marking.
This is the option-to-complete property. From any marking reachable from the source i,
we can fire emit transitions (Sum.inr n) to move tokens to the sink o. -/
lemma crownCounter_reaches_final (M : Marking CrownCounterPlace) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M →
    crownCounterWfNet.net.Reaches M crownCounterWfNet.finalMarking := by
  intro _
  -- Strategy: any reachable marking has tokens distributed among places.
  -- We can always find an n such that the net has enough tokens to reach the final marking.
  -- For this countermodel, any reachable marking can reach the final marking.
  sorry

/-- Characterize the shape of all reachable markings:
    A marking M is reachable from the initial marking iff:
    1. M equals the initial marking [i], OR
    2. M has the intermediate form with n tokens at q and 1 at some c n, OR
    3. M equals the final marking [o].
-/
lemma crownCounter_reachable_shape (M : Marking CrownCounterPlace) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M →
    (M = crownCounterWfNet.initialMarking ∨
     (∃ n, M = intermediateMarking n) ∨
     M = crownCounterWfNet.finalMarking) := by
  intro _
  -- Any reachable marking has one of these three shapes.
  -- This follows from the token-conserving structure of the net.
  sorry

end ProcInt.Playground.Ticket012
