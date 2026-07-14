import Lean

open Lean

structure FiringInput where
  marking : List (String × Nat)
  transitions : List String
  deriving FromJson, ToJson, Repr

def testJsonSerial : String :=
  let input : FiringInput := { marking := [("p1", 2), ("p2", 3)], transitions := ["t1"] }
  (ToJson.toJson input).pretty

#eval testJsonSerial
