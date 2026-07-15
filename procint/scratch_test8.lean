structure OpenRealizationSpace deriving Nonempty
structure Contracts deriving Nonempty

def RealizationClass : Type := OpenRealizationSpace → Prop

instance : Nonempty RealizationClass := ⟨fun _ => True⟩

noncomputable opaque exploit : Contracts → RealizationClass
