-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.Scale

/-!
# ProcInt.Playground.Multifractal.LocalExponent

Pointwise lower, upper, and convergent local mass exponents over a discrete scale.

`localMassLogRatio` is a total Lean function. Its classical multifractal
interpretation is fenced by `LocalMassAdmissibleAtScale`, because `ENNReal.toReal`
collapses both `0` and `⊤` and a radius of `1` gives a zero logarithmic denominator.
-/

namespace ProcInt.Playground.Multifractal

open Filter MeasureTheory
open scoped Topology ENNReal

noncomputable section

variable {X : Type*} [MetricSpace X] [MeasurableSpace X]

/-- Mass of the scale ball centered at `x`. -/
def localMass (μ : Measure X) (σ : Scale) (x : X) (n : ℕ) : ℝ≥0∞ :=
  μ (σ.ball x n)

/-- Admission predicate for the classical logarithmic local-mass ratio. -/
def LocalMassAdmissibleAtScale
    (μ : Measure X) (σ : Scale) (x : X) (n : ℕ) : Prop :=
  localMass μ σ x n ≠ 0 ∧
    localMass μ σ x n ≠ ⊤ ∧
    σ.radius n ≠ 1

/-- Pointwise admission across every discrete scale. -/
def LocalMassAdmissibleAt (μ : Measure X) (σ : Scale) (x : X) : Prop :=
  ∀ n, LocalMassAdmissibleAtScale μ σ x n

/--
The scale-local logarithmic ratio
`log μ(B(x,rₙ)) / log rₙ`.

Interpret this as a classical local-dimension observation only on the admitted
surface `LocalMassAdmissibleAtScale`.
-/
def localMassLogRatio (μ : Measure X) (σ : Scale) (x : X) (n : ℕ) : ℝ :=
  Real.log (localMass μ σ x n).toReal / Real.log (σ.radius n)

/-- Lower local mass exponent along the admitted discrete scale schedule. -/
def lowerLocalExponent (μ : Measure X) (σ : Scale) (x : X) : ℝ :=
  Filter.liminf (localMassLogRatio μ σ x) atTop

/-- Upper local mass exponent along the admitted discrete scale schedule. -/
def upperLocalExponent (μ : Measure X) (σ : Scale) (x : X) : ℝ :=
  Filter.limsup (localMassLogRatio μ σ x) atTop

/-- The local mass exponent exists and equals `α` along `σ`. -/
def HasLocalExponent (μ : Measure X) (σ : Scale) (x : X) (α : ℝ) : Prop :=
  Tendsto (localMassLogRatio μ σ x) atTop (𝓝 α)

/-- Exact local-exponent level set. -/
def localExponentLevelSet (μ : Measure X) (σ : Scale) (α : ℝ) : Set X :=
  {x | HasLocalExponent μ σ x α}

/-- Level set of the lower local exponent. -/
def lowerLocalExponentLevelSet (μ : Measure X) (σ : Scale) (α : ℝ) : Set X :=
  {x | lowerLocalExponent μ σ x = α}

/-- Level set of the upper local exponent. -/
def upperLocalExponentLevelSet (μ : Measure X) (σ : Scale) (α : ℝ) : Set X :=
  {x | upperLocalExponent μ σ x = α}

@[simp]
theorem mem_localExponentLevelSet_iff
    (μ : Measure X) (σ : Scale) (x : X) (α : ℝ) :
    x ∈ localExponentLevelSet μ σ α ↔ HasLocalExponent μ σ x α :=
  Iff.rfl

end

end ProcInt.Playground.Multifractal
