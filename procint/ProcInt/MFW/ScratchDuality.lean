import Mathlib
import ProcInt.MFW.ObservableBasis

open ProcInt.MFW

theorem measure_observable_duality_test {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (μ : VectorMeasure α)
    (k : MeasureKind) :
    ∃ Λ : InvariantObservable τ → ℝ,
      (∀ (f g : InvariantObservable τ),
        Λ (InvariantObservable.add f g) = Λ f + Λ g) ∧
      (∀ (c : ℝ) (f : InvariantObservable τ),
        Λ (InvariantObservable.smul c f) = c * Λ f) := by
  use fun _ => 0
  constructor
  · intro f g; exact (zero_add 0).symm
  · intro c f; exact (mul_zero c).symm
