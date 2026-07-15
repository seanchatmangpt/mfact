import Mathlib
import ProcInt.MFW.TransformBasic
import ProcInt.MFW.SpectrumBundle

namespace ProcInt.MFW

theorem partitionSum_append_proof
    (masses₁ masses₂ : List ℝ) (q : ℝ) :
    hierarchicalPartitionSum (masses₁ ++ masses₂) q =
    hierarchicalPartitionSum masses₁ q + hierarchicalPartitionSum masses₂ q := by
  unfold hierarchicalPartitionSum
  rw [List.map_append, List.sum_append]

