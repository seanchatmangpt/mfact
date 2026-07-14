-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.ZeroKnowledge
import ProcInt.Petri.Net

/-! # ProcInt.Tests.ZeroKnowledge

zk-SNARK trace verification tests -/

namespace ProcInt


-- Place and transition types
inductive TestPlace
  | p1
  deriving DecidableEq, Fintype

inductive TestTrans
  | t1
  deriving DecidableEq, Fintype

open TestPlace TestTrans

-- Define a simple Petri net
noncomputable def testNet : PetriNet TestPlace TestTrans where
  pre t := match t with
    | t1 => Finsupp.single p1 1
  post t := match t with
    | t1 => Finsupp.single p1 2

-- Define a relation for payloads
def testRelation (t : TestTrans) (in_p out_p : TestPlace → Multiset Nat) : Prop :=
  true

-- Let's define a marking before and after with type PMarking TestPlace Nat Nat
noncomputable def M0 : PMarking TestPlace Nat Nat := fun p => match p with
  | p1 => {(1, 0)}

noncomputable def M1 : PMarking TestPlace Nat Nat := fun p => match p with
  | p1 => {(2, 0), (2, 0)}

-- A valid step witnesses
noncomputable def testStep : PayloadStep testNet testRelation M0 t1 M1 := by
  use (fun p => match p with | p1 => {(1, 0)}), (fun p => match p with | p1 => {(2, 0), (2, 0)})
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rintro (_|_) <;> (unfold testNet; simp)
  · rintro (_|_) <;> (unfold testNet; simp)
  · rintro (_|_) <;> (unfold M0; simp)
  · unfold testRelation; rfl
  · ext p
    rcases p with _
    rfl

-- Let's verify that the completeness theorem can be applied to get a valid witness/public input
noncomputable def testCompleteness : ∃ (w : Witness TestPlace Nat Nat) (x : PublicInput TestPlace TestTrans Int),
    Relation (fun (v : Nat) (r : Nat) => (v : Int)) testNet testRelation x w := by
  apply step_completeness (fun (v : Nat) (r : Nat) => (v : Int))
  exact testStep



end ProcInt
