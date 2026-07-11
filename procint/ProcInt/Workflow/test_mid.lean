import Mathlib
import ProcInt.Workflow.Countermodel

open ProcInt

lemma test_mid (n : ℕ) :
    ∃ M, crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M := by
  use crownCounterWfNet.net.fire crownCounterWfNet.initialMarking (Sum.inl n)
  apply Relation.ReflTransGen.single
  constructor
  · intro p
    dsimp [crownCounterWfNet, WfNet.initialMarking, crownCounterNet, PetriNet.Enabled]
    simp [Finsupp.single_apply]
    split_ifs
    · rfl
    · exact Nat.zero_le _
  · rfl
