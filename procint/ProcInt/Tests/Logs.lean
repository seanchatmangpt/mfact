-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Logs.Event
import ProcInt.Logs.Trace

/-! # ProcInt.Tests.Logs

Event-log oracles (Level 1): activity projection and timestamp monotonicity on concrete traces, decided by the kernel. -/

namespace ProcInt

-- Activities projection oracle.
#guard (Trace.activities ⟨"c", [Event.simple "a" 0, Event.simple "b" 5]⟩ : List String) == ["a", "b"]
-- Monotone oracle trace (equal timestamps allowed: non-strict order).
example : Trace.Monotone (⟨"c", [Event.simple "a" 0, Event.simple "b" 0, Event.simple "c" 7]⟩ : Trace String) := by
  unfold Trace.Monotone; decide


end ProcInt
