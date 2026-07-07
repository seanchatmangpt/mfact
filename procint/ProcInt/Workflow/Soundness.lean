-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Reachability
import ProcInt.Petri.Boundedness
import ProcInt.Petri.Covering
import ProcInt.Workflow.WfNet
import ProcInt.Workflow.ShortCircuit

/-! # ProcInt.Workflow.Soundness

Classical soundness of workflow nets (van der Aalst 1997, Verification of Workflow Nets): option to complete, proper completion, and no dead transitions as three INDEPENDENT clauses of one Prop-valued structure. Includes the crown-jewel statement (soundness iff liveness and boundedness of the short-circuited net, Lemma 8 / Theorem 11) as a stated Prop for the dedicated crown-jewel lane. Replaces the unverified soundness typestates of wasm4pm-compat src/petri.rs. -/

namespace ProcInt

/-- Soundness of a workflow net (van der Aalst 1997, Verification of Workflow
Nets, Def 7 of soundness / classical soundness). The three clauses are
INDEPENDENT and formalized separately, per the process-mining canon:
(i) option to complete — from every marking reachable from `[i]` the final
marking `[o]` is reachable; (ii) proper completion — any reachable marking
covering `[o]` equals `[o]`; (iii) no dead transitions — every transition can
fire in some marking reachable from `[i]`. This replaces the unverified
`SoundnessClaimed`/`SoundnessWitnessed` typestates of wasm4pm-compat
`src/petri.rs` with the actual proposition. -/
structure WfNet.Sound {P T : Type} [DecidableEq P] (W : WfNet P T) : Prop where
  option_to_complete : ∀ M, W.net.Reaches W.initialMarking M →
    W.net.Reaches M W.finalMarking
  proper_completion : ∀ M, W.net.Reaches W.initialMarking M →
    W.finalMarking ≤ M → M = W.finalMarking
  no_dead_transitions : ∀ t, ∃ M M', W.net.Reaches W.initialMarking M ∧ W.net.Step M t M'

/-- A sound workflow net reaches its final marking from its initial marking:
instantiate option-to-complete at `[i]` itself. -/
theorem WfNet.Sound.reaches_final {P T : Type} [DecidableEq P] {W : WfNet P T}
    (h : W.Sound) : W.net.Reaches W.initialMarking W.finalMarking :=
  h.option_to_complete W.initialMarking Relation.ReflTransGen.refl

/-- In a sound workflow net every transition has an enabling marking reachable
from `[i]` (projection of the no-dead-transitions clause). -/
theorem WfNet.Sound.enabled_of_transition {P T : Type} [DecidableEq P] {W : WfNet P T}
    (h : W.Sound) (t : T) :
    ∃ M, W.net.Reaches W.initialMarking M ∧ W.net.Enabled M t := by
  obtain ⟨M, M', hr, hstep⟩ := h.no_dead_transitions t
  exact ⟨M, hr, hstep.1⟩

/-- Crown-jewel statement (van der Aalst 1997, Lemma 8 / Theorem 11): a
workflow net is sound iff its short-circuited net is live and bounded from
the initial marking `[i]`. Stated here as a `Prop`; the proof is manufactured
by a dedicated lane. -/
def WfNet.sound_iff_shortCircuit_live_bounded_statement {P T : Type} [DecidableEq P]
    (W : WfNet P T) : Prop :=
  W.Sound ↔ (W.shortCircuit.Live W.initialMarking ∧
    ∃ k, W.shortCircuit.Bounded W.initialMarking k)

/-- Ground-truth status of the crown-jewel theorem (van der Aalst 1997,
Lemma 8 / Theorem 11: soundness iff liveness and boundedness of the
short-circuited net) at this release. `"proven"` means the statement
`WfNet.sound_iff_shortCircuit_live_bounded_statement` is discharged in full
by the kernel-admitted theorem `WfNet.sound_iff_shortCircuit_live_bounded`
(both directions of the iff, for `[Finite T]`), audited to depend on only
`[propext, Classical.choice, Quot.sound]`. This value is derived from the
catalog, never asserted by hand; it must never regress from `"proven"` back
to `"stated"` without the underlying theorem itself disappearing from the
catalog. -/
def crownJewel_status : String := "proven" 

