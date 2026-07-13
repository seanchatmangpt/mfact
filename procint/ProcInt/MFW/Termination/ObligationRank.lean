-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.EntailmentOrder
import Mathlib.Data.Multiset.Basic

/-!
# Obligation rank (Wave M1 — Crown II, productive descent)

Pipeline:
`Residue/EntailmentOrder.lean (AdmittedObligationOrder) → this file (CrownState, rank) →
ManufactureDecrease.lean (ManufactureStep) → MultisetDescent.lean
(crown_multiset_strictly_decreases) → CrownWellFounded.lean
(no_infinite_productive_mfw_chain)`.

Crown law:
Crown II (`ROADMAP_MATH_SPINE.md` §1, §4 "Wave M1 — Dershowitz–Manna crown descent") measures a
workflow by the multiset of its currently-open frontier obligations and shows recursive
manufacture strictly decreases that multiset in the Dershowitz–Manna extension of
`AdmittedObligationOrder`. This file fixes the carrier the rest of Wave M1 measures:
`CrownState`, a frontier of obligations, and `rank`, the projection onto the
`Multiset Obligation` that `Mathlib.Data.Multiset.DershowitzManna` orders.

Carrier choice:
`CrownState` is *new* work — Wave M0 (`Residue/*.lean`) never packages a workflow's open
obligations as a single object, only `Context`/`Support` (`Finset Obligation`) for a single
entailment check. Wave M1 needs a `Multiset`, not a `Finset`: `Multiset.IsDershowitzMannaLT`
(`Mathlib.Data.Multiset.DershowitzManna`) is stated over `Multiset α`, and a genuine workflow
frontier can hold the same obligation open at two independent sockets simultaneously (finset
dedup would silently conflate them, understating the measure and making a descent step that adds
a duplicate look like no descent at all). `CrownState` is kept to the one field the roadmap's
Wave M1 target needs — `frontier` — rather than modelling the rest of a workflow's state; the
manufacture relation (`ManufactureDecrease.lean`) is likewise stated purely in terms of frontier
rewriting. `rank` is the identity projection onto that field, named separately from
`CrownState.frontier` only so downstream files (`MultisetDescent.lean`,
`CrownWellFounded.lean`) can cite "the rank function" by the roadmap's own vocabulary
(`ROADMAP_MATH_SPINE.md` §4: "the active obligation multiset") without every call site spelling
out `.frontier`.

Preserves:
genericity over `Obligation` via `[AdmittedObligationOrder Obligation]`
(`Residue/EntailmentOrder.lean:53`) — the only Wave M0 object this wave actually needs. No
dependency on `Residue`'s closure operator, entailment, support, or antichain machinery: those
answer "which obligations are in this minimal support" (Crown I), a different question from "does
the frontier multiset strictly descend" (Crown II). See the correction below.

Excludes:
`Residue.residue`, `Residue.residue_isAntichain`, and `Residue.residue_purity` are *not* imported
or used anywhere in Wave M1. `MFW_WORKFLOW_CATALOG.md` §1.1 ("Real math assets") lists
`residue_isAntichain` and `residue_purity` alongside `AdmittedObligationOrder` as if all three
were Wave-M1 scaffolding composed with `wellFounded_isDershowitzMannaLT`; that overstates the
dependency. Only `AdmittedObligationOrder` is load-bearing here — the antichain and purity
theorems are Crown I (minimal-residue) facts about a single entailment check, not premises of the
Crown II descent argument. The correction is recorded in this wave's ledger entry rather than
silently reproduced.

Standing:
definitional scaffold only, no theorem in this file (mirrors Wave M0's `Obligation.lean`/
`EntailmentOrder.lean` convention of separating vocabulary from proof).

Downstream:
`ManufactureDecrease.lean`, `MultisetDescent.lean`, `CrownWellFounded.lean`.
-/

namespace ProcInt.MFW.Termination

open ProcInt.MFW.Residue

/-- A *crown state*: the multiset of currently-open frontier obligations a workflow is measured
by. A `Multiset`, not a `Finset` (`ObligationRank.lean`, "Carrier choice"): the same obligation
may sit open at two independent sockets at once, and the Dershowitz–Manna order
(`Mathlib.Data.Multiset.DershowitzManna`) that Wave M1 descends in is itself a `Multiset` order. -/
structure CrownState (Obligation : Type*) where
  /-- The open frontier obligations, with multiplicity. -/
  frontier : Multiset Obligation

variable {Obligation : Type*} [AdmittedObligationOrder Obligation]

/-- The *rank* of a crown state: its frontier multiset, viewed as the object that
`Multiset.IsDershowitzMannaLT` orders. Definitionally `CrownState.frontier`; named separately so
`MultisetDescent.lean` and `CrownWellFounded.lean` can cite "the rank function" by the roadmap's
vocabulary (`ROADMAP_MATH_SPINE.md` §4) without unfolding the structure at every call site. -/
def rank (s : CrownState Obligation) : Multiset Obligation := s.frontier

end ProcInt.MFW.Termination
