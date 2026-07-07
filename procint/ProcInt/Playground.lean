-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.ConformanceWalkthrough
import ProcInt.Playground.PetriFiringWalkthrough
import ProcInt.Playground.WorkflowNetWalkthrough
import ProcInt.Playground.LogsModelsWalkthrough
import ProcInt.Playground.AnalyticsWalkthrough
import ProcInt.Playground.OcelWalkthrough
import ProcInt.Playground.FoundationsRegistryWalkthrough
import ProcInt.Playground.AlignmentWalkthrough
import ProcInt.Playground.QualityWalkthrough
import ProcInt.Playground.XesWalkthrough
import ProcInt.Playground.CausalNetWalkthrough
import ProcInt.Playground.ChoiceGraphWalkthrough
import ProcInt.Playground.DeclareWalkthrough
import ProcInt.Playground.PowlProcessTreeWalkthrough
import ProcInt.Playground.OcelLifecycleRelationsWalkthrough
import ProcInt.Playground.PetriReachabilityWalkthrough
import ProcInt.Playground.PetriAdvancedWalkthrough
import ProcInt.Playground.WorkflowAdvancedWalkthrough
import ProcInt.Playground.AnalyticsRelationsWalkthrough
import ProcInt.Playground.AnalyticsTemporalWalkthrough

/-! # ProcInt.Playground

Hand-authored demonstration surface: worked instances of ProcInt algorithms
applied to concrete data, showing the library "used in production" rather
than declared in the abstract. Every file here imports `ProcInt` as an
ordinary consumer and cites the ledgered definition/theorem it demonstrates.

Not rendered by ggen, not ledgered in `.mfact/artifacts.toml`, not part of
`defaultTargets` or `testDriver` — built only via `lake build Playground`
/ `just playground`. A failure here is an ordinary code-review issue, never
`ARTIFACT_DRIFT_REFUSED` or a release-standing regression. -/
