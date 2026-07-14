-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
import ProcInt.Petri.Fhe
import ProcInt.Petri.Hdl

/-! # ProcInt.Tests.FheHdl

Correctness-ladder tests for Petri FHE and HDL compiler. -/

namespace ProcInt

inductive TestPlace
  | p0
  deriving DecidableEq, Fintype

inductive TestTrans
  | t0
  deriving DecidableEq, Fintype

open TestPlace TestTrans

noncomputable def testNet : PetriNet TestPlace TestTrans where
  pre _ := Finsupp.single p0 1
  post _ := Finsupp.single p0 2

/-- Test that compileToHdl compiles the Petri net successfully. -/
def testCompiledModule : HdlModule :=
  compileToHdl testNet 8 (fun | p0 => "p0") (fun | t0 => "t0")

/-- Trivial FHE scheme for testing. -/
def trivialFheScheme : FheScheme ℤ Unit where
  decrypt _ c := c
  add c1 c2 := c1 + c2
  sub c1 c2 := c1 - c2
  mul c1 c2 := c1 * c2
  mul_const c k := c * k
  add_const c k := c + k
  geq_const c k := if c ≥ k then 1 else 0
  encrypt_one := 1
  decrypt_add _ _ _ := rfl
  decrypt_sub _ _ _ := rfl
  decrypt_mul _ _ _ := rfl
  decrypt_mul_const _ _ _ := rfl
  decrypt_add_const _ _ _ := rfl
  decrypt_geq_const _ _ _ := rfl
  decrypt_one _ := rfl

def testFheMarking : FheMarking TestPlace ℤ :=
  fun | p0 => 1

def testMarking : Marking TestPlace :=
  Finsupp.single p0 1

theorem testFheMatching : FheMarking.Matches trivialFheScheme () testFheMarking testMarking := by
  intro p
  cases p
  · simp [testFheMarking, testMarking]

/-- A simple test declaration. -/
def test_fhe_hdl : Bool :=
  decide (testCompiledModule.name = "petri_controller")



end ProcInt
