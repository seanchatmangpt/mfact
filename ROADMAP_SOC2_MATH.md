# ROADMAP_SOC2_MATH — SOC 2 Trust Services Criteria × Multifractal Workflow

**SOC 2 compliance is an auditor's professional attestation under AICPA's Trust Services**
**Criteria (TSC) framework, applied to a real operating environment by a licensed CPA firm.**
**No theorem in this repository is, or could ever be, SOC 2 compliance.** What follows models
specific control-relevant invariants as kernel-checked Lean properties, on the abstract formal
objects named in §2. As §3(b) states explicitly, none of this strengthens evidence available to
a real auditor today, because no admitted correspondence connects any of these objects to a
production system; it names what *could* strengthen that evidence if such correspondences were
built and discharged. It does not constitute, substitute for, or shorten an audit.

This document follows `AGENTS.md` §4 (No Ambient Theorem Authority): every mapping below is a
typed edge, strong claims get theorem cards, and no TSC-side binding is prose-promoted past
what an admitted correspondence morphism would justify. It uses the same discipline as
`ROADMAP_CLOUD_MATH.md`, whose findings it inherits directly — in particular, that document's
Cards 1-5 already establish that zero production-Rust correspondence exists for any MFW
theorem today. Nothing in this document raises that standing; every production-side cell here
is `MISSING` or `ANALOGY`, never higher.

**Scope boundary, stated once here rather than repeated per section.** mfact's controlled,
validated deliverable is the chain it actually builds and kernel-checks: Lake admits Lean 4,
Lean 4 relates to the TTL ontology, ggen projects artifacts from that ontology. Once an auditor
validates that chain once, mfact's obligation with respect to it is discharged. Whatever
consumes the resulting specification — a production runtime, praxis's `multifractal-workflow`
crate, `crates/mfact-core`'s own Rust bindings, or any other system — is a *consumer* of that
specification, not part of the chain mfact controls or continuously re-verifies. Building a
carrier that discharges one of §2's correspondence obligations, wiring any runtime to an
invariant-carrying type, or auditing whether a specific deployment actually routes through that
type is the consumer's responsibility to get right, not a roadmap item for mfact. Every
"correspondence map (undischarged)" note in §2 below describes what a *consumer* would need to
build and prove, not unfinished mfact work.

Sources: AICPA TSP Section 100, *2017 Trust Services Criteria for Security, Availability,
Processing Integrity, Confidentiality, and Privacy* (2022 conforming-change revision, verified
directly against the PDF this session — criterion numbers, names, and category structure
confirmed unchanged from the 2017 baseline); the live `procint/ProcInt/` tree at the commit
cited in each theorem card; `PRAXIS_SELF_AUDIT.md` PA23/PA24 (§3 below).

Updated 2026-07-13.

## 1. The correspondence table

Edge types per `AGENTS.md` §4: `PROVEN` (kernel-checked theorem exists), `CORRESPONDENCE`
(explicit bridge admitted, obligations discharged), `ANALOGY` (shared shape, no admitted
bridge — never supports theorem prose), `MISSING` (no formal object at all on that side). The
workflow-side column states what is actually proven in Lean; the production-side column states
the binding's current honest type. Every production-side cell in this table is `MISSING` or
`ANALOGY` — no row claims `CORRESPONDENCE` or `PROVEN` in production, because none exists.

| TSC criterion | MFW formal object | Workflow side | Production side |
|---|---|---|---|
| CC1 — Control Environment | none | — | MISSING (organizational) |
| CC2 — Communication and Information | none | — | MISSING (organizational) |
| CC3 — Risk Assessment | none | — | MISSING (organizational) |
| CC4 — Monitoring Activities | none | — | MISSING (organizational) |
| CC5 — Control Activities | none | — | MISSING |
| CC6 — Logical and Physical Access Controls | `crossTenant_residue_disjoint`, `minimalSupport_tenant_pure` (`Residue/Tenancy.lean:111,86`) | PROVEN (conditional on `Separated`) | ANALOGY |
| CC7 — System Operations | none | — | MISSING |
| CC8 — Change Management | none | — | MISSING |
| CC9 — Risk Mitigation | none | — | MISSING (vendor/business-partner risk, organizational) |
| Availability A1.1-A1.3 | `replay_eq_of_traceEq` (`Swarm11/Replay.lean:105`) | PROVEN_CONDITIONALLY | ANALOGY |
| Processing Integrity PI1.1-PI1.5 | `zero_unreceipted_completion` (`MFW/Runtime.lean:62`) | PROVEN | ANALOGY (weak — see Card 2) |
| Confidentiality C1.1-C1.2 | `residue_purity`, `residue_isAntichain` (`Residue/Antichain.lean:113,75`) | PROVEN | ANALOGY |
| Privacy P1.1-P8.1 | none | — | MISSING (personal-data-specific, organizational) |

