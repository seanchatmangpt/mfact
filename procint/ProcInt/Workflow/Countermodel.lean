import Mathlib
import ProcInt.Workflow.Soundness

set_option linter.unusedSimpArgs false

namespace ProcInt

inductive CrownCounterPlace : Type | i | q | o | c : ℕ → CrownCounterPlace deriving DecidableEq, Repr
def CrownCounterTransition := ℕ ⊕ ℕ

noncomputable def crownCounterNet : PetriNet CrownCounterPlace CrownCounterTransition where
  pre := fun t => match t with
    | Sum.inl _ => Finsupp.single CrownCounterPlace.i 1
    | Sum.inr n => Finsupp.update (Finsupp.single CrownCounterPlace.q n) (CrownCounterPlace.c n) 1
  post := fun t => match t with
    | Sum.inl n => Finsupp.update (Finsupp.single CrownCounterPlace.q n) (CrownCounterPlace.c n) 1
    | Sum.inr _ => Finsupp.single CrownCounterPlace.o 1

macro "solve_flow_edge" : tactic =>
  `(tactic| (
    unfold PetriNet.FlowEdge crownCounterNet
    simp [Finsupp.single_eq_same, Finsupp.mem_support_iff, Finsupp.coe_update, Finsupp.single_apply, Finsupp.update_apply]
  ))

noncomputable def crownCounterWfNet : WfNet CrownCounterPlace CrownCounterTransition where
  net := crownCounterNet
  source := CrownCounterPlace.i
  sink := CrownCounterPlace.o
  source_ne_sink := by decide
  source_no_input := by intro t; cases t <;> simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
  sink_no_output := by intro t; cases t <;> simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
  onPath := by
    intro x
    constructor
    · cases x with
      | inl p =>
        cases p with
        | i => exact Relation.ReflTransGen.refl
        | q =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
          · apply Relation.ReflTransGen.single
            solve_flow_edge
          · solve_flow_edge
        | o =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
          · apply Relation.ReflTransGen.tail (b := Sum.inl CrownCounterPlace.q)
            · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
              · apply Relation.ReflTransGen.single
                solve_flow_edge
              · solve_flow_edge
            · solve_flow_edge
          · solve_flow_edge
        | c n =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl n))
          · apply Relation.ReflTransGen.single
            solve_flow_edge
          · solve_flow_edge
      | inr t =>
        cases t with
        | inl n =>
          apply Relation.ReflTransGen.single
          solve_flow_edge
        | inr n =>
          apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c n))
          · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl n))
            · apply Relation.ReflTransGen.single
              solve_flow_edge
            · solve_flow_edge
          · solve_flow_edge
    · cases x with
      | inl p =>
        cases p with
        | i =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
          · apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c 1))
            · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
              · apply Relation.ReflTransGen.single
                solve_flow_edge
              · solve_flow_edge
            · solve_flow_edge
          · solve_flow_edge
        | q =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
          · apply Relation.ReflTransGen.single
            solve_flow_edge
          · solve_flow_edge
        | o => exact Relation.ReflTransGen.refl
        | c n =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr n))
          · apply Relation.ReflTransGen.single
            solve_flow_edge
          · solve_flow_edge
      | inr t =>
        cases t with
        | inl n =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr n))
          · apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c n))
            · apply Relation.ReflTransGen.single
              solve_flow_edge
            · solve_flow_edge
          · solve_flow_edge
        | inr n =>
          apply Relation.ReflTransGen.single
          solve_flow_edge

noncomputable def intermediateMarking (n : ℕ) : Marking CrownCounterPlace :=
  Finsupp.single CrownCounterPlace.q n + Finsupp.single (CrownCounterPlace.c n) 1

macro "solve_enabled" : tactic =>
  `(tactic| (
    intro p
    dsimp [intermediateMarking, crownCounterNet, PetriNet.Enabled, WfNet.initialMarking, WfNet.finalMarking, crownCounterWfNet]
    try simp [Finsupp.single_apply, Finsupp.update_apply, Finsupp.add_apply, Finsupp.tsub_apply]
    try (cases p <;> simp <;> try split_ifs <;> omega)
  ))

