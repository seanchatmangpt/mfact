-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.BirkhoffSpectrum
import ProcInt.Playground.Multifractal.LocalExponent
import Mathlib.Topology.MetricSpace.HausdorffDimension

/-!
# ProcInt.Playground.Multifractal.HausdorffSpectrum

Hausdorff-dimension evaluators for exact observables, local mass exponents,
and Birkhoff-average level sets.
-/

namespace ProcInt.Playground.Multifractal

open MeasureTheory
open scoped ENNReal

noncomputable section

section Generic

variable {X A : Type*} [EMetricSpace X]

/-- Hausdorff dimension of an exact observable level set. -/
def hausdorffSpectrumAt (φ : X → A) (a : A) : ℝ≥0∞ :=
  dimH (levelSet φ a)

/-- Full Hausdorff spectrum of an observable. -/
def hausdorffSpectrum (φ : X → A) : A → ℝ≥0∞ :=
  fun a => hausdorffSpectrumAt φ a

end Generic

section LocalMass

variable {X : Type*} [MetricSpace X] [MeasurableSpace X]

/-- Hausdorff dimension of points with an existing local mass exponent `α`. -/
def localExponentHausdorffSpectrum
    (μ : Measure X) (σ : Scale) (α : ℝ) : ℝ≥0∞ :=
  dimH (localExponentLevelSet μ σ α)

/-- Hausdorff spectrum of the lower local mass exponent. -/
def lowerLocalExponentHausdorffSpectrum
    (μ : Measure X) (σ : Scale) (α : ℝ) : ℝ≥0∞ :=
  dimH (lowerLocalExponentLevelSet μ σ α)

/-- Hausdorff spectrum of the upper local mass exponent. -/
def upperLocalExponentHausdorffSpectrum
    (μ : Measure X) (σ : Scale) (α : ℝ) : ℝ≥0∞ :=
  dimH (upperLocalExponentLevelSet μ σ α)

end LocalMass

section Birkhoff

variable {X : Type*} [EMetricSpace X]

/-- Hausdorff dimension of the Birkhoff-average level set at `α`. -/
def birkhoffHausdorffSpectrum
    (T : X → X) (φ : X → ℝ) (α : ℝ) : ℝ≥0∞ :=
  dimH (birkhoffLevelSet T φ α)

end Birkhoff

end

end ProcInt.Playground.Multifractal