CC1-CC5, CC7-CC9, and the full Privacy series are listed with `none` deliberately, not omitted:
this repository has zero formal objects touching governance, personnel, vendor management,
change-control process, incident response, or personal-data handling. §3 explains why most of
these are not formalizable targets at all, not merely unstarted ones.

What would strengthen a covered row from `ANALOGY` toward `CORRESPONDENCE`, if a consumer of
this specification chose to build it: a theorem card naming the concrete production carrier (a
real tenant-tagged data store, a real completion event stream, a real event log), the map into
the MFW carrier, and the preserved structure — then discharging the obligations. None of that
exists yet for any row, and building it is out of mfact's scope (see the boundary statement
above); §2 states precisely what each of the four strongest candidate cards would require of
whoever builds against it.

## 2. Theorem cards (the four strongest mappings)

### Card 1 — Tenancy isolation as residue independence (→ CC6)

- Object: `Separated C tag` (`Residue/Tenancy.lean:72`) over `SemanticClosure Obligation` and
  a tenant tag `tag : Obligation → Tenant`.
- Imported theorem: none (native). Proven: `minimalSupport_tenant_pure` (`:86`) — under
  `Separated` and a tenant-pure context, every member of a minimal support for a tenant's goal
  is tagged for that same tenant. `crossTenant_residue_disjoint` (`:111`) — minimal supports
  for two distinct, individually tenant-pure-context tenants are `Disjoint` `Finset`s.
- Source hypotheses: `Separated C tag` — membership of a fixed-tenant goal in the closure of a
  set depends only on that set's same-tenant slice (`g ∈ C X ↔ g ∈ C (X.filter (tag · = tag g))`,
  `:72`). This is *not* automatically true and is deliberately weaker than full closure
  factorization `C (S ∪ T) = C S ∪ C T`. A mandatory non-vacuity countermodel
  (`TenancyCountermodel`, `:131-243`) exhibits a concrete two-obligation, two-tenant closure
  operator for which `Separated` genuinely fails (`not_separated`, `:197`) and for which
  `minimalSupport_tenant_pure`'s conclusion fails right along with it
  (`tenant_purity_conclusion_fails`, `:236`) — the hypothesis is load-bearing, not decorative.
  Both theorems also require each context to be independently tenant-pure (`hG`/`h1`,`h2`) and
  the two goals to carry distinct tags (`hne`).
- Correspondence map (undischarged): a real multi-tenant obligation store — e.g. a workflow
  engine's task backlog tagged by tenant ID — mapped to `Obligation`/`tag`, with `Separated`
  *proven* for that store's actual closure semantics, not assumed. No such store exists in this
  codebase; `crates/mfact-core` has no tenant concept at all as of this writing.
