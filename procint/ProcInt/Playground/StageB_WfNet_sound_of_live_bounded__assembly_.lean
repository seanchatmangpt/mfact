import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit
import ProcInt.Workflow.Soundness

namespace ProcInt

-- Locally-named primed copies of the prior Stage B facts (not yet ported to
-- TTL/rendered `ShortCircuit.lean`), so this file can be verified standalone
-- today. Proof text is byte-identical to the previous chain steps' output.

theorem WfNet.shortCircuit_fire_star' {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.fire W.finalMarking (Sum.inr ()) = W.initialMarking := by
  have h := W.shortCircuit.fire_pre_self (Sum.inr () : T ⊕ Unit)
  rwa [W.shortCircuit_pre_inr, W.shortCircuit_post_inr] at h

theorem WfNet.shortCircuit_step_star' {P T : Type} [DecidableEq P] (W : WfNet P T) :
    W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
  ⟨W.shortCircuit_enabled_star, (W.shortCircuit_fire_star').symm⟩

theorem WfNet.proper_of_bounded' {P T : Type} [DecidableEq P] {W : WfNet P T} {k : ℕ}
    (hb : W.shortCircuit.Bounded W.initialMarking k) :
    ∀ M, W.net.Reaches W.initialMarking M → W.finalMarking ≤ M → M = W.finalMarking := by
  intro M hReach0 hle
  by_contra hne
  set R : Marking P := M - W.finalMarking with hRdef
  have hMeq : W.finalMarking + R = M := by
    rw [hRdef]; exact add_tsub_cancel_of_le hle
  have hRne : R ≠ 0 := by
    intro hR0
    apply hne
    rw [← hMeq, hR0, add_zero]
  have hReachSC : W.shortCircuit.Reaches W.initialMarking M :=
    WfNet.reaches_shortCircuit W hReach0
  have hStepStar : W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
    WfNet.shortCircuit_step_star' W
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

theorem WfNet.shortCircuit_reaches_project' {P T : Type} [DecidableEq P] {W : WfNet P T}
    (H : ∀ M, W.net.Reaches W.initialMarking M → W.finalMarking ≤ M → M = W.finalMarking) :
    ∀ M, W.shortCircuit.Reaches W.initialMarking M → W.net.Reaches W.initialMarking M := by
  intro M h
  induction h with
  | refl => exact Relation.ReflTransGen.refl
  | @tail Mprev M hprev hstep ih =>
      obtain ⟨t, ht⟩ := hstep
      cases t with
      | inl t =>
          have ht' : W.net.Step Mprev t M := (WfNet.shortCircuit_step_inl W Mprev M t).mp ht
          exact ih.tail ⟨t, ht'⟩
      | inr u =>
          obtain ⟨u⟩ := u
          have hEnabled : W.shortCircuit.Enabled Mprev (Sum.inr ()) := ht.1
          have hle : W.finalMarking ≤ Mprev := hEnabled
          have hMprevEq : Mprev = W.finalMarking := H Mprev ih hle
          have hfire : M = W.shortCircuit.fire Mprev (Sum.inr ()) := ht.2
          have hMeq : M = W.initialMarking := by
            rw [hfire, hMprevEq, W.shortCircuit_fire_star']
          rw [hMeq]
          exact Relation.ReflTransGen.refl

theorem WfNet.shortCircuit_seq_split' {P T : Type} [DecidableEq P] {W : WfNet P T}
    {M M' : Marking P} {σ : List (T ⊕ Unit)}
    (h : W.shortCircuit.FiringSeq M σ M') :
    (∃ σ', W.net.FiringSeq M σ' M') ∨
      (∃ M1, W.net.Reaches M M1 ∧ W.finalMarking ≤ M1) := by
  induction h with
  | nil M => exact Or.inl ⟨[], .nil M⟩
  | @cons Ma Mb Mc t σ' hstep hrest ih =>
      cases t with
      | inl t0 =>
          have hstep0 : W.net.Step Ma t0 Mb := (WfNet.shortCircuit_step_inl W Ma Mb t0).mp hstep
          rcases ih with ⟨σ0, hσ0⟩ | ⟨M1, hReach, hle⟩
          · exact Or.inl ⟨t0 :: σ0, .cons hstep0 hσ0⟩
          · exact Or.inr ⟨M1, Relation.ReflTransGen.head ⟨t0, hstep0⟩ hReach, hle⟩
      | inr u =>
          obtain ⟨⟩ := u
          have hEnabled : W.shortCircuit.Enabled Ma (Sum.inr ()) := hstep.1
          have hle : W.finalMarking ≤ Ma := hEnabled
          exact Or.inr ⟨Ma, Relation.ReflTransGen.refl, hle⟩

/-- Stage B assembly (van der Aalst 1997, Lemma 8 / Theorem 11, the "if"
direction): liveness and boundedness of the short-circuited net imply
soundness of the workflow net. Proper completion is the pump lemma
(`proper_of_bounded`); option-to-complete and no-dead-transitions both use
liveness of the short-circuited net together with `shortCircuit_seq_split`
(to peel off the run up to the *first* occurrence of the fresh transition
`t*`, staying entirely inside the original net) or, when the liveness
witness is already anchored at `[i]`, the simpler
`shortCircuit_reaches_project`. -/
theorem WfNet.sound_of_live_bounded {P T : Type} [DecidableEq P] {W : WfNet P T}
    (hl : W.shortCircuit.Live W.initialMarking)
    (hb : ∃ k, W.shortCircuit.Bounded W.initialMarking k) :
    W.Sound := by
  obtain ⟨k, hbk⟩ := hb
  have hproper : ∀ M, W.net.Reaches W.initialMarking M → W.finalMarking ≤ M → M = W.finalMarking :=
    WfNet.proper_of_bounded' hbk
  refine ⟨?_, hproper, ?_⟩
  · -- option_to_complete : ∀ M, Reaches [i] M → Reaches M [o]
    intro M hReach
    have hReachSC : W.shortCircuit.Reaches W.initialMarking M :=
      WfNet.reaches_shortCircuit W hReach
    obtain ⟨M', hReachMM', hEnM'⟩ := hl M hReachSC (Sum.inr ())
    have hle : W.finalMarking ≤ M' := hEnM'
    obtain ⟨σ, hσ⟩ := PetriNet.reaches_firingSeq hReachMM'
    rcases WfNet.shortCircuit_seq_split' hσ with ⟨σ', hσ'⟩ | ⟨M1, hReachMM1, hleM1⟩
    · -- the whole M --σ'--> M' run avoids t*: it lives entirely in the
      -- original net, so M' itself is net-reachable from [i] and from M.
      have hReachNetMM' : W.net.Reaches M M' := PetriNet.firingSeq_reaches hσ'
      have hReachInitM' : W.net.Reaches W.initialMarking M' := hReach.trans hReachNetMM'
      have hM'eq : M' = W.finalMarking := hproper M' hReachInitM' hle
      rwa [hM'eq] at hReachNetMM'
    · -- t* fires somewhere in the run; M1 is the marking right before its
      -- *first* occurrence, reached from M entirely inside the original net.
      have hReachInitM1 : W.net.Reaches W.initialMarking M1 := hReach.trans hReachMM1
      have hM1eq : M1 = W.finalMarking := hproper M1 hReachInitM1 hleM1
      rwa [hM1eq] at hReachMM1
  · -- no_dead_transitions : ∀ t, ∃ M M', Reaches [i] M ∧ Step M t M'
    intro t
    have hReach0 : W.shortCircuit.Reaches W.initialMarking W.initialMarking :=
      Relation.ReflTransGen.refl
    obtain ⟨M', hReachM', hEnM'⟩ := hl W.initialMarking hReach0 (Sum.inl t)
    have hReachNetM' : W.net.Reaches W.initialMarking M' :=
      WfNet.shortCircuit_reaches_project' hproper M' hReachM'
    have hEnNetM' : W.net.Enabled M' t := (WfNet.shortCircuit_enabled_inl W M' t).mp hEnM'
    exact ⟨M', W.net.fire M' t, hReachNetM', ⟨hEnNetM', rfl⟩⟩

end ProcInt
