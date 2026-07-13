-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Termination.ManufactureDecrease
import ProcInt.Playground.SOC2.AuditFlow

/-!
# `ManufactureStep` admits tenancy-crossing children (Wave M1 x SOC2 tenancy, soundness gap)

`ObligationRank.lean`'s own "Excludes" section (`ProcInt/MFW/Termination/ObligationRank.lean:34-38`)
and `ROADMAP_MATH_SPINE.md`'s Wave M1 status note (`ROADMAP_MATH_SPINE.md:330-337`) both record,
independently, that Wave M1's Crown II descent machinery (`CrownState`, `rank`, `ManufactureStep`)
imports and uses only `AdmittedObligationOrder` — never `Residue.residue`, `Residue.Separated`, or
either tenancy-purity theorem in `Residue/Tenancy.lean`. That is stated there as a *scope*
correction (Crown II answers "does the frontier multiset strictly descend", not "does the frontier
stay inside one tenant's residue" — a different question). This file makes the *consequence* of
that documented disjointness concrete: `ManufactureStep` (`ManufactureDecrease.lean:68-70`) is
satisfied by an order-descent condition alone (`∀ c ∈ children, c < a`), so nothing in its type
stops a legal manufacture step from replacing a resolved obligation with children drawn from a
*different* tenant's obligation universe entirely. This is not a bug in `ManufactureStep` itself
(it was never specified to enforce tenancy) — it is a real, previously-unstated soundness gap for
any caller who assumes Crown II's termination guarantee also implies tenant isolation: it does
not, and this file exhibits the concrete counterexample rather than leaving the claim unfalsified.

## Theorem card

* **Object.** `ManufactureStep (Obligation := AuditFlow.Obl2)`, instantiated at the two-tenant
  closure `AuditFlow.Obl2`/`AuditFlow.tag2` already built (and proved `Separated`) in
  `ProcInt.Playground.SOC2.AuditFlow`, ordered by `Fin 4`'s standard `LinearOrder` (the only order
  registered as `AdmittedObligationOrder Obl2` here — `local`, scoped to this file, precisely
  because `RankOrder.lean` already establishes that a carrier can admit more than one such order
  and a global instance would be non-canonical).
