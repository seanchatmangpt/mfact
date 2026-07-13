-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import Mathlib.Tactic.TypeStar
import Mathlib.Data.Finset.Defs

/-!
# Obligation (Wave M0 — Crown I, obligation geometry)

Pipeline:
`abstract obligation universe → context/support vocabulary (this file) → entailment order
(EntailmentOrder.lean) → minimal support (MinimalSupport.lean) → residue antichain
(Antichain.lean)`.

Crown law:
Crown I types the residue as `ρ : State × Goal → Antichain (Finset Obligation)`
(`ROADMAP_MATH_SPINE.md` §1), not as a single residue state. This file fixes only the
vocabulary the rest of Wave M0 shares. The obligation universe itself is left an arbitrary
`Type*` everywhere downstream — no concrete representation (no RDF triple, no PDDL literal, no
receipt event) is hard-coded here or anywhere in this wave. Concrete instantiations are a later,
separate admission, out of scope for Wave M0 ("Definitions: obligation; admitted obligation
preorder; support; pointwise load-bearing minimality; `ρ` as the minimal-support antichain. No
broad crown theorem in this wave.").

Preserves:
full genericity over `Obligation`; every downstream file states its own hypotheses
(`DecidableEq`, a closure operator, ...) explicitly rather than inheriting an implicit
representation from this file.

Excludes:
any concrete obligation representation, closure operator, or entailment relation — those are
introduced as explicit parameters starting in `EntailmentOrder.lean`. This file proves nothing;
it only names the two roles (`Context`, `Support`) that `Finset Obligation` plays in the
roadmap's notation `C(G ∪ S) ⊨ g`.

Standing:
Wave M0 definitional scaffold (`ROADMAP_MATH_SPINE.md` §4, "Wave M0 — Obligation geometry").
No theorem is claimed by this file.

Downstream:
`EntailmentOrder.lean`, `MinimalSupport.lean`, `Antichain.lean`.
-/

namespace ProcInt.MFW.Residue

/-- A *context* (`G` in the roadmap notation) is a finite set of already-admitted obligations
against which further entailment is checked. Structurally just `Finset Obligation` — no
constructor beyond finite-set formation is assumed; `Obligation` itself stays fully abstract. -/
abbrev Context (Obligation : Type*) := Finset Obligation

/-- A *support* (`S` in the roadmap notation) is a finite set of candidate obligations proposed
to entail a goal on top of a context. Structurally identical to `Context`; kept as a distinct
abbreviation only to preserve the roadmap's role distinction between "what is already admitted"
(`Context`) and "what is being proposed to close the gap" (`Support`). -/
abbrev Support (Obligation : Type*) := Finset Obligation

end ProcInt.MFW.Residue
