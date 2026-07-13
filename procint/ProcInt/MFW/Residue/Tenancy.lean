-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.Antichain
import Mathlib.Data.Finset.Filter
import Mathlib.Data.Finset.Disjoint
import Mathlib.Data.Fin.Basic

/-!
# Tenancy isolation as residue independence (Wave CM2 — Crown residue, cross-tenant purity)

Pipeline:
`Antichain.lean (residue, IsMinimalSupport) → this file (Separated, minimalSupport_tenant_pure,
crossTenant_residue_disjoint) → [MISSING: no downstream file yet]`.

Crown law:
CM2 tenancy isolation, read off `IsMinimalSupport`/`residue` exactly as they already stand: if
membership of a fixed-tenant goal `g` in the semantic closure never depends on obligations tagged
for a different tenant (`Separated`), then every minimal support for `g` is itself tenant-pure
(`minimalSupport_tenant_pure`), and minimal supports for goals of two distinct tenants are
disjoint sets of obligations (`crossTenant_residue_disjoint`). This is the residue-level
statement of "tenant A's proposed unfinished work never leaks into tenant B's residue."

Preserves:
genericity over `Obligation` and `C` inherited from `EntailmentOrder.lean`/`MinimalSupport.lean`/
`Antichain.lean`; adds only `Tenant : Type*` with `DecidableEq` and an explicit tagging function
`tag : Obligation → Tenant`, exactly as needed to state `Separated` and filter by it.

Deliberately weaker hypothesis:
`Separated` is *not* full closure factorization (it does not assert
`C (S ∪ T) = C S ∪ C T` for same/different-tenant `S`, `T`); it only asserts that membership of a
*fixed-tenant goal* depends solely on *same-tenant inputs*:
`g ∈ C X ↔ g ∈ C (X.filter (tag · = tag g))`. This is the minimal hypothesis both theorems below
actually consume — proving them from the stronger factorization law would be sound but would
silently overclaim what the residue geometry needs.

Excludes:
the "composed with boundary cuts" extension mentioned in the wave brief. The DAG/Region boundary
theorems in `ProcInt.Workflow.Multifractal` are a genuinely different object; no correspondence
morphism between them and `Residue.residue` is admitted here, so no composed theorem is proved
or implied (`MISSING` edge, `AGENTS.md` §4 taxonomy). Also excludes full closure factorization
(see above) — only the goal-filtered form is proved.

Standing:
`minimalSupport_tenant_pure` and `crossTenant_residue_disjoint` are `PROVEN` in this file
(kernel-checked by `lake build ProcInt.MFW.Residue.Tenancy`), unconditionally for any
`C : SemanticClosure Obligation` and `tag : Obligation → Tenant` satisfying `Separated C tag`.
No `sorry`. The `TenancyCountermodel` section below is the mandatory non-vacuity discharge: a
concrete two-obligation, two-tenant instance where `Separated` genuinely fails and
`minimalSupport_tenant_pure`'s conclusion genuinely fails along with it, so `Separated` is shown
load-bearing rather than decorative.

Falsifier:
a reported minimal support for goal `g` containing an obligation tagged for a different tenant
than `g`, under a closure that is `Separated` for that tagging — this is exactly what
`minimalSupport_tenant_pure` forbids.

Downstream:
none yet (`MISSING`): no correspondence to `ProcInt.Workflow.Multifractal`'s boundary-cut theorems
is claimed by this file.
-/

namespace ProcInt.MFW.Residue

section TenancyCore

variable {Obligation Tenant : Type*} [DecidableEq Obligation] [DecidableEq Tenant]

/-- `Separated C tag`: membership of a *fixed-tenant goal* `g` in the closure of `X` depends only
on the same-tenant slice of `X`. Deliberately weaker than full closure factorization
(`C (S ∪ T) = C S ∪ C T`); only the goal-filtered form that `minimalSupport_tenant_pure` actually
needs. -/
def Separated (C : SemanticClosure Obligation) (tag : Obligation → Tenant) : Prop :=
  ∀ (X : Finset Obligation) (g : Obligation),
    g ∈ C X ↔ g ∈ C (X.filter (fun a => tag a = tag g))

variable {C : SemanticClosure Obligation} {tag : Obligation → Tenant}
  {G G1 G2 S T : Finset Obligation} {g g1 g2 : Obligation}

