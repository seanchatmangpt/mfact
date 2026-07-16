import ProcInt.MFW.ModuleMap
import ProcInt.MFW.QLens
import ProcInt.MFW.Tests

/-! # ProcInt library root

Re-exports the main modules from `ProcInt.MFW`. `ModuleMap` transitively imports every
core MFW module (TransformBasic, Concurrency, Kernel, Observability, FiberEntropy,
IntrinsicDimension, ObservableBasis, SpectrumBundle, Manufacture, ExploreExploit,
Falsification, CompilerPipeline, Ledger), so only it, `QLens`, and `Tests` need to be
listed explicitly here — keep it that way rather than re-adding direct imports that
`ModuleMap` already covers, so the dependency graph doesn't have to be kept in sync by hand
in two places.
-/
