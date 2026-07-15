structure OpenRealizationSpace deriving Nonempty
structure Contracts deriving Nonempty

def RealizationClass : Type := OpenRealizationSpace → Prop

noncomputable opaque exploit : Contracts → RealizationClass
