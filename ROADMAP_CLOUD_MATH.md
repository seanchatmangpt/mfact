# ROADMAP_CLOUD_MATH — Fortune-5 Cloud Architecture × Multifractal Workflow

Correspondence spine between Fortune-5-scale cloud-architecture concerns and MFW's actual
formal assets, written under `AGENTS.md` §4 (No Ambient Theorem Authority): every mapping
below is a typed edge, every strong claim gets a theorem card, and cloud-side bindings that
do not yet have an admitted correspondence morphism are marked `ANALOGY` or `MISSING`, not
prose-promoted. This is not a deployment plan, and it does not decide the open question of
whether `CLAUDE_ROADMAP.md` Phases 1/5-7 specify praxis's `multifractal-workflow` crate
(see §6). Sources: five read-only exploration passes over the live tree (2026-07-13); every
Lean citation below was re-grepped against the live file before this document was written.

Updated 2026-07-13.

## 1. The correspondence table

Edge types per `AGENTS.md` §4: `PROVEN` (kernel-checked theorem exists), `CORRESPONDENCE`
(explicit bridge admitted with obligations discharged), `ANALOGY` (shared shape, no admitted
bridge — never supports theorem prose), `MISSING` (no formal object on the cloud side at
all). The workflow-side column states what is actually proven; the cloud-side column states
the binding's current honest type.

| Cloud concern | MFW formal object | Workflow side | Cloud binding |
|---|---|---|---|
| Multi-region eventual consistency | `replay_eq_of_traceEq` (`Swarm11/Replay.lean:105`), `swap_locallyConfluent` (`NewmanCorrespondence.lean:305`) | PROVEN (finite, commuting) | ANALOGY |
| Substrate portability (N runtimes) | `replay_preserved` (`Correspondence/AtomVM.lean:54`) | PROVEN (given bridge) | CORRESPONDENCE-shaped, uninstantiated |
| Mandatory audit / no rogue actuation | `zero_unreceipted_completion` (`MFW/Runtime.lean:62`), `ValidReceipt` (`Swarm11/Replay.lean:143`) | PROVEN | ANALOGY |
| Parallel-dispatch width (autoscaling) | `enabled_frontier_isAntichain` (`MFW/Order.lean:48`) | PROVEN | ANALOGY |
| Minimal blast radius / change sets | `residue_is_antichain` (`Residue/Antichain.lean:81`), `residue_purity` (`:113`) | PROVEN | ANALOGY |
| Multi-region topology, forced cuts | `projection_path_independence` (`Workflow/Multifractal.lean:53`), `edge_to_in_boundary` (`:67`) | PROVEN | ANALOGY |
| Governance / evidence ceilings | `Standing`, `canClaimTheorem` (`Swarm11/Standing.lean:25,47`) | PROVEN | ANALOGY |
| Capacity cost ceiling | `work_bounds` (`Thermo.lean:30`) | PROVEN | ANALOGY (see card 5) |
| Workload heterogeneity spectra | `Playground/Multifractal/*` (`Z(q,n)`, `τ(q)`, `f(α)` defs) | DEFINITIONAL only | MISSING (see §3) |
| Tenancy isolation | none — closest: residue independence + boundary cuts | — | MISSING (Wave CM2) |
| Quota / rate limits | none (G32 shows an *unenforced* internal bound) | — | MISSING (Wave CM0) |
| Trust-boundary ingress | Wave S0 admission `a_i : O_i → O_i* ∪ Refusal` (`ROADMAP_SWARM_SUPPLY_CHAIN.md`, unbuilt) | TARGET | MISSING (Wave CM0) |

What would admit each `ANALOGY` edge: a theorem card naming the concrete cloud carrier (a
real event-log type, a real telemetry record, a real region graph), the map into the MFW
carrier, and the preserved structure — then discharging the obligations. §2 drafts the five
strongest cards; each states precisely what remains undischarged.

## 2. Theorem cards (the five strongest mappings)

### Card 1 — Reordered multi-region event logs replay to one state

- Object: `List Event → State → State` deterministic fold (`Swarm11/Replay.lean:27`), with
  trace equivalence `TraceEq` closed under adjacent commuting swaps.
- Imported theorem: none (native). Proven: `replay_eq_of_traceEq` (`Replay.lean:105`);
  `swap_locallyConfluent` (`NewmanCorrespondence.lean:305`) unconditionally.
