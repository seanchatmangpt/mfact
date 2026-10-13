-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.Scale

/-!
# ProcInt.Playground.Multifractal.PartitionFunction

Finite scale-indexed cell families and mass partition functions.

`ScalePartition` stores the finite cells. Covering and disjointness are explicit
admission predicates rather than silently built into the carrier, so candidate
partitions can be diagnosed and refused before they gain standing.
-/

namespace ProcInt.Playground.Multifractal

open MeasureTheory
open scoped ENNReal

noncomputable section

/-- A finite family of observation cells at every discrete scale. -/
structure ScalePartition (X : Type*) where
  cells : ℕ → Finset (Set X)

namespace ScalePartition

/-- Every point of `s` is observed by some cell at every scale. -/
def Covers {X : Type*} (P : ScalePartition X) (s : Set X) : Prop :=
  ∀ n x, x ∈ s → ∃ U, U ∈ P.cells n ∧ x ∈ U

/-- Distinct cells at scale `n` are disjoint. -/
def PairwiseDisjointAt {X : Type*} (P : ScalePartition X) (n : ℕ) : Prop :=
  ∀ ⦃U⦄, U ∈ P.cells n → ∀ ⦃V⦄, V ∈ P.cells n → U ≠ V → Disjoint U V

/-- The cells form a pairwise-disjoint cover of `s` at every scale. -/
def AdmissibleOn {X : Type*} (P : ScalePartition X) (s : Set X) : Prop :=
  P.Covers s ∧ ∀ n, P.PairwiseDisjointAt n

end ScalePartition

variable {X : Type*} [MeasurableSpace X]

/-- Mass assigned to a cell. -/
def cellMass (μ : Measure X) (U : Set X) : ℝ≥0∞ :=
  μ U

/-- No cell mass is `⊤`; required before interpreting `ENNReal.toReal` numerically. -/
def PartitionMassAdmissible (μ : Measure X) (P : ScalePartition X) : Prop :=
  ∀ n U, U ∈ P.cells n → cellMass μ U ≠ ⊤

/-- Real `q`-power of a finite cell mass. -/
def massPower (μ : Measure X) (q : ℝ) (U : Set X) : ℝ :=
  Real.rpow (cellMass μ U).toReal q

/-- The multifractal partition function `Z(q,n) = Σ_U μ(U)^q`. -/
def partitionFunction (μ : Measure X) (P : ScalePartition X) (q : ℝ) (n : ℕ) : ℝ :=
  ∑ U ∈ P.cells n, massPower μ q U

/-- The scale-local information sum `Σ_U p_U log p_U`. -/
def informationSumAtScale (μ : Measure X) (P : ScalePartition X) (n : ℕ) : ℝ :=
  ∑ U ∈ P.cells n,
    (cellMass μ U).toReal * Real.log (cellMass μ U).toReal

/-- Positivity fence for logarithmic partition-function scaling. -/
def PartitionFunctionPositive
    (μ : Measure X) (P : ScalePartition X) (q : ℝ) : Prop :=
  ∀ n, 0 < partitionFunction μ P q n

end

end ProcInt.Playground.Multifractal
