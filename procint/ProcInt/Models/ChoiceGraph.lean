-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Models.ChoiceGraph

Choice graphs per Definition 1 of Kourani, Park, van der Aalst, Unlocking Non-Block-Structured Decisions: Inductive Mining with Choice Graphs (arXiv:2505.07052): a directed graph over start/end/activity/submodel nodes with a unique start (no incoming edges) and unique end (no outgoing edges) where every node lies on a start-to-end path; cycles permitted (POWL 2.0 relaxation). Ported from wasm4pm-compat choice_graph.rs (ChoiceGraph::new validation). -/

namespace ProcInt

/-- A node of a choice graph (Kourani, Park, van der Aalst, arXiv:2505.07052
Definition 1; ported from wasm4pm-compat choice_graph.rs ChoiceGraphNode):
the unique start marker, the unique end marker (named finish here since end is
a Lean keyword), an inline activity, or a reference to a sub-model by index. -/
inductive ChoiceGraphNode (α : Type*)
  | start
  | finish
  | activity (a : α)
  | subModel (i : ℕ)

/-- A choice graph: a node list, directed index-pair edges, and designated
start and end indices (choice_graph.rs ChoiceGraph fields). Validity is the
separate predicate ChoiceGraph.Valid. -/
structure ChoiceGraph (α : Type*) where
  nodes : List (ChoiceGraphNode α)
  edges : List (ℕ × ℕ)
  startIdx : ℕ
  endIdx : ℕ

/-- Reachability along the directed edges of a choice graph: reflexive and
closed under following one edge (the BFS reachability bfs_reach of
choice_graph.rs, as an inductive predicate). -/
inductive Reach (E : List (ℕ × ℕ)) : ℕ → ℕ → Prop
  | refl (i : ℕ) : Reach E i i
  | step {i j k : ℕ} : Reach E i j → (j, k) ∈ E → Reach E i k

/-- Reachability is transitive. -/
theorem Reach.trans {E : List (ℕ × ℕ)} {i j k : ℕ}
    (h1 : Reach E i j) (h2 : Reach E j k) : Reach E i k := by
  induction h2 with
  | refl => exact h1
  | step _ e ih => exact .step ih e

/-- Validity of a choice graph, per Definition 1 of arXiv:2505.07052 as checked
by ChoiceGraph::new in choice_graph.rs: start and end indices in bounds, all
edge endpoints in bounds, the start has no incoming edge, the end has no
outgoing edge, and every node lies on some start-to-end path (is reachable from
start and reaches end). Cycles are permitted (POWL 2.0 relaxation). -/
def ChoiceGraph.Valid {α : Type*} (g : ChoiceGraph α) : Prop :=
  g.startIdx < g.nodes.length ∧
  g.endIdx < g.nodes.length ∧
  (∀ e ∈ g.edges, e.1 < g.nodes.length ∧ e.2 < g.nodes.length) ∧
  (∀ e ∈ g.edges, e.2 ≠ g.startIdx) ∧
  (∀ e ∈ g.edges, e.1 ≠ g.endIdx) ∧
  (∀ i, i < g.nodes.length →
    Reach g.edges g.startIdx i ∧ Reach g.edges i g.endIdx)

/-- The empty path: a direct start-to-end edge exists (has_empty_path in
choice_graph.rs). -/
def ChoiceGraph.HasEmptyPath {α : Type*} (g : ChoiceGraph α) : Prop :=
  (g.startIdx, g.endIdx) ∈ g.edges

/-- The minimal choice graph: just the start and end markers with the single
edge start to end (the minimal_valid test of choice_graph.rs). -/
def ChoiceGraph.minimal (α : Type*) : ChoiceGraph α :=
  ⟨[ChoiceGraphNode.start, ChoiceGraphNode.finish], [(0, 1)], 0, 1⟩

/-- The minimal choice graph is valid per Definition 1. -/
theorem ChoiceGraph.minimal_valid (α : Type*) : (ChoiceGraph.minimal α).Valid := by
  refine ⟨by simp [ChoiceGraph.minimal], by simp [ChoiceGraph.minimal], ?_, ?_, ?_, ?_⟩
  · intro e he
    simp only [ChoiceGraph.minimal, List.mem_singleton] at he
    subst he
    simp [ChoiceGraph.minimal]
  · intro e he
    simp only [ChoiceGraph.minimal, List.mem_singleton] at he
    subst he
    simp [ChoiceGraph.minimal]
  · intro e he
    simp only [ChoiceGraph.minimal, List.mem_singleton] at he
    subst he
    simp [ChoiceGraph.minimal]
  · intro i hi
    simp only [ChoiceGraph.minimal, List.length_cons, List.length_nil] at hi
    interval_cases i
    · exact ⟨.refl 0, .step (.refl 0) (by simp [ChoiceGraph.minimal])⟩
    · exact ⟨.step (.refl 0) (by simp [ChoiceGraph.minimal]), .refl 1⟩

/-- The minimal choice graph has the empty path (direct start-to-end edge). -/
theorem ChoiceGraph.minimal_hasEmptyPath (α : Type*) :
    (ChoiceGraph.minimal α).HasEmptyPath := by
  simp [ChoiceGraph.HasEmptyPath, ChoiceGraph.minimal]


end ProcInt
