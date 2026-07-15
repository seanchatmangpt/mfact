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
      -- For sum we can use congr_arg
      have h_eq_lists : List.zipWith (fun c φ => c * φ.observe b₁) cs bs = List.zipWith (fun c φ => c * φ.observe b₂) cs bs := by
        -- wait, ih doesn't give us list equality, it gives us sum equality!
        -- Wait! ih gives: (zipWith ... b₁).sum = (zipWith ... b₂).sum
        -- and we want to show:
        -- (c * φ.observe b₁ :: zipWith ... b₁).sum = (c * φ.observe b₂ :: zipWith ... b₂).sum
        -- which is c * φ.observe b₁ + (zipWith ... b₁).sum = c * φ.observe b₂ + (zipWith ... b₂).sum
        -- We can just rewrite with sum_cons! But sum on List ℝ might not have sum_cons if it's not defined via simp.
        -- Let's see if simp [List.sum_cons] works.
        skip
