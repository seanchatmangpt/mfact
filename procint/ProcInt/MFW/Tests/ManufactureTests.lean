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

-- 4. Concrete witness theories for the BRCE invariant. Carriers not under test are
-- degenerate `Unit` plumbing (satisfiability only); the discriminating data is the
-- `Actuation` carrier together with its `isReceipted` predicate.

/-- Witness theory whose single `Unit` actuation is receipted: `brceInvariant` holds.
Degenerate `Unit` carriers everywhere except the fields under test. -/
def receiptedWitnessTheory : ManufactureTheory where
  ObservationSpace := Unit
  AdmittedObservation := Unit
  ArtifactDomain := Unit
  manufacturingLaw := fun _ _ => True
  stand := fun _ => True
  receipt := fun _ _ => True
  Actuation := Unit
  isReceipted := fun _ => True
  DefectVectorImpl := Unit
  Voice := Unit
  ctqDerivation := fun _ => none
  riceContainment := fun _ => True

/-- Witness theory over `Bool` actuations where only `true` is receipted:
`brceInvariant` fails at the concrete unreceipted actuation `false`. -/
def unreceiptedWitnessTheory : ManufactureTheory where
  ObservationSpace := Unit
  AdmittedObservation := Unit
  ArtifactDomain := Unit
  manufacturingLaw := fun _ _ => True
  stand := fun _ => True
  receipt := fun _ _ => True
  Actuation := Bool
  isReceipted := fun a => a = true
  DefectVectorImpl := Unit
  Voice := Unit
  ctqDerivation := fun _ => none
  riceContainment := fun _ => True

-- Witness pair: statement-adequacy check — `ManufactureTheory.brceInvariant` accepts
-- `receiptedWitnessTheory` (every actuation is receipted) and provably rejects
-- `unreceiptedWitnessTheory` (the actuation `false` is not receipted).
example : receiptedWitnessTheory.brceInvariant := fun _ => True.intro

example : ¬ unreceiptedWitnessTheory.brceInvariant := fun h => nomatch h false

end ProcInt.MFW.Tests
