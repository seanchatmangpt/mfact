-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.MassExponent

/-!
# ProcInt.Playground.Multifractal.GeneralizedDimension

Generalized dimensions away from `q = 1`, plus a separate information-dimension
rail at `q = 1`.

The `q = 1` singularity is not silently filled with a fake value.
-/

namespace ProcInt.Playground.Multifractal

open Filter MeasureTheory

noncomputable section

variable {X : Type*} [MeasurableSpace X]

/-- Orders for the algebraic formula `D_q = τ(q)/(q-1)` must exclude `q = 1`. -/
def IsAdmissibleRenyiOrder (q : ℝ) : Prop :=
  q ≠ 1

/-- Lower generalized dimension away from the `q = 1` singularity. -/
def lowerGeneralizedDimension
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q : ℝ) : ℝ :=
  lowerMassExponent μ P σ q / (q - 1)

/-- Upper generalized dimension away from the `q = 1` singularity. -/
def upperGeneralizedDimension
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (q : ℝ) : ℝ :=
  upperMassExponent μ P σ q / (q - 1)

/-- Rényi entropy at one discrete scale, valid classically only for `q ≠ 1`. -/
def renyiEntropyAtScale
    (μ : Measure X) (P : ScalePartition X) (q : ℝ) (n : ℕ) : ℝ :=
  Real.log (partitionFunction μ P q n) / (1 - q)

/-- Information-dimension scaling sequence at `q = 1`. -/
def informationDimensionSequence
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) (n : ℕ) : ℝ :=
  informationSumAtScale μ P n / Real.log (σ.radius n)

/-- Lower information dimension from the `q = 1` rail. -/
def lowerInformationDimension
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) : ℝ :=
  Filter.liminf (informationDimensionSequence μ P σ) atTop

/-- Upper information dimension from the `q = 1` rail. -/
def upperInformationDimension
    (μ : Measure X) (P : ScalePartition X) (σ : Scale) : ℝ :=
  Filter.limsup (informationDimensionSequence μ P σ) atTop

end

end ProcInt.Playground.Multifractal
