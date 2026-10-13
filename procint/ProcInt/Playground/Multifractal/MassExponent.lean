-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.PartitionFunction

/-!
# ProcInt.Playground.Multifractal.MassExponent

Lower, upper, and convergent mass exponents `τ(q)` from recursive scale observations.
-/

namespace ProcInt.Playground.Multifractal

open Filter MeasureTheory
open scoped Topology

noncomputable section

variable {X : Type*} [MeasurableSpace X]

/-- Scale-normalized logarithmic partition function. -/
def massExponentSequence
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q : ℝ) (n : ℕ) : ℝ :=
  Real.log (partitionFunction μ P q n) / Real.log (σ.radius n)

/-- Admission predicate for the logarithmic mass-exponent sequence. -/
def MassExponentAdmissible
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q : ℝ) : Prop :=
  PartitionMassAdmissible μ P ∧
    PartitionFunctionPositive μ P q ∧
    ∀ n, σ.radius n ≠ 1

/-- Lower mass exponent `τ₋(q)`. -/
def lowerMassExponent
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q : ℝ) : ℝ :=
  Filter.liminf (massExponentSequence μ P σ q) atTop

/-- Upper mass exponent `τ₊(q)`. -/
def upperMassExponent
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q : ℝ) : ℝ :=
  Filter.limsup (massExponentSequence μ P σ q) atTop

/-- The mass exponent exists and equals `τ` along the scale schedule. -/
def HasMassExponent
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q τ : ℝ) : Prop :=
  Tendsto (massExponentSequence μ P σ q) atTop (𝓝 τ)

end

end ProcInt.Playground.Multifractal
