-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.MFW.Order

/-!
# POWL 2.0 syntax and standing

Partial orders represent generalized concurrency and causal dependency.
Choice graphs represent generalized exclusive routing and cycles.  Standing is
an explicit proof object and is not inherited from generation.
-/

namespace ProcInt.Playground.MFW

inductive ChoiceNode (n : Nat)
  | start
  | item (index : Fin n)
  | finish
deriving Repr, DecidableEq

/-- Reflexive-transitive reachability for choice graphs. -/
inductive Reach {α : Type} (edge : α → α → Prop) : α → α → Prop
  | refl (a : α) : Reach edge a a
  | step {a b : α} : edge a b → Reach edge a b
  | trans {a b c : α} : Reach edge a b → Reach edge b c → Reach edge a c

/-- A POWL 2.0 choice graph; cycles are permitted by `edge`. -/
structure ChoiceGraph (n : Nat) where
  edge : ChoiceNode n → ChoiceNode n → Prop
  decidableEdge : DecidableRel edge
  noIntoStart : ∀ x, ¬ edge x .start
  noOutFinish : ∀ x, ¬ edge .finish x
  allOnRoute : ∀ i,
    Reach edge .start (.item i) ∧ Reach edge (.item i) .finish

instance (g : ChoiceGraph n) : DecidableRel g.edge := g.decidableEdge

/-- Recursive POWL 2.0 workflow syntax. -/
inductive POWL
  | activity (activity : Activity)
  | silent
  | partialOrder (n : Nat) (children : Fin n → POWL) (order : StrictOrder n)
  | choiceGraph (n : Nat) (children : Fin n → POWL) (graph : ChoiceGraph n)

namespace POWL

/-- Kernel standing for a POWL candidate. -/
inductive Admitted : POWL → Prop
  | activity (a : Activity) : Admitted (.activity a)
  | silent : Admitted .silent
  | partialOrder
      {n : Nat} (children : Fin n → POWL) (order : StrictOrder n)
      (atLeastTwo : 2 ≤ n)
      (childrenAdmitted : ∀ i, Admitted (children i)) :
      Admitted (.partialOrder n children order)
  | choiceGraph
      {n : Nat} (children : Fin n → POWL) (graph : ChoiceGraph n)
      (nonempty : 1 ≤ n)
      (childrenAdmitted : ∀ i, Admitted (children i)) :
      Admitted (.choiceGraph n children graph)

end POWL

/-- A POWL artifact paired with the proof that gives it standing. -/
structure AdmittedPOWL where
  workflow : POWL
  standing : POWL.Admitted workflow

end ProcInt.Playground.MFW
