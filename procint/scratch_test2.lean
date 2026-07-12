import Mathlib
import ProcInt.Workflow.Soundness

namespace ProcInt

inductive CrownCounterPlace : Type | i | q | o | c : ℕ → CrownCounterPlace deriving DecidableEq, Repr

example (n : ℕ) : (Finsupp.update (Finsupp.single CrownCounterPlace.q n) (CrownCounterPlace.c n) 1) CrownCounterPlace.q = n := by
  simp [Finsupp.update_apply]
