-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib
import ProcInt.Workflow.Soundness
import ProcInt.Petri.Net
import ProcInt.Petri.Boundedness

namespace ProcInt.Playground.Ticket012

/-! # Ticket 012: Crown Countermodel Types and Petri Net

This file defines the structure of the crown countermodel WF-net:
- Place type `CrownCounterPlace` with four variants: input (i), queue (q), output (o), counter (c n)
- Transition type `CrownCounterTransition` as a sum of natural numbers
- The Petri net operations: Sum.inl n fires from i to place n tokens in q and 1 in c n;
  Sum.inr n fires from q and c n to o
- The WF-net value with source i, sink o, and complete onPath proof

This countermodel demonstrates that bounded, live, and proper nets need not be sound.
-/

open Relation (ReflTransGen)

/-- Place type for the crown countermodel WF-net.
- `i`: input place
- `q`: queue place (holds tokens)
- `o`: output place
- `c n`: counter place at index n -/
inductive CrownCounterPlace : Type
  | i : CrownCounterPlace
  | q : CrownCounterPlace
  | o : CrownCounterPlace
  | c : ℕ → CrownCounterPlace
  deriving DecidableEq, Repr

/-- Transition type for the crown countermodel WF-net.
Sum.inl n: absorb transition at index n (fires from i)
Sum.inr n: emit transition at index n (fires to o) -/
def CrownCounterTransition := ℕ ⊕ ℕ

/-- The Petri net underlying the crown countermodel.

Transition semantics:
- Sum.inl n (absorb): pre = {i:1}, post = {q:n, c n:1}
- Sum.inr n (emit): pre = {q:n, c n:1}, post = {o:1}
-/
noncomputable def crownCounterNet : PetriNet CrownCounterPlace CrownCounterTransition where
  pre := fun t => match t with
    | Sum.inl n =>
        -- Absorb transition: consumes 1 from i
        Finsupp.single CrownCounterPlace.i 1
    | Sum.inr n =>
        -- Emit transition: consumes n from q and 1 from c n
        Finsupp.update (Finsupp.single CrownCounterPlace.q n)
          (CrownCounterPlace.c n) 1
  post := fun t => match t with
    | Sum.inl n =>
        -- Absorb transition: produces n tokens to q and 1 to c n
        Finsupp.update (Finsupp.single CrownCounterPlace.q n)
          (CrownCounterPlace.c n) 1
    | Sum.inr n =>
        -- Emit transition: produces 1 token to o
        Finsupp.single CrownCounterPlace.o 1

/-- Construct the source place (i) to absorb transition flow edge. -/
private theorem flow_i_absorb (n : ℕ) :
    crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i)
      (Sum.inr (Sum.inl n)) := by
  unfold PetriNet.FlowEdge crownCounterNet
  simp [Finsupp.single_eq_same]

/-- Construct the absorb-to-queue flow edge. -/
private theorem flow_absorb_q (n : ℕ) :
    crownCounterNet.FlowEdge (Sum.inr (Sum.inl n))
      (Sum.inl CrownCounterPlace.q) := by
  unfold PetriNet.FlowEdge crownCounterNet
  simp [Finsupp.single_eq_same, Finsupp.mem_support_iff, Finsupp.coe_update]

/-- Construct the absorb-to-counter flow edge. -/
private theorem flow_absorb_c (n : ℕ) :
    crownCounterNet.FlowEdge (Sum.inr (Sum.inl n))
      (Sum.inl (CrownCounterPlace.c n)) := by
  unfold PetriNet.FlowEdge crownCounterNet
  simp [Finsupp.mem_support_iff, Finsupp.coe_update, Finsupp.single_eq_same]

/-- Construct the queue-to-emit flow edge. -/
private theorem flow_q_emit (n : ℕ) :
    crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.q)
      (Sum.inr (Sum.inr n)) := by
  unfold PetriNet.FlowEdge crownCounterNet
  simp [Finsupp.single_eq_same, Finsupp.mem_support_iff, Finsupp.coe_update]

/-- Construct the counter-to-emit flow edge. -/
private theorem flow_c_emit (n : ℕ) :
    crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n))
      (Sum.inr (Sum.inr n)) := by
  unfold PetriNet.FlowEdge crownCounterNet
  simp [Finsupp.mem_support_iff, Finsupp.coe_update, Finsupp.single_eq_same]

/-- Construct the emit-to-sink flow edge. -/
private theorem flow_emit_o (n : ℕ) :
    crownCounterNet.FlowEdge (Sum.inr (Sum.inr n))
      (Sum.inl CrownCounterPlace.o) := by
  unfold PetriNet.FlowEdge crownCounterNet
  simp [Finsupp.single_eq_same]

/-- Source i has no incoming transitions. -/
private theorem source_no_input : ∀ t, crownCounterNet.post t CrownCounterPlace.i = 0 := by
  intro t
  match t with
  | Sum.inl n => simp [crownCounterNet]
  | Sum.inr n => simp [crownCounterNet]

