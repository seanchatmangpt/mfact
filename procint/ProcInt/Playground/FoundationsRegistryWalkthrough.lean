-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt
import ProcInt.Playground.ConformanceWalkthrough

/-! # Playground: metric foundations and the algorithm/breed catalog

`ProcInt.Foundations.Metric` supplies the unit-interval carrier
(`UnitRat`) every conformance metric lives in, and the `AlgorithmSpec`/
`BreedSpec` record shapes the registry catalogs. This file packages the
`fitness` value from `ConformanceWalkthrough` into a `UnitRat` using the
ledgered `ReplayCounts.fitnessUnit` helper (`Conformance.Quality`), and
looks up two registry entries from the same family of algorithms this
playground exercises. -/

namespace ProcInt.Playground

/-- The token-replay fitness of `sampleReplay` (`ConformanceWalkthrough`),
packaged as a `UnitRat` via the ledgered `ReplayCounts.fitnessUnit`
(`Conformance.Quality`) — this is the carrier every conformance metric
(fitness, precision, generalization, simplicity) is required to live in. -/
def sampleFitnessUnit : UnitRat :=
  sampleReplay.fitnessUnit

example : (sampleFitnessUnit : ℚ) = 67 / 80 := by
  show fitness sampleReplay = 67 / 80
  unfold fitness sampleReplay
  norm_num

/-- Every `UnitRat` is between 0 and 1 — the ledgered bounds, instantiated
on `sampleFitnessUnit`. -/
example : 0 ≤ (sampleFitnessUnit : ℚ) ∧ (sampleFitnessUnit : ℚ) ≤ 1 :=
  ⟨unitRat_nonneg sampleFitnessUnit, unitRat_le_one sampleFitnessUnit⟩

-- The registry entries for two algorithms in the same conformance/discovery
-- family this playground exercises: precision (a cousin metric of
-- fitness, both conformance→analytics) and the DFG discovery this
-- playground's LogsModelsWalkthrough runs.
#eval alg_etconformance_precision.citation
#eval alg_dfg.citation

end ProcInt.Playground
