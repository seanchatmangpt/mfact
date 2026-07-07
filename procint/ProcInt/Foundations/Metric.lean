-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Foundations.Metric

Metric-law foundations: the unit-interval rational carrier for every conformance metric (fitness, precision, generalization, simplicity all lie in [0,1] — Carmona et al. 2018, Conformance Checking; wasm4pm-compat METRIC_LAW Between01), plus the specification records targeted by the generated algorithm and breed registries (van der Aalst 2016, Process Mining 2nd ed.). -/

namespace ProcInt

/-- A rational number confined to the unit interval [0, 1] — the carrier of
every conformance metric (fitness, precision, generalization, simplicity)
per the wasm4pm-compat METRIC_LAW (Between01). -/
def UnitRat := {q : ℚ // 0 ≤ q ∧ q ≤ 1}

/-- Coerce a unit rational to its underlying rational value. -/
instance instCoeUnitRatRat : Coe UnitRat ℚ := ⟨Subtype.val⟩

/-- A unit rational is nonnegative (lower metric-law bound). -/
theorem unitRat_nonneg (q : UnitRat) : (0 : ℚ) ≤ q.val := q.property.1

/-- A unit rational is at most one (upper metric-law bound). -/
theorem unitRat_le_one (q : UnitRat) : q.val ≤ 1 := q.property.2

/-- Specification record for a process-intelligence algorithm — one row of
the 60-algorithm registry (van der Aalst 2016, Process Mining 2nd ed.). -/
structure AlgorithmSpec where
  id : String
  label : String
  category : String
  outputType : String
  citation : String
  deriving Repr, DecidableEq

/-- Specification record for a cognition breed — one row of the 55-breed
registry mirrored from the wasm4pm compat ontology. -/
structure BreedSpec where
  id : String
  label : String
  doc : String
  citation : String
  deriving Repr, DecidableEq


end ProcInt