* **Imported facts used, not reproven.** `AuditFlow.g2` (tenant B's goal, `tag2 = true`),
  `AuditFlow.S1` (tenant A's already-proven minimal support for tenant A's own goal,
  `AuditFlow.hS1 : S1 ∈ residue C2 G1 g1`), `AuditFlow.tag2_zero`/`AuditFlow.tag2_three` (the
  concrete tag values). No new closure or entailment machinery is built here — the point is
  reuse, not new scaffolding (`AGENTS.md` §3).
* **Correspondence map.** None needed: `AuditFlow.Obl2` is fed directly as `ManufactureStep`'s
  `Obligation`, exactly as `Fin n` is fed directly as `Event`/`State` elsewhere in this tree.
* **Preserved structure.** None — this is a refutation, not a preservation result.
* **Conclusion.** `manufactureStep_not_tenant_pure`: it is **false** that every `ManufactureStep`
  instance (presented via its own defining witness shape `common + {a} → common + children`)
  keeps `children` tenant-pure relative to `a`. Witnessed concretely by
  `gap_manufactureStep`/`gap_tenant_crossing`: replacing tenant B's goal obligation (`g2 = 3`)
  with tenant A's minimal-support obligation (`S1 = {0}`) is a fully legal `ManufactureStep`
  (`0 < 3` in the standard order) whose sole child is tagged for the *other* tenant.
* **Standing.** `PROVEN` (as a refutation), unconditionally. Mirrors the proof shape
  `Swarm11/OrientedSwap.lean`'s `not_orientedSwap_locallyConfluent` uses for its own counterexample:
  a concrete witness first, then the general universally-quantified claim refuted by it — not an
  unproven gap, an exhibited one.
-/

namespace ProcInt.Playground.SOC2

namespace ManufactureTenancyGap

open ProcInt.MFW.Termination
open ProcInt.MFW.Residue

/-- The only `AdmittedObligationOrder` this file registers for `AuditFlow.Obl2`: `Fin 4`'s
ordinary `LinearOrder`, lifted through the `Preorder` field `AdmittedObligationOrder` extends.
`local` (scoped to this file), not global — `RankOrder.lean`'s own docstring already establishes
that a carrier can admit more than one admitted obligation order, so a bare top-level `instance`
here would silently claim canonicity this file does not need and should not assert. -/
local instance obl2AdmittedOrder : AdmittedObligationOrder AuditFlow.Obl2 :=
  { (inferInstance : Preorder AuditFlow.Obl2) with }

/-- The resolved obligation: tenant B's goal (`AuditFlow.g2 = 3`, `tag2 = true`). -/
def a : AuditFlow.Obl2 := AuditFlow.g2

/-- The manufactured children: literally `AuditFlow.S1` (tenant A's already-proven minimal
support `{0}` for tenant A's own goal), reused verbatim rather than re-declared, viewed as a
`Multiset` via `Finset.val`. Not an arbitrary same-numbered coincidence — the exact object
`AuditFlow.hS1` already certifies as tenant-A evidentiary data. -/
def children : Multiset AuditFlow.Obl2 := AuditFlow.S1.val

/-- The frontier before the step: just the resolved obligation `a`, nothing else open. -/
def gapSource : CrownState AuditFlow.Obl2 := ⟨{a}⟩

/-- The frontier after the step: `a` replaced by `children`, nothing else open. -/
def gapTarget : CrownState AuditFlow.Obl2 := ⟨children⟩

/-- **The witness.** `gapSource → gapTarget` is a fully legal `ManufactureStep`: `common := 0`,
and the sole descent obligation `∀ c ∈ children, c < a` reduces to the single decidable fact
`0 < 3` in `Fin 4`'s standard order. -/
theorem gap_manufactureStep : ManufactureStep gapSource gapTarget :=
  ⟨a, children, 0, by simp [gapSource], by simp [gapTarget], by decide⟩

/-- **The tenancy crossing.** The manufactured child `0` is tagged for tenant A
(`AuditFlow.tag2_zero`), while the resolved obligation `a = g2 = 3` is tagged for tenant B
(`AuditFlow.tag2_three`) — a legal `ManufactureStep` step whose child carries the *other*
tenant's tag. -/
theorem gap_tenant_crossing : ∃ c ∈ children, AuditFlow.tag2 c ≠ AuditFlow.tag2 a := by
  refine ⟨(0 : AuditFlow.Obl2), ?_, ?_⟩
  · show (0 : AuditFlow.Obl2) ∈ AuditFlow.S1.val
    decide
  · show AuditFlow.tag2 (0 : AuditFlow.Obl2) ≠ AuditFlow.tag2 AuditFlow.g2
    decide

/-- **The refutation.** It is false that every `ManufactureStep` instance, presented via its own
defining witness shape (a resolved obligation `a` sitting over a common remainder, replaced by
`children`), keeps `children` tenant-pure relative to `a`. `manufactureStep_not_tenant_pure`
refutes exactly the reading of Crown II's "theorem boundary"
(`ManufactureDecrease.lean:22-37`) that would over-claim tenant isolation as a free consequence of
order descent: `ManufactureStep`'s own `∀ c ∈ children, c < a` clause is silent on tenancy, and
this witness shows that silence is not vacuous — a real, legal step exploits it.

Standing: `PROVEN`, by the concrete witness above. Not merely unproven in the positive direction —
actively false, the same way `not_orientedSwap_locallyConfluent`
(`Swarm11/OrientedSwap.lean:390-414`) is a genuine refutation, not an open goal. -/
theorem manufactureStep_not_tenant_pure :
    ¬ (∀ (a : AuditFlow.Obl2) (children common : Multiset AuditFlow.Obl2),
        ManufactureStep (Obligation := AuditFlow.Obl2)
          ⟨common + {a}⟩ ⟨common + children⟩ →
        ∀ c ∈ children, AuditFlow.tag2 c = AuditFlow.tag2 a) := by
  intro h
  have hpure : ∀ c ∈ children, AuditFlow.tag2 c = AuditFlow.tag2 a := by
    have hstep : ManufactureStep (Obligation := AuditFlow.Obl2)
        ⟨(0 : Multiset AuditFlow.Obl2) + {a}⟩ ⟨(0 : Multiset AuditFlow.Obl2) + children⟩ := by
      have hs : (⟨(0 : Multiset AuditFlow.Obl2) + {a}⟩ : CrownState AuditFlow.Obl2) = gapSource :=
        by simp [gapSource]
      have ht : (⟨(0 : Multiset AuditFlow.Obl2) + children⟩ : CrownState AuditFlow.Obl2) =
          gapTarget := by simp [gapTarget]
      rw [hs, ht]; exact gap_manufactureStep
    exact h a children 0 hstep
  obtain ⟨c, hc, hne⟩ := gap_tenant_crossing
  exact hne (hpure c hc)

/-! ## `checks` — standing-aware Bool aggregator, `AuditFlow`/`Crown.lean`-style -/

/-- Standing-aware checks for this file's counterexample, mirroring
`ProcInt.Playground.SOC2.AuditFlow.checks`'s exact `List (String × Bool)` shape. -/
def checks : List (String × Bool) := [
  ("gap-manufactureStep-legal-descent",
    decide (∀ c ∈ children, c < a)),
  ("gap-child-is-tenantA-support-member",
    decide ((0 : AuditFlow.Obl2) ∈ AuditFlow.S1.val)),
  ("gap-resolved-obligation-is-tenantB",
    decide (AuditFlow.tag2 a = true)),
  ("gap-child-is-tenantA-not-tenantB",
    decide (AuditFlow.tag2 (0 : AuditFlow.Obl2) ≠ AuditFlow.tag2 a))
]

end ManufactureTenancyGap

end ProcInt.Playground.SOC2
