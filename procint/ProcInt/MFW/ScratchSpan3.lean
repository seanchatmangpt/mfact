import Mathlib
import ProcInt.MFW.ObservableBasis

open ProcInt.MFW

theorem observableSpan_subset_invariant_test {Th : PlanningTheory} {α : Type}
    (τ : WorkflowTransformation Th α)
    (basis : List (InvariantObservable τ)) :
    observableSpan τ basis ⊆ invariantObservableSpace τ := by
  intro f hf
  rcases hf with ⟨coeffs, hlen, hf_eq⟩
  intro b₁ b₂ hτ
  rw [hf_eq b₁, hf_eq b₂]
  clear hf_eq f
  induction coeffs generalizing basis with
  | nil =>
    cases basis with
    | nil => rfl
    | cons hd tl => contradiction
  | cons c cs ih =>
    cases basis with
    | nil => contradiction
    | cons φ bs =>
      have hlen' : cs.length = bs.length := by
        revert hlen
        intro h
        injection h with h'
        exact h'
      have h_ih := ih bs hlen'
      dsimp [List.zipWith]
      rw [φ.fiber_const b₁ b₂ hτ]
      exact congrArg (fun x => c * φ.observe b₂ + x) h_ih
