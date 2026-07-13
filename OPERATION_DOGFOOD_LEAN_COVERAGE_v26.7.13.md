# Operation Dogfood v26.7.13 — Lean Coverage Report

Updated 2026-07-13. Governing sources: `Operation_Dogfood_PRD_v26.7.13.md`, the praxis-side
SOC2/DfCM audit prompt, `MFW_Vision_2030.md`, and the v26.7.13 Working Backwards press
release. Scope: what `~/mfact` proves or can prove in Lean 4/Lake alone — no Rust executed.

This report answers one question per PRD row: does mfact carry the mathematics and the
executable tests that witness this claim? Verdicts are one of:

1. `PROVABLE-NOW` — a kernel-checked theorem or decidable check witnesses the math today.
2. `PARTIAL` — a real Lean slice exists; the full claim does not.
3. `NOT-LEAN` — inherently runtime/Rust/adapter; a consumer obligation per the scope
   doctrine (AGENTS.md §4, `ROADMAP_SOC2_MATH.md`). Lean may model it, never discharge it.
4. `MISSING-ABLE` — no artifact yet, but formalizable in Lean (construction waves below).

Reconciliation rule: where audit lenses disagreed, the conservative verdict wins and the
discrepancy is recorded. Press-release Status Fence applies to every narrative source:
no claim in prose supersedes a verdict produced by the real artifacts.

## Claims C1–C12

| # | Claim (short) | Verdict | Evidence / gap |
|---|---|---|---|
| C1 | PDDL + POWL structure | PARTIAL | Types real; theorem content thin (see note below) |
| C2 | RDF lifecycle authority | NOT-LEAN | Graph-store runtime |
| C3 | Recon/Explore dogfooded | NOT-LEAN | Adapter runtime |
| C4 | Discovers unfamiliar Rust system | NOT-LEAN | Runtime discovery |
| C5 | Plan + permission before mutation | PARTIAL→W2 | Plan math real; permission absent |
| C6 | Governs Claude Code repair | PARTIAL | Termination proven; launch is runtime |
| C7 | Every CC tool event in RDF | NOT-LEAN | Adapter runtime |
| C8 | Rust dry-run publish succeeds | NOT-LEAN | Cargo execution; correctly REFUSED |
| C9 | Receipt & replay cover lifecycle | PARTIAL→W3 | Replay proven; lifecycle model thin |
| C10 | Public ontologies before private | NOT-LEAN | TTL namespace policy (findings below) |
| C11 | Typed outcome algebra preserved | MISSING-ABLE→W1 | No unified type; over-claim watch |
| C12 | Autonomous external publication | NOT-LEAN | Typed refusal modeled in `PostRelease` |

C1 reconciliation note: one lens rated C1 `PROVABLE-NOW` (types elaborate; small lemmas
pass); a second rated it GENEROUS — `Planning/Pddl.lean` carries exactly one theorem
(`PddlAction.mem_add_mem_apply`), `Models/Powl.lean` four well-formedness lemmas, no
projection or composition theorems, and the only real POWL boundedness theorems
(`expandLayer_bounds_strictly`, `Bounded.mono`) live in the orphan unbuilt file
`procint/test_expand.lean`. Conservative verdict: PARTIAL, promoted by Wave 4.

## Functional requirements FR-1…FR-22

| FR | Short name | Verdict | Evidence / gap |
|---|---|---|---|
| 1 | Goal admission | NOT-LEAN | RDF store creation |
| 2 | Repository snapshot | NOT-LEAN | Runtime hashing |
| 3 | Research planning | PARTIAL | `Models/Powl.lean`, `MFW/Residue/*` graft |
| 4 | Observation capture (PROV-O) | NOT-LEAN | Adapter |
| 5 | Claim derivation | PARTIAL | `Quadrature.claims_all_evidenced` |
| 6 | Bounded plan (PDDL/POWL) | PARTIAL | Same C1 reconciliation; promoted by W1+W4 |
| 7 | Approval request UI | NOT-LEAN | Presentation |
| 8 | Approval binding to plan digest | MISSING-ABLE→W2 | Hash-binding shape in `CertifiedRelease` |
| 9 | Pre-actuation guard | MISSING-ABLE→W2 | `MayStart` opaque, unenforced (below) |
| 10 | Claude Code launch | NOT-LEAN | Runtime |
| 11 | Tool lifecycle capture | NOT-LEAN | Adapter |
| 12 | Native payload integrity | NOT-LEAN | Hash fold is binding, never injective (§4) |
| 13 | Real command outcomes | NOT-LEAN | Harness-owned (PRD §6.5) |
| 14 | Typed gate result | PARTIAL→W1 | `Refusal`/`Objection`/`Standing` pieces |
| 15 | Recursive repair | PARTIAL | Termination math strong; CC invocation runtime |
| 16 | Patch admission gates | PARTIAL | `CertifiedRelease.allPass`, `no_valid_objection` |
| 17 | Replanning | NOT-LEAN | Runtime loop |
| 18 | Dry-run non-actuation | NOT-LEAN | Runtime; typed refusal in `PostRelease` |
| 19 | Receipt binding | PARTIAL→W3 | `AuditFlow` card 3; full lifecycle runtime |
| 20 | Replay verification | PARTIAL | `Swarm11/Replay.lean`, `Glue/RuntimeReplay.lean` |
| 21 | Human projection | NOT-LEAN | ggen/scripts |
| 22 | No lifecycle orphan | PROVABLE-NOW | Strongest row — see hard-invariant note |