macro "solve_fire" : tactic =>
  `(tactic| (
    ext p
    dsimp [intermediateMarking, crownCounterNet, PetriNet.fire, WfNet.initialMarking, WfNet.finalMarking, crownCounterWfNet]
    try simp [Finsupp.single_apply, Finsupp.update_apply, Finsupp.add_apply, Finsupp.tsub_apply]
    try (cases p <;> simp <;> try split_ifs <;> omega)
  ))

lemma reachable_is_one_of (M : Marking CrownCounterPlace) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M →
    M = crownCounterWfNet.initialMarking ∨
    (∃ n, M = intermediateMarking n) ∨
    M = crownCounterWfNet.finalMarking := by
  intro h
  induction h with
  | refl => exact Or.inl rfl
  | tail M1 M2 _ hStep ih =>
    rcases ih with rfl | ⟨n, rfl⟩ | rfl
    · rcases hStep with ⟨t, hEn, rfl⟩
      cases t with
      | inl n =>
        right; left; use n
        solve_fire
      | inr n =>
        exfalso
        have hEn_q := hEn CrownCounterPlace.q
        revert hEn_q
        dsimp [crownCounterWfNet, WfNet.initialMarking, crownCounterNet, PetriNet.Enabled, PetriNet.pre]
        simp [Finsupp.single_apply]
        try omega
    · rcases hStep with ⟨t, hEn, rfl⟩
      cases t with
      | inl m =>
        exfalso
        have hEn_i := hEn CrownCounterPlace.i
        revert hEn_i
        dsimp [crownCounterWfNet, intermediateMarking, crownCounterNet, PetriNet.Enabled, PetriNet.pre]
        simp [Finsupp.single_apply, Finsupp.add_apply, Finsupp.update_apply]
        try omega
      | inr m =>
        have hEn_c := hEn (CrownCounterPlace.c m)
        revert hEn_c
        dsimp [crownCounterWfNet, intermediateMarking, crownCounterNet, PetriNet.Enabled, PetriNet.pre]
        simp [Finsupp.single_apply, Finsupp.add_apply, Finsupp.update_apply]
        intro hEn_c
        split_ifs at hEn_c
        · rename_i h_eq
          subst h_eq
          right; right
          solve_fire
        · omega
    · rcases hStep with ⟨t, hEn, rfl⟩
      cases t with
      | inl m =>
        exfalso
        have hEn_i := hEn CrownCounterPlace.i
        revert hEn_i
        dsimp [crownCounterWfNet, WfNet.finalMarking, crownCounterNet, PetriNet.Enabled, PetriNet.pre]
        simp [Finsupp.single_apply]
        try omega
      | inr m =>
        exfalso
        have hEn_q := hEn CrownCounterPlace.q
        revert hEn_q
        dsimp [crownCounterWfNet, WfNet.finalMarking, crownCounterNet, PetriNet.Enabled, PetriNet.pre]
        simp [Finsupp.single_apply]
        try omega

lemma crownCounter_reaches_mid (n : ℕ) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking (intermediateMarking n) := by
  apply Relation.ReflTransGen.single
  use (Sum.inl n)
  constructor
  · solve_enabled
  · solve_fire

lemma crownCounter_reaches_final (M : Marking CrownCounterPlace) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M →
    crownCounterWfNet.net.Reaches M crownCounterWfNet.finalMarking := by
  intro h
  rcases reachable_is_one_of M h with rfl | ⟨n, rfl⟩ | rfl
  · apply Relation.ReflTransGen.tail (b := intermediateMarking 0)
    · apply Relation.ReflTransGen.single
      use (Sum.inl 0)
      constructor
      · solve_enabled
      · solve_fire
    · use (Sum.inr 0)
      constructor
      · solve_enabled
      · solve_fire
  · apply Relation.ReflTransGen.single
    use (Sum.inr n)
    constructor
    · solve_enabled
    · solve_fire
  · exact Relation.ReflTransGen.refl

theorem crownCounter_sound : WfNet.Sound crownCounterWfNet := by
  constructor
  · exact crownCounter_reaches_final
  · intro M hReach hLe
    rcases reachable_is_one_of M hReach with rfl | ⟨n, rfl⟩ | rfl
    · exfalso
      have hLe_o := hLe CrownCounterPlace.o
      revert hLe_o
      dsimp [crownCounterWfNet, WfNet.finalMarking, WfNet.initialMarking, PetriNet.pre]
      simp [Finsupp.single_apply]
      try omega
    · exfalso
      have hLe_o := hLe CrownCounterPlace.o
      revert hLe_o
      dsimp [crownCounterWfNet, WfNet.finalMarking, intermediateMarking, PetriNet.pre]
      simp [Finsupp.single_apply, Finsupp.add_apply]
      try omega
    · rfl
  · intro t
    cases t with
    | inl n =>
      use crownCounterWfNet.initialMarking, intermediateMarking n
      constructor
      · exact Relation.ReflTransGen.refl
      · constructor
        · solve_enabled
        · solve_fire
    | inr n =>
      use intermediateMarking n, crownCounterWfNet.finalMarking
      constructor
      · exact crownCounter_reaches_mid n
      · constructor
        · solve_enabled
        · solve_fire

theorem crownCounter_not_bounded :
    ¬ ∃ k, crownCounterWfNet.shortCircuit.Bounded crownCounterWfNet.initialMarking k := by
  intro ⟨k, hk⟩
  have hReach : crownCounterWfNet.shortCircuit.Reaches crownCounterWfNet.initialMarking (intermediateMarking (k + 1)) := by
    apply WfNet.reaches_shortCircuit
    apply Relation.ReflTransGen.single
    use (Sum.inl (k + 1))
    constructor
    · solve_enabled
    · solve_fire
  have hBound := hk (intermediateMarking (k + 1)) hReach CrownCounterPlace.q
  dsimp [intermediateMarking] at hBound
  try simp [Finsupp.add_apply, Finsupp.single_apply] at hBound
  try omega

instance : Infinite CrownCounterTransition := by
  unfold CrownCounterTransition
  infer_instance

theorem WfNet.infinite_transition_countermodel_sound_not_bounded :
    Infinite CrownCounterTransition ∧
    ∃ (W : WfNet CrownCounterPlace CrownCounterTransition),
      W.Sound ∧ ¬ ∃ k, W.shortCircuit.Bounded W.initialMarking k := by
  constructor
  · infer_instance
  · use crownCounterWfNet
    exact ⟨crownCounter_sound, crownCounter_not_bounded⟩

end ProcInt
