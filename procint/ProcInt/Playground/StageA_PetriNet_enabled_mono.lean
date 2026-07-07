import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

namespace ProcInt

theorem PetriNet.enabled_mono {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} {t : T}
    (h : N.Enabled M t) (hle : M ≤ M') : N.Enabled M' t :=
  le_trans h hle

end ProcInt
