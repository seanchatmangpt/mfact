-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.MFW.Residue.Tenancy
import ProcInt.Playground.MFW.Runtime
import ProcInt.Playground.Glue.RuntimeReplay
import ProcInt.Playground.Glue.OrientedSwapReplay
import ProcInt.Playground.Swarm11.Replay
import ProcInt.Playground.SOC2.AuditFlow
import ProcInt.Playground.SOC2.AuditFlowViolation
import ProcInt.Playground.SOC2.ManufactureTenancyGap

/-! # Axiom audit — SOC2 two-tenant audit-flow crown (hand-authored)

Instantiates testing-atlas **T006** (`MFW.TST.KERNEL.AXIOM_DEP.006`, "Which axioms are
transitively reachable from a theorem?", canonical mechanism `Lean.collectAxioms / #print
axioms`) and **T007** (`MFW.TST.KERNEL.NO_SORRY.007`, "Does any controlled declaration depend on
an unproved placeholder axiom?", canonical mechanism `compiled environment
inspection`) — see `docs/testing-atlas/10_llm_guides/01_kernel.md` §T006/§T007 — against the SOC2
two-tenant audit-flow theorems that carry no axiom-audit coverage in `procint/AxiomAudit.lean`
(that file is ggen-rendered from the `ProcInt.*` ontology catalog only; it never imports or
mentions `ProcInt.Playground.*` or `ProcInt.MFW.Residue`/`ProcInt.MFW.Termination`, confirmed by
grep against its own text). Every `#guard_msgs` pair below is both T006 evidence (the asserted
info string is the exact, kernel-computed transitive axiom set — a mismatch is a build error, not
a silent pass) and T007 evidence in the same motion (`#print axioms` reports the
unproved placeholder axiom in that same set if any target declaration transitively
depends on one; none of the twenty do, so every info string below is one of `does not depend on
any axioms`, `[propext]`, `[propext, Quot.sound]`, or `[propext, Classical.choice, Quot.sound]` —
never that placeholder marker).

**Claim ceiling.** This evidence establishes that these theorems depend only on `[propext,
Classical.choice, Quot.sound]`; it does not establish semantic correctness of what they claim.
An axiom-clean kernel certificate is not a proof that `Separated`, `residue`, `ExecutionState`, or
`ManufactureStep` model SOC2 controls correctly — that is a `CORRESPONDENCE`-edge question
(`AGENTS.md` §4), out of scope for T006/T007.

**Gap closed.** An earlier crown-matrix dry-run found kernel-proven SOC2 theorems
(`ProcInt.Playground.SOC2.AuditFlow`/`AuditFlowViolation`/`ManufactureTenancyGap`, plus the
`ProcInt.MFW.Residue.Tenancy`, `ProcInt.Playground.MFW.Runtime`, `ProcInt.Playground.Glue.*`, and
`ProcInt.Playground.Swarm11.Replay` theorems they compose) that existed and built, but had never
been run through `#print axioms` — this file closes exactly that gap.

**Selection note.** Twenty theorems are audited below: the two generic Wave-CM2 theorem-card
targets and the countermodel's non-vacuity discharge from `Tenancy.lean`; the one BRCE consequence
from `Runtime.lean`; the cross-layer correspondence theorems from `RuntimeReplay.lean` and
`OrientedSwapReplay.lean`; the two headline replay-machinery theorems from `Swarm11/Replay.lean`;
every numbered "Card"-instantiation piece proven in `AuditFlow.lean` (both tenants' purity, the
cross-tenant disjointness, the audit-trace BRCE instance, the dual-order replay equality, and the
manufactured-receipt validity); the packaged countermodel refutation from
`AuditFlowViolation.lean`; and the tenancy-crossing refutation from `ManufactureTenancyGap.lean`.
Purely internal plumbing lemmas (`if_pos`/`if_neg` unfoldings, `Finset` membership rewrites,
`Decidable` instances, `rfl`-closed restatements) are not separately audited — they are not
independent claims, and auditing them would not test anything `#print axioms` on their callers
does not already cover.
-/

