-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Models.Dfg
import ProcInt.Models.Declare
import ProcInt.Models.ProcessTree

/-! # ProcInt.Tests.Models

Model-family oracles (Level 1): directly-follows graphs of concrete traces, Declare template satisfaction, and process-tree interleaving semantics. -/

namespace ProcInt

-- DFG of a simple-sequence trace: adjacent pairs, each frequency 1.
#guard (dfgOfTrace ["a", "b", "c"]).edges == [("a", "b", 1), ("b", "c", 1)]
-- Declare response oracle: response(a,b) holds on [a,b,a,b].
example : Response "a" "b" ["a", "b", "a", "b"] := by decide
-- Declare precedence oracle.
example : Precedence "a" "b" ["a", "b"] := by decide
-- Parallel split/join semantics seed: interleavings of [a] and [b].
#guard interleavings ["a"] ["b"] == [["a", "b"], ["b", "a"]]


end ProcInt
