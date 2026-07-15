namespace ProcInt.MFW

opaque ObservationSpace : Type

opaque AdmittedObservation : Type

opaque ArtifactDomain : Type

opaque ManufacturingLaw : ArtifactDomain → ObservationSpace → Prop

opaque Stand : ArtifactDomain → Prop

opaque Receipt : ArtifactDomain → AdmittedObservation → Prop

opaque Actuation : Type

opaque isReceipted : Actuation → Prop

def BRCEInvariant : Prop :=
  ∀ a : Actuation, isReceipted a

opaque DefectVector_impl : Type

def DefectVector : Type := Option DefectVector_impl

instance : Inhabited DefectVector where
  default := none

opaque Voice : Type

opaque CTQDerivation : Voice → DefectVector

opaque RiceContainment : ArtifactDomain → Prop

end ProcInt.MFW
