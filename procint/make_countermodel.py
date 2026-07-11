import os

lean_code = """import Mathlib
import ProcInt.Workflow.Soundness

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
            show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl 1))
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl 1)) (Sum.inl CrownCounterPlace.q)
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
        | o =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
          · apply Relation.ReflTransGen.tail (b := Sum.inl CrownCounterPlace.q)
            · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
              · apply Relation.ReflTransGen.single
                show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl 1))
                simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
              · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl 1)) (Sum.inl CrownCounterPlace.q)
                simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
            · show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.q) (Sum.inr (Sum.inr 1))
              simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr 1)) (Sum.inl CrownCounterPlace.o)
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
        | c n =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl n))
          · apply Relation.ReflTransGen.single
            show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl n))
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl n)) (Sum.inl (CrownCounterPlace.c n))
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
      | inr t =>
        cases t with
        | inl n =>
          apply Relation.ReflTransGen.single
          show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl n))
          simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
        | inr n =>
          apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c n))
          · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl n))
            · apply Relation.ReflTransGen.single
              show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl n))
              simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
            · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl n)) (Sum.inl (CrownCounterPlace.c n))
              simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n)) (Sum.inr (Sum.inr n))
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
    · cases x with
      | inl p =>
        cases p with
        | i =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
          · apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c 1))
            · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
              · apply Relation.ReflTransGen.single
                show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl 1))
                simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
              · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl 1)) (Sum.inl (CrownCounterPlace.c 1))
                simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
            · show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c 1)) (Sum.inr (Sum.inr 1))
              simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr 1)) (Sum.inl CrownCounterPlace.o)
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
        | q =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
          · apply Relation.ReflTransGen.single
            show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.q) (Sum.inr (Sum.inr 1))
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr 1)) (Sum.inl CrownCounterPlace.o)
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
        | o => exact Relation.ReflTransGen.refl
        | c n =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr n))
          · apply Relation.ReflTransGen.single
            show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n)) (Sum.inr (Sum.inr n))
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr n)) (Sum.inl CrownCounterPlace.o)
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
      | inr t =>
        cases t with
        | inl n =>
          apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr n))
          · apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c n))
            · apply Relation.ReflTransGen.single
              show crownCounterNet.FlowEdge (Sum.inr (Sum.inl n)) (Sum.inl (CrownCounterPlace.c n))
              simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
            · show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n)) (Sum.inr (Sum.inr n))
              simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr n)) (Sum.inl CrownCounterPlace.o)
            simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]
        | inr n =>
          apply Relation.ReflTransGen.single
          show crownCounterNet.FlowEdge (Sum.inr (Sum.inr n)) (Sum.inl CrownCounterPlace.o)
          simp [crownCounterNet, Finsupp.single_apply, Finsupp.update_apply]

noncomputable def intermediateMarking (n : ℕ) : Marking CrownCounterPlace :=
  Finsupp.single CrownCounterPlace.q n + Finsupp.single (CrownCounterPlace.c n) 1

macro "solve_enabled" : tactic =>
  `(tactic| (
    intro p
    dsimp [intermediateMarking, crownCounterNet, PetriNet.Enabled, WfNet.initialMarking, WfNet.finalMarking, crownCounterWfNet]
    try simp only [Finsupp.single_apply, Finsupp.update_apply, Finsupp.add_apply, Finsupp.tsub_apply]
    try split_ifs
    try omega
  ))

macro "solve_fire" : tactic =>
  `(tactic| (
    ext p
    dsimp [intermediateMarking, crownCounterNet, PetriNet.fire, WfNet.initialMarking, WfNet.finalMarking, crownCounterWfNet]
    try simp only [Finsupp.single_apply, Finsupp.update_apply, Finsupp.add_apply, Finsupp.tsub_apply]
    cases p
    · try simp; try omega
    · try simp; try omega
    · try simp; try omega
    · rename_i m; try simp; try split_ifs; try omega
  ))

lemma reachable_is_one_of (M : Marking CrownCounterPlace) :
    crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M →
    M = crownCounterWfNet.initialMarking ∨
    (∃ n, M = intermediateMarking n) ∨
    M = crownCounterWfNet.finalMarking := by
  intro h
  induction h using Relation.ReflTransGen.induction_on with
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
        dsimp [crownCounterWfNet, WfNet.initialMarking, crownCounterNet, PetriNet.Enabled] at hEn_q
        try simp [Finsupp.single_apply] at hEn_q
        try exact Nat.not_succ_le_zero _ hEn_q
    · rcases hStep with ⟨t, hEn, rfl⟩
      cases t with
      | inl m =>
        exfalso
        have hEn_i := hEn CrownCounterPlace.i
        dsimp [intermediateMarking, crownCounterNet, PetriNet.Enabled] at hEn_i
        try simp [Finsupp.single_apply, Finsupp.add_apply] at hEn_i
        try exact Nat.not_succ_le_zero _ hEn_i
      | inr m =>
        have hEn_c := hEn (CrownCounterPlace.c m)
        dsimp [intermediateMarking, crownCounterNet, PetriNet.Enabled] at hEn_c
        try simp [Finsupp.single_apply, Finsupp.add_apply] at hEn_c
        have h_eq : m = n := by
          by_contra hc
          have h_ne : CrownCounterPlace.c m ≠ CrownCounterPlace.c n := by intro h; injection h with h; contradiction
          rw [if_neg h_ne] at hEn_c
          try exact Nat.not_succ_le_zero _ hEn_c
        subst h_eq
        right; right
        solve_fire
    · rcases hStep with ⟨t, hEn, rfl⟩
      cases t with
      | inl m =>
        exfalso
        have hEn_i := hEn CrownCounterPlace.i
        dsimp [crownCounterWfNet, WfNet.finalMarking, crownCounterNet, PetriNet.Enabled] at hEn_i
        try simp [Finsupp.single_apply] at hEn_i
        try exact Nat.not_succ_le_zero _ hEn_i
      | inr m =>
        exfalso
        have hEn_q := hEn CrownCounterPlace.q
        dsimp [crownCounterWfNet, WfNet.finalMarking, crownCounterNet, PetriNet.Enabled] at hEn_q
        try simp [Finsupp.single_apply] at hEn_q
        try exact Nat.not_succ_le_zero _ hEn_q

lemma crownCounter_reaches_mid (n : ℕ) :
    ∃ M, crownCounterWfNet.net.Reaches crownCounterWfNet.initialMarking M := by
  use intermediateMarking n
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

theorem crownCounter_sound : crownCounterWfNet.Sound := by
  constructor
  · exact crownCounter_reaches_final
  · intro M hReach hLe
    rcases reachable_is_one_of M hReach with rfl | ⟨n, rfl⟩ | rfl
    · exfalso
      have hLe_o := hLe CrownCounterPlace.o
      dsimp [crownCounterWfNet, WfNet.finalMarking, WfNet.initialMarking] at hLe_o
      try simp only [Finsupp.single_apply] at hLe_o
      try exact Nat.not_succ_le_zero _ hLe_o
    · exfalso
      have hLe_o := hLe CrownCounterPlace.o
      dsimp [crownCounterWfNet, WfNet.finalMarking, intermediateMarking] at hLe_o
      try simp only [Finsupp.single_apply, Finsupp.add_apply] at hLe_o
      try exact Nat.not_succ_le_zero _ hLe_o
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
      · apply Relation.ReflTransGen.single
        use (Sum.inl n)
        constructor
        · solve_enabled
        · solve_fire
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
  try simp only [Finsupp.add_apply, Finsupp.single_apply] at hBound
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
"""

with open("ProcInt/Workflow/Countermodel.lean", "w") as f:
    f.write(lean_code)
