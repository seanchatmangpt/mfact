import Mathlib
import ProcInt.Workflow.Countermodel

open ProcInt

lemma onPath_proof : ∀ x : CrownCounterPlace ⊕ CrownCounterTransition,
    Relation.ReflTransGen crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) x ∧
    Relation.ReflTransGen crownCounterNet.FlowEdge x (Sum.inl CrownCounterPlace.o) := by
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
          decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl 1)) (Sum.inl CrownCounterPlace.q)
          decide
      | o =>
        apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
        · apply Relation.ReflTransGen.tail (b := Sum.inl CrownCounterPlace.q)
          · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
            · apply Relation.ReflTransGen.single
              show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl 1))
              decide
            · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl 1)) (Sum.inl CrownCounterPlace.q)
              decide
          · show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.q) (Sum.inr (Sum.inr 1))
            decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr 1)) (Sum.inl CrownCounterPlace.o)
          decide
      | c n =>
        apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl n))
        · apply Relation.ReflTransGen.single
          show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl n))
          decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl n)) (Sum.inl (CrownCounterPlace.c n))
          decide
    | inr t =>
      cases t with
      | inl n =>
        apply Relation.ReflTransGen.single
        show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl n))
        decide
      | inr n =>
        apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c n))
        · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl n))
          · apply Relation.ReflTransGen.single
            show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl n))
            decide
          · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl n)) (Sum.inl (CrownCounterPlace.c n))
            decide
        · show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n)) (Sum.inr (Sum.inr n))
          decide
  · cases x with
    | inl p =>
      cases p with
      | i =>
        apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
        · apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c 1))
          · apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inl 1))
            · apply Relation.ReflTransGen.single
              show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.i) (Sum.inr (Sum.inl 1))
              decide
            · show crownCounterNet.FlowEdge (Sum.inr (Sum.inl 1)) (Sum.inl (CrownCounterPlace.c 1))
              decide
          · show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c 1)) (Sum.inr (Sum.inr 1))
            decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr 1)) (Sum.inl CrownCounterPlace.o)
          decide
      | q =>
        apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr 1))
        · apply Relation.ReflTransGen.single
          show crownCounterNet.FlowEdge (Sum.inl CrownCounterPlace.q) (Sum.inr (Sum.inr 1))
          decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr 1)) (Sum.inl CrownCounterPlace.o)
          decide
      | o => exact Relation.ReflTransGen.refl
      | c n =>
        apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr n))
        · apply Relation.ReflTransGen.single
          show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n)) (Sum.inr (Sum.inr n))
          decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr n)) (Sum.inl CrownCounterPlace.o)
          decide
    | inr t =>
      cases t with
      | inl n =>
        apply Relation.ReflTransGen.tail (b := Sum.inr (Sum.inr n))
        · apply Relation.ReflTransGen.tail (b := Sum.inl (CrownCounterPlace.c n))
          · apply Relation.ReflTransGen.single
            show crownCounterNet.FlowEdge (Sum.inr (Sum.inl n)) (Sum.inl (CrownCounterPlace.c n))
            decide
          · show crownCounterNet.FlowEdge (Sum.inl (CrownCounterPlace.c n)) (Sum.inr (Sum.inr n))
            decide
        · show crownCounterNet.FlowEdge (Sum.inr (Sum.inr n)) (Sum.inl CrownCounterPlace.o)
          decide
      | inr n =>
        apply Relation.ReflTransGen.single
        show crownCounterNet.FlowEdge (Sum.inr (Sum.inr n)) (Sum.inl CrownCounterPlace.o)
        decide
