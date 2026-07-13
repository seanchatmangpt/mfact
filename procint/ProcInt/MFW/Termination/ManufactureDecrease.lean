-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Termination.ObligationRank
import Mathlib.Data.Multiset.AddSub

/-!
# Manufacture step (Wave M1 — Crown II, productive descent)

Pipeline:
`ObligationRank.lean (CrownState, rank) → this file (ManufactureStep) → MultisetDescent.lean
(crown_multiset_strictly_decreases) → CrownWellFounded.lean
(no_infinite_productive_mfw_chain)`.

Crown law:
Crown II (`ROADMAP_MATH_SPINE.md` §1, §55): "every admitted recursive manufacture replaces a
frontier obligation by finitely many obligations strictly lower in the admitted obligation
order." `ManufactureStep` is the one-step relation that formalizes exactly that event: a single
resolved obligation `a` is removed from the frontier and replaced by a multiset `children`, every
member of which is strictly `<` `a` in `AdmittedObligationOrder`, while the rest of the frontier
(`common`) is untouched.

Theorem boundary — `manufacture_children_strictly_descend`:
`ROADMAP_MATH_SPINE.md` §4 (Wave M1) names `manufacture_children_strictly_descend` ("every
admitted decomposition replaces a resolved frontier obligation only with obligations strictly
below it") as "not assumed" but "the theorem boundary." This file resolves that instruction by
making the descent condition part of `ManufactureStep`'s *definition* (`∀ c ∈ children, c < a`
below) rather than introducing it a second time as a free-standing `variable` hypothesis or an
`axiom`. Concretely this means: nothing in this wave *proves* that any given real-world
transition satisfies `ManufactureStep` — that a runtime "remove one socket obligation,
manufacture finitely many strictly-smaller obligations" event really is one is exactly the
correspondence obligation (`AGENTS.md` §4) a later, concrete instantiation must discharge by
exhibiting the required `children`/`common`/`a` witness and the `∀ c ∈ children, c < a` proof.
Wave M1 itself only proves what follows *given* that a step meets this definition — restating the
same existential a second time under the name `manufacture_children_strictly_descend` would be a
content-free identity (unfolds to `id` on `ManufactureStep`'s own body) and is deliberately
omitted as redundant scaffolding (`AGENTS.md` §3). The descent clause is visible by name at
`ManufactureStep`'s own definition site instead.

Preserves:
genericity over `Obligation` via `[AdmittedObligationOrder Obligation]`
(`Residue/EntailmentOrder.lean:53`, imported transitively through `ObligationRank.lean`).

Excludes:
any claim that a concrete workflow engine's transition relation satisfies `ManufactureStep` —
that is a separate, later correspondence admission (`AGENTS.md` §4), out of scope here.

Standing:
definitional scaffold only, no theorem in this file.

Downstream:
`MultisetDescent.lean`, `CrownWellFounded.lean`.
-/

namespace ProcInt.MFW.Termination

open ProcInt.MFW.Residue

variable {Obligation : Type*} [AdmittedObligationOrder Obligation]

/-- One admitted manufacture step: the frontier `s.frontier` is `common + {a}` (a single resolved
obligation `a` sitting above an untouched remainder `common`), and the successor frontier
`s'.frontier` is `common + children`, where every member of `children` is strictly below `a` in
`AdmittedObligationOrder` — Crown II's "replaces a frontier obligation by finitely many
obligations strictly lower in the admitted obligation order" (`ROADMAP_MATH_SPINE.md` §55), read
directly off a single step. The `∀ c ∈ children, c < a` clause *is*
`manufacture_children_strictly_descend`: see "Theorem boundary" above for why it lives here,
definitionally, rather than as a separately named hypothesis. -/
def ManufactureStep (s s' : CrownState Obligation) : Prop :=
  ∃ (a : Obligation) (children common : Multiset Obligation),
    s.frontier = common + {a} ∧ s'.frontier = common + children ∧ ∀ c ∈ children, c < a

end ProcInt.MFW.Termination
