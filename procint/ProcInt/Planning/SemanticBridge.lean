import Mathlib.Data.Finset.Basic
import ProcInt.Planning.Pddl

namespace ProcInt.Semantic

/-- An abstract RDF Node -/
inductive RDFNode
  | iri (uri : String)
  | blank (id : String)
  | literal (val : String)
  deriving DecidableEq, Repr

/-- An RDF Graph is a set of triples -/
structure RDFGraph where
  triples : Finset (RDFNode × RDFNode × RDFNode)

/-- A Datalog Closure represents a set of deduced facts -/
structure DatalogClosure where
  facts : Finset (RDFNode × RDFNode × RDFNode)

/-- SHACLShape represents a state in semantic validation,
which may contain unresolved atoms that need to be planned for. -/
structure SHACLShape (Atom : Type u) [DecidableEq Atom] where
  targetNode : RDFNode
  unresolved : Finset Atom
  resolved : Finset Atom

/-- The bridge function mapping an unresolved SHACLShape state
into the irreducible Finset Atom state required by the Pddl planner. -/
def projectShapeState {Atom : Type u} [DecidableEq Atom] (shape : SHACLShape Atom) : Finset Atom :=
  shape.unresolved

/-- Mathematically projects graph state (Yin) into PDDL starting state (Yang).
Here we map the RDF triples directly into PDDL atoms. -/
def projectGraphState (yin : RDFGraph) : Finset (RDFNode × RDFNode × RDFNode) :=
  yin.triples

end ProcInt.Semantic
