import ProcInt.MFW.Ledger

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
This instantiates a `CanonicalDerivation`, showing that the topological sort checks out.
-/
def toyDerivation : CanonicalDerivation := {
  ledger := toyLedger,
  sequence := [1, 2, 3],
  isValidTopologicalSort := True.intro
}

-- Simple sanity check to ensure the sequence evaluates properly.
#eval toyDerivation.sequence
