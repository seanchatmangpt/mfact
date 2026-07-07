-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net

/-! # ProcInt.Petri.OCPN

Object-centric Petri nets (van der Aalst and Berti, Fundamenta Informaticae 2020, Def. 5.1-5.3): places typed by object types via pt : P → OT, variable arcs as a predicate on transition-place adjacencies, well-formedness as per-transition type disjointness between variable and non-variable arcs, and colored markings as multisets of (place, object) pairs with a typing conformance predicate proven closed under multiset union and sub-multisets. Ported from ObjectCentricPetriNet in wasm4pm-compat src/petri.rs. -/

namespace ProcInt

/-- Object-centric Petri net (van der Aalst & Berti 2020, Def. 5.1): a Petri net whose
places are typed by object types via pt : P → OT, and whose transition/place adjacencies
may be marked as variable arcs (Fvar). Ported from ObjectCentricPetriNet in
wasm4pm-compat petri.rs. -/
structure OCPN (P T OT : Type) where
  net : PetriNet P T
  pt : P → OT
  varArc : T → P → Prop

/-- Place p is adjacent to transition t: p occurs in the pre- or post-multiset of t. -/
def OCPN.Adjacent {P T OT : Type} (C : OCPN P T OT) (t : T) (p : P) : Prop :=
  C.net.pre t p ≠ 0 ∨ C.net.post t p ≠ 0

/-- Well-formedness (van der Aalst & Berti 2020, Def. 5.3): at each transition, the object
types consumed through variable arcs and through non-variable arcs are disjoint. -/
def OCPN.WellFormed {P T OT : Type} (C : OCPN P T OT) : Prop :=
  ∀ t p q, C.Adjacent t p → C.Adjacent t q → C.varArc t p → ¬ C.varArc t q →
    C.pt p ≠ C.pt q

/-- Colored marking (van der Aalst & Berti 2020, Def. 5.2): a multiset of (place, object)
token pairs. -/
abbrev ColoredMarking (P Obj : Type) := Multiset (P × Obj)

/-- A colored marking conforms to the typing: every token's object type matches the type of
the place it sits on (van der Aalst & Berti 2020, Def. 5.2, typed token games). -/
def OCPN.Conforms {P T OT Obj : Type} (C : OCPN P T OT) (otyp : Obj → OT)
    (M : ColoredMarking P Obj) : Prop :=
  ∀ pr ∈ M, otyp pr.2 = C.pt pr.1

/-- Conformance is closed under multiset union: adding conforming tokens to a conforming
colored marking stays conforming (needed for the OCPN firing rule, Def. 5.3). -/
theorem OCPN.conforms_add {P T OT Obj : Type} (C : OCPN P T OT) (otyp : Obj → OT)
    {M₁ M₂ : ColoredMarking P Obj}
    (h₁ : C.Conforms otyp M₁) (h₂ : C.Conforms otyp M₂) :
    C.Conforms otyp (M₁ + M₂) := by
  intro pr hpr
  rcases Multiset.mem_add.mp hpr with h | h
  · exact h₁ pr h
  · exact h₂ pr h

/-- Conformance is closed under sub-multisets: consuming tokens preserves conformance
(the token-consumption half of the OCPN firing rule). -/
theorem OCPN.conforms_of_le {P T OT Obj : Type} (C : OCPN P T OT) (otyp : Obj → OT)
    {M₁ M₂ : ColoredMarking P Obj}
    (hle : M₁ ≤ M₂) (h₂ : C.Conforms otyp M₂) : C.Conforms otyp M₁ :=
  fun pr hpr => h₂ pr (Multiset.mem_of_le hle hpr)


end ProcInt