- Source hypotheses: finite traces; a *proof of commutation* for each swapped pair; for full
  confluence, termination — which is kernel-refuted for the symmetric relation
  (`not_terminating_of_cycle`, `NewmanCorrespondence.lean:109`), leaving the `OrientedSwap`
  normal-form route open (P22, `ROADMAP_SWARM_SUPPLY_CHAIN.md`).
- Correspondence map (undischarged): a real multi-region event-log type (e.g. per-region
  ordered logs with vector-clock concurrency) → `List Event`, with commutation proofs
  derived from declared operation independence, not assumed.
- Preserves: final replayed state across commuting reorderings.
- Conclusion if admitted: CRDT-style convergence for the mapped log class.
- Standing: `PROVEN_CONDITIONALLY` (workflow side); cloud edge `BLOCKED_ON_CORRESPONDENCE`.

### Card 2 — One workflow, N regional runtimes

- Object: `StepCorrespondence` bridge record (`Correspondence/AtomVM.lean:33`).
- Proven: `replay_preserved` (`:54`) — a one-step commuting square lifts to every finite
  trace: `encode (replay abstract t s) = replay runtime t (encode s)`.
- Source hypotheses: an *inhabited* bridge per runtime — `encodeState`, both step functions,
  and the `preservesStep` proof. The structure deliberately grants no runtime authority by
  name (`AtomVM.lean:29`).
- Correspondence map (undischarged): one inhabitant per real regional substrate (BEAM, WASM,
  container runtime). Zero inhabitants over non-toy state exist today; the sweeping
  `κ_runtime` version is flagged OVERCLAIM in `ROADMAP_SWARM_SUPPLY_CHAIN.md` C1.
- Preserves: full finite-trace replay equality across substrates.
- Standing: `PROVEN_CONDITIONALLY`; each concrete substrate edge `BLOCKED_ON_CORRESPONDENCE`.

### Card 3 — No completed action escapes audit

- Object: `ExecutionState n` with invariant `completionReceipted` (`MFW/Runtime.lean:52`).
- Proven: `zero_unreceipted_completion` (`:62`); receipt validity `manufacturedReceipt_valid`
  (`Swarm11/Replay.lean:149`). Receipts bind consequence, explicitly not cryptographic
  authenticity (`Replay.lean:125`).
