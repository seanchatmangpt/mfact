namespace ProcInt.MFW

/-- Explicit hypothesis bundle for the manufacturing signature.

Previously these carriers and operations were global bodyless `opaque` declarations, which
function as unmarked axioms. Bundling them as structure fields makes every assumption a
visible hypothesis: consumers must take an explicit `(M : ManufactureTheory)` instead of
relying on hidden global constants. No field carries a construction or a proof — this record
declares an interface, not standing. -/
structure ManufactureTheory where
  /-- [Notation Authority §1] The space of observations. -/
  ObservationSpace : Type
  /-- [Notation Authority §1] The space of admitted observations. -/
  AdmittedObservation : Type
  /-- [Notation Authority §2] The domain of manufactured artifacts. -/
  ArtifactDomain : Type
  /-- [Notation Authority §2] The manufacturing law mapping admitted observations to artifacts. -/
  manufacturingLaw : ArtifactDomain → ObservationSpace → Prop
  /-- [Notation Authority §3] The artifact-standing predicate. -/
  stand : ArtifactDomain → Prop
  /-- [Notation Authority §4] The receipt relation mapping artifacts and observations. -/
  receipt : ArtifactDomain → AdmittedObservation → Prop
  /-- [Notation Authority §5] The actuation of an artifact. -/
  Actuation : Type
  /-- Checks if an actuation is receipted. -/
  isReceipted : Actuation → Prop
  /-- Implementation carrier for defect vectors. -/
  DefectVectorImpl : Type
  /-- [Notation Authority §6] Voice of customer representation. -/
  Voice : Type
  /-- [Notation Authority §6] CTQ derivation function. Returns `none` when no defect vector
  is derivable from the given voice. -/
  ctqDerivation : Voice → Option DefectVectorImpl
  /-- [Notation Authority §15] Rice Containment semantic domain constraint. -/
  riceContainment : ArtifactDomain → Prop

/-- [Notation Authority §5] The Zero Unreceipted Actuation invariant, relative to a theory. -/
def ManufactureTheory.brceInvariant (M : ManufactureTheory) : Prop :=
  ∀ a : M.Actuation, M.isReceipted a

/-- [Notation Authority §6] Defect vector for quality checking, relative to a theory. -/
abbrev ManufactureTheory.DefectVector (M : ManufactureTheory) : Type :=
  Option M.DefectVectorImpl

instance (M : ManufactureTheory) : Inhabited M.DefectVector where
  default := none

end ProcInt.MFW
