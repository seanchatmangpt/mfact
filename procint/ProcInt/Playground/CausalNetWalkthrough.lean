-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-- Concrete dependency-measure values for a three-task log fragment
`A → B → C` where `A` is always directly followed by `B` (5 times, never the
reverse) and `B` is directly followed by `C` about as often as `C` follows
`B`. Demonstrates `ProcInt.dependencyMeasure`
(Weijters and Ribeiro 2011, Section 2). -/
def abMeasure : ℚ := dependencyMeasure 5 0

def bcMeasure : ℚ := dependencyMeasure 3 2

-- Strong one-directional dependency: (5 - 0) / (5 + 0 + 1) = 5/6.
#eval abMeasure

-- Weak, mostly-noise dependency: (3 - 2) / (3 + 2 + 1) = 1/6.
#eval bcMeasure

/-- A small concrete causal net on tasks `0 = A`, `1 = B`, `2 = C`: `A ⇒ B`
strongly, `B ⇒ C` weakly, and the reverse arcs carry the antisymmetric
(negative) scores. Bindings say `A` alone activates `B`, and `B` alone
produces `C`. Port target: `ProcInt.CausalNet`
(Weijters and Ribeiro 2011; `causal_net.rs` `CausalNet`). -/
def abcNet : CausalNet ℕ where
  nodes := [0, 1, 2]
  deps := [(0, 1, abMeasure), (1, 0, -abMeasure), (1, 2, bcMeasure), (2, 1, -bcMeasure)]
  inputs := [{ sources := [0], targets := [1] : CausalBinding ℕ },
             { sources := [1], targets := [2] : CausalBinding ℕ }]
  outputs := [{ sources := [0], targets := [1] : CausalBinding ℕ },
              { sources := [1], targets := [2] : CausalBinding ℕ }]

-- The net's input/output bindings round-trip through the fields as stored.
#eval abcNet.inputs.map (fun b => (b.sources, b.targets))

/-- `abcNet`'s scores are all structurally valid, i.e. every stored
dependency measure lies in `[-1, 1]`. Demonstrates
`ProcInt.CausalNet.ScoresValid` together with the bound theorems
`dependencyMeasure_lt_one` and `neg_one_lt_dependencyMeasure`. -/
example : abcNet.ScoresValid := by
  intro d hd
  simp only [abcNet, List.mem_cons, List.not_mem_nil, or_false] at hd
  rcases hd with h | h | h | h <;> subst h
  · exact ⟨le_of_lt (neg_one_lt_dependencyMeasure 5 0), le_of_lt (dependencyMeasure_lt_one 5 0)⟩
  · refine ⟨?_, ?_⟩ <;>
      (dsimp only; unfold abMeasure;
        linarith [dependencyMeasure_lt_one 5 0, neg_one_lt_dependencyMeasure 5 0])
  · exact ⟨le_of_lt (neg_one_lt_dependencyMeasure 3 2), le_of_lt (dependencyMeasure_lt_one 3 2)⟩
  · refine ⟨?_, ?_⟩ <;>
      (dsimp only; unfold bcMeasure;
        linarith [dependencyMeasure_lt_one 3 2, neg_one_lt_dependencyMeasure 3 2])

/-- Antisymmetry, concretely: the `B ⇒ C` and `C ⇒ B` measures stored in
`abcNet` are negatives of each other. Demonstrates
`ProcInt.dependencyMeasure_antisymm`. -/
example : bcMeasure = - dependencyMeasure 2 3 := dependencyMeasure_antisymm 3 2

/-- A perfectly balanced (uninformative) pair of tasks has zero causal
strength either way. Demonstrates `ProcInt.dependencyMeasure_self`. -/
example : dependencyMeasure 7 7 = 0 := dependencyMeasure_self 7

end ProcInt.Playground
