import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing

namespace ProcInt

/-- Firing is compatible with adding an arbitrary marking offset: if `t`
takes `M` to `M'`, it also takes `M + A` to `M' + A`. Used to transport a
firing step along a place-wise token increase (e.g. when comparing markings
that differ by an invariant offset). -/
theorem PetriNet.step_add {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} {t : T} (A : Marking P)
    (h : N.Step M t M') : N.Step (M + A) t (M' + A) := by
  obtain ⟨hen, hfire⟩ := h
  have hle : N.pre t ≤ M + A := hen.trans le_self_add
  refine ⟨hle, ?_⟩
  show M' + A = (M + A) - N.pre t + N.post t
  rw [hfire]
  show M - N.pre t + N.post t + A = (M + A) - N.pre t + N.post t
  have hkey : (M + A) - N.pre t = M - N.pre t + A := by
    rw [add_comm M A, add_tsub_assoc_of_le hen A, add_comm A]
  rw [hkey, add_right_comm]

end ProcInt
