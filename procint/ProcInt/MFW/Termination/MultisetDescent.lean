-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Termination.ManufactureDecrease
import Mathlib.Data.Multiset.DershowitzManna

/-!
# Crown multiset descent (Wave M1 — Crown II, productive descent)

Pipeline:
`ManufactureDecrease.lean (ManufactureStep) → this file
(crown_multiset_strictly_decreases) → CrownWellFounded.lean
(no_infinite_productive_mfw_chain)`.

Crown law:
Crown II's descent claim (`ROADMAP_MATH_SPINE.md` §51–55) stated in Mathlib's own vocabulary: one
`ManufactureStep` is one step down in `Multiset.IsDershowitzMannaLT`
(`Mathlib.Data.Multiset.DershowitzManna`, pinned rev `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`).
The witness is read directly off `ManufactureStep`'s own existential: `X := common`,
`Y := children`, `Z := {a}`.

Preserves:
genericity over `Obligation` via `[AdmittedObligationOrder Obligation]`. Needs only
`[Preorder Obligation]` (supplied by `AdmittedObligationOrder`) to state
`Multiset.IsDershowitzMannaLT` — `WellFoundedLT` is not required until
`CrownWellFounded.lean`.

Excludes:
well-foundedness itself (`CrownWellFounded.lean`); this file proves only the one-step descent.

Standing:
`crown_multiset_strictly_decreases` is `PROVEN` in this file (kernel-checked by
`lake build ProcInt.MFW.Termination.MultisetDescent`), unconditionally for any
`[AdmittedObligationOrder Obligation]`. No `sorry`.

Falsifier:
a `ManufactureStep` witness whose `rank` does not strictly descend in
`Multiset.IsDershowitzMannaLT` — impossible by construction here, since the four
`IsDershowitzMannaLT` conjuncts are discharged directly from `ManufactureStep`'s own equalities
and descent clause, with no extra assumption smuggled in.

Downstream:
`CrownWellFounded.lean`.
-/

namespace ProcInt.MFW.Termination

open ProcInt.MFW.Residue

variable {Obligation : Type*} [AdmittedObligationOrder Obligation]

/-- Crown II's one-step descent theorem: a `ManufactureStep` from `s` to `s'` is a
Dershowitz–Manna descent from `rank s'` to `rank s` (note the direction — `IsDershowitzMannaLT`
reads "smaller, bigger", and the *successor* frontier `rank s'` is the smaller multiset). The
witness `⟨common, children, {a}⟩` is read straight off `h`: `Z = {a} ≠ ∅` since `{a}` is a
singleton; `rank s' = common + children` is `h`'s own successor-frontier equality; `rank s =
common + {a}` is `h`'s own predecessor-frontier equality; and `∀ c ∈ children, ∃ z ∈ {a}, c < z`
is `h`'s own descent clause, instantiated at the unique member `z := a` of `{a}`. -/
theorem crown_multiset_strictly_decreases {s s' : CrownState Obligation}
    (h : ManufactureStep s s') :
    Multiset.IsDershowitzMannaLT (rank s') (rank s) := by
  obtain ⟨a, children, common, hs, hs', hlt⟩ := h
  refine ⟨common, children, {a}, ?_, hs', hs, ?_⟩
  · simp
  · intro c hc
    exact ⟨a, Multiset.mem_singleton_self a, hlt c hc⟩

end ProcInt.MFW.Termination