- Source hypotheses: all actuation flows through states satisfying the invariant — i.e. the
  runtime enforces the type. The authority-token rule ("public IDs are not authority
  tokens", `CLAUDE_ROADMAP.md`) is prose, not yet a carrier.
- Correspondence map (undischarged): real cloud actuation events (API mutations) → the
  `completed`/`receipted` predicates; the crypto layer is a separate, unformalized system.
- Standing: `PROVEN` (invariant); cloud edge `BLOCKED_ON_CORRESPONDENCE`.

### Card 4 — Safe parallel-dispatch width

- Object: `StrictOrder n` on `Fin n` with `Enabled`/`Concurrent` (`MFW/Order.lean:16,29`).
- Proven: `enabled_frontier_isAntichain` (`:48`) — the enabled frontier is pairwise
  concurrent, so dispatching all of it in parallel violates no declared order.
- Source hypotheses: the declared strict order faithfully captures *all* real dependencies
  (data, quota, side-channel). An undeclared dependency falsifies the safety claim.
- Correspondence map (undischarged): real task DAGs (deploy pipelines, fan-out jobs) →
  `StrictOrder n`, with completeness-of-dependencies as an explicit admission obligation.
- Conclusion if admitted: the antichain width is a proven lower bound on safe horizontal
  parallelism at each instant — the formal core of an autoscaling width policy.
- Standing: `PROVEN`; cloud edge `BLOCKED_ON_CORRESPONDENCE`.

### Card 5 — Cost ceiling as free energy

- Object: `Process S G` with `first_law`/`second_law` fields (`Thermo.lean`).
- Proven: `work_bounds` (`Thermo.lean:30`): `p.W ≤ F S G p.T`, a genuine `linarith`
  discharge, not tautological.
- Source hypotheses: the two laws hold for the mapped quantities — this is the entire
  question. No telemetry→`State` morphism exists; `ROADMAP_GAP_THERMO.md` records zero
  structural matches in the runtime, and `CLAUDE_ROADMAP.md` §8 itself forbids claiming
  literal energy without a proven transfer.
- Correspondence map (undischarged, Wave CM1): instance-hours/queue-depth/request-rate →
  `U`, `S`, `T` with the two laws *derived* for that reading, or the edge is refused.
- Standing: `PROVEN` (bound); cloud edge `ANALOGY` — the weakest of the five, kept because
  it is the only capacity-side theorem that exists at all.

## 3. The multifractal gap, stated honestly

`Playground/Multifractal/` holds correct, Mathlib-typed definitions of the full classical
apparatus: partition function `Z(q,n)` (`PartitionFunction.lean:57`), mass exponent `τ(q)`
as a filter limit (`MassExponent.lean:22-46`), generalized dimensions `D_q`
(`GeneralizedDimension.lean:28`), local Hölder exponent `α(x)` (`LocalExponent.lean:45`),
and the genuine singularity spectrum `f(α)` as `dimH` of exponent level sets
(`HausdorffSpectrum.lean:40-47`). The only proven lemma in the package is a one-line
`csInf_le` Legendre bound (`Legendre.lean:32`). No convergence, no scaling law, no computed
spectrum. Elsewhere, "multifractal" names non-fractal math: `Workflow/Multifractal.lean` is
DAG boundary-cut functoriality (real theorems, zero measure theory); `MFW/Multifractal.lean`
is finite `Nat` moment arithmetic whose own docstring refuses the asymptotic claim;
`research-papers/smfdcca` is a stub whose one theorem re-extracts its hypothesis fields.

The minimal object that would make the name load-bearing for cloud workload heterogeneity:
a multiplicative-cascade measure `μ` on the boundary space of a POWL execution tree, with
branching weights from declared fan-out, then (a) `HasMassExponent μ P σ q τ` proven for
the geometric scale already defined in `Scale.lean`, and (b) one computed instance of
`localExponentHausdorffSpectrum μ σ α` matching `concaveLegendre τ`. Heavy-tailed fan-out
across regions is the cloud phenomenon this would model — but only after (a) and (b) exist.
Until then every "multifractal cloud" sentence is an `ANALOGY` edge. This is Wave CM3.

## 4. Lean waves CM0-CM3

Format follows `ROADMAP_MATH_SPINE.md` §4. Ceilings use its marker schema.

### Wave CM0 — Cloud carrier vocabulary and ingress admission

- Deliverables: a `cloud:` ontology namespace (Tenant, Region, Service, Quota, Boundary) —
  the existing `compat:`/`pi:` namespaces are process-mining vocabulary with zero
  infrastructure terms; plus the Wave S0 admission gate `a_i : O_i → O_i* ∪ Refusal`
  instantiated for external service returns (a cross-boundary response has no standing
  until re-admitted — the F20/F02 law, currently prose).
- Reuses: catalog §2.3 (admission typing), §6.3 (exactly-once dispatch + authority tokens),
  §6.6 (chained boundary receipts) from `MFW_WORKFLOW_CATALOG.md`.
- Ceiling: `DEFINITIONAL` + one admission-refusal countermodel per carrier.
- Carrier note (2026-07-13): `ontology/fortune5-cloud-architecture.ttl` (public-vocabulary-only
  Turtle graph — `dcat`/`prov`/`org`/`odrl`/`sh`/`sosa`/`qudt`/`skos`/`schema`/`togaf` prefixes,
  no private namespace, no custom `@base`, all enterprise-specific resources are blank nodes) is
  now vendored in-repo as a candidate data carrier for this wave's `cloud:` namespace, verified
  byte-identical to its source via SHA-256 (`2ba847d7c27a775fcad263f55d43bfaf41133316dfae93d9ebf19985bd53ba2c`,
  1,664,092 bytes). This is a production/carrier fact only: no correspondence morphism between
  the ontology's PROV shape (`prov:Entity`, `dcat:Dataset`, receipt-shaped blank nodes) and any
  MFW Lean type is admitted (`AGENTS.md` §4), so vendoring it does not raise the standing of any
  theorem card in this document. Status: `CARRIER-ONLY`.

### Wave CM1 — Telemetry correspondence for the cost ceiling

- Deliverables: the Card-5 morphism as a real theorem card — map measured quantities to
  `Thermo.State`, derive (not assume) `first_law`/`second_law` for that reading, or record
  a refusal. Independently: replace `turbulence.rs`'s hardcoded `alpha > -0.5` trigger with
  a data-fitted critical point, or downgrade its output banner to remove the phase-change
  claim (`AGENTS.md` §2 requires the threshold be computationally verified, not asserted).
- Ceiling: `PROVEN_CONDITIONALLY` at best; refusal is an acceptable outcome.

### Wave CM2 — Tenancy isolation as residue independence

- Deliverables: the one genuinely new theorem this document proposes. Carrier: obligations
  tagged by tenant; goal: cross-tenant obligations never share a minimal support —
  isolation as a provable property of the residue geometry, composed with the boundary-cut
  theorems (`edge_to_in_boundary`) so cross-tenant influence is forced through explicit
  cuts. Builds directly on `eq_of_subset_of_sufficient_of_isMinimalSupport`
  (`Residue/MinimalSupport.lean:97`) and `residue_purity`.
- Ceiling: `TARGET_THEOREM` until the tagged carrier exists; then `PROVEN` is realistic —
  the component lemmas are already kernel-checked.

### Wave CM3 — The cascade-measure multifractal wave

- Deliverables: §3's minimal object — cascade measure on POWL boundary space,
  `HasMassExponent` for the geometric scale, one computed `f(α)` instance. Mathlib at this
  pin supplies `dimH` and Hausdorff measure but no box-counting dimension; the level-set
  route through the existing definitions is the viable one.
- Ceiling: `TARGET_THEOREM`. Largest wave; do not start before CM0-CM2 or the spectrum has
  no cloud carrier to be a spectrum *of*.

## 5. Problem ledger

- CL1 — No inhabited `StepCorrespondence` over non-toy state (blocks Card 2's cloud edge).
  Falsifier: exhibit a bridge whose `preservesStep` fails on a real substrate step.
- CL2 — Commutation proofs for real event logs do not exist (blocks Card 1). Falsifier: two
  declared-independent operations whose replay orders diverge.
- CL3 — Inherited: P22 `OrientedSwap` normal form open; symmetric `Swap` termination is
  kernel-refuted (`not_terminating_of_cycle`), so full confluence stays conditional.
- CL4 — Inherited: `κ_FR : PhysicalTransition → ReceiptEvent` named but never signed
  (`ROADMAP_SWARM_SUPPLY_CHAIN.md` C2); actuation-authority chain incomplete.
- CL5 — `REAL_EDGE`/`CausalHole` predicates (`CLAUDE_ROADMAP.md:815-823`) unmechanized; a
  cloud service can be deployed, healthy, tested, and have zero production callers without
  any check firing. Also only 2 edge states vs. the 5-state taxonomy practice uses.
- CL6 — Dependency completeness for Card 4 is an admission obligation with no tooling: an
  undeclared dependency silently falsifies the parallel-safety claim.
- CL7 — Empty stubs carrying roadmap weight: `scalar_dissipation`, `revops_turbulence`,
  `star_graphs` (0-21 bytes); `smfdcca`'s vacuous theorem. Either build or strike from
  `ROADMAP.md`'s bridge list (G13 territory).
- CL8 — No quota carrier anywhere; the one internal bound found is claimed-but-unenforced
  (G32: depth cap 256 commented, 513 passes).

## 6. Explicitly not decided here

Whether `CLAUDE_ROADMAP.md` Phases 1/5-7 specify praxis's already-running
`multifractal-workflow` crate or are an independent reformulation remains the user's open
decision (`PRAXIS_DOGFOODING_EXPLORATION.md` §4 item 1). It bears on rows 2, 3, and 12 of
§1: if dependence is chosen, Cards 2 and 3's correspondence maps target praxis's F16/F18
runtime as the concrete substrate; if independence is chosen, CM0's carriers must include a
native runtime model first. Nothing in Waves CM0-CM2 requires the answer; CM3 does not
either. Only the substrate instantiation of Cards 1-3 waits on it.

## References

- `ROADMAP_MATH_SPINE.md` — Crown spine, marker schema, Waves M0-M5
- `ROADMAP_SWARM_SUPPLY_CHAIN.md` — Waves S0-S3, P14-P22, correspondence corrections
- `MFW_WORKFLOW_CATALOG.md` — reusable primitives cited in Wave CM0
- `GAP_LEDGER_v26.7.12.md` — G13, G32, Selection law
- `AGENTS.md` §§2-4 — construction discipline, phase-change evidence rule, theorem cards
