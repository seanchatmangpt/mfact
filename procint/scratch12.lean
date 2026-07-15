import Mathlib
import ProcInt.MFW.TransformBasic
import ProcInt.MFW.SpectrumBundle

namespace ProcInt.MFW
open scoped Real

theorem partitionSum_nonneg_proof
    (masses : List ℝ) (q : ℝ)
    (hnn : ∀ p ∈ masses, 0 ≤ p)
    (hq : 0 ≤ q) :
    0 ≤ hierarchicalPartitionSum masses q := by
  unfold hierarchicalPartitionSum
  apply List.sum_nonneg
  intro x hx
  have ⟨p, hp, hp_eq⟩ := List.mem_map.mp hx
  rw [← hp_eq]
  exact Real.rpow_nonneg (hnn p hp) q

