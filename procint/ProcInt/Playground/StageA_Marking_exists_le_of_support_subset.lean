import Mathlib
import ProcInt.Petri.Net

namespace ProcInt

/-- Stage-A infrastructure lemma: any sequence of markings all supported on a
fixed finite set of places `S` contains an increasing pair `m < n` with
`f m ≤ f n` (Dickson's lemma for finitely-supported functions over a finite
index type, via `Finsupp.wellQuasiOrderedLE`). -/
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

end ProcInt