Hard-invariant note (FR-22, PRD §5): `zero_unreceipted_completion`
(`ProcInt/Playground/MFW/Runtime.lean:62`) is the receipt analog of
`{a | actuated(a) ∧ ¬receipted(a)} = ∅`, axiom-clean, instantiated at concrete audit states
in `SOC2/AuditFlow.lean` (card 2) and re-decided in the verifier checks. Caveat, per
`ROADMAP_SOC2_MATH.md §3(c)`: it holds **by construction** — `ExecutionState` carries
`completionReceipted` as a field and `completeStep` (`Glue/RuntimeReplay.lean:58`) fuses
completion with receipt, so orphans are unrepresentable rather than dynamically refuted.
Wave 3 lifts the invariant to arbitrary event traces. `Quadrature.ttl_manifest_closed` and
`ttl_audit_closed` carry the artifact-surface no-orphan half (203 decls, closure by `rfl`).

## Non-functional requirements NFR-1…NFR-12

| NFR | Short name | Verdict | Evidence / gap |
|---|---|---|---|
| 1 | Determinism | PARTIAL | `Quadrature` closure-by-`rfl`; bytes are build-side |
| 2 | Fail closed | PARTIAL→W2 | `no_valid_objection`; closed `Refusal` vocabulary |
| 3 | Public ontology first | NOT-LEAN | See RDF findings |
| 4 | Bounded private ABI report | NOT-LEAN | Absent (RDF findings) |
| 5 | Canonical identity (RDF c14n) | NOT-LEAN | No dataset canonicalization anywhere in Lean |
| 6 | Information preservation | NOT-LEAN | Storage |
| 7 | Resumability | PARTIAL→W3 | `replay_append` exists; no composed resume theorem |
| 8 | Idempotence | PARTIAL→W3 | Replay determinism proven; step idempotence absent |
| 9 | Explainability | PARTIAL | `Refusal` constructors carry diagnostics |
| 10 | Performance | NOT-LEAN | Architecture |
| 11 | Security/redaction | NOT-LEAN | Policy |
| 12 | Agent-agnostic model | PARTIAL | `Deployment`-parametric `Runtime.lean` |

Pre-construction tally: PROVABLE-NOW 2 rows (FR-22 plus the kernel backing every PROVEN
citation), PARTIAL 20, NOT-LEAN 22, MISSING-ABLE 3 (C11, FR-8, FR-9). Post-construction
verdicts are appended at the end of the Dogfood waves (see final section).

## Executable test-surface inventory

All pass-states read from artifacts regenerated 2026-07-13; no build was run to write this
report.

| Surface | Exercises | Current state | Evidences |
|---|---|---|---|
| `just test` | 15 `#guard`, 9 `example`, 14 `decide` | PASS (standing.env) | C1, FR-6 |
| `just audit` | 203 `#print axioms` pairs, allowlist-only | `AXIOM_AUDIT=PASS` | kernel backing |
| `AxiomAuditSOC2` | 21 pairs over the SOC2 crown | build-gated | C5/C6/FR-22 |
| `swarm11-verify` | 795 decls 0-sorry; 5 crown + 24 SOC2 checks | admitted, 0 fail | C6/C9/FR-15,19,22 |
| `just certify` | proven 203/401; 3 negative controls | certified v26.7.7 | FR-16, FR-22, NFR-2 |
| `standing-quadrature` | 14 theorems incl. both closures | PASS; orphans 0 | FR-5, FR-22, NFR-1 |

## PRD standing disagreements

