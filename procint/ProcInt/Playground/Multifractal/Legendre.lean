-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib

/-!
# ProcInt.Playground.Multifractal.Legendre

The concave Legendre transform used in the classical multifractal formalism:
`α ↦ inf_q (q α - τ(q))`.

Because `ℝ` is only conditionally complete, bounded-below candidates are an
explicit admission condition.
-/

namespace ProcInt.Playground.Multifractal

noncomputable section

/-- Candidate values `q α - τ(q)` for the multifractal Legendre transform. -/
def legendreCandidates (τ : ℝ → ℝ) (α : ℝ) : Set ℝ :=
  Set.range (fun q => q * α - τ q)

/-- Admission condition for the real-valued infimum. -/
def LegendreAdmissible (τ : ℝ → ℝ) (α : ℝ) : Prop :=
  BddBelow (legendreCandidates τ α)

/-- Concave Legendre transform `inf_q (q α - τ(q))`. -/
def concaveLegendre (τ : ℝ → ℝ) (α : ℝ) : ℝ :=
  sInf (legendreCandidates τ α)

/-- Every candidate bounds the admitted concave Legendre transform from above. -/
theorem concaveLegendre_le
    {τ : ℝ → ℝ} {α : ℝ} (h : LegendreAdmissible τ α) (q : ℝ) :
    concaveLegendre τ α ≤ q * α - τ q := by
  exact csInf_le h ⟨q, rfl⟩

end

end ProcInt.Playground.Multifractal