/-- Tenancy purity of a single minimal support: under `Separated`, if the context `G` is already
tenant-pure for `g` (`hG`), every member of a minimal support `S` for `g` is tagged for `g`'s own
tenant. Proof shape mirrors `residue_purity` (`Antichain.lean`): `by_contra` on a witness member
`a` with a foreign tag, derive that `S.erase a` is *also* sufficient (via `Separated`, since `a`
does not survive the goal-filter either way — `hne` alone forces that; `hG` is used to collapse
`G.filter (tag · = tag g)` back down to `G` so the filtered union splits along `G ∪ (filtered S)`),
contradicting `IsPointwiseLoadBearing` at `a`. -/
theorem minimalSupport_tenant_pure (sep : Separated C tag) (hS : S ∈ residue C G g)
    (hG : ∀ a ∈ G, tag a = tag g) : ∀ a ∈ S, tag a = tag g := by
  intro a haS
  by_contra hne
  have hInsuff : ¬ IsSufficient C G g (S.erase a) := hS.2 a haS
  apply hInsuff
  have hGfilter : G.filter (fun x => tag x = tag g) = G :=
    Finset.filter_true_of_mem (fun x hx => hG x hx)
  have haFilter : a ∉ S.filter (fun x => tag x = tag g) := by
    simp [Finset.mem_filter, hne]
  have hSerase :
      (S.erase a).filter (fun x => tag x = tag g) = S.filter (fun x => tag x = tag g) := by
    rw [Finset.filter_erase, Finset.erase_eq_of_notMem haFilter]
  have hfilter_eq : (G ∪ S).filter (fun x => tag x = tag g)
      = (G ∪ S.erase a).filter (fun x => tag x = tag g) := by
    rw [Finset.filter_union, Finset.filter_union, hGfilter, hSerase]
  have h1 : g ∈ C ((G ∪ S).filter (fun x => tag x = tag g)) := (sep (G ∪ S) g).mp hS.1
  rw [hfilter_eq] at h1
  exact (sep (G ∪ S.erase a) g).mpr h1

/-- The Wave CM2 target theorem: tenant isolation as residue independence. Under `Separated`,
minimal supports for goals of two distinct, individually tenant-pure-context tenants never share
an obligation — `S` and `T` are `⊆`-disjoint, not merely inequal. Follows from
`minimalSupport_tenant_pure` applied to both sides: any shared member would have to carry both
`tag g1` and `tag g2`, contradicting `hne`. -/
theorem crossTenant_residue_disjoint (sep : Separated C tag)
    (h1 : ∀ a ∈ G1, tag a = tag g1) (h2 : ∀ a ∈ G2, tag a = tag g2)
    (hne : tag g1 ≠ tag g2) (hS : S ∈ residue C G1 g1) (hT : T ∈ residue C G2 g2) :
    Disjoint S T := by
  rw [Finset.disjoint_left]
  intro a haS haT
  have hS' : tag a = tag g1 := minimalSupport_tenant_pure sep hS h1 a haS
  have hT' : tag a = tag g2 := minimalSupport_tenant_pure sep hT h2 a haT
  exact hne (hS'.symm.trans hT')

end TenancyCore

/-! ## Countermodel: `Separated` is load-bearing, not decorative

Mandatory non-vacuity discharge (`AGENTS.md` §3): a concrete two-obligation, two-tenant instance
in which `Separated` fails, and `minimalSupport_tenant_pure`'s conclusion fails right along with
it. This shows the `Separated` hypothesis is doing real work in the theorem above, not decorating
a vacuously true statement. `TenancyCore`'s section has closed by this point, so `C`/`tag`/etc.
are free to be reused here as concrete definitions rather than the abstract section variables. -/

namespace TenancyCountermodel

/-- The two-obligation universe: `aA := (0 : Fin 2)` tags to tenant `false`,
`bB := (1 : Fin 2)` tags to tenant `true`. -/
abbrev Obl := Fin 2

/-- `tag 0 = false`, `tag 1 = true`, exactly as the wave brief specifies. -/
def tag (a : Obl) : Bool := decide (a = 1)

theorem tag_zero : tag (0 : Obl) = false := by decide
theorem tag_one : tag (1 : Obl) = true := by decide