1. **C6 (PRD: PLANNED) — mild under-claim.** The recursive-repair governance math is proven
   today: `CrownWellFounded`, `ManufactureTenancy` (G53, closed at `11b03d2`/`050d067`),
   `MultisetDescent`, `ObligationRank`. Only the Claude Code launch is runtime.
2. **C5 (PRD: PLANNED) — mild under-claim on the plan half**, honest on the permission half
   (which is genuinely absent; Wave 2).
3. **C11 (PRD: PARTIAL_ALIVE) — the one over-claim watch.** "Algebra" implies one object.
   The outcomes are scattered (`Swarm11/Standing.lean` 7-way, `ClosureRefusal.fuelExhausted`,
   `Mfact.Refusal` 7-way, `Objection`); the exact five-valued
   `Found/Exhausted/Bounded/Unsupported/Inconsistent` inductive does not exist, and no
   non-collapse or pipeline-preservation theorem exists. `PddlPlan.validCheck` returns bare
   `Bool` (`Planning/Pddl.lean:50`), so the PRD's own Truth falsifier — a bounded search
   reported as infeasible — is structurally unavoidable in the Lean corpus today. Wave 1.
4. C8 and C12 REFUSED, C2/C3/C4/C7 PLANNED — all agree; definitionally outside Lean.

Fuller-frame ruling (user, 2026-07-13): adoption/recognition rows are EXCLUDED from the
calculus entirely; no such row appears in this report.

## Permission mathematics — the deepest gap (C5 / FR-8 / FR-9)

The word "authorized" appears in the corpus twice, and neither occurrence is
permission-to-mutate:

1. `Swarm11.Claim.authorized` is a theorem-claim standing gate (claim ceiling vs. evidence).
2. `Runtime.ExecutionState.authorized : Fin n → Prop` is abstract and opaque;
   `MayStart := Enabled ∧ authorized` exists, but `completeStep` explicitly does not check
   it (`Glue/RuntimeReplay.lean` module docstring, "Excludes"), and the one concrete
   instantiation is vacuous: `AuditFlow.s0.authorized := fun _ => True`
   (`SOC2/AuditFlow.lean:330`).

Consequently the permission analog of the hard invariant,
`{a | actuated(a) ∧ ¬authorized(a)} = ∅`, cannot currently be stated meaningfully, let
alone proven. No ODRL vocabulary exists in any Lean file. Wave 2 constructs the guard.

## Scope boundary — definitionally not Lean's job

Consumer obligations per PRD §4 ("the Rust harness owns actual command execution"),
AGENTS.md §4 (`Praxis ⊥_epistemic mfact`), and `ROADMAP_SOC2_MATH.md`:

- Claims: C2, C3, C4, C7, C8, C10, C12.
- FRs: 1, 2, 4, 7, 10, 11, 12, 13, 17, 18, 21.
- NFRs: 3, 4, 5, 6, 10, 11.

The canonical routing-around-the-type precedent is `PRAXIS_SELF_AUDIT.md` PA23/PA24: a
consumer doc-comment quoted a proven Lean formula while its body bypassed the type
entirely. A proven type-level invariant says nothing about consumer code paths that route
around the type; verifying the consumer did not is the consumer's obligation, and no Lean
theorem in this repo claims otherwise.

## Praxis audit-prompt crosswalk (Lean-relevant laws only)

| Praxis-side law | mfact status |
|---|---|
| `SearchOutcome<P>` 5-constructor enum | Wave 1 mirrors constructor-for-constructor |
| PDDL8 bounds (4096/64/8) | Wave 1 named constants; Wave 4 uses depth 64 |
| TraceEq-guarded reduction falsifier | Carried: `replay_eq_of_traceEq` + oriented-swap |
| PDDL→POWL preservation falsifier | MISSING; Wave 4 bridge lemma is the first fragment |
| Six slice-composition obligations | Praxis-side; abstract Lean model deferred (stretch) |

Per the No Ambient Theorem Authority law, the Wave 1 type mirroring the Rust enum is an
edge of type `MISSING` until an explicit correspondence morphism is admitted; the mirror
makes the morphism definable, it does not constitute it.

## RDF/ontology findings (C10, NFR-3/4/5 evidence)

1. The ggen-wired chain (17 fragments in `packs/lean-math-pack/fragments/`,
   `ontology/procint-schema.ttl`) uses zero public vocabulary — 100% `procint:`/`verif:`/
   `compat:`/`pi:`. P-Plan, EARL, SPDX, DOAP appear nowhere in the repo.
