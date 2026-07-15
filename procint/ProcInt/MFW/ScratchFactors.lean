import Mathlib
import ProcInt.MFW.ObservableBasis

open ProcInt.MFW

theorem invariant_observable_factors_test {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (f : BehavioralPhaseSpace Th → ℝ)
    (hf : f ∈ invariantObservableSpace τ)
    (hsurj : Function.Surjective τ.map) :
    ∃ g : WorkflowSpace α → ℝ, ∀ b, f b = g (τ.map b) := by
  use fun w => f (Classical.choose (hsurj w))
  intro b
  apply hf
  exact (Classical.choose_spec (hsurj (τ.map b))).symm
