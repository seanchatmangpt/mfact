namespace ProcInt.MFW

/--
[Notation Authority §39] Meta-Mathematical DAG Node.
A Directed Acyclic Graph node tracking mathematical claims.
-/
structure Node where
  id : Nat
  statement : String

/-- [Notation Authority §39] Directed edge between DAG nodes. -/
structure Edge where
  fromNode : Nat
  toNode : Nat

/-- [Notation Authority §40] Directed Acyclic Graph tracking dependencies of
meta-mathematical objects. -/
structure MetaMathDAG where
  nodes : List Node
  edges : List Edge

/--
[Notation Authority §39] The Central Theorem Ledger.
Tracks the DAG and the subset of currently closed/proved nodes.
-/
structure CentralTheoremLedger where
  dag : MetaMathDAG
  provedNodes : List Nat

/-- [Notation Authority §40] Validates that a sequence is a valid topological sort:
the sequence lists the DAG's node ids without duplicates (covering exactly the node set),
and every dependency edge points from an earlier position to a later position. -/
def validTopologicalSort (dag : MetaMathDAG) (seq : List Nat) : Prop :=
  seq.Nodup ∧
    (∀ n ∈ dag.nodes, n.id ∈ seq) ∧
    (∀ i ∈ seq, ∃ n ∈ dag.nodes, n.id = i) ∧
    ∀ e ∈ dag.edges,
      e.fromNode ∈ seq ∧ e.toNode ∈ seq ∧ seq.idxOf e.fromNode < seq.idxOf e.toNode

/-- `validTopologicalSort` is decidable: every conjunct is a bounded quantifier over lists
with decidable body, so concrete instances can be discharged by `decide`. -/
instance (dag : MetaMathDAG) (seq : List Nat) : Decidable (validTopologicalSort dag seq) := by
  unfold validTopologicalSort
  infer_instance

/-- [Notation Authority §40] The Canonical Derivation tracking. -/
structure CanonicalDerivation where
  ledger : CentralTheoremLedger
  sequence : List Nat
  isValidTopologicalSort : validTopologicalSort ledger.dag sequence

end ProcInt.MFW
