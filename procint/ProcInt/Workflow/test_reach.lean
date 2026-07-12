import Mathlib
import ProcInt.Workflow.Soundness

namespace ProcInt

inductive CrownCounterPlace : Type | i | q | o | c : ℕ → CrownCounterPlace deriving DecidableEq, Repr
def CrownCounterTransition := ℕ ⊕ ℕ

lemma test_ind (r : Marking CrownCounterPlace → Marking CrownCounterPlace → Prop) (M1 M2 : Marking CrownCounterPlace) (h : Relation.ReflTransGen r M1 M2) : True := by
  induction h with
  | refl => by exact trivial
  | tail a b c => by exact trivial
