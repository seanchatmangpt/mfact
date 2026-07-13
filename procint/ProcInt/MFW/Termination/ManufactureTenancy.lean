-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Termination.ManufactureDecrease
import ProcInt.MFW.Residue.Tenancy

/-!
# Tenant-pure manufacture (Wave M1 x CM2 — Crown II / Crown I composition, G53 repair)

Pipeline:
`ManufactureDecrease.lean (ManufactureStep) + Residue/Tenancy.lean (Separated,
minimalSupport_tenant_pure) → this file (TenantPureManufactureStep,
manufactureStep_tenant_pure_of_residue) → Playground/SOC2/ManufactureTenancyGap.lean (positive
specialization + hypothesis-removal countermodel + composition into the SOC2 `checks`
aggregator)`.

Crown law:
`ObligationRank.lean`'s "Excludes" section and `ROADMAP_MATH_SPINE.md`'s Wave M1 status note both
record, independently, that Crown II's descent machinery (`CrownState`, `rank`, `ManufactureStep`)
has never been composed with Crown I/CM2's residue machinery (`residue`, `Separated`,
`minimalSupport_tenant_pure`) — they answer different questions ("does the frontier multiset
strictly descend" vs "does the frontier stay inside one tenant's residue"). Gap ledger entry G53
names this the `ManufactureStep` tenancy-crossing soundness gap, exhibited concretely by
`Playground/SOC2/ManufactureTenancyGap.lean`'s `manufactureStep_not_tenant_pure`. This file states
and proves the missing SUFFICIENT condition: a `ManufactureStep` whose children are literally a
real minimal-support witness for the very goal being resolved (`hS`), under a tenant-pure context
(`hG`) and a `Separated` closure (`sep`), is automatically tenant-pure — closing the edge, not
merely naming it.

Preserves:
genericity over `Obligation` and `Tenant` inherited from `ManufactureDecrease.lean`
(`[AdmittedObligationOrder Obligation]`, `Residue/EntailmentOrder.lean:53`) and
`Residue/Tenancy.lean` (`[DecidableEq Obligation] [DecidableEq Tenant]`, explicit
`tag : Obligation → Tenant`). No new machinery: the general theorem below is a direct composition
of `minimalSupport_tenant_pure` (the tenancy half) and the raw `ManufactureStep` existential
witness (the descent half) — `AGENTS.md` §3, "compose what already exists," not a reinvention of
either.

Deliberately separate hypotheses:
`hS : children.toFinset ∈ residue C G goal` (children are a real minimal-support witness for
`goal`) is NOT implied by, and does not imply, `hdescent : ∀ c ∈ children, c < goal`
(`ManufactureStep`'s own order-descent clause). `residue` membership is a closure-sufficiency
fact (Crown I); `<` is an order fact (Crown II); the two machineries have never shared an axiom
connecting them, so both must be supplied independently here — this file does not silently
discharge one from the other.

Excludes:
any claim that every `ManufactureStep` is tenant-pure (false — see
`ManufactureTenancyGap.manufactureStep_not_tenant_pure`, which exploits exactly the case where
`hS` fails to hold for the mismatched goal). This file states a SUFFICIENT condition only, never a
necessary one, and never asserts `ManufactureStep`'s own definition needs to change.

Standing:
`TenantPureManufactureStep.toManufactureStep` and `manufactureStep_tenant_pure_of_residue` are
`PROVEN` in this file (kernel-checked by
`lake build ProcInt.MFW.Termination.ManufactureTenancy`), unconditionally given the stated
hypotheses. No `sorry`, `admit`, or `native_decide`.

Falsifier:
a `ManufactureStep` instance satisfying `sep`/`hG`/`hS`/`hdescent` whose children are not
tenant-pure relative to `goal` — this is exactly what `manufactureStep_tenant_pure_of_residue`
forbids.

Downstream:
`Playground/SOC2/ManufactureTenancyGap.lean` (positive specialization on the `AuditFlow.Obl2`
carrier, plus the hypothesis-removal corollary connecting this theorem's `hS` hypothesis to the
existing gap witness, composed into the file's `checks` aggregator).
-/

namespace ProcInt.MFW.Termination

open ProcInt.MFW.Residue

variable {Obligation Tenant : Type*} [DecidableEq Obligation] [DecidableEq Tenant]
  [AdmittedObligationOrder Obligation]

/-- A tenant-pure manufacture step: the same existential shape as `ManufactureStep`
(`ManufactureDecrease.lean:68-70`) — a resolved obligation `a` sitting over an untouched
remainder `common`, replaced by `children`, every member strictly below `a` — plus a second
conjunct that `ManufactureStep` itself is silent on (G53): every member of `children` carries
`a`'s own tag. -/
def TenantPureManufactureStep (tag : Obligation → Tenant) (s s' : CrownState Obligation) : Prop :=
  ∃ (a : Obligation) (children common : Multiset Obligation),
    s.frontier = common + {a} ∧ s'.frontier = common + children ∧
    (∀ c ∈ children, c < a) ∧ (∀ c ∈ children, tag c = tag a)

omit [DecidableEq Obligation] [DecidableEq Tenant] in
/-- The formal link showing `TenantPureManufactureStep` genuinely strengthens `ManufactureStep`
rather than being an unrelated relation: dropping the tenancy conjunct recovers exactly
`ManufactureStep`'s own existential witness (its first three conjuncts, verbatim). -/
theorem TenantPureManufactureStep.toManufactureStep {tag : Obligation → Tenant}
    {s s' : CrownState Obligation} (h : TenantPureManufactureStep tag s s') :
    ManufactureStep s s' := by
  obtain ⟨a, children, common, hs, hs', hdescent, -⟩ := h
  exact ⟨a, children, common, hs, hs', hdescent⟩

/-- **The general repair theorem (G53).** A `ManufactureStep`-shaped transition is automatically
tenant-pure once its children are literally a real minimal-support witness (`hS`) for the very
goal being manufactured (`goal`), under a `Separated` closure (`sep`) and a tenant-pure context
(`hG`) — combining `minimalSupport_tenant_pure` (Crown I/CM2, the tenancy half) with the raw
`ManufactureStep` witness shape (Crown II, the descent half, `hdescent`/`hs`/`hs'`). `hS`'s
`Multiset.toFinset` bridges `ManufactureStep`'s `Multiset` children to `residue`'s `Finset`
support via `Multiset.mem_toFinset` (`Mathlib.Data.Finset.Dedup`). -/
theorem manufactureStep_tenant_pure_of_residue
    {C : SemanticClosure Obligation} {tag : Obligation → Tenant}
    {G : Context Obligation} {goal : Obligation} {children common : Multiset Obligation}
    {s s' : CrownState Obligation}
    (sep : Separated C tag)
    (hG : ∀ x ∈ G, tag x = tag goal)
    (hS : children.toFinset ∈ residue C G goal)
    (hdescent : ∀ c ∈ children, c < goal)
    (hs : s.frontier = common + {goal})
    (hs' : s'.frontier = common + children) :
    TenantPureManufactureStep tag s s' :=
  ⟨goal, children, common, hs, hs', hdescent, fun c hc =>
    minimalSupport_tenant_pure sep hS hG c (Multiset.mem_toFinset.mpr hc)⟩

end ProcInt.MFW.Termination
