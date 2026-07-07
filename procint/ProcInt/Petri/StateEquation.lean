-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability

/-! # ProcInt.Petri.StateEquation

Murata 1989 state equation over the integers: markings P →₀ ℕ are cast into ℤ^P via Finsupp.mapRange Int.ofNat, the incidence column of a transition is post − pre, and both the single-step (Mʹ = M + A·eₜ) and firing-sequence (Mʹ = M + Σ A·eₜᵢ) forms of Murata Eq. (5) are proven by pointwise omega and induction on the firing sequence. Ported from the Marking/firing structure in wasm4pm-compat src/petri.rs. -/

namespace ProcInt

/-- Cast a natural-number marking to an integer-valued vector (Murata 1989, Section IV-A:
markings are embedded in ℤ^P so that the state equation lives in an additive group). -/
noncomputable def Marking.toInt {P : Type} (M : Marking P) : P →₀ ℤ :=
  Finsupp.mapRange Int.ofNat rfl M

/-- The marking cast is injective: distinct ℕ-markings stay distinct in ℤ^P. -/
theorem Marking.toInt_injective {P : Type} :
    Function.Injective (Marking.toInt (P := P)) :=
  Finsupp.mapRange_injective Int.ofNat rfl (fun _ _ h => Int.ofNat.inj h)

/-- The incidence column of transition t (Murata 1989, Eq. (4): A = A⁺ − A⁻, one column
per transition): the net token change post t − pre t as an integer vector. -/
noncomputable def PetriNet.change {P T : Type} (N : PetriNet P T) (t : T) : P →₀ ℤ :=
  Finsupp.mapRange Int.ofNat rfl (N.post t) - Finsupp.mapRange Int.ofNat rfl (N.pre t)

/-- Murata 1989, state equation (Eq. (5)) for a single firing: if M —t→ M' then
Mʹ = M + A·eₜ over ℤ. -/
theorem PetriNet.stateEquation_step {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} {t : T} (h : N.Step M t M') :
    Marking.toInt M' = Marking.toInt M + N.change t := by
  obtain ⟨hen, rfl⟩ := h
  ext p
  have hp : N.pre t p ≤ M p := hen p
  simp only [Marking.toInt, PetriNet.fire, PetriNet.change, Finsupp.mapRange_apply,
    Finsupp.add_apply, Finsupp.sub_apply, Finsupp.tsub_apply, Int.ofNat_eq_natCast]
  omega

/-- Murata 1989, state equation (Eq. (5)) for a firing sequence: the reached marking is the
initial marking plus the sum of incidence columns of the fired transitions, over ℤ.
Proof by induction on the firing sequence. -/
theorem PetriNet.stateEquation_seq {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} {σ : List T} (h : N.FiringSeq M σ M') :
    Marking.toInt M' = Marking.toInt M + (σ.map N.change).sum := by
  induction h with
  | nil => simp
  | cons hstep _ ih =>
      rw [ih, N.stateEquation_step hstep]
      simp [add_assoc]


end ProcInt
