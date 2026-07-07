import Mathlib
import ProcInt.Petri.Boundedness

namespace ProcInt

theorem PetriNet.bounded_of_finite_reach {P T : Type} [DecidableEq P]
    (N : PetriNet P T) (M₀ : Marking P)
    (hfin : {M | N.Reaches M₀ M}.Finite) :
    ∃ k, N.Bounded M₀ k := by
  refine ⟨hfin.toFinset.sup (fun N' => N'.support.sup N'), ?_⟩
  intro M hM p
  have hMmem : M ∈ hfin.toFinset := hfin.mem_toFinset.mpr hM
  by_cases hp : p ∈ M.support
  · calc M p ≤ M.support.sup (⇑M) := Finset.le_sup hp
      _ ≤ hfin.toFinset.sup (fun N' => N'.support.sup N') :=
        Finset.le_sup (f := fun N' => N'.support.sup (⇑N')) hMmem
  · have : M p = 0 := by simpa using hp
    rw [this]
    exact Nat.zero_le _

end ProcInt

#print axioms ProcInt.PetriNet.bounded_of_finite_reach
