-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

open ProcInt

/-- A concrete XOR-choice graph: `start` branches to either activity `A` or
activity `B`, both of which converge on `finish`. Nodes are indexed
`[start, A, B, finish] = [0, 1, 2, 3]` with edges `start→A`, `start→B`,
`A→finish`, `B→finish`. This instantiates `ProcInt.ChoiceGraph`
(ProcInt/Models/ChoiceGraph.lean) with a genuinely branching (non-minimal)
example, unlike `ChoiceGraph.minimal` which has a single direct edge. -/
def xorChoice : ChoiceGraph String :=
  ⟨[ChoiceGraphNode.start, ChoiceGraphNode.activity "A",
    ChoiceGraphNode.activity "B", ChoiceGraphNode.finish],
   [(0, 1), (0, 2), (1, 3), (2, 3)], 0, 3⟩

/-- The XOR-choice graph satisfies `ChoiceGraph.Valid` (Definition 1 of
Kourani, Park, van der Aalst, arXiv:2505.07052): every node lies on some
start-to-end path, the start has no incoming edge, and the end has no
outgoing edge. -/
theorem xorChoice_valid : xorChoice.Valid := by
  refine ⟨by decide, by decide, ?_, ?_, ?_, ?_⟩
  · intro e he
    fin_cases he <;> decide
  · intro e he
    fin_cases he <;> decide
  · intro e he
    fin_cases he <;> decide
  · intro i hi
    simp only [xorChoice, List.length_cons, List.length_nil] at hi
    interval_cases i
    · exact ⟨.refl 0,
        .step (j := 1) (.step (j := 0) (.refl 0) (by simp [xorChoice])) (by simp [xorChoice])⟩
    · exact ⟨.step (j := 0) (.refl 0) (by simp [xorChoice]),
        .step (j := 1) (.refl 1) (by simp [xorChoice])⟩
    · exact ⟨.step (j := 0) (.refl 0) (by simp [xorChoice]),
        .step (j := 2) (.refl 2) (by simp [xorChoice])⟩
    · exact ⟨.step (j := 1) (.step (j := 0) (.refl 0) (by simp [xorChoice])) (by simp [xorChoice]),
        .refl 3⟩

-- ProcInt.ChoiceGraph.HasEmptyPath demonstrated as false: the XOR-choice
-- graph forces a detour through either `A` or `B`, so no direct start-to-end
-- edge exists.
example : ¬ xorChoice.HasEmptyPath := by
  simp [ChoiceGraph.HasEmptyPath, xorChoice]

end ProcInt.Playground
