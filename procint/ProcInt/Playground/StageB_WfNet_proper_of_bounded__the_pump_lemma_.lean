import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

/-- Local copy of the Stage B lemma `WfNet.shortCircuit_fire_star`
(not yet ported to the rendered `ShortCircuit.lean`): firing `t*` at the
final marking lands at the initial marking. -/
theorem WfNet.shortCircuit_fire_star' {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.fire W.finalMarking (Sum.inr ()) = W.initialMarking := by
  have h := W.shortCircuit.fire_pre_self (Sum.inr () : T ⊕ Unit)
  rwa [W.shortCircuit_pre_inr, W.shortCircuit_post_inr] at h

/-- Local copy of the Stage B lemma `WfNet.shortCircuit_step_star`
(not yet ported to the rendered `ShortCircuit.lean`): `t*` steps the
short-circuited net from `[o]` to `[i]`. -/
theorem WfNet.shortCircuit_step_star' {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
  ⟨W.shortCircuit_enabled_star, (W.shortCircuit_fire_star').symm⟩

/-- The pump lemma (van der Aalst 1997, Lemma 8 direction: liveness/boundedness
of the short-circuited net forces proper completion): if the short-circuited
net is `k`-bounded from `[i]`, then every marking reachable from `[i]` in the
original net that covers `[o]` is exactly `[o]`. Proof by contradiction: a
strict surplus `R = M - [o] ≠ 0` could be pumped around the short-circuit
cycle arbitrarily many times (embed the original run, then fire `t*`, repeat),
producing markings with unboundedly many tokens at any place in the support
of `R`, contradicting `k`-boundedness. -/
theorem WfNet.proper_of_bounded {P T : Type} [DecidableEq P] {W : WfNet P T} {k : ℕ}
    (hb : W.shortCircuit.Bounded W.initialMarking k) :
    ∀ M, W.net.Reaches W.initialMarking M → W.finalMarking ≤ M → M = W.finalMarking := by
  intro M hReach0 hle
  by_contra hne
  -- Decompose the surplus.
  set R : Marking P := M - W.finalMarking with hRdef
  have hMeq : W.finalMarking + R = M := by
    rw [hRdef]; exact add_tsub_cancel_of_le hle
  have hRne : R ≠ 0 := by
    intro hR0
    apply hne
    rw [← hMeq, hR0, add_zero]
  -- The embedding of the original run into the short-circuited net.
  have hReachSC : W.shortCircuit.Reaches W.initialMarking M :=
    WfNet.reaches_shortCircuit W hReach0
  have hStepStar : W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
    WfNet.shortCircuit_step_star' W
  -- Pumping: reachability of `[i] + n • R` for every `n`.
  have hpump : ∀ n : ℕ, W.shortCircuit.Reaches W.initialMarking (W.initialMarking + n • R) := by
    intro n
    induction n with
    | zero =>
        show W.shortCircuit.Reaches W.initialMarking (W.initialMarking + (0 : ℕ) • R)
        simp only [zero_smul, add_zero]
        exact Relation.ReflTransGen.refl
    | succ n ih =>
        have hReachSC' :
            W.shortCircuit.Reaches (W.initialMarking + n • R) (M + n • R) :=
          PetriNet.reaches_add W.shortCircuit (n • R) hReachSC
        have hStep' :
            W.shortCircuit.Step (W.finalMarking + (n + 1) • R) (Sum.inr ())
              (W.initialMarking + (n + 1) • R) :=
          PetriNet.step_add W.shortCircuit ((n + 1) • R) hStepStar
        have hEq1 : M + n • R = W.finalMarking + (n + 1) • R := by
          rw [← hMeq, succ_nsmul]
          abel
        have hReachSC'' :
            W.shortCircuit.Reaches (W.initialMarking + n • R)
              (W.finalMarking + (n + 1) • R) := by
          rw [← hEq1]; exact hReachSC'
        have hstep2 :
            W.shortCircuit.Reaches (W.finalMarking + (n + 1) • R)
              (W.initialMarking + (n + 1) • R) :=
          Relation.ReflTransGen.single ⟨Sum.inr (), hStep'⟩
        exact ih.trans (hReachSC''.trans hstep2)
  -- A place in the support of the (nonzero) surplus grows without bound.
  obtain ⟨p, hp⟩ := Finsupp.ne_iff.mp hRne
  simp only [Finsupp.coe_zero, Pi.zero_apply] at hp
  have hp1 : 1 ≤ R p := Nat.one_le_iff_ne_zero.mpr hp
  have hbig := hb (W.initialMarking + (k + 1) • R) (hpump (k + 1)) p
  have hcontra : k + 1 ≤ (W.initialMarking + (k + 1) • R) p := by
    rw [Finsupp.add_apply, Finsupp.smul_apply]
    calc k + 1 = (k + 1) * 1 := by ring
      _ ≤ (k + 1) * R p := by exact Nat.mul_le_mul_left _ hp1
      _ = (k + 1) • R p := by rw [smul_eq_mul]
      _ ≤ W.initialMarking p + (k + 1) • R p := Nat.le_add_left _ _
  omega