namespace ProcInt.Playground.SOC2.AxiomAuditSOC2

/-! ## `ProcInt.MFW.Residue.Tenancy` — Wave CM2 tenancy-isolation theorem card, and its
countermodel's non-vacuity discharge -/

/-- info: 'ProcInt.MFW.Residue.minimalSupport_tenant_pure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.MFW.Residue.minimalSupport_tenant_pure

/-- info: 'ProcInt.MFW.Residue.crossTenant_residue_disjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.MFW.Residue.crossTenant_residue_disjoint

/-- info: 'ProcInt.MFW.Residue.TenancyCountermodel.not_separated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.MFW.Residue.TenancyCountermodel.not_separated

/-! ## `ProcInt.Playground.MFW.Runtime` — BRCE consequence -/

/-- info: 'ProcInt.Playground.MFW.zero_unreceipted_completion' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.MFW.zero_unreceipted_completion

/-! ## `ProcInt.Playground.Glue.RuntimeReplay` — BRCE-runtime x causal-replay correspondence -/

/-- info: 'ProcInt.Playground.Glue.concurrent_commute' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Glue.concurrent_commute

/-- info: 'ProcInt.Playground.Glue.frontier_interleaving_replay_eq' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Glue.frontier_interleaving_replay_eq

/-! ## `ProcInt.Playground.Glue.OrientedSwapReplay` — unconditional Newman's Lemma for
`OrientedSwap (completeStep p) priority` -/

/-- info: 'ProcInt.Playground.Glue.orientedSwap_locallyConfluent_completeStep' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Glue.orientedSwap_locallyConfluent_completeStep

/-- info: 'ProcInt.Playground.Glue.orientedSwap_confluent_completeStep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Glue.orientedSwap_confluent_completeStep

/-- info: 'ProcInt.Playground.Glue.orientedSwap_replay_eq_completeStep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.Glue.orientedSwap_replay_eq_completeStep

/-! ## `ProcInt.Playground.Swarm11.Replay` — causal replay / trace-equivalence machinery -/

/-- info: 'ProcInt.Playground.Swarm11.Replay.replay_eq_of_traceEq' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.Swarm11.Replay.replay_eq_of_traceEq

/-- info: 'ProcInt.Playground.Swarm11.Replay.manufacturedReceipt_valid' does not depend on any axioms -/
#guard_msgs in #print axioms ProcInt.Playground.Swarm11.Replay.manufacturedReceipt_valid

/-! ## `ProcInt.Playground.SOC2.AuditFlow` — the positive two-tenant witness, every numbered
theorem-card piece -/

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.separated_C2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.separated_C2

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.piece1_tenantA_pure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.piece1_tenantA_pure

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.piece1_tenantB_pure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.piece1_tenantB_pure

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.piece2_cross_tenant_disjoint' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.piece2_cross_tenant_disjoint

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.s3_zero_unreceipted' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.s3_zero_unreceipted

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.reorder_replay_eq' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.reorder_replay_eq

/-- info: 'ProcInt.Playground.SOC2.AuditFlow.auditReceipt_valid' depends on axioms: [propext] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlow.auditReceipt_valid

/-! ## `ProcInt.Playground.SOC2.AuditFlowViolation` — the negative companion, packaged -/

/-- info: 'ProcInt.Playground.SOC2.AuditFlowViolation.violation_summary' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.AuditFlowViolation.violation_summary

/-! ## `ProcInt.Playground.SOC2.ManufactureTenancyGap` — the Crown-II-x-tenancy soundness-gap
refutation -/

/-- info: 'ProcInt.Playground.SOC2.ManufactureTenancyGap.manufactureStep_not_tenant_pure' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in #print axioms ProcInt.Playground.SOC2.ManufactureTenancyGap.manufactureStep_not_tenant_pure

end ProcInt.Playground.SOC2.AxiomAuditSOC2