/-- The underlying closure *function*: closing on any set that already contains `0` grows to the
full pair `{0, 1}`; closing on a set without `0` (in particular `∅`) leaves it untouched. Chosen
to be the smallest function realizing `C {0} = {0, 1}` (the wave's required witness) while keeping
`C ∅ = ∅` — the latter is what makes `{0}` pointwise load-bearing for goal `1` below. -/
def f (X : Finset Obl) : Finset Obl := if (0 : Obl) ∈ X then insert 1 X else X

theorem f_apply_pos {X : Finset Obl} (h : (0 : Obl) ∈ X) : f X = insert 1 X := if_pos h

theorem f_apply_neg {X : Finset Obl} (h : (0 : Obl) ∉ X) : f X = X := if_neg h

theorem f_monotone : Monotone f := by
  intro X Y hXY
  by_cases hX0 : (0 : Obl) ∈ X
  · have hY0 : (0 : Obl) ∈ Y := hXY hX0
    rw [f_apply_pos hX0, f_apply_pos hY0]
    exact Finset.insert_subset_insert 1 hXY
  · by_cases hY0 : (0 : Obl) ∈ Y
    · rw [f_apply_neg hX0, f_apply_pos hY0]
      exact hXY.trans (Finset.subset_insert 1 Y)
    · rw [f_apply_neg hX0, f_apply_neg hY0]
      exact hXY

theorem f_extensive : ∀ X, X ≤ f X := by
  intro X
  by_cases hX0 : (0 : Obl) ∈ X
  · rw [f_apply_pos hX0]
    exact Finset.subset_insert 1 X
  · simp [f_apply_neg hX0]

theorem f_idempotent : ∀ X, f (f X) ≤ f X := by
  intro X
  by_cases hX0 : (0 : Obl) ∈ X
  · have hX0' : (0 : Obl) ∈ insert (1 : Obl) X := Finset.mem_insert_of_mem hX0
    simp [f_apply_pos hX0, f_apply_pos hX0']
  · simp [f_apply_neg hX0]

/-- The actual `ClosureOperator` for the countermodel, built honestly from `f_monotone`,
`f_extensive`, `f_idempotent` on the genuine `PartialOrder (Finset Obl)` (`≤ = ⊆`,
`Finset.le_eq_subset`) — not faked or assumed. -/
def C : SemanticClosure Obl := ClosureOperator.mk' f f_monotone f_extensive f_idempotent

theorem C_apply (X : Finset Obl) : C X = f X := rfl

/-- The wave's required witness: closing on `{0}` grows to the full pair `{0, 1}`. -/
theorem C_zero : C ({0} : Finset Obl) = {0, 1} := by
  rw [C_apply, f_apply_pos (Finset.mem_singleton_self 0)]
  decide

theorem C_empty : C (∅ : Finset Obl) = ∅ := by
  rw [C_apply, f_apply_neg (Finset.notMem_empty 0)]

/-- `Separated C tag` fails: witnessed at `X = {0}`, `g = 1`. `1 ∈ C {0}` (by `C_zero`) but the
same-tenant slice of `{0}` for goal `1` (tenant `true`) is empty, since `0` tags `false`, and
`1 ∉ C ∅` (by `C_empty`). -/
theorem not_separated : ¬ Separated C tag := by
  intro hsep
  have h := hsep ({0} : Finset Obl) (1 : Obl)
  rw [C_zero] at h
  have hfilter : ({0} : Finset Obl).filter (fun a => tag a = tag (1 : Obl)) = ∅ := by
    apply Finset.filter_false_of_mem
    intro a ha
    have ha0 : a = (0 : Obl) := Finset.mem_singleton.mp ha
    subst ha0
    rw [tag_zero, tag_one]
    decide
  rw [hfilter, C_empty] at h
  simp at h

/-- `{0}` is a minimal support for goal `1` given the empty context, under `C`: sufficient
(`1 ∈ C {0} = {0,1}`, by `C_zero`) and pointwise load-bearing (erasing `0` leaves `∅`, and
`1 ∉ C ∅ = ∅`, by `C_empty`). -/
theorem singleton_mem_residue : ({0} : Finset Obl) ∈ residue C (∅ : Finset Obl) (1 : Obl) := by
  refine ⟨?_, ?_⟩
  · show (1 : Obl) ∈ C ((∅ : Finset Obl) ∪ ({0} : Finset Obl))
    rw [Finset.empty_union, C_zero]
    decide
  · intro a ha
    have ha0 : a = (0 : Obl) := Finset.mem_singleton.mp ha
    subst ha0
    show ¬ (1 : Obl) ∈ C ((∅ : Finset Obl) ∪ (({0} : Finset Obl).erase (0 : Obl)))
    rw [Finset.empty_union, Finset.erase_singleton, C_empty]
    decide

/-- The context `∅` is vacuously tenant-pure for any goal. -/
theorem empty_context_tenant_pure : ∀ a ∈ (∅ : Finset Obl), tag a = tag (1 : Obl) :=
  fun a ha => absurd ha (Finset.notMem_empty a)

/-- The non-vacuity discharge itself: `minimalSupport_tenant_pure`'s conclusion is false for this
`C`, exactly because `Separated C tag` (proved false by `not_separated`) is unavailable to supply
it. `{0} ∈ residue C ∅ 1` and the context hypothesis both hold (`singleton_mem_residue`,
`empty_context_tenant_pure`), yet `0 ∈ {0}` has `tag 0 = false ≠ true = tag 1`. So `Separated` is
load-bearing, not decorative: drop it and the theorem's conclusion is exhibited false, not merely
unproved. -/
theorem tenant_purity_conclusion_fails :
    ¬ (∀ a ∈ ({0} : Finset Obl), tag a = tag (1 : Obl)) := by
  intro hconclusion
  have h0 : tag (0 : Obl) = tag (1 : Obl) := hconclusion 0 (Finset.mem_singleton_self 0)
  rw [tag_zero, tag_one] at h0
  exact Bool.false_ne_true h0

end TenancyCountermodel

end ProcInt.MFW.Residue