/-- Sink o has no outgoing transitions. -/
private theorem sink_no_output : ∀ t, crownCounterNet.pre t CrownCounterPlace.o = 0 := by
  intro t
  match t with
  | Sum.inl n => simp [crownCounterNet]
  | Sum.inr n => simp [crownCounterNet]

/-- Path from source i to queue via absorb transition (using index 0). -/
private theorem path_i_q :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i)
      (Sum.inl CrownCounterPlace.q) :=
  ReflTransGen.head (flow_i_absorb 0) (ReflTransGen.head (flow_absorb_q 0) ReflTransGen.refl)

/-- Path from queue to sink o via emit transition (using index 0). -/
private theorem path_q_o :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.q)
      (Sum.inl CrownCounterPlace.o) :=
  ReflTransGen.head (flow_q_emit 0) (ReflTransGen.head (flow_emit_o 0) ReflTransGen.refl)

/-- Path from source i to counter c n via absorb transition. -/
private theorem path_i_c (n : ℕ) :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i)
      (Sum.inl (CrownCounterPlace.c n)) :=
  ReflTransGen.head (flow_i_absorb n) (ReflTransGen.head (flow_absorb_c n) ReflTransGen.refl)

/-- Path from counter c n to sink o via emit transition. -/
private theorem path_c_o (n : ℕ) :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n))
      (Sum.inl CrownCounterPlace.o) :=
  ReflTransGen.head (flow_c_emit n) (ReflTransGen.head (flow_emit_o n) ReflTransGen.refl)

/-- Path from source i to sink o via absorb and emit transitions (using index 0). -/
private theorem path_i_o :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i)
      (Sum.inl CrownCounterPlace.o) :=
  ReflTransGen.head (flow_i_absorb 0)
    (ReflTransGen.head (flow_absorb_q 0)
      (ReflTransGen.head (flow_q_emit 0)
        (ReflTransGen.head (flow_emit_o 0) ReflTransGen.refl)))

/-- Path from source i to absorb transition via flow edge. -/
private theorem path_i_absorb (n : ℕ) :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i)
      (Sum.inr (Sum.inl n)) :=
  ReflTransGen.head (flow_i_absorb n) ReflTransGen.refl

/-- Path from absorb transition to sink o. -/
private theorem path_absorb_o (n : ℕ) :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inr (Sum.inl n))
      (Sum.inl CrownCounterPlace.o) :=
  ReflTransGen.head (flow_absorb_q n)
    (ReflTransGen.head (flow_q_emit n)
      (ReflTransGen.head (flow_emit_o n) ReflTransGen.refl))

/-- Path from source i to emit transition. -/
private theorem path_i_emit (n : ℕ) :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i)
      (Sum.inr (Sum.inr n)) :=
  ReflTransGen.head (flow_i_absorb n)
    (ReflTransGen.head (flow_absorb_q n)
      (ReflTransGen.head (flow_q_emit n) ReflTransGen.refl))

/-- Path from emit transition to sink o. -/
private theorem path_emit_o (n : ℕ) :
    ReflTransGen crownCounterNet.FlowEdge (Sum.inr (Sum.inr n))
      (Sum.inl CrownCounterPlace.o) :=
  ReflTransGen.head (flow_emit_o n) ReflTransGen.refl

/-- The crown countermodel is a workflow net.

Source: i (no input transitions)
Sink: o (no output transitions)
Every node lies on a path from i to o.
-/
noncomputable def crownCounterWfNet : WfNet CrownCounterPlace CrownCounterTransition where
  net := crownCounterNet
  source := CrownCounterPlace.i
  sink := CrownCounterPlace.o
  source_ne_sink := by decide
  source_no_input := source_no_input
  sink_no_output := sink_no_output
  onPath := fun x => by
    match x with
    | Sum.inl p =>
        match p with
        | CrownCounterPlace.i =>
            -- Source place: reflexive from i, path to o
            exact ⟨ReflTransGen.refl, path_i_o⟩
        | CrownCounterPlace.q =>
            -- Queue place: path from i, path to o
            exact ⟨path_i_q, path_q_o⟩
        | CrownCounterPlace.o =>
            -- Sink place: path from i, reflexive to o
            exact ⟨path_i_o, ReflTransGen.refl⟩
        | CrownCounterPlace.c n =>
            -- Counter place c n: path from i via absorb n, path to o via emit n
            exact ⟨path_i_c n, path_c_o n⟩
    | Sum.inr t =>
        match t with
        | Sum.inl n =>
            -- Absorb transition: path from i, path to o through q
            exact ⟨path_i_absorb n, path_absorb_o n⟩
        | Sum.inr n =>
            -- Emit transition: path from i through q, path to o
            exact ⟨path_i_emit n, path_emit_o n⟩

end ProcInt.Playground.Ticket012
