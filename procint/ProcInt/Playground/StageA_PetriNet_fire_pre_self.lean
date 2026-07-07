import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

namespace ProcInt

variable {P T : Type} (N : PetriNet P T) (t : T)

theorem PetriNet.fire_pre_self : N.fire (N.pre t) t = N.post t := by
  show N.pre t - N.pre t + N.post t = N.post t
  rw [tsub_self, zero_add]

theorem PetriNet.step_pre_self : N.Step (N.pre t) t (N.post t) :=
  ⟨le_refl (N.pre t), (N.fire_pre_self t).symm⟩

end ProcInt

#print axioms ProcInt.PetriNet.fire_pre_self
#print axioms ProcInt.PetriNet.step_pre_self
