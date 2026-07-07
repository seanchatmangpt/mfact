-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt

namespace ProcInt.Playground

/-! ## ProcessTree.lean walkthrough (Leemans 2013 / van der Aalst 2016 ch. 3) -/

/-- A concrete two-activity sequence tree: do `1` then `2`.
Instantiates `ProcessTree.seq` from `ProcInt.Models.ProcessTree`. -/
def seqTree : ProcessTree Nat := (ProcessTree.leaf 1).seq (ProcessTree.leaf 2)

/-- The trace `[1, 2]` lies in the language of `seqTree`, a direct instance of
`ProcessTree.mem_language_seq_leaf`. -/
example : [1, 2] ∈ seqTree.language :=
  ProcessTree.mem_language_seq_leaf 1 2

-- All interleavings (shuffles) of a two-activity parallel branch and a
-- three-activity parallel branch, exercising `interleavings`.
#eval interleavings [1, 2] [3, 4, 5]

/-- Every shuffle of `[1, 2]` and `[3, 4, 5]` has length `2 + 3 = 5`, a direct
instance of `length_of_mem_interleavings`. -/
example (w : List Nat) (h : w ∈ interleavings [1, 2] ([3, 4, 5] : List Nat)) :
    w.length = 5 :=
  length_of_mem_interleavings [1, 2] [3, 4, 5] w h

/-- A loop that does `[1]`, redoes with `[2]`, then does `[1]` again: the trace
`[1, 2, 1]` lies in the loop language of do-language `{[1]}` and
redo-language `{[2]}`, an instance of `LoopLang.step` built on `LoopLang.base`. -/
example :
    LoopLang ({[1]} : Set (List Nat)) ({[2]} : Set (List Nat)) ([1] ++ [2] ++ [1]) :=
  LoopLang.step (LoopLang.base rfl) rfl rfl

/-! ## Powl.lean walkthrough (Kourani and van Zelst, BPM 2023, Definitions 1-2) -/

/-- A binary exclusive choice between doing activity `7` or staying silent,
well-formed by `Powl.wellFormed_xor_pair`. -/
def choiceModel : Powl Nat := Powl.xor [Powl.atom 7, Powl.silent]

example : Powl.WellFormed choiceModel :=
  Powl.wellFormed_xor_pair 7

/-- A do/redo loop over activities `1` and `2`, well-formed by
`Powl.wellFormed_loop_atoms`. -/
def loopModel : Powl Nat := Powl.loop (Powl.atom 1) (Powl.atom 2)

example : Powl.WellFormed loopModel :=
  Powl.wellFormed_loop_atoms 1 2

/-- A partial order over three atoms `1, 2, 3` with precedence `i < j` on
child indices: a genuine (non-empty) strict partial order, unlike
`Powl.wellFormed_po_emptyPrec`'s trivial empty relation. -/
def poModel : Powl Nat :=
  Powl.po [Powl.atom 1, Powl.atom 2, Powl.atom 3] (fun i j => i < j)

/-- `poModel` is well-formed: `i < j` on `Nat` is irreflexive and transitive on
the three child indices, and every child atom is well-formed. -/
theorem poModel_wellFormed : Powl.WellFormed poModel :=
  Powl.WellFormed.po _ _
    (fun i _ h => lt_irrefl i h)
    (fun _ _ _ _ _ _ hij hjk => lt_trans hij hjk)
    (by
      intro c hc
      simp only [List.mem_cons, List.not_mem_nil, or_false] at hc
      rcases hc with rfl | rfl | rfl
      · exact .atom 1
      · exact .atom 2
      · exact .atom 3)

end ProcInt.Playground