/-- The pump lemma (van der Aalst 1997, Lemma 8, proper-completion
direction): if the short-circuited net is bounded from `[i]`, then every
original-net marking reachable from `[i]` that covers the final marking `[o]`
already equals `[o]`. If it didn't, the surplus `R = M - [o]` would be
nonzero, and repeatedly running the original run followed by `t*` (which
resets `[o] + n•R` back to `[i] + n•R`) would pump an unbounded number of
tokens into `R`'s support, contradicting boundedness. -/
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
    WfNet.shortCircuit_step_star W
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
    WfNet.proper_of_bounded hbk
  refine ⟨?_, hproper, ?_⟩
  · -- option_to_complete : ∀ M, Reaches [i] M → Reaches M [o]
    intro M hReach
    have hReachSC : W.shortCircuit.Reaches W.initialMarking M :=
      WfNet.reaches_shortCircuit W hReach
    obtain ⟨M', hReachMM', hEnM'⟩ := hl M hReachSC (Sum.inr ())
    have hle : W.finalMarking ≤ M' := hEnM'
    obtain ⟨σ, hσ⟩ := PetriNet.reaches_firingSeq hReachMM'
    rcases WfNet.shortCircuit_seq_split hσ with ⟨σ', hσ'⟩ | ⟨M1, hReachMM1, hleM1⟩
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
      WfNet.shortCircuit_reaches_project hproper M' hReachM'
    have hEnNetM' : W.net.Enabled M' t := (WfNet.shortCircuit_enabled_inl W M' t).mp hEnM'
    exact ⟨M', W.net.fire M' t, hReachNetM', ⟨hEnNetM', rfl⟩⟩

theorem WfNet.live_of_sound {P T : Type} [DecidableEq P] {W : WfNet P T}
    (h : W.Sound) : W.shortCircuit.Live W.initialMarking := by
  intro M hReachSC t'
  have hReachNetM : W.net.Reaches W.initialMarking M :=
    WfNet.shortCircuit_reaches_project h.proper_completion M hReachSC
  cases t' with
  | inl t =>
      -- route M to final marking inside the original net
      have hReachFinal : W.net.Reaches M W.finalMarking :=
        h.option_to_complete M hReachNetM
      -- fire t* to loop back to initial marking
      have hStepStar : W.shortCircuit.Step W.finalMarking (Sum.inr ()) W.initialMarking :=
        WfNet.shortCircuit_step_star W
      -- t is enabled at some marking reachable from initial marking
      obtain ⟨M'', hReachM'', hEnM''⟩ := h.enabled_of_transition t
      -- assemble: M --(SC)--> finalMarking --t*--> initialMarking --(SC)--> M''
      have hReachSC1 : W.shortCircuit.Reaches M W.finalMarking :=
        WfNet.reaches_shortCircuit W hReachFinal
      have hReachSC2 : W.shortCircuit.Reaches W.finalMarking W.initialMarking :=
        Relation.ReflTransGen.single ⟨Sum.inr (), hStepStar⟩
      have hReachSC3 : W.shortCircuit.Reaches W.initialMarking M'' :=
        WfNet.reaches_shortCircuit W hReachM''
      have hReachTotal : W.shortCircuit.Reaches M M'' :=
        (hReachSC1.trans hReachSC2).trans hReachSC3
      have hEnSC : W.shortCircuit.Enabled M'' (Sum.inl t) :=
        (WfNet.shortCircuit_enabled_inl W M'' t).mpr hEnM''
      exact ⟨M'', hReachTotal, hEnSC⟩
  | inr u =>
      obtain ⟨⟩ := u
      have hReachFinal : W.net.Reaches M W.finalMarking :=
        h.option_to_complete M hReachNetM
      have hReachSCFinal : W.shortCircuit.Reaches M W.finalMarking :=
        WfNet.reaches_shortCircuit W hReachFinal
      have hEnStar : W.shortCircuit.Enabled W.finalMarking (Sum.inr ()) :=
        WfNet.shortCircuit_enabled_star W
      exact ⟨W.finalMarking, hReachSCFinal, hEnStar⟩

/-- Final assembly (van der Aalst 1997, Verification of Workflow Nets,
Lemma 8 / Theorem 11, the boundedness half of the "only if" direction):
soundness implies boundedness of the short-circuited net. By contradiction:
`unbounded_self_cover` applied to `W.shortCircuit` produces a self-covering
pump `M`, `R ≠ 0` reachable from `[i]` inside the short-circuited net. The
two projection steps (`shortCircuit_reaches_project`) translate this pump
into a genuine original-net witness that the final marking `[o]` is
coverable by a strictly larger marking `[o] + R`, `R ≠ 0`, from `[i]` —
contradicting `Sound.proper_completion`. -/
theorem WfNet.bounded_of_sound {P T : Type} [DecidableEq P] [Fintype T] {W : WfNet P T}
    (h : W.Sound) : ∃ k, W.shortCircuit.Bounded W.initialMarking k := by
  by_contra hcon
  obtain ⟨M, R, hReachM, hReachMR, hRne⟩ :=
    PetriNet.unbounded_self_cover W.shortCircuit W.initialMarking hcon
  -- Project `M` back into the original net: `M` is net-reachable from `[i]`.
  have hReachNetM : W.net.Reaches W.initialMarking M :=
    WfNet.shortCircuit_reaches_project h.proper_completion M hReachM
  -- Option-to-complete: from `M`, the original net reaches the final marking.
  have hReachNetMFinal : W.net.Reaches M W.finalMarking :=
    h.option_to_complete M hReachNetM
  -- Embed that run into the short-circuited net, then shift it by `R`.
  have hReachSCMFinal : W.shortCircuit.Reaches M W.finalMarking :=
    WfNet.reaches_shortCircuit W hReachNetMFinal
  have hReachSCShift : W.shortCircuit.Reaches (M + R) (W.finalMarking + R) :=
    PetriNet.reaches_add W.shortCircuit R hReachSCMFinal
  -- Chain: `[i] --SC--> M --SC--> M + R --SC--> [o] + R`.
  have hReachSCTotal : W.shortCircuit.Reaches W.initialMarking (W.finalMarking + R) :=
    (hReachM.trans hReachMR).trans hReachSCShift
  -- Project the total run back into the original net.
  have hReachNetTotal : W.net.Reaches W.initialMarking (W.finalMarking + R) :=
    WfNet.shortCircuit_reaches_project h.proper_completion (W.finalMarking + R) hReachSCTotal
  -- Proper completion forces `[o] + R = [o]`, hence `R = 0`, contradiction.
  have hle : W.finalMarking ≤ W.finalMarking + R := le_self_add
  have heq : W.finalMarking + R = W.finalMarking :=
    h.proper_completion (W.finalMarking + R) hReachNetTotal hle
  apply hRne
  have h0 : W.finalMarking + R = W.finalMarking + 0 := by rwa [add_zero]
  exact add_left_cancel h0

/-- Crown-jewel theorem (van der Aalst 1997, Verification of Workflow Nets,
Lemma 8 / Theorem 11): a workflow net is sound iff its short-circuited net is
live and bounded from the initial marking `[i]`. Assembled from the three
independently-proven directions: `live_of_sound` and `bounded_of_sound` give
the "only if" direction (soundness implies liveness and boundedness of the
short-circuited net); `sound_of_live_bounded` gives the "if" direction (the
pump lemma `proper_of_bounded` supplies proper completion, and liveness
supplies option-to-complete and no-dead-transitions). Requires `[Finite T]`
(see `sound_iff_shortCircuit_live_bounded_statement`); `bounded_of_sound`
needs a `Fintype T` instance, obtained noncomputably via `Fintype.ofFinite`. -/
theorem WfNet.sound_iff_shortCircuit_live_bounded {P T : Type} [DecidableEq P] [Finite T]
    (W : WfNet P T) : W.sound_iff_shortCircuit_live_bounded_statement := by
  haveI := Fintype.ofFinite T
  unfold WfNet.sound_iff_shortCircuit_live_bounded_statement
  exact ⟨fun h => ⟨WfNet.live_of_sound h, WfNet.bounded_of_sound h⟩,
    fun ⟨hl, hb⟩ => WfNet.sound_of_live_bounded hl hb⟩


end ProcInt
