-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import ProcInt.Tests.Petri
import ProcInt.Tests.Logs
import ProcInt.Tests.Conformance
import ProcInt.Tests.Ocel
import ProcInt.Tests.Models
import ProcInt.Fixtures.Positive
import ProcInt.Fixtures.Negative

/-! # ProcInt.Tests

Correctness-ladder umbrella: importing this module elaborates every oracle fixture, negative fixture, and law instance; lake test builds it as the test driver. A fixture failure is an elaboration failure — there is no separate test runner to disagree with the kernel. -/

namespace ProcInt

/-- Marker for the test surface: its elaboration means every imported
fixture module was kernel-admitted. -/
def testSurface : String := "correctness-ladder" 


end ProcInt