2. `ontology/fortune5-cloud-architecture.ttl` (16 `sh:NodeShape`, ~64 ODRL
   permission/prohibition/duty blocks, prov/skos/dcterms/qudt/sosa-rich) is unwired: not a
   ggen pack, not ledgered in `.mfact/artifacts.toml`. It is git-tracked (commit `0956080`;
   an earlier lens report called it uncommitted — corrected by audit Pass 19).
3. No SHACL conformance predicate exists in Lean — `Graph/Semantic.lean` (untracked) and
   `Planning/SemanticBridge.lean` are declaration-only structs, imported nowhere.
4. No generated namespace report (NFR-4) exists.
5. Canonical identity is blake3 in Python (`scripts/build_manifest.py` `foldHash`) plus
   name-sorted lists in `Quadrature`; no RDF dataset canonicalization. The AGENTS.md §4
   predicate-namespace rule (a hash fold is *binding*, never *injective*) is honored by
   omission: no Lean file dresses the fold as `Function.Injective`.

## Vision 2030 §8 — the twelve "exactly zero" measures

| Measure | Status |
|---|---|
| Unreceipted actuation | HAVE: `zero_unreceipted_completion` (+ W3 trace lift) |
| Unauthorized mutation | WAVE 2: `zero_unauthorized_completion` |
| Hand-maintained generated artifacts | HAVE: `regen-check` drift lock over 96 ledgered paths |
| `Bounded` collapsed into `Exhausted` | WAVE 1: non-collapse theorems |
| Planner claims without provenance | HAVE (artifact side): `claims_all_evidenced` |
| CC mutations outside plan+permission | NOT-LEAN (consumer); W2 models the guard |
| Lifecycle events outside RDF authority | NOT-LEAN (consumer) |
| Native payloads without content identity | NOT-LEAN (blake3 fold, Python side) |
| Critical tests without adversarial witness | HAVE: countermodel discipline (AuditFlowViolation) |
| Claims exceeding verifier standing | HAVE: `Standing.canClaimTheorem` gate + `Claim.authorized` |
| Replayed receipts diverging silently | HAVE: `replay_eq_of_traceEq`, `manufacturedReceipt_valid` |
| Private ontology terms without justification | NOT-LEAN (namespace report absent, NFR-4) |

## Construction waves (this release)

1. **Wave 1 — `Playground/Dogfood/Outcome.lean`**: unified five-valued outcome algebra,
   `bounded` carrying the resumption frontier (Vision §3.3), bound-hit-never-exhausted,
   exhausted-only-from-finite-closure (wired to `FiniteExperiment` only — Pass 19 refuted
   the claim that `reachable_is_one_of` belongs to that machinery), non-collapse
   countermodel, `PddlPlan.searchOutcome` wrapper with the `validCheck` iff-lemma, PDDL8
   constants, resume-composition law.
2. **Wave 2 — `Playground/Dogfood/Guard.lean`**: `Approval` with decidable `covers`,
   `guardedCompleteStep` with typed refusal, `zero_unauthorized_completion` over guarded
   traces, countermodel showing the unguarded step completes an unauthorized node.
3. **Wave 3 — `Playground/Dogfood/Lifecycle.lean`**: `receiptCheck` over arbitrary traces
   with the iff theorem, bridge to `completeStep` dynamics, orphan negative fixture, step
   idempotence, composed resume on `replay_append`, expected-effect ≠ observed-consequence
   separation with impersonation countermodel.
4. **Wave 4 — `Playground/Dogfood/PowlBounds.lean`**: rescue `expandLayer_bounds_strictly`
   into the built tree at depth bound 64; one bridge lemma connecting POWL expansion to the
   Termination island's obligation-descent machinery.
5. **Wave 5**: verifier fold (check count strictly above 24), `AxiomAuditDogfood.lean`
   guard pairs, gap-ledger entries, and the post-construction verdict update below.

## Post-construction verdicts

Pending — appended when the waves land, citing compiled theorem names and the refreshed
`swarm11-verifier.json`.

## See also

- `RELEASE_v26.7.13_ARD.md`, `RELEASE_v26.7.13_PRD.md` — release architecture/requirements.
- `ROADMAP_SOC2_MATH.md` — scope doctrine and the §3(c) by-construction gap.
- `GAP_LEDGER_v26.7.12.md` — gap registry (Dogfood constructions get entries at Wave 5).
- `docs/TESTING_ATLAS_INTEGRATION.md` — vocabulary crosswalk governing atlas terms.
- `AGENTS.md` §4 — No Ambient Theorem Authority; predicate namespace separation.
