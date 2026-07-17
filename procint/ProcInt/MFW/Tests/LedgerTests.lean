import ProcInt.MFW.Ledger

namespace ProcInt.MFW.Tests

open ProcInt.MFW

/--
A list of nodes representing toy mathematical statements.
-/
def toyNodes : List Node := [
  { id := 1, statement := "Axiom A" },
  { id := 2, statement := "Lemma B" },
  { id := 3, statement := "Theorem C" }
]

/--
A list of edges forming a valid DAG dependency relation (1 -> 2 -> 3).
-/
def toyEdges : List Edge := [
  { fromNode := 1, toNode := 2 },
  { fromNode := 2, toNode := 3 }
]

/--
Toy Meta-Mathematical DAG.
-/
def toyDAG : MetaMathDAG := {
  nodes := toyNodes,
  edges := toyEdges
}

/--
CentralTheoremLedger populated with our toy DAG and list of proved nodes.
-/
def toyLedger : CentralTheoremLedger := {
  dag := toyDAG,
  provedNodes := [1, 2, 3]
}

/--
Verifies that the topological sort sequence `[1, 2, 3]` is valid for our toy ledger.
This instantiates a `CanonicalDerivation`; the validity obligation is discharged by
`decide` against the real `validTopologicalSort` predicate.
-/
def toyDerivation : CanonicalDerivation := {
  ledger := toyLedger,
  sequence := [1, 2, 3],
  isValidTopologicalSort := by decide
}

/-- The reversed sequence `[3, 2, 1]` places both edges backwards, so it is rejected. -/
example : ¬ validTopologicalSort toyDAG [3, 2, 1] := by decide

/-- The sequence `[1, 3, 2]` violates the edge `2 -> 3`, so it is rejected. -/
example : ¬ validTopologicalSort toyDAG [1, 3, 2] := by decide

/-- A sequence that omits node `3` does not cover the node set, so it is rejected. -/
example : ¬ validTopologicalSort toyDAG [1, 2] := by decide

-- Witness pair: statement-adequacy check — `validTopologicalSort` accepts `[1, 2, 3]`
-- (via `toyDerivation` above) and provably rejects `[1, 1, 2, 3]`: duplicating a node id
-- violates `Nodup`, exercising the one conjunct the negatives above leave untested.
example : ¬ validTopologicalSort toyDAG [1, 1, 2, 3] := by decide

-- Simple sanity check to ensure the sequence evaluates properly.
#eval toyDerivation.sequence

end ProcInt.MFW.Tests