- Preserves: disjointness of minimal supports across tenants (no shared obligation is
  load-bearing for two different tenants' goals simultaneously).
- Conclusion if admitted: a formal statement of "tenant A's unfinished work never leaks into
  tenant B's residue" — the kind of logical-isolation property CC6's access-control criteria
  ask an auditor to evaluate evidence for.
- Standing: `PROVEN` (residue-independence core, unconditional given `Separated`); production
  edge `MISSING` — no carrier, no morphism, no `Separated` proof for any real store.

### Card 2 — No completed action escapes receipt (→ Processing Integrity PI1.1-PI1.5)

- Object: `ExecutionState n` with invariant field `completionReceipted`
  (`MFW/Runtime.lean:52-56`): `∀ i, completed i → receipted i`.
- Proven: `zero_unreceipted_completion` (`:62`) — no closed `ExecutionState` contains an
  activity that is `completed` but not `receipted`.
- Source hypotheses: this is true by construction. `completionReceipted` is a *structure field*
  of `ExecutionState`, not an independently derived property — no term of type `ExecutionState`
  can exist without already satisfying it. The theorem unpacks the invariant; it says nothing
  about how a real system would come to occupy a state satisfying it, nor about states reached
  by any path that bypasses the type (see §3(c) and the PA23/PA24 finding below).
- Correspondence map (undischarged): the TSC's own PI1.1-PI1.5 wording is about completeness,
  accuracy, authorization, and timeliness of ordinary business data processing — input,
  processing, output, and storage controls (per the verified AICPA text: PI1.3 "detects and
  corrects production errors" and "records processing activities" is the closest single
  sub-criterion). PI is explicitly **not** about receipts, cryptographic logging, or audit
  trails in the sense this theorem uses "receipt." The honest correspondence target is
  narrower than the row header suggests: only the "does every unit of processing get recorded
  as complete" slice of PI1.3 has any structural resemblance to `completionReceipted`; PI1.1
  (objective definition), PI1.2 (input controls), PI1.4 (output controls), and PI1.5 (storage
  controls) have no candidate MFW object at all.
- Preserves: (if admitted for the PI1.3 slice) that every processing unit which reaches
  "complete" status in the mapped system has a corresponding processing-activity record.
- Standing: `PROVEN` (the Lean invariant, trivially by construction); production edge `ANALOGY`
  at best, and only against a fraction of one sub-criterion — this is the weakest of the four
  cards, kept because it is the closest thing to an audit-trail theorem this repository has.

### Card 3 — Reordered event logs replay to one state (→ Availability A1.1-A1.3)

- Object: `List Event → State → State` deterministic fold (`Swarm11/Replay.lean:27`) with
  trace equivalence `TraceEq` closed under adjacent commuting swaps.
- Imported theorem: none (native). Proven: `replay_eq_of_traceEq` (`:105`) — traces related by
  `TraceEq` replay to an identical final state.
- Source hypotheses: finite traces, and a genuine *proof of commutation* for each swapped
  adjacent pair — `TraceEq` is inductively generated only from `Commute`-witnessed swaps plus
  refl/symm/trans; two traces that are merely equal as multisets, without an admitted
  `Commute` witness chaining them, are not covered. Full unconditional confluence over the
  symmetric swap relation is kernel-*refuted* (`not_terminating_of_cycle`,
  `NewmanCorrespondence.lean:109`), so this theorem's guarantee holds only along the specific
  commuting-swap paths a caller actually proves, not "any reordering."
- Correspondence map (undischarged): the natural A1.2/A1.3 reading is disaster-recovery replay
  — a backup/recovery process that replays a log of operations in a different order than they
  were originally applied (due to region failover, partial delivery, or retry) and must
  converge to the same recovered state. No such recovery-replay carrier exists in this
  codebase; mapping it would require exhibiting `Commute` proofs for the actual operation set
  a real recovery pipeline replays, not assuming they hold.
- Preserves: final state, across any reordering the caller can actually prove commutes.
- Standing: `PROVEN_CONDITIONALLY` (workflow side, conditional on supplied `Commute` proofs);
  production edge `MISSING` — no recovery-replay carrier, no commutation proofs, exist today.

### Card 4 — Residue purity as minimal information exposure (→ Confidentiality C1.1-C1.2)

- Object: `residue C G g`, the set of inclusion-minimal, pointwise-load-bearing supports for a
  goal `g` over context `G` and closure `C` (`Residue/Antichain.lean`,
  `Residue/MinimalSupport.lean:97`).
- Proven: `residue_purity` (`Antichain.lean:113`) — every minimal support `S` satisfies
  `S ∩ C G = ∅`: no minimal support ever contains an obligation already entailed by the
  untouched context alone. `residue_isAntichain` (`:75`) — the residue set is pairwise
  `⊆`-incomparable, so no minimal support is a strict subset of another.
- Source hypotheses: `residue_purity` needs all three `ClosureOperator` laws
  (monotone, extensive, idempotent) on `C`, not just monotonicity — the strongest hypothesis
  load in this document's four cards. `residue_isAntichain` needs only monotonicity, via
  `eq_of_subset_of_sufficient_of_isMinimalSupport` (`MinimalSupport.lean:97`).
- Correspondence map (undischarged): the informal reading is "a computation's minimal support
  never redundantly touches information the surrounding context already determines" — a
  structural minimality property. Confidentiality's C1.1 ("identifies and maintains
  confidential information") and C1.2 ("disposes of confidential information") are about
  classification and lifecycle of specific data, not about minimality of logical support sets;
  the correspondence is a shape analogy (both are "touch no more than the minimum necessary"),
  not a semantic match. No carrier mapping real confidential-data fields to `Obligation` exists.
- Preserves: disjointness from context-closure, if the mapped reading is admitted.
- Standing: `PROVEN` (both Lean theorems, unconditionally for `residue_isAntichain`,
  conditional on full `ClosureOperator` laws for `residue_purity`); production edge `ANALOGY` —
  the correspondence is a structural resemblance, not a discharged bridge, and the semantic
  gap between "minimal logical support" and "confidential data classification" is real.

## 3. What this cannot do

This section is at least as prominent as §1's table, deliberately.

- **(a) Organizational criteria are out of scope by kind, not by unstarted effort.**
  CC1 (Control Environment), CC2 (Communication and Information), CC3 (Risk Assessment), CC4
  (Monitoring Activities), CC8 (Change Management), CC9 (Risk Mitigation — vendor and
  business-partner risk), and the Privacy series ask about governance structure, personnel
  competence, board oversight, communication channels, fraud risk consideration, third-party
  contracts, and personal-data lifecycle decisions. None of these are properties of a formal
  object a theorem prover checks; they are properties of an organization's people, contracts,
  and processes. No amount of additional Lean work in this repository formalizes them. This is
  a permanent fence, not a wave on a roadmap.
- **(b) Even the covered rows have zero production correspondence today.** Every theorem cited
  in §2 is about an abstract Lean carrier — `SemanticClosure Obligation`, `ExecutionState n`,
  `List Event`, `residue`. None of them has an admitted morphism to any real Rust type, data
  store, or event stream in `crates/mfact-core` or elsewhere in this repository, which is
  exactly the gap `ROADMAP_CLOUD_MATH.md` Cards 1-5 already document for the cloud-architecture
  reading of the same theorems. This document does not close that gap; it inherits it. As of
  today, reading this roadmap reduces an auditor's actual workload by exactly zero — it names
  what *could* reduce it if the correspondence morphisms in §2 were built and discharged.
- **(c) A proven type-level invariant says nothing about code paths that route around the**
  **type — and verifying that a consumer didn't is the consumer's job, not mfact's.**
  `zero_unreceipted_completion` (Card 2) is true of every `ExecutionState n` value that exists —
  but only of values reached *through* that type. This session's own finding
  `PRAXIS_SELF_AUDIT.md` PA23/PA24 is a real, already-diagnosed instance of a consumer failing
  this: `crates/mfact-core/src/thermo.rs`'s `thermo_helmholtz`/`thermo_f` doc comments quote the
  real, proven Lean formula (`Thermo.lean:12-13`) almost verbatim, but the function bodies never
  call it — they call an FFI symbol from an unrelated package whose generated implementation is
  a hardcoded two-branch constant lookup that ignores the actual input state (PA23), and a
  companion file, `lean_ffi_wrapper.c`, supplies hand-written stand-ins for Mathlib lemmas that
  unconditionally return fixed constants regardless of their arguments (PA24). The doc comment
  cited a real theorem; the code that ran did not go through it.

  This is not a gap mfact's proofs need to close, and mfact does not build FFI shims, wire
  runtimes to invariant-carrying types, or continuously re-verify that a given deployment routes
  through them. That is precisely "poor subcontracting" in the sense that once mfact's own chain
  (Lake, Lean 4, the TTL ontology, ggen) is validated once by an auditor, whether a downstream
  consumer implements it faithfully is a property of that consumer, outside what mfact controls
  — an architect who has produced a correct, stamped specification is not responsible for a
  subcontractor building the wrong thing from it. PA23/PA24 is cited here as evidence that this
  failure mode is real and has already occurred once *within this same repository*, not as an
  open question this document leaves for mfact to answer. `crates/mfact-core`'s own Rust code is,
  for this purpose, a consumer like any other: G2/G11 in `GAP_LEDGER_v26.7.12.md` track its
  cleanup as ordinary repository hygiene, not as correspondence-closing work. An auditor
  evaluating any real deployment still determines scope and sampling for whatever sits outside
  the validated chain, exactly as they would for any subcontracted component.

## 4. Explicitly not decided here

Whether any of the carriers named in §2's undischarged correspondence maps (a tenant-tagged
obligation store for Card 1, a completion-event stream for Card 2, a recovery-replay pipeline
for Card 3, a confidential-field-tagged obligation set for Card 4) should be built against
praxis's `multifractal-workflow` crate or an independent native runtime is the same open
decision `ROADMAP_CLOUD_MATH.md` §6 defers to the user. Nothing in this document requires that
decision to be made first; no card here can proceed past `ANALOGY`/`MISSING` regardless of
which substrate is eventually chosen, because the correspondence obligations in §2 are
substrate-agnostic proof work that has not been attempted yet.

## References

- `ROADMAP_CLOUD_MATH.md` — the correspondence-table/theorem-card discipline this document
  follows, and the source of the "zero production correspondence today" finding this document
  inherits for every row
- `AGENTS.md` §4 — No Ambient Theorem Authority; the typed-edge taxonomy (`PROVEN`,
  `CORRESPONDENCE`, `ANALOGY`, `MISSING`) used throughout §1-§2
- `PRAXIS_SELF_AUDIT.md` PA23, PA24 — the thermo.rs/lean_ffi_wrapper.c finding cited in §3(c):
  a doc comment quoting a real proven theorem while the code path that runs never calls it
