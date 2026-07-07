-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Reachability

/-! # ProcInt.Petri.Boundedness

Behavioural properties over the reachability set: k-boundedness (every reachable marking carries at most k tokens per place) and L4-liveness (every transition can always eventually fire again) — Murata 1989, section IV; the two properties whose conjunction characterizes WF-net soundness (van der Aalst 1997, Lemma 8). -/

namespace ProcInt

/-- A net is k-bounded from M₀ when every reachable marking carries at most
k tokens in every place (Murata 1989, section IV, boundedness; k = 1 is
safeness). -/
def PetriNet.Bounded {P T : Type} (N : PetriNet P T) (M₀ : Marking P) (k : ℕ) : Prop :=
  ∀ M, N.Reaches M₀ M → ∀ p, M p ≤ k

/-- A net is live from M₀ when from every reachable marking, every transition
can eventually be enabled again (Murata 1989, section IV, L4-liveness — the
liveness clause of van der Aalst 1997 WF-net soundness). -/
def PetriNet.Live {P T : Type} (N : PetriNet P T) (M₀ : Marking P) : Prop :=
  ∀ M, N.Reaches M₀ M → ∀ t, ∃ M', N.Reaches M M' ∧ N.Enabled M' t

theorem Marking.exists_le_of_support_subset {P : Type} [DecidableEq P]
    (S : Finset P) (f : ℕ → Marking P) (hf : ∀ n, (f n).support ⊆ S) :
    ∃ m n : ℕ, m < n ∧ f m ≤ f n := by
  classical
  -- restrict each marking to the finite index type `{x // x ∈ S}`
  let g : ℕ → ({x // x ∈ S} →₀ ℕ) := fun n => (f n).subtypeDomain (· ∈ S)
  obtain ⟨m, n, hmn, hle⟩ := wellQuasiOrdered_le g
  refine ⟨m, n, hmn, ?_⟩
  rw [Finsupp.le_def]
  intro p
  by_cases hp : p ∈ S
  · have := (Finsupp.le_def).mp hle ⟨p, hp⟩
    simpa [g, Finsupp.subtypeDomain_apply] using this
  · have hmp : (f m) p = 0 := by
      by_contra h
      exact hp (hf m (Finsupp.mem_support_iff.mpr h))
    simp [hmp]

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
