# RELEASE_v26.7.13 — Architecture Requirements Document

This is the first ARD this repository has produced for a core release. No prior ARD/PRD
precedent exists at repo root (the only file matching that name pattern is
`PYLAB-PRD-ARD-v26.7.7.md`, scoped to `pylab/`, not the core release). This document is
modeled on the header/section conventions observed in `GAP_LEDGER_v26.7.12.md` and the
`ROADMAP_*.md` family: a descriptive title (version in the filename, not forced into the H1),
an `Updated <date>` line, `AGENTS.md` §4 cited as the governing discipline, and related docs
cited inline near point of use rather than in a trailing footer — the pattern this repo's own
documents follow more consistently than the generic footer-References convention.

Updated 2026-07-13.

Scope: branch `v26.7.12-close`, 78 commits ahead of `main..HEAD`, merge-base `c0ffeed3`
(`git merge-base HEAD main`, re-run live). This document covers architecture only — what
formal/structural state this branch establishes and what remains open. Consumer-facing
delivery is `RELEASE_v26.7.13_PRD.md`.

## 1. Executive summary

The prior certified tag (`v26.7.7-procint-certified`, `STANDING.md`) described a 318-artifact,
145-proven ontology with a working Lean core but no cross-layer bridges: the DAG-ranking layer
(Workflow.Multifractal), the causal-replay layer (Swarm11.Replay), the residue/closure layer
(MFW.Residue), the termination layer, and the SOC2 correspondence layer each existed but did
not connect to one another. This branch's principal architectural contribution is nine new
Lean files (procint/ProcInt/Playground/Glue/*, Multifractal/UniformWitness.lean,
MFW/Residue/Tenancy.lean, MFW/Termination/*, Swarm11/Correspondence/LedgerBridge.lean,
SOC2/AuditFlow*.lean, SOC2/ManufactureTenancyGap.lean) that cross those layer boundaries for
the first time, plus a corrected CI substrate (12 relocated Lean workflow YAMLs — see
§2 of the PRD) and a Rust cleanup that removed a dead FFI apparatus (`crates/mfact-core`,
`build.rs` now `fn main() {}`, verified live).

Per `AGENTS.md` §4 (No Ambient Theorem Authority), none of this is reported as a finished
system: each bridge is scoped file-by-file, each correspondence-table cell that remains
`ANALOGY` or `MISSING` is reported as such, and the `procint` tree overall still carries 566
`sorry` occurrences (`grep -rE '\bsorry\b' procint --include='*.lean' | wc -l`, re-run live)
across 15 touched-or-added files — so "kernel-checked" claims below are scoped to the specific
files named, not extended to the tree as a whole.

## 2. Cross-layer bridges now proven

All nine files were re-read in full and re-verified against the live tree for this document
(sorry counts and line counts below are freshly measured, not transcribed — see §7 for two
corrections to figures carried in the source survey). All eight wave commits are present in
`git log --oneline` at HEAD: `69df262` (wave1), `250fcc7` (wave2), `d6fc2a3` (wave3),
`782bf6c` (wave4/CM2), `6270a44` (wave5/CL1), `d4ed2f3` (wave6/M1, 4-file chain),
`8338516` (SOC2 composition), `bb25faf` (doc fix), `84ab3de` (wave7).

### Wave 1 (A×D) — DAG rank-order bridge

`procint/ProcInt/Playground/Glue/RankOrder.lean` (76 lines, 0 `sorry`). Connects
`Workflow.Multifractal`'s DAG structure to the Wave-M0 admitted obligation order via
`DAG.edge_lt`, `StrictOrder.ofRank`, and `dag_rank_enabledFrontier_isAntichain`
(theorem, line 72) — the enabled frontier of a DAG under a rank-respecting strict order is an
antichain in `MFW.Order`'s sense. Standing: `PROVEN` for the abstract carrier.

### Wave 2 (C×B) — BRCE runtime × causal-replay bridge

`procint/ProcInt/Playground/Glue/RuntimeReplay.lean` (122 lines, 0 `sorry`). Defines
`completeStep` over `ExecutionState`, proves `concurrent_commute` (line 96) and
`frontier_interleaving_replay_eq` (line 115), connecting the BRCE runtime layer to
`Swarm11.Replay`'s `Commute`/`TraceEq`/`replay_eq_of_traceEq` machinery.

### Wave 3 — first genuine multifractal scaling-law theorem (monofractal witness)

`procint/ProcInt/Playground/Multifractal/UniformWitness.lean` (180 lines, live count —
see §7 correction; 0 `sorry`). Proves `partitionFunction_uniformDyadic` (exact, line 104),
`hasMassExponent_uniform` (a genuine `Tendsto` limit, line 151), and
`lowerGeneralizedDimension_uniform` / `upperGeneralizedDimension_uniform` (lines 163, 172):
Lebesgue measure under the uniform dyadic partition is monofractal, `D_q = 1` at every
admissible Rényi order. The file's own docstring is explicit this is **not** yet a genuine
multifractal (two-weight/Bernoulli-cascade) witness — that construction is refused as
unbuildable at the pinned Mathlib commit (no `Fintype`-free infinite-product /
Ionescu–Tulcea cylinder-measure construction), scoped forward as Wave CM3.

### Wave 4/CM2 — tenancy isolation as residue independence

`procint/ProcInt/MFW/Residue/Tenancy.lean` (0 `sorry`). Defines `Separated C tag` (weaker
than full closure factorization) and proves `minimalSupport_tenant_pure` (line 86) and
`crossTenant_residue_disjoint` (line 111) unconditionally given `Separated`. Includes a
mandatory countermodel (`not_separated`, `tenant_purity_conclusion_fails`, lines 197-onward)
exhibiting a concrete 2-obligation/2-tenant closure where `Separated` genuinely fails and the
conclusion fails alongside it — discharging AGENTS.md §3's non-vacuity mandate. The
docstring states composition with the Wave-1 DAG boundary-cut theorems remains **MISSING**:
no correspondence morphism has been admitted between `Residue.residue` and
`Workflow.Multifractal`'s DAG machinery.

### Wave 5/CL1 — first non-toy `StepCorrespondence` inhabitant, plus an impossibility result

`procint/ProcInt/Playground/Swarm11/Correspondence/LedgerBridge.lean` (186 lines, live
count — see §7 correction). `crownLedgerCorrespondence` (def, line 102) is a genuine
non-identity model-to-model bridge from Crown's `(Nat × Nat)` counter pair to a
structurally different `Ledger` record (`Nat` total + `Int` diff), with the one-step
commuting square closed by `omega`, not `rfl` — stronger than the prior toy witness
(`Int.ofNat` identity in `Swarm11Tests/Correspondence.lean`). `no_log_correspondence`
(line 138) and `no_ledgerLog_correspondence` (line 170) prove no `encodeState` can bridge
`Crown.step` to an append-log runtime, because `Crown.step` commutes on its two event
constructors while list-append never does — a genuine negative result. This does **not**
license calling the bridge a correspondence to any concrete external runtime; that
instantiation is explicitly left open (CL1 in `ROADMAP_CLOUD_MATH.md`).

### Wave 6/M1 — Crown II descent for the abstract carrier, plus a self-discovered gap

The four-file chain
`procint/ProcInt/MFW/Termination/{ObligationRank,ManufactureDecrease,MultisetDescent,
CrownWellFounded}.lean` proves `no_infinite_productive_mfw_chain`
(`CrownWellFounded.lean:66`) by pulling back `Multiset.wellFounded_isDershowitzMannaLT`
along the `CrownState` rank function — `PROVEN` for the abstract `CrownState`/
`ManufactureStep` carrier, not yet discharged for any concrete workflow-engine transition
relation. `procint/ProcInt/Playground/SOC2/ManufactureTenancyGap.lean` (0 `sorry`) then
exhibits a real soundness gap this chain implies: `ManufactureStep`'s definition
(`∀ c ∈ children, c < a`) is silent on tenancy, so a manufacture step can legally replace a
tenant-B obligation with a tenant-A obligation as its sole child —
`manufactureStep_not_tenant_pure` (line 110) is the general refutation, built by reusing
`AuditFlow.lean`'s two-tenant closure verbatim, in the same exhibited-counterexample
style as Wave 7's `not_orientedSwap_locallyConfluent`.

### Wave 7 — unconditional Newman confluence for `OrientedSwap(completeStep)`

`procint/ProcInt/Playground/Glue/OrientedSwapReplay.lean` (219 lines, 0 `sorry`).
Composes Wave 2's `concurrent_commute` with `Swarm11/OrientedSwap.lean`'s previously-open
`LocallyConfluent` theorem card: `completeStep_commute_all` (line 74) discovers
`concurrent_commute`'s proof never actually used its `Concurrent` hypothesis, so
`completeStep` commutes unconditionally at every pair, not just concurrent ones. This
supplies the missing third-witness hypothesis, yielding
`orientedSwap_locallyConfluent_completeStep` (line 105) unconditionally, and
`orientedSwap_confluent_completeStep` (line 165) via Newman's Lemma
(Cslib's `Relation.LocallyConfluent.Terminating_toConfluent`) — a genuine new `PROVEN`
general theorem, not a hand-picked instance.

### SOC2 composition — cross-wave, one toy scenario, no correspondence-table cell moved

Commit `8338516`, doc fix `bb25faf`. `procint/ProcInt/Playground/SOC2/AuditFlow.lean`
(535 lines, 0 `sorry`) and `AuditFlowViolation.lean` (148 lines, 2 `sorry`) instantiate the
tenancy (CC6), receipt (PI1.3), and replay (A1) obligation cards together on one shared
concrete two-tenant, three-step audit trail — the first file to show these three
independently-proven theorem families actually compose when instantiated on shared data.
`AuditFlowViolation.lean` is the negative companion, reusing `Tenancy.lean`'s countermodel
verbatim to show what a control failure looks like when `Separated` fails; it is the only
one of the nine bridge files that is not fully `sorry`-free. Both files' own docstrings
state this composition moves nothing in `ROADMAP_SOC2_MATH.md`'s correspondence table past
`ANALOGY`/`MISSING` — it is workflow-side composition evidence only.

## 3. Correspondence-table status — what remains ANALOGY or MISSING

Per `AGENTS.md` §4, a `PROVEN` workflow-side theorem does not by itself license a `PROVEN` or
`CORRESPONDENCE` cell on the production/cloud/compliance side. Re-grepped live against
`ROADMAP_CLOUD_MATH.md` and `ROADMAP_SOC2_MATH.md`:

- `ROADMAP_CLOUD_MATH.md` edge-taxonomy token counts: `PROVEN` 15, `ANALOGY` 13, `MISSING` 7,
  `BLOCKED_ON_CORRESPONDENCE` 4, `PROVEN_CONDITIONALLY` 3, `DEFINITIONAL` 2,
  `CORRESPONDENCE` 2. Every workflow-side cell that is `PROVEN` has a cloud-side binding of
  `ANALOGY`, `MISSING`, or `BLOCKED_ON_CORRESPONDENCE` — none reach `CORRESPONDENCE` or
  `PROVEN` on the production side. Concrete rows: multi-region eventual consistency
  (`replay_eq_of_traceEq`, `swap_locallyConfluent` — `PROVEN` workflow-side) is `ANALOGY`
  cloud-side; tenancy isolation (`crossTenant_residue_disjoint`, `Tenancy.lean:111`) is
  `PROVEN` for residue independence but the boundary-cut composition is `MISSING`, cloud-side
  still `ANALOGY`; quota/rate limits has no workflow-side theorem at all (`MISSING`, Wave CM0).
- `ROADMAP_SOC2_MATH.md` edge-taxonomy token counts: `MISSING` 17, `ANALOGY` 14, `PROVEN` 11,
  `CORRESPONDENCE` 4, `PROVEN_CONDITIONALLY` 3. Organizational TSC criteria (CC1-CC5, CC7-CC9,
  Privacy) are `MISSING` by kind, not by unstarted effort — a stated permanent fence, not a
  todo. Only four criteria (CC6, A1, PI1, C1) have a workflow-side `PROVEN`/
  `PROVEN_CONDITIONALLY` theorem, and each of those four still has a production-side binding
  no stronger than `ANALOGY`. The document's own disclaimer: "No theorem in this repository
  is, or could ever be, SOC 2 compliance."

This release therefore proves new *workflow-side* theorems (§2) without discharging any new
*correspondence* edge to a concrete external system. That distinction is the architectural
headline of this release: depth increased inside the Lean model; width across the
model/production boundary did not.

## 4. No-Ambient-Theorem-Authority enforcement state

`AGENTS.md` §4 is not aspirational prose in this branch — it is mechanically applied. Fresh
`grep -rl "Standing:"` across `.lean`/`.md` hits 35 files. Every one of the nine bridge files
in §2 carries an explicit module-header theorem card (Object / Imported theorem / Source
hypotheses / Correspondence map / Preserves / Excludes / Standing / Falsifier / Downstream),
matching the exact shape §4 prescribes. The edge taxonomy (`DEFINITIONAL`, `PROVEN`,
`IMPORTED`, `CORRESPONDENCE`, `CONJECTURAL`, `ANALOGY`, `MISSING`) is used consistently across
`ROADMAP_CLOUD_MATH.md`, `ROADMAP_SOC2_MATH.md`, `ROADMAP_MATH_SPINE.md`, and
`ROADMAP_SWARM_SUPPLY_CHAIN.md` — no document in this branch reports an `ANALOGY` edge as if
it were a `PROVEN` or `CORRESPONDENCE` one.

The discipline also caught its own errors within the branch: `MFW_WORKFLOW_CATALOG.md` §1.1
had overstated Wave M1's dependency graph (listing `residue_isAntichain`/`residue_purity` as
scaffolding the four `MFW/Termination/*.lean` files do not actually import — corrected after a
live grep, not assumed). `PRAXIS_SELF_AUDIT.md` records 14 independent re-verification passes
(Pass 2 through Pass 15, `grep -nE '^## Pass [0-9]+' PRAXIS_SELF_AUDIT.md`) over this branch's
own claims, several of which downgrade or correct earlier entries in the same document.

Two enforcement gaps remain open, disclosed rather than papered over:

- No self-audit pass in this branch has ever run an actual `lake build`/`lake env lean` on the
  new Lean content — `which lean lake` in the sandboxed audit shell returns not-found (a real
  login shell has `~/.elan/bin` on `PATH`; the audit shell does not), so every completeness
  verdict for the nine bridge files above rests on source inspection plus the `.olean`
  timestamp evidence in §2, not an independently re-run build. `PRAXIS_SELF_AUDIT.md`'s own
  Pass 14/Pass 12 entries record this as `UNVERIFIABLE` / a weaker grep-only proxy.
- `PRAXIS_SELF_AUDIT.md`'s last entry (Pass 15) reviewed HEAD `836fb53`; live HEAD is 7 commits
  ahead (`f735022`), including two substantive, un-audited commits (`84ab3de`, the Wave 7
  confluence proof and tenancy gap; `f735022`, the 93-file Testing Atlas vendor-drop). Their
  claims currently stand only on their own commit messages and this document's fresh spot
  checks (§7), not on a completed self-audit pass.

## 5. Standing open architecture decisions

- **CLAUDE_ROADMAP.md Phases 1/5-7 vs. praxis's `multifractal-workflow` crate — explicitly
  out of scope for this document too.** `ROADMAP_CLOUD_MATH.md` §6, `MFW_WORKFLOW_CATALOG.md`
  (lines 43-47 and 2497-2499), and `PRAXIS_DOGFOODING_EXPLORATION.md` §4 item 1 all
  independently flag the same unresolved fork: whether `CLAUDE_ROADMAP.md`'s Phases 1 and 5-7
  *specify* praxis's already-running `multifractal-workflow` Rust crate, or are an independent
  reformulation. Every one of those documents declines to decide it and defers to the user.
  This ARD makes the same choice and does not resolve it — it bears on at least the DAG-rank
  bridge (§2, Wave 1) and the tenancy bridge (§2, Wave 4), since both formalize workflow
  concepts that may or may not already have a production analogue in that crate.
- **Multifractal witness scope (Wave CM3).** A genuine two-weight/Bernoulli-cascade
  multifractal measure remains unbuildable at the currently pinned Mathlib commit; §2's Wave 3
  result is monofractal only. This is the largest remaining wave in `ROADMAP_CLOUD_MATH.md`'s
  plan and is not attempted in this branch.
- **DAG-boundary/residue composition (Wave CM2 residual).** Composing Wave 1's DAG rank-order
  bridge with Wave 4's tenancy-as-residue-independence result remains `MISSING` — no
  correspondence morphism has been admitted between `Residue.residue` and
  `Workflow.Multifractal`'s DAG machinery, per `Tenancy.lean`'s own docstring.
- **`ManufactureStep` tenancy soundness.** Wave 6's `manufactureStep_not_tenant_pure` is a
  disclosed defect, not a fix: `ManufactureStep`'s definition permits tenancy-crossing
  manufacture steps. No repair is scoped in this branch; it is reported as an open item for
  whichever release addresses production-side manufacture semantics.
- **`crates/mfact-core` Lean-FFI apparatus.** This branch deleted the dead/fake FFI layer
  (broker.rs, lean.rs, lean_ffi_wrapper.c, main.rs, thermo.rs, transport.rs — all confirmed
  absent from `git ls-files crates/mfact-core/`, re-run live) rather than repairing it. No
  replacement FFI bridge between compiled Lean theorems and `crates/mfact-core`'s Rust runtime
  exists in this branch; whether one is needed is itself an open architecture question, since
  the prior implementation's docstrings quoted proven Lean formulas verbatim while the function
  bodies returned hardcoded constants (`PRAXIS_SELF_AUDIT.md` PA23/PA24, `ROADMAP_SOC2_MATH.md`
  §3(c)).

## 6. Scale reference

`procint/ProcInt` contains 185 `.lean` files total (fresh count); `Playground/` (the
hand-authored demonstration surface, not ggen-rendered, not release-gating) contains 109;
`MFW/` (the formal core — `Residue/` plus `Termination/` plus other layers) contains 9. The
nine files in §2 are a small but structurally load-bearing slice: they are the only files in
the tree that cross previously-disconnected layers rather than adding depth within one layer.

## 7. Corrections to source-survey figures

Two line counts cited in the originating survey were re-measured against the live tree and
differ from what this document uses; both are corrected in place above rather than carried
forward uncritically, per `AGENTS.md` §4's "verify against the live environment" rule:

- `Multifractal/UniformWitness.lean`: survey cited 189 lines; live `wc -l` gives 180. This
  document uses 180.
- `Swarm11/Correspondence/LedgerBridge.lean`: survey cited 199 lines; live `wc -l` gives 186.
  This document uses 186.

All other line counts, `sorry` counts, commit hashes, theorem/def names, and file existence
claims cited in §2 were independently re-verified against the live tree while writing this
document (grep for each named theorem, `wc -l` for each named file, `git log --oneline` for
each commit hash) and matched the source survey exactly.

## See Also

- `AGENTS.md` — the No Ambient Theorem Authority law this document is written under (§4).
- `ROADMAP_CLOUD_MATH.md` — full correspondence table and theorem cards for §3.
- `ROADMAP_SOC2_MATH.md` — full TSC correspondence table and theorem cards for §3.
- `ROADMAP_MATH_SPINE.md` — the theorem-spine document Wave 6/M1 belongs to.
- `MFW_WORKFLOW_CATALOG.md` — the CLAUDE_ROADMAP/multifractal-workflow open decision (§5).
- `PRAXIS_SELF_AUDIT.md` — the 14-pass self-verification ledger referenced in §4.
- `RELEASE_v26.7.13_PRD.md` — the companion product-facing document for this release.
