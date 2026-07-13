-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.Obligation
import Mathlib.Order.Closure

/-!
# Entailment order (Wave M0 — Crown I, obligation geometry)

Pipeline:
`Obligation.lean (vocabulary) → this file (admitted obligation order, semantic closure,
entailment) → MinimalSupport.lean (support, minimality) → Antichain.lean (ρ)`.

Crown law:
Crown II (`ROADMAP_MATH_SPINE.md` §1) states that recursive manufacture replaces a frontier
obligation "by finitely many obligations strictly lower in the admitted obligation order"; this
file fixes the vocabulary for that order (`AdmittedObligationOrder`) so Wave M1 can quantify over
it later. Crown I's entailment symbol `C(G ∪ S) ⊨ g` is fixed here as `Entails`, parametrized by
an explicit semantic closure operator — not a hard-coded fixed-point construction over one
concrete obligation representation.

Preserves:
genericity over `Obligation`; the closure operator `C` is taken as an explicit parameter (a
`Mathlib.Order.Closure.ClosureOperator (Finset Obligation)` — monotone, extensive, idempotent)
rather than an arbitrary function, because `residue_purity` (`Antichain.lean`) genuinely needs
all three closure laws and `residue_is_antichain` needs monotonicity; asserting either theorem
for a bare unconstrained function would be false in general. This is a definitional choice for
Wave M0's abstract library, not a claim that any *concrete* instantiation's closure is easy to
admit — concrete admission (e.g. `L = P(Atoms)`, Correction 3 of `ROADMAP_MATH_SPINE.md` §2)
remains separate, later work.

Excludes:
any theorem. This file is definitions only, matching "No broad crown theorem in this wave."
The `AdmittedObligationOrder` class is declared but not used by any Wave M0 theorem — it is
scaffolding for Wave M1 (`manufacture_children_strictly_descend`), named here because the
roadmap's own "Definitions" list for Wave M0 includes "admitted obligation preorder".

Standing:
Wave M0 definitional scaffold (`ROADMAP_MATH_SPINE.md` §4, "Wave M0 — Obligation geometry").

Downstream:
`MinimalSupport.lean`, `Antichain.lean`.
-/

namespace ProcInt.MFW.Residue

/-- The *admitted obligation order* (Crown II, `ROADMAP_MATH_SPINE.md` §1): a preorder on the
obligation universe against which recursive manufacture is later shown (Wave M1) to strictly
descend. A plain type-class alias for `Preorder Obligation` rather than a bare `variable`, so
that a concrete instantiation can register it by name and downstream waves can write
`[AdmittedObligationOrder Obligation]` instead of re-deriving which preorder is "the admitted
one" from context. Wave M0 proves no theorem about this order (no broad crown theorem in this
wave); it is vocabulary for Wave M1. -/
class AdmittedObligationOrder (Obligation : Type*) extends Preorder Obligation

/-- Semantic closure (`C` in the roadmap notation `C(G ∪ S) ⊨ g`) is an explicit parameter
throughout Wave M0: a genuine `Mathlib.Order.Closure.ClosureOperator` on the `Finset Obligation`
partial order (whose order is definitionally `⊆`, `Finset.le_eq_subset`). Concrete
instantiations (out of scope here) must exhibit their own `ClosureOperator`; Wave M0 assumes only
the three standard closure laws (monotone, extensive/`le_closure`, idempotent) that
`ClosureOperator` bundles, and no more. -/
abbrev SemanticClosure (Obligation : Type*) := ClosureOperator (Finset Obligation)

/-- Entailment, `C(X) ⊨ g` in the roadmap notation: the goal `g` is a member of the closure of
`X` under the admitted semantic closure `C`. -/
def Entails {Obligation : Type*}
    (C : SemanticClosure Obligation) (X : Finset Obligation) (g : Obligation) : Prop :=
  g ∈ C X

end ProcInt.MFW.Residue
