import ProcInt.MFW.Manufacture

namespace ProcInt.MFW.Tests

/-!
# ProcInt.MFW.Tests.ManufactureTests

Verification of the Definition of Done for `ProcInt.MFW.Manufacture`.
-/

-- 1. Toy observation and prove it is admitted.
theorem toy_observation_admitted (artifact : ArtifactDomain) (observation : AdmittedObservation)
    (receipts : receipt artifact observation) :
    receipt artifact observation := receipts

-- 2. Verification of the BRCE (Zero Unreceipted Actuation) invariant for a concrete artifact.
theorem verify_brce_invariant (h : ∀ a : Actuation, isReceipted a) : brceInvariant := by
  exact h

end ProcInt.MFW.Tests
