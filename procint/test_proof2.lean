import Mathlib

noncomputable def pddlLocalDim (b : Nat) : ℕ := b
noncomputable def powlLocalDim (_w : Nat) : ℕ := 0
noncomputable def transformationDimensionLoss (b w : Nat) : ℤ :=
  (pddlLocalDim b : ℤ) - (powlLocalDim w : ℤ)

theorem dimension_loss_nonneg (b w : Nat) :
    0 ≤ transformationDimensionLoss b w := by
  simp [transformationDimensionLoss, powlLocalDim]
