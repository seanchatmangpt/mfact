-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Logs.Event
import ProcInt.Logs.Trace
import ProcInt.Conformance.TokenReplay

/-! # ProcInt.Fixtures.Positive

Positive fixtures: concrete well-formed instances exercised by direct computation, the Lean analogue of wasm4pm-compat tests/smoke_models.rs. Each example is decidable and checked at elaboration time — there is no separate test runner. -/

namespace ProcInt

/-- A perfect-replay `ReplayCounts` instance (produced = consumed = 4, no
missing, no remaining) has fitness exactly 1 — mirrors
`calculate_fitness(4,4,0,0) = 1.0` in wasm4pm-compat src/conformance.rs. -/
example :
    fitness ⟨4, 4, 0, 0, by decide, by decide⟩ = 1 :=
  fitness_perfect _ rfl rfl

/-- A trace of three events fired at non-decreasing timestamps 0, 5, 5 is
monotone by direct computation. -/
example :
    Trace.Monotone
      (⟨"case-1", [Event.simple "a" 0, Event.simple "b" 5, Event.simple "c" 5]⟩ :
        Trace String) := by
  unfold Trace.Monotone
  decide


end ProcInt
