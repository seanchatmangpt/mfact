import Mathlib
import ProcInt.MFW.TransformBasic
import ProcInt.MFW.SpectrumBundle

namespace ProcInt.MFW
open scoped Real

theorem partitionSum_q_zero_proof
    (masses : List ℝ)
    (hpos : ∀ p ∈ masses, 0 < p) :
    hierarchicalPartitionSum masses 0 = masses.length := by
  unfold hierarchicalPartitionSum
  induction' masses with p ps ih
  · simp
  · simp only [List.map_cons, List.sum_cons, List.length_cons, Nat.cast_add, Nat.cast_one]
    have hp0 : p ≠ 0 := by linarith [hpos p (List.Mem.head _)]
    have hps : ∀ p ∈ ps, 0 < p := fun p hp => hpos p (List.Mem.tail _ hp)
    rw [ih hps]
    have : p ^ (0 : ℝ) = 1 := Real.rpow_zero _
    rw [this]
    ring
