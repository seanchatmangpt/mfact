-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.EntailmentOrder
import Mathlib.Data.Finset.Erase
import Mathlib.Data.Finset.Lattice.Basic

/-!
# Minimal support (Wave M0 — Crown I, obligation geometry)

Pipeline:
`EntailmentOrder.lean (C, Entails) → this file (support, pointwise load-bearing minimality) →
Antichain.lean (ρ)`.

Crown law:
a support `S` for goal `g` given context `G` is *sufficient* when `C(G ∪ S) ⊨ g`, and
*pointwise load-bearing* when every one of its members is individually necessary: removing any
single obligation breaks sufficiency, `∀ a ∈ S, C(G ∪ (S \ {a})) ⊭ g`
(`ROADMAP_MATH_SPINE.md` §4, Wave M0 definitions).

Preserves:
genericity over `Obligation` (with `DecidableEq` for `Finset.erase`/`Finset.union`) and over the
semantic closure `C`.

Excludes:
the antichain/residue-set packaging (`Antichain.lean`) and any claim that pointwise
load-bearing minimality is the *only* reasonable minimality notion — it is the one the roadmap
names, and (`eq_of_subset_of_sufficient_of_isMinimalSupport` below) it is provably equivalent,
given `C` monotone, to full inclusion-minimality (no proper subset of `S` is sufficient).

Standing:
`residue_supports_goal`, `residue_atoms_load_bearing`,
`residue_support_and_pointwise_load_bearing`, and
`eq_of_subset_of_sufficient_of_isMinimalSupport` are `PROVEN` in this file (kernel-checked by
`lake build ProcInt.MFW.Residue.MinimalSupport`), unconditionally for any
`C : SemanticClosure Obligation`. No `sorry`.

Falsifier:
a reported minimal support with a proper subset that is still sufficient — this is exactly what
`eq_of_subset_of_sufficient_of_isMinimalSupport` forbids.

Downstream:
`Antichain.lean`.
-/

namespace ProcInt.MFW.Residue

variable {Obligation : Type*} [DecidableEq Obligation]

/-- `S` is *sufficient* for goal `g` relative to context `G` under closure `C`:
`C(G ∪ S) ⊨ g`. -/
def IsSufficient (C : SemanticClosure Obligation) (G : Context Obligation) (g : Obligation)
    (S : Support Obligation) : Prop :=
  Entails C (G ∪ S) g

/-- Pointwise load-bearing minimality: every obligation of `S` is individually necessary —
removing any single one breaks sufficiency, `∀ a ∈ S, C(G ∪ (S \ {a})) ⊭ g`. -/
def IsPointwiseLoadBearing (C : SemanticClosure Obligation) (G : Context Obligation)
    (g : Obligation) (S : Support Obligation) : Prop :=
  ∀ a ∈ S, ¬ IsSufficient C G g (S.erase a)

/-- `S` is a *minimal support* for `g` given `G` under `C`: sufficient and pointwise
load-bearing. This is `ρ`'s membership predicate; `Antichain.lean` packages the resulting set
as the antichain `ρ(G,g)`. -/
def IsMinimalSupport (C : SemanticClosure Obligation) (G : Context Obligation) (g : Obligation)
    (S : Support Obligation) : Prop :=
  IsSufficient C G g S ∧ IsPointwiseLoadBearing C G g S

variable {C : SemanticClosure Obligation} {G : Context Obligation} {g : Obligation}
  {S T U : Support Obligation}

/-- Every minimal support actually entails the goal (the sufficiency half of
`residue_support_and_pointwise_load_bearing`). -/
theorem residue_supports_goal (h : IsMinimalSupport C G g S) : IsSufficient C G g S :=
  h.1

/-- Every member of a minimal support is individually necessary — removing it breaks
sufficiency (the pointwise load-bearing half of `residue_support_and_pointwise_load_bearing`). -/
theorem residue_atoms_load_bearing (h : IsMinimalSupport C G g S) :
    IsPointwiseLoadBearing C G g S :=
  h.2

/-- The Wave M0 target theorem, stated in the roadmap's own notation:
`S ∈ ρ(G,g) ⇒ [C(G ∪ S) ⊨ g ∧ ∀ a ∈ S, C(G ∪ (S \ {a})) ⊭ g]`.
Membership in the minimal-support predicate is exactly this conjunction; this theorem is the
public API that decouples callers from `IsMinimalSupport`'s internal shape. -/
theorem residue_support_and_pointwise_load_bearing (h : IsMinimalSupport C G g S) :
    IsSufficient C G g S ∧ ∀ a ∈ S, ¬ IsSufficient C G g (S.erase a) :=
  h

/-- Given a monotone closure, pointwise load-bearing minimality (removing any *one* member of a
minimal support breaks sufficiency) already forces full inclusion-minimality: no proper
sub-support of a minimal support is sufficient. This is the key lemma behind both
`residue_is_antichain` and `orFree_residue_subsingleton` in `Antichain.lean`: a smaller
sufficient support would witness a proper subset of `T` that is still sufficient, and
monotonicity lets that proper subset be enlarged back up to `T` minus one point, contradicting
load-bearing minimality at that point. -/
theorem eq_of_subset_of_sufficient_of_isMinimalSupport
    (hT : IsMinimalSupport C G g T) (hU : IsSufficient C G g U) (hUT : U ⊆ T) : U = T := by
  by_contra hne
  obtain ⟨a, haT, haU⟩ :=
    (Finset.ssubset_iff_of_subset hUT).mp (Finset.ssubset_iff_subset_ne.mpr ⟨hUT, hne⟩)
  have hUsub : U ⊆ T.erase a := by
    intro x hx
    refine Finset.mem_erase.mpr ⟨?_, hUT hx⟩
    rintro rfl
    exact haU hx
  have hmono : G ∪ U ⊆ G ∪ T.erase a := Finset.union_subset_union_right hUsub
  have hsuff : IsSufficient C G g (T.erase a) := C.monotone hmono hU
  exact hT.2 a haT hsuff

end ProcInt.MFW.Residue
