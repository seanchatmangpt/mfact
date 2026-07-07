import Mathlib
import ProcInt.Petri.Reachability

namespace ProcInt

/-- Local helper: firing under [Marking] addition by a constant offset
commutes with the fire function, provided the transition was enabled at
the original (smaller) marking. -/
theorem PetriNet.fire_add {P T : Type} (N : PetriNet P T)
    {M : Marking P} (A : Marking P) {t : T} (h : N.Enabled M t) :
    N.fire (M + A) t = N.fire M t + A := by
  have hle : N.pre t ≤ M := h
  show M + A - N.pre t + N.post t = M - N.pre t + N.post t + A
  have : M + A - N.pre t = M - N.pre t + A := by
    rw [add_comm M A, add_tsub_assoc_of_le hle, add_comm]
  rw [this, add_right_comm]

/-- Local helper: a transition enabled at M remains enabled at M + A, since
adding tokens can only help satisfy the pre-condition. -/
theorem PetriNet.enabled_add {P T : Type} (N : PetriNet P T)
    {M : Marking P} (A : Marking P) {t : T} (h : N.Enabled M t) :
    N.Enabled (M + A) t := by
  have hle : N.pre t ≤ M := h
  exact hle.trans le_self_add

/-- Local helper: one firing step is stable under adding a constant offset
to both markings. -/
theorem PetriNet.step_add {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} (A : Marking P) {t : T} (h : N.Step M t M') :
    N.Step (M + A) t (M' + A) := by
  refine ⟨N.enabled_add A h.1, ?_⟩
  rw [h.2, N.fire_add A h.1]

/-- Reachability is stable under adding a constant offset to both markings:
if M' is reachable from M, then M' + A is reachable from M + A (Stage A
infrastructure lemma — token-conserving translation of reachability facts,
Murata 1989 section II.D). -/
theorem PetriNet.reaches_add {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} (A : Marking P) (h : N.Reaches M M') :
    N.Reaches (M + A) (M' + A) := by
  induction h with
  | refl => exact Relation.ReflTransGen.refl
  | tail _ hstep ih =>
      obtain ⟨t, ht⟩ := hstep
      exact Relation.ReflTransGen.tail ih ⟨t, N.step_add A ht⟩

end ProcInt
