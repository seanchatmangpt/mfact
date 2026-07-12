-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib

/-!
# ProcInt.Playground.Multifractal.Scale

A discrete scale schedule for recursive multifractal analysis.

The scale carrier is `ℕ → ℝ`: each manufacturing step selects a positive radius,
and the radius tends to zero along `Filter.atTop`.
-/

namespace ProcInt.Playground.Multifractal

open Filter
open scoped Topology

/-- A positive discrete radius schedule converging to zero. -/
structure Scale where
  radius : ℕ → ℝ
  positive : ∀ n, 0 < radius n
  tendsto_zero : Tendsto radius atTop (𝓝 0)

namespace Scale

/-- Every admitted scale radius is nonnegative. -/
theorem radius_nonneg (σ : Scale) (n : ℕ) : 0 ≤ σ.radius n :=
  (σ.positive n).le

/-- Every admitted scale radius is nonzero. -/
theorem radius_ne_zero (σ : Scale) (n : ℕ) : σ.radius n ≠ 0 :=
  ne_of_gt (σ.positive n)

/-- The metric ball observed at scale `n`. -/
def ball {X : Type*} [MetricSpace X] (σ : Scale) (x : X) (n : ℕ) : Set X :=
  Metric.ball x (σ.radius n)

/-- The closed metric ball observed at scale `n`. -/
def closedBall {X : Type*} [MetricSpace X] (σ : Scale) (x : X) (n : ℕ) : Set X :=
  Metric.closedBall x (σ.radius n)

/-- A geometric scale schedule `c^n`, valid for `0 < c < 1`. -/
def geometric (c : ℝ) (hc0 : 0 < c) (hc1 : c < 1) : Scale where
  radius n := c ^ n
  positive n := pow_pos hc0 n
  tendsto_zero := tendsto_pow_atTop_nhds_zero_of_lt_one hc0.le hc1

/-- The canonical dyadic scale schedule `2⁻ⁿ = (1/2)^n`. -/
noncomputable def dyadic : Scale :=
  geometric (1 / 2 : ℝ) (by norm_num) (by norm_num)

end Scale

end ProcInt.Playground.Multifractal
