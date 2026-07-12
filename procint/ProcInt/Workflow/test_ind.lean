import Mathlib.Data.Finset.Basic
import ProcInt.Petri.Reachability
open ProcInt

lemma test_induction (P : Type) (N : PetriNet P P) (M1 M2 : Marking P) (h : N.Reaches M1 M2) : True := by
  induction h with
  | refl => trivial
  | tail a b c =>
    trace_state
