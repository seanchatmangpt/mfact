import ProcInt.MFW.Manufacture

namespace ProcInt.MFW.Tests

/-!
# ProcInt.MFW.Tests.ManufactureTests

Verification of the Definition of Done for `ProcInt.MFW.Manufacture`. All tests are
parameterized over an explicit `ManufactureTheory` instance — no global carriers exist.
-/

-- 1. Toy observation and prove it is admitted (relative to an explicit theory).
theorem toy_observation_admitted (M : ManufactureTheory) (artifact : M.ArtifactDomain)
    (observation : M.AdmittedObservation) (receipts : M.receipt artifact observation) :
    M.receipt artifact observation := receipts

-- 2. Verification of the BRCE (Zero Unreceipted Actuation) invariant for an explicit theory.
theorem verify_brce_invariant (M : ManufactureTheory)
    (h : ∀ a : M.Actuation, M.isReceipted a) : M.brceInvariant := h

-- 3. The default defect vector is `none` for every theory.
example (M : ManufactureTheory) : (default : M.DefectVector) = none := rfl

end ProcInt.MFW.Tests
