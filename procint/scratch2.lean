import Mathlib
import ProcInt.MFW.TransformBasic
import ProcInt.MFW.SpectrumBundle

namespace ProcInt.MFW

theorem partitionSum_q_one_proof
    (masses : List ℝ)
    (hnorm : (masses).sum = 1) :
    hierarchicalPartitionSum masses 1 = 1 := by
  unfold hierarchicalPartitionSum
  have : masses.map (fun p => p ^ (1 : ℝ)) = masses := by
    apply List.map_id''
    intro p _
    exact Real.rpow_one p
  rw [this, hnorm]

