namespace ProcInt.MFW

/-- [Notation Authority §1] The space of observations. -/
opaque ObservationSpace : Type

/-- [Notation Authority §1] The space of admitted observations. -/
opaque AdmittedObservation : Type

/-- [Notation Authority §2] The domain of manufactured artifacts. -/
opaque ArtifactDomain : Type

/-- [Notation Authority §2] The manufacturing law mapping admitted observations to artifacts. -/
opaque manufacturingLaw : ArtifactDomain → ObservationSpace → Prop

/-- [Notation Authority §3] The artifact-standing predicate. -/
opaque stand : ArtifactDomain → Prop

/-- [Notation Authority §4] The receipt relation mapping artifacts and observations. -/
opaque receipt : ArtifactDomain → AdmittedObservation → Prop

/-- [Notation Authority §5] The actuation of an artifact. -/
opaque Actuation : Type

/-- Checks if an actuation is receipted. -/
opaque isReceipted : Actuation → Prop

/-- [Notation Authority §5] The Zero Unreceipted Actuation invariant. -/
def brceInvariant : Prop :=
  ∀ a : Actuation, isReceipted a

opaque DefectVectorImpl : Type

/-- [Notation Authority §6] Defect vector for quality checking. -/
def DefectVector : Type := Option DefectVectorImpl

instance : Inhabited DefectVector where
  default := none

/-- [Notation Authority §6] Voice of customer representation. -/
opaque Voice : Type

/-- [Notation Authority §6] CTQ derivation function. -/
opaque ctqDerivation : Voice → DefectVector

/-- [Notation Authority §15] Rice Containment semantic domain constraint. -/
opaque riceContainment : ArtifactDomain → Prop

end ProcInt.MFW
