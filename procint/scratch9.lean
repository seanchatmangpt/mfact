import Mathlib
import ProcInt.MFW.TransformBasic
import ProcInt.MFW.SpectrumBundle

namespace ProcInt.MFW
open scoped Real

theorem partitionSum_singleton_q_zero_proof
    (p : ℝ) (hp : 0 < p) :
    hierarchicalPartitionSum [p] 0 = 1 := by
  unfold hierarchicalPartitionSum
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, add_zero]
  exact Real.rpow_zero p
