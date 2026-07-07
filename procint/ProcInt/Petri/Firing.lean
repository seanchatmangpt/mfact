-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net

/-! # ProcInt.Petri.Firing

The transition (firing) rule: enabledness, the fire function via truncated Finsupp subtraction, the one-step relation, determinism of firing, and the single-firing token-conservation identity underlying the state equation (Murata 1989, section II.C). -/

namespace ProcInt

/-- Transition t is enabled at marking M when every input place carries at
least the required tokens (Murata 1989, firing rule, condition (1)). -/
def PetriNet.Enabled {P T : Type} (N : PetriNet P T) (M : Marking P) (t : T) : Prop :=
  N.pre t ≤ M

/-- Fire transition t at marking M: consume the pre-multiset (truncated
subtraction) and produce the post-multiset (Murata 1989, firing rule,
condition (2)). Noncomputable because Finsupp addition is. -/
noncomputable def PetriNet.fire {P T : Type} (N : PetriNet P T) (M : Marking P) (t : T) : Marking P :=
  M - N.pre t + N.post t

/-- One firing step: t is enabled at M and M' is the result of firing it
(Murata 1989, the transition (firing) rule). -/
def PetriNet.Step {P T : Type} (N : PetriNet P T) (M : Marking P) (t : T) (M' : Marking P) : Prop :=
  N.Enabled M t ∧ M' = N.fire M t

/-- Firing is deterministic: one transition fired at one marking yields a
unique successor marking (immediate from the firing rule, Murata 1989). -/
theorem PetriNet.step_deterministic {P T : Type} (N : PetriNet P T)
    {M M₁ M₂ : Marking P} {t : T}
    (h₁ : N.Step M t M₁) (h₂ : N.Step M t M₂) : M₁ = M₂ := by
  rw [h₁.2, h₂.2]

/-- Firing under enabledness satisfies the token-conservation identity
fire M t + pre t = M + post t — the Finsupp form of the state-equation
increment for a single firing (Murata 1989, section II.C). -/
theorem PetriNet.fire_add_pre {P T : Type} (N : PetriNet P T)
    {M : Marking P} {t : T} (h : N.Enabled M t) :
    N.fire M t + N.pre t = M + N.post t := by
  have h' : N.pre t ≤ M := h
  show M - N.pre t + N.post t + N.pre t = M + N.post t
  rw [add_right_comm, tsub_add_cancel_of_le h']

theorem PetriNet.enabled_mono {P T : Type} (N : PetriNet P T)
    {M M' : Marking P} {t : T}
    (h : N.Enabled M t) (hle : M ≤ M') : N.Enabled M' t :=
  le_trans h hle

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

theorem PetriNet.fire_pre_self {P T : Type} (N : PetriNet P T) (t : T) :
    N.fire (N.pre t) t = N.post t := by
  show N.pre t - N.pre t + N.post t = N.post t
  rw [tsub_self, zero_add]

theorem PetriNet.step_pre_self {P T : Type} (N : PetriNet P T) (t : T) :
    N.Step (N.pre t) t (N.post t) :=
  ⟨le_refl (N.pre t), (N.fire_pre_self t).symm⟩


end ProcInt
