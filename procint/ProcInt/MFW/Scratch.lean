namespace Scratch

opaque DefectVector_impl : Type
def DefectVector : Type := Option DefectVector_impl

instance : Inhabited DefectVector where
  default := none

opaque Voice : Type

opaque CTQDerivation : Voice → DefectVector

end Scratch
