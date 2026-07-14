import Mathlib

namespace ProcInt
namespace Graph

/-- RDF Subject-Predicate-Object triple. -/
structure Triple (Node : Type) where
  subject : Node
  predicate : Node
  object : Node
  deriving Repr, DecidableEq

/-- RDF Graph is a set of triples. -/
def RdfGraph (Node : Type) := Finset (Triple Node)

/-- A Datalog Horn clause rule (without negation) over Triples. -/
structure DatalogRule (Node Var : Type) where
  head : Triple (Sum Node Var)
  body : List (Triple (Sum Node Var))

/-- Projects unresolved semantic state from an RDF Graph into PDDL atoms. -/
def extractPddlAtoms {Node Atom : Type} [DecidableEq Atom] (graph : RdfGraph Node) (projection : Triple Node → Option Atom) : Finset Atom :=
  Finset.biUnion graph (fun t => match projection t with
    | some a => {a}
    | none => ∅)

/-- A SHACL admission rule for validating an RDF Graph. -/
structure ShaclRule (Node : Type) where
  targetClass : Node
  property : Node
  minCount : ℕ

/-- A ShEx admission rule describing the expected shape of an RDF Graph. -/
structure ShexRule (Node : Type) where
  shape : Node
  expression : List (Triple Node)

/-- A SPARQL admission rule for query-based semantic validation. -/
structure SparqlRule (Node Var : Type) where
  query : List (Triple (Sum Node Var))
  condition : List (Triple (Sum Node Var)) → Prop

end Graph
end ProcInt
