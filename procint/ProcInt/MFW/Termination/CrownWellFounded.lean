-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Termination.MultisetDescent

/-!
# Crown well-foundedness (Wave M1 — Crown II, productive descent)

Pipeline:
`MultisetDescent.lean (crown_multiset_strictly_decreases) → this file
(no_infinite_productive_mfw_chain)`.

Crown law:
Crown II's termination consequence (`ROADMAP_MATH_SPINE.md` §49–55): because every
`ManufactureStep` strictly descends in the Dershowitz–Manna order
(`crown_multiset_strictly_decreases`, `MultisetDescent.lean`), and that order is well-founded
over any well-founded base order (`Multiset.wellFounded_isDershowitzMannaLT`,
`Mathlib.Data.Multiset.DershowitzManna`), there is no infinite chain of admitted manufacture
steps. `no_infinite_productive_mfw_chain` is exactly this: the pullback of
`Multiset.wellFounded_isDershowitzMannaLT` along `rank` (`InvImage.wf`), restricted to the
`ManufactureStep` relation via `crown_multiset_strictly_decreases` as the `Subrelation` witness
(`Init.WF`, Lean core).

Preserves:
genericity over `Obligation`; adds exactly the one hypothesis
`Multiset.wellFounded_isDershowitzMannaLT` itself needs beyond `AdmittedObligationOrder`'s
`Preorder`, namely `[WellFoundedLT Obligation]` — the admitted obligation order's `<` is
well-founded. This is a new, explicit hypothesis of this theorem, not something
`AdmittedObligationOrder` (`Residue/EntailmentOrder.lean:53`) already supplies.

Excludes:
any claim that `[WellFoundedLT Obligation]` holds for a *concrete* obligation representation —
that is a separate, later admission for whichever concrete `Obligation` type a runtime engine
instantiates.

Standing:
`no_infinite_productive_mfw_chain` is `PROVEN` in this file (kernel-checked by
`lake build ProcInt.MFW.Termination.CrownWellFounded`), conditional only on
`[AdmittedObligationOrder Obligation]` and `[WellFoundedLT Obligation]`. No `sorry`. This is
Wave M1's target theorem (`ROADMAP_MATH_SPINE.md` §55, Crown II, upgraded from
`TARGET_THEOREM` by this wave for the abstract `CrownState`/`ManufactureStep` carrier — no
concrete workflow engine's transition relation has yet been shown to correspond to
`ManufactureStep`, so this does not yet discharge Crown II for any real MFW instantiation).

Falsifier:
an infinite sequence `s₀, s₁, s₂, …` with `ManufactureStep sᵢ sᵢ₊₁` for every `i` — impossible
given this theorem, since each step would witness an infinite `Multiset.IsDershowitzMannaLT`
descending chain, contradicting `Multiset.wellFounded_isDershowitzMannaLT`.

Downstream:
Wave M2 (`ROADMAP_MATH_SPINE.md` §4, free process monad and grafting) and any concrete
`Obligation`/`ManufactureStep` instantiation.
-/

namespace ProcInt.MFW.Termination

open ProcInt.MFW.Residue

variable {Obligation : Type*} [AdmittedObligationOrder Obligation]

/-- Wave M1's target theorem, stated in the roadmap's own vocabulary
(`ROADMAP_MATH_SPINE.md` §4): no infinite chain of admitted recursive manufacture steps. The
relation is oriented `s' ≺ s ↔ ManufactureStep s s'` (`s'` is "smaller", i.e. reached by
manufacturing *from* `s`), matching `WellFounded`'s usual reading that there is no infinite
`≺`-descending sequence — equivalently, no infinite sequence of admitted manufacture steps
`s₀ ↦ s₁ ↦ s₂ ↦ ⋯`. -/
theorem no_infinite_productive_mfw_chain [WellFoundedLT Obligation] :
    WellFounded (fun (s' s : CrownState Obligation) => ManufactureStep s s') := by
  apply Subrelation.wf (r := InvImage Multiset.IsDershowitzMannaLT rank)
  · intro s' s h
    exact crown_multiset_strictly_decreases h
  · exact InvImage.wf rank Multiset.wellFounded_isDershowitzMannaLT

end ProcInt.MFW.Termination
