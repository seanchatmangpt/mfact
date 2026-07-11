import ProcInt.Workflow.Countermodel

open ProcInt

theorem test1 (n : ℕ) : (crownCounterNet.post (Sum.inl n)) CrownCounterPlace.i = 0 := by
  simp [crownCounterNet, PetriNet.post, Finsupp.update, Finsupp.single]

theorem test2 (n : ℕ) : (crownCounterNet.post (Sum.inr n)) CrownCounterPlace.i = 0 := by
  simp [crownCounterNet, PetriNet.post, Finsupp.update, Finsupp.single]
