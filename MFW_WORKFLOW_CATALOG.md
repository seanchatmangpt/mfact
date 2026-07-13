# MFW Workflow Catalog

## Scope

This catalog surveys six real, on-disk sources for every currently open
mathematical or engineering item that a Claude Code Workflow could close,
then proposes one launchable workflow per viable item. Nothing here is
invented filler: every entry names the specific ledger line, file:line, or
theorem it targets, and every real-math citation was independently
re-verified against the live checkout during this survey, not quoted from
memory.

The six sources:

1. `ROADMAP_MATH_SPINE.md` — Crown I-V / Wave M0-M5 formalization spine.
2. `ROADMAP_SWARM_SUPPLY_CHAIN.md` — Wave S0-S9 swarm/supply-chain spine,
   its Correction ledger (C1-C44), and its Problem Ledger (P13-P22).
3. `GAP_LEDGER_v26.7.12.md` — the 48-entry mechanical gap ledger (G1-G48)
   produced by this session's own audit-then-fix passes.
4. Three prior-session action lists: `PRAXIS_SELF_AUDIT.md` (PA/PB/PC
   findings across three audit passes), `PRAXIS_DOGFOODING_EXPLORATION.md`
   (DOG findings), and `WASM4PM_AUTONOMIC_EXPLORATION.md` together with
   `MFACT_SELF_IMPROVEMENT_LOOP.md` (W4PM/F items and the receipt schema).
5. The `ROADMAP_GAP_*.md` files. **Correction to the task framing:** only
   three such files exist on disk — `ROADMAP_GAP_AUTONOMIC.md`,
   `ROADMAP_GAP_SEMANTIC.md`, `ROADMAP_GAP_THERMO.md` (verified via
   `ls ROADMAP_GAP_*.md`, all three untracked, dated 2026-07-11/12). No
   fourth file of that name exists; this catalog reports three, not four,
   per this project's own rule to verify claims against the live tree
   rather than repeat an unverified count.
6. `CLAUDE_ROADMAP.md` — the Phase 0-15 execution plan and its blank
   achievement markers.

Every proposal below was checked against `AGENTS.md`'s Combinatorial
Maximalism mandate: no vacuous tautologies, no redundant scaffolding, and
no theorem standing claimed without an admitted correspondence. Where two
independently-discovered proposals target the same underlying defect, this
catalog says so explicitly (a cross-reference note) rather than silently
listing both as if they were separate backlog mass — padding the count
that way would itself violate the no-redundant-scaffolding rule this
catalog is built under.

**This catalog does not decide, and no entry below presupposes, whether
`CLAUDE_ROADMAP.md`'s Phases 1 and 5-7 specify praxis's
`multifractal-workflow` crate.** That is flagged in the "considered but
not viable" section as the single largest blocker in the whole survey,
and it is left for the user.

## Executive summary

- **135 real open items surveyed** across the six sources above.
- **96 support an honest, launchable, non-padded Claude Code Workflow**
  proposal — a distinct name, phased agent plan, cited real math or
  engineering asset, and a falsifiable artifact.
- **39 do not**, and are listed in full under "Considered but not
  viable," each with the specific reason (duplicate of another item,
  already resolved at current HEAD, blocked on the reserved architectural
  question, or carries no real math/engineering asset to construct
  against).
- Of the 96 viable proposals, roughly **58 (about three-fifths)** are
  load-bearing on Lean theorems, lemmas, or carrier objects **already
  kernel-checked** in this repo or in the pinned Mathlib/cslib checkout —
  they port, instantiate, generalize, or wire existing proofs rather than
  inventing new mathematics. The remaining **~38** are infrastructure,
  CI-gate, ledger-integrity, or process-discipline fixes that touch no
  Lean content at all (build wiring, receipt plumbing, doc corrections,
  loop-guard hardening). Within the math-bearing 58, a smaller subset —
  roughly 15-18, concentrated in the `ROADMAP_MATH_SPINE.md`,
  `ROADMAP_SWARM_SUPPLY_CHAIN.md`, and `ROADMAP_GAP_*.md` groups —
  requires constructing genuinely new theorem statements or admitting new
  correspondence morphisms, not just re-exporting proofs that already
  exist. This is a qualitative split, not a precision claim; several
  entries straddle both categories (e.g. a workflow that ports an
  existing proof and then proves one new corollary on top of it), and are
  counted on the side of their larger obligation.
- Entries are grouped by source ledger below, and **ranked by leverage
  within each group** — highest-value / most load-bearing first, using
  each ledger's own stated blocking relationships (e.g. `GAP_LEDGER`'s
  explicit "blocked by" adjacency list) and severity tiers where given.

---

## 1. ROADMAP_MATH_SPINE.md (5 proposals)

### 1.1 wave-m1-crown-descent

**Source:** Wave M1 (Crown II, `ROADMAP_MATH_SPINE.md:55`, target theorem,
blank marker `MFW_M1_DM_DESCENT_FORMALIZED=`).

**Executed 2026-07-13** (see `ROADMAP_MATH_SPINE.md` §4 Wave M1 for the current status:
`PROVEN` for the abstract `CrownState`/`ManufactureStep` carrier, no concrete workflow-engine
correspondence yet). The bullet below is corrected in place — the original overstated which
Wave M0 assets are actually load-bearing; the built files import and use only
`AdmittedObligationOrder`.

Formalizes the Dershowitz-Manna crown-descent theorem chain
(`ObligationRank -> MultisetDescent -> ManufactureDecrease ->
CrownWellFounded`) over Wave M0's proven residue vocabulary.

- **Phases:** 5 agents, single Lean-proof lens — fix the rank codomain,
  state the manufacture-decrease hypothesis as an explicit un-proved
  variable (not a bare axiom), derive multiset descent, derive
  well-foundedness, verify and `#print axioms`.
- **Real math assets (corrected 2026-07-13):** `Mathlib.Data.Multiset.DershowitzManna`
  (`wellFounded_isDershowitzMannaLT`, pinned rev `fabf563a`) composed with this session's own
  kernel-checked Wave M0 output — `AdmittedObligationOrder`
  (`procint/ProcInt/MFW/Residue/EntailmentOrder.lean:53`), already authored as Wave-M1
  scaffolding. The original bullet also listed `residue`, `residue_isAntichain`, `residue_purity`
  (`Residue/Antichain.lean:64,75,113`) as Wave-M1 assets; that overstated the dependency —
  `procint/ProcInt/MFW/Termination/*.lean` neither imports nor references `Residue.residue`,
  `residue_isAntichain`, or `residue_purity` (confirmed by grep against the built files). Those
  three answer a Crown I question (which supports are minimal for one entailment check), not a
  premise of Crown II's descent argument.
- **Falsifiable artifact:** four new files under
  `procint/ProcInt/MFW/Termination/`, `lake build` clean, zero
  `sorry`/`admit`, `#print axioms` output on
  `no_infinite_productive_mfw_chain` pasted into the commit.

### 1.2 theorem-21-1-assumption-ledger-recovery

**Source:** Theorem 21.1's `(A1 ∧ ... ∧ A10) ⇒ Crown` conjunction,
`ROADMAP_MATH_SPINE.md:78,115,484` — currently an unenumerated aggregate.

Recovers an individually-stated A1-A9 hypothesis list from the Crown I-IV
prose and Wave M0's proofs, so the master theorem has hypotheses to
formalize against. No Lean proof attempted — pure ledger recovery.

- **Phases:** 4 agents — extract candidate conjuncts from Wave M0-M3
  prose and the Claim Status Table, cite an existing Lean object or mark
  `MISSING`/`IMPORTED` per each, adversarial trigger-word/duplicate-edge
  check, commit the block after Correction 1.
- **Real math assets:** `residue_isAntichain`, `residue_purity`,
  `orFree_residue_subsingleton`
  (`procint/ProcInt/MFW/Residue/Antichain.lean:75,81,96,113`),
  `residue_supports_goal`, `eq_of_subset_of_sufficient_of_isMinimalSupport`
  (`MinimalSupport.lean:73,97`) as the concrete carriers for whichever A_i
  states the semantic-closure ingredient.
- **Falsifiable artifact:** a new "Theorem 21.1 — Assumption Ledger
  (A1-A9)" block in `ROADMAP_MATH_SPINE.md`, each entry with formal
  statement, source wave, standing marker, and Lean citation or `MISSING`.

### 1.3 mfw-m2-graft-consolidate

**Source:** Wave M2 (`ROADMAP_MATH_SPINE.md:313-322`) — two independent,
duplicate-vocabulary playground Workflow drafts, neither containing the
wave's two open theorems.

Consolidates the zero-sorry `Experimental/Workflow.lean` and
`Swarm11/Workflow.lean` drafts into the canonical
`procint/ProcInt/MFW/Workflow/{Signature,Free,SocketSubstitution,Graft,
GraftLaws}.lean`, then proves nested-graft associativity and
`graft_commutes_of_socket_independent`.

- **Phases:** 4 phases (survey/diff, construct 5 target files, prove the
  2 open theorems — 2 agents in parallel, verify + retire duplicates).
- **Real math assets:** `bind`, `bind_right_identity`, `bind_assoc`,
  `graft`, `graft_open_same`/`graft_hole_same` — both confirmed sorry-free
  in `procint/ProcInt/Playground/Experimental/Workflow.lean` and
  `.../Swarm11/Workflow.lean` this session.
- **Falsifiable artifact:** 5 new kernel-checked files, `#print axioms`
  per theorem/law, passing `lake build ProcInt`, zero `sorry`, and the two
  superseded playground files retired.

### 1.4 wave-m4-minimal-completion-generalize

**Source:** Wave M4 (`ROADMAP_MATH_SPINE.md:333-338`, target theorem,
blank marker `MFW_M0_RESIDUE_FORMALIZED=`).

Generalizes Wave M0's proven `SemanticClosure`/residue machinery with an
explicit admissible-completion-basis parameter to yield
`MinimalCompletion(C, x, A)`, then discharges the planning instance only
(abduction and causal-identification instances explicitly excluded).

- **Phases:** 5 agents — verify-before-generalize (baseline
  `#print axioms`), add the basis parameter and re-derive old theorems as
  corollaries at `A = univ`, instantiate against `PddlAction.apply`'s
  reachability closure, kernel-check + axiom-diff, update the roadmap's
  status line honestly (partial, not full-wave).
- **Real math assets:** `SemanticClosure`
  (`EntailmentOrder.lean:59`), `IsMinimalSupport`,
  `eq_of_subset_of_sufficient_of_isMinimalSupport` (`MinimalSupport.lean`),
  `residue_purity` (`Antichain.lean:113`), `PddlAction.apply`/
  `PddlPlan.validCheck` (`procint/ProcInt/Planning/Pddl.lean:15-63`).
  Confirmed live: zero Lean hits anywhere for Pearl's do-calculus, so the
  causal-identification instance is correctly excluded, not deferred.
- **Falsifiable artifact:** `AdmissibleBasis.lean` +
  `PddlCompletion.lean`, `#print axioms` diffed against a Phase-0
  baseline, and a `ROADMAP_MATH_SPINE.md` §4 status line reading "PROVEN
  (generalization + planning instance); abduction and
  causal-identification remain TARGET_THEOREM."

### 1.5 p13-planner-field-tropical-bridge

**Source:** P13 — Planner-Field Tropical Correspondence
(`ROADMAP_MATH_SPINE.md:353`, Correction 6, lines 168-178).

Constructs the P13 correspondence map `L : A_planner -> M_offspring` on a
concrete finite instance by extending `PddlAction` with a capability
weight and building both operators as `TropicalMatrix` objects, then
proves or falsifies cycle-mean preservation by `decide`/`native_decide`.

- **Phases:** 5 sequential agents — operator-identity audit, construct
  `A_planner`, construct `M_offspring`, exhibit-or-refute `L` on one small
  instance (a falsification is an equally valid deliverable), theorem-card
  + build verification.
- **Real math assets:** `Trop`, `TropicalMatrix`, `tropicalMul`,
  `diagonalCycleScore`, `frozenPhaseTrace`
  (`procint/ProcInt/Playground/Experimental/Tropical.lean:38-121`, whose
  own header names this exact bridge as "UNSUPPORTED"); `PddlAction`,
  `PddlAction.apply` (`Pddl.lean:15-31`).
- **Falsifiable artifact:** new hand-authored
  `PlannerFieldCorrespondence.lean` with either a `decide`-checked
  `cycle_mean_preserved` theorem or an explicit counterexample, `#print
  axioms` output, and one prose sentence added to the P13 Problem Ledger
  entry — no hand-filled achievement marker.

---

## 2. ROADMAP_SWARM_SUPPLY_CHAIN.md (11 proposals)

### 2.1 wave-s3-pipeline-conservation

**Source:** Wave S3, Corrections C6/C7, Problem P16
(`ROADMAP_SWARM_SUPPLY_CHAIN.md:685-693,790-793`).

Discharges the genesis-boundary and pipeline-incidence corrections and
proves the pipeline-stock conservation invariant
`sum_i x_i(t) + sum_e T_e(t)` — the repo's first non-ported
`ProcInt/Supply` Lean wave. Closes P16 as the same theorem, not a second
item (see §5.2 of the not-viable section).

- **Phases:** 6 agents — hypothesis-closure (blocking), `DelayedFlow`
  construction, incidence-property formalization, telescoping-sum
  conservation proof, adversarial counterexample-without-C6 check,
  ledger/receipt.
- **Real math assets:** `total_applyActivity_of_conservative`
  (`procint/ProcInt/Playground/Swarm11/Supply.lean:71-90`, sorry-free) as
  the base-case proof shape to extend; `Finset.sum_Ico_succ_top`
  (pinned Mathlib, `Algebra/BigOperators/Intervals.lean:50-53`) as the
  telescoping-sum lemma the time-indexed step needs.
- **Falsifiable artifact:** `ProcInt/Supply/{DelayedFlow,Capacity,
  Conservation}.lean`, `#print axioms` on the invariant theorem, new
  `.mfact/artifacts.toml` entries, and the
  `SWARM_S3_PIPELINE_CONSERVATION_PROVEN` marker flipped by the workflow
  itself, never hand-asserted.

### 2.2 swarm-wave-s1-stoichiometry-port

**Source:** Wave S1 (`ROADMAP_SWARM_SUPPLY_CHAIN.md:53-57`, Correction
C6, blank marker `SWARM_S1_STOICHIOMETRY_PORTED=` at line 893).

Ports the sorry-free `total_applyActivity_of_conservative` proof from the
playground into ledgered `ProcInt/Supply/{Inventory,Stoichiometry}.lean`,
relabeled as bare D3 bookkeeping with no conservation claim (C6 demotes
the original "conservation spine" framing).

- **Phases:** 3 agents — re-verify + port, `lake build` +
  `#print axioms`, flip the ledger marker to the axiom output.
- **Real math assets:** `total_applyActivity_of_conservative`
  (`Playground/Swarm11/Supply.lean:71-90`), proven via
  `Finset.sum_add_distrib`/`Finset.mul_sum`.
- **Falsifiable artifact:** `ProcInt/Supply/{Inventory,Stoichiometry}.lean`,
  kernel-checked, marker flipped from blank to the axiom-output evidence.

### 2.3 swarm-wave-s0-actor-admission-typing

**Source:** Wave S0 (`ROADMAP_SWARM_SUPPLY_CHAIN.md:47-48,658-659`, D1/D2)
— the cheapest open item in the swarm spine, no theorem obligation.

ggen-renders `ProcInt.Swarm.State`/`Observation` from a new TTL fragment,
encoding D2's per-actor tuple and D1's admission-gate signature as pure,
non-vacuous Lean types.

- **Phases:** 5 phases — live re-check (abort if claimed), TTL authoring
  mirroring `fixtures.ttl`'s shape, render + `lake build` +
  `lake env leanchecker`, signature-fidelity audit (no overclaiming in doc
  comments), ledger/artifacts.toml closeout.
- **Real math assets:** D1's `a_i : O_i -> O_i* ∪ Refusal` instantiates
  the repo's own foundational law "`O` does not imply `O*`"
  (`ROADMAP_MATH_SPINE.md` §8 Claim Status Table, row 1).
- **Falsifiable artifact:** `procint/ProcInt/Swarm/{State,Observation}.lean`
  via the ggen pipeline only, `lake env leanchecker` clean, two
  non-vacuous example inhabitants, `.mfact/artifacts.toml` updated.

### 2.4 s2-coalition-capability-port

**Source:** Wave S2 (`ROADMAP_SWARM_SUPPLY_CHAIN.md:673-684`, D5, P15) —
also closes Problem P15, which is the identical theorem restated (see
not-viable section).

Ports the sorry-free capability-only minimal-cover antichain theorem into
`ProcInt/Coordination`, and types (but does not fake-prove) the D5
four-conjunct `AdmissibleCoalition` definition as an explicit
`BLOCKED_ON(M4)` stub.

- **Phases:** 5 agents — read-only context, port `MinimalCover`/
  `minimalCovers_incomparable`, coalition wrapper, explicit non-proof
  stub, verify + honest ledger update.
- **Real math assets:** `minimalCovers_incomparable`
  (`Playground/Swarm11/Swarm.lean:72-118`, sorry-free), `residue_isAntichain`
  (`MFW/Residue/Antichain.lean:75,81`) as the doc-comment/import-chain
  precedent to mirror. `MinimalCompletion(C,x,A)` confirmed absent
  (Wave M4, `TARGET_THEOREM`) — the generalization stays typed, not proved.
- **Falsifiable artifact:** `Coordination/{Capability,Coalition,
  Residue}.lean`, two sorry-free theorems with `#print axioms`, one
  explicitly `BLOCKED_ON(M4)` definition, Wave S2 ledger entry split
  CLOSED (port) / OPEN (generalization).

### 2.5 dual-decomposition-admission-profile

**Source:** Problem P18, Corrections C16/C17/C19-C22
(`ROADMAP_SWARM_SUPPLY_CHAIN.md:298-365`).

Turns P18's six unstated dual-decomposition hypotheses into an executable
Lean admission profile emitting `DUAL_DECOMPOSITION_GUARANTEE_ACTIVE` or
`CONVEXITY_UNESTABLISHED`, wiring Sion's saddle-point theorem (present at
this pin) and explicitly marking subgradient/dual-ascent iteration
`BLOCKED_AT_PIN` (confirmed absent) — unblocking Wave S6's dual-field
half.

- **Phases:** 7 phases, ~8 agents — theorem cards for C16-C22, pin audit,
  convex-definitions construction, Sion-import correspondence, honest
  pin-blocker entry for dual-ascent, wire an executable checker against
  `Playground/Swarm11/{Supply,Swarm}.lean`, ledger closure.
- **Real math assets:** `Sion.exists_isSaddlePointOn`
  (`Mathlib/Topology/Sion.lean`), `ConvexOn`/`QuasiconvexOn`
  (`Mathlib/Analysis/Convex/{Function,Quasiconvex}.lean`), all confirmed
  present at pinned rev `fabf563a`; zero `subgradient`/`Subgradient` hits
  anywhere at this pin (confirmed this session).
- **Falsifiable artifact:** `Coordination/{DualField,Stability}.lean`,
  `#print axioms`, a `checkAdmission` function run against real Swarm11
  fixture data emitting the marker to a receipt, ledger's
  `DUAL_DECOMPOSITION_CEILING` updated, a new `DUAL_ASCENT_ITERATION_ROUTE
  =BLOCKED_AT_PIN` correction entry.

### 2.6 oriented-swap-newman-closure

**Source:** Problem P17 (refutation) and Problem P22
(`ROADMAP_SWARM_SUPPLY_CHAIN.md:795-860`), Correction C27.

Constructs `OrientedSwap` (a priority-broken, inversion-decreasing
restriction of `Swap`), proves it `Terminating` by an explicit
inversion-count measure, reproves `LocallyConfluent`, and applies cslib's
Newman's Lemma for real — closing P22 with a kernel-checked, honestly
weaker theorem than P17's blocked original.

- **Phases:** 4 agents — construct `OrientedSwap`/`inversions` and the
  decrease lemma, terminate (parallel), reprove local confluence
  (parallel, the one cell with real proof risk), compose + verify.
- **Real math assets:** `swap_disjoint_confluent`, `swap_site_cases`,
  `swap_locallyConfluent`, `swap_confluent_of_terminating`
  (`Playground/Swarm11/NewmanCorrespondence.lean:154-395`, sorry-free);
  `LocallyConfluent.Terminating_toConfluent`
  (cslib `Foundations/Relation/Confluence.lean:269`); Correction C27
  already names "inversion count between L1, L2" as the missing measure.
- **Falsifiable artifact:** `OrientedSwap.lean` with 6 kernel-checked
  theorems ending in an unconditional `Confluent (OrientedSwap step
  priority)`, `#print axioms` transcript, updated P22 ledger entry.

### 2.7 wave-m1-standing-downgrade

**Source:** `ROADMAP_SWARM_SUPPLY_CHAIN.md:239,280` (Corrections C9/C14)
— a self-contradiction: these two lines claim Wave M1's `Terminates(j)`
is `PROVEN`, directly contradicting the same document's own T2 section
(line 111-112) and `ROADMAP_MATH_SPINE.md:55,399,475`, which all say
`TARGET_THEOREM`.

Downgrades C9/C14 from `PROVEN` to `TARGET_THEOREM` — a two-line,
honesty-only fix, no Lean touched.

- **Phases:** 3 phases, 2 agents — verify-citation (re-derive the
  contradiction live), verify-absence (`crown_multiset_strictly_decreases`
  and `no_infinite_productive_mfw_chain` have zero occurrences in
  `procint`), fix + independent re-verify.
- **Real math assets:** none newly proven — cites Wave M0's
  `residue_is_antichain`/`residue_purity` only to establish what Wave M1
  would need to build on, and confirms `manufacture_children_
  strictly_descend` is a doc-comment forward reference, not a declaration.
- **Falsifiable artifact:** a 2-line diff, `grep -n "PROVEN"
  ROADMAP_SWARM_SUPPLY_CHAIN.md | grep "Wave M1"` returns empty after.

### 2.8 wave-s5-kappa-fr-gate

**Source:** Wave S5, `κ_FR` (`ROADMAP_SWARM_SUPPLY_CHAIN.md`), Correction
C2's sibling gap.

Two-phase, hard-gated: Phase 0 (launchable now) replaces `κ_FR`'s total
silence with an honest `BLOCKED_ON_CORRESPONDENCE` theorem card; Phase 1
(auto-unlocked only once Wave S3/P16 lands) constructs the real
`κ_FR : PhysicalTransition -> ReceiptEvent` bridge.

- **Phases:** Phase 0, 1 agent, launchable today. Phase 1, 2 agents,
  gated on wave-s3-pipeline-conservation and Crown IV/Wave M3 landing a
  `ReceiptEvent`-shaped type — not counted as launchable now.
- **Real math assets:** zero pre-existing `κ_FR` content anywhere
  (confirmed via grep); `residue_isAntichain`
  (`Antichain.lean:75,81`) cited only so the sibling `κ_GW` fix doesn't
  reinvent a second antichain type.
- **Falsifiable artifact:** Phase 0 — a theorem-card diff to
  `ROADMAP_SWARM_SUPPLY_CHAIN.md` recording `BLOCKED_ON_CORRESPONDENCE`
  with the exact missing object names, re-checkable via `find
  ProcInt/Supply` and `find ProcInt/MFW/Replay` (both currently absent).

### 2.9 swarm-queue-drift-declaration

**Source:** Corrections C9-C13 (queue-stability section),
`ROADMAP_SWARM_SUPPLY_CHAIN.md`.

From-scratch Lean declaration of the swarm's aggregate-queue
Foster/Meyn-Tweedie-shaped drift condition (stated, not proved), plus one
genuinely provable Cesàro-bound correction — without importing any absent
Lyapunov/Markov-stability theorem (confirmed absent at this pin).

- **Phases:** 5-6 agents — recon/re-verify pin absence, construct
  `QueueDrift.lean` (declarative substrate + two real proven theorems),
  `lake build Playground` verify, honest ledger correction (still
  `BLOCKED_AT_PIN` for the general stability theorem).
- **Real math assets:** `ProbabilityTheory.IsMarkovKernel`,
  `MeasureTheory.Filtration`, `MeasureTheory.Supermartingale`
  (pinned Mathlib, confirmed present), `Filter.limsup_le_of_le`
  (`Order/LiminfLimsup.lean:403`, gives the one real, provable C11
  correction with no Foster-Lyapunov machinery needed).
- **Falsifiable artifact:** `Playground/Swarm11/QueueDrift.lean`, ≥2
  proven theorems with `#print axioms`, ledger markers revised to
  "hypotheses declared, stability unproven."

### 2.10 swarm-sheaf-site-construction

**Source:** Problem P19, Corrections C29/C30/C32/C33/C35
(`ROADMAP_SWARM_SUPPLY_CHAIN.md`).

Sequential, phase-gated construction of an actual site/topological space
for the swarm's `{U_i}` family and a proof that `F` is functorial and
separated on it — closing 5 corrections without invoking gluing or
cohomology language, per P19's own ordering.

- **Phases:** 6 phases (~9-11 agent-slots), all sheaf-theory lens — site
  construction (closes C29), functoriality (C30), compatibility/
  separatedness (C32/C33, honestly may refute), triple-overlap cocycle
  (C35), ledger closure leaving C31/C34/C36-C38 explicitly open.
- **Real math assets:** `LocalState`, `Covers`, `MinimalCover`
  (`Playground/Swarm11/Swarm.lean:39,54,108`, sorry-free, unledgered);
  `TopologicalSpace.generateFrom`, `CategoryTheory.Opens.
  grothendieckTopology`, `Presieve.IsSeparatedFor`, `Coverage` (pinned
  Mathlib, confirmed present).
- **Falsifiable artifact:** `Sheaf/{LocalState,Restriction,Compatibility,
  Gluing,Residue}.lean`, `#print axioms` per declaration,
  `SHEAF_GLUING_CEILING` marker updated to the actual proof outcome —
  including an honest refutation if separatedness fails.

### 2.11 joint-multifractal-cross-measure-regularity

**Source:** Corrections C40/C41/C44 (`ROADMAP_SWARM_SUPPLY_CHAIN.md`).

Lifts the 10 sorry-free single-measure Lean carriers in
`Playground/Multifractal/` to an indexed family over `{mu_W, mu_I, mu_R,
mu_L}`, states the cross-measure regularity condition and pointwise
`alpha_k(x)`, and constructs the joint Legendre transform onto
`E_alphavec` — leaving C42 (routing policy) explicitly open.

- **Phases:** 4 phases — lift by index `k:Fin 4` over one shared
  `ScalePartition`, regularity + `alpha_k` (closes C40/C41), joint
  spectrum (closes C44), kernel verify + ledger.
- **Real math assets:** `Scale`, `LocalExponent`, `PartitionFunction`,
  `MassExponent`, `Legendre`, `LevelSet`, `HausdorffSpectrum`
  (`Playground/Multifractal/*.lean`, all confirmed sorry-free);
  `MeasureTheory.HausdorffDimension`, `csInf_le` at the pinned commit.
- **Falsifiable artifact:** `SwarmMultifractal/{JointMeasure,
  JointSpectrum}.lean`, `#print axioms` on every new theorem,
  `JOINT_MULTIFRACTAL_CEILING` corrected, `C42`/routing left open.

---

## 3. GAP_LEDGER_v26.7.12.md (35 proposals)

Ranked using the ledger's own explicit adjacency list ("G1, G6, G7
blocked by G4"; "G8 blocked by G5"; "G30, G42 blocked by G41"; "G44
blocked by G24") and its Release-blocking/Major/Minor severity tiers.

### 3.1 g4-countermodel-gate-wire

**Source:** G4 — the countermodel-promotion guard's own computed
`countermodel_not_promoted` gate is printed then discarded, never
reaching CLI exit codes. Unblocks G1, G6, G7.

Extends `Mfact.GateResults`/`ValidObjection`/`GatesJson` from 4 fields to
5 so the guard actually gates `mfact certify`'s exit code, then replays
the current live (uncommitted PROVEN) manifest state without pre-deciding
revert-vs-promote.

- **Phases:** 5 phases — diagnostic reproduction of the dead path, Lean
  5th-conjunct extension of `no_valid_objection`'s proof, CLI/build
  wiring, adversarial replay + new negative-control script, reporting
  (corrects `PROJECT.md`'s false DONE claims, presents the revert-vs-keep
  decision without executing either).
- **Real math assets:** `Mfact.GateResults.allPass`
  (`mfact/Mfact/CertifiedRelease.lean:8-21`), `Mfact.no_valid_objection`
  (`Objection.lean:10-32`) — a real, already-proven closed-objection
  theorem that must be re-discharged, not just re-typed, for the 5th case.
- **Falsifiable artifact:** `lake build` clean, `#print axioms
  Mfact.no_valid_objection` unchanged, `just certify` now genuinely
  refuses or passes on the countermodel gate instead of ignoring it.
  *Overlaps with §3.6 `countermodel-gate-closure` — same fix from a
  different angle; launch one.*

### 3.2 g41-verif-report-liveness

**Source:** G41 — `VERIFIER_REPORT_ALL_FIELDS_LIVE` is never emitted;
6/13 Phase-15 fields are unbuilt. Unblocks G30, G42.

Builds `scripts/build_verif_report.py` so the marker is computed
per-field from existing receipts, honestly marking the 6
zero-instrumentation fields UNAVAILABLE with a named blocking phase
instead of silently omitting them.

- **Phases:** 5 agents — audit each field's source-of-truth or absence,
  build the script (LIVE/UNAVAILABLE per field, never a bare boolean),
  wire a new `just verif-report` target into `just check`, adversarial
  verify (field names match `CLAUDE_ROADMAP.md:1364-1380` exactly, marker
  resolves false today, UNAVAILABLE fields cite the correct phase), ledger.
- **Real math assets:** `release/quadrature.json`, `release/verif-receipt.json`
  (obligation `token_replay_counts_corr`, status DECLARED),
  `release/replay_report.json`, `release/standing.env` — all confirmed
  live; `scripts/build_verif.py`'s DECLARED→EXTRACTED→STATED→PROVEN
  ladder reused, not reinvented.
- **Falsifiable artifact:** `release/verif-report.json`, 13 named fields
  each LIVE(value, source) or UNAVAILABLE(blocking phase),
  `VERIFIER_REPORT_ALL_FIELDS_LIVE=false` (honestly), a new
  `just verif-report` target. *Overlaps with §3.15
  `g30-g41-verif-report-assembly` and §3.16 `verif-report-field-unifier`
  — three independent angles on the same missing generator; launch one.*

### 3.3 release-status-lineage-reconciliation

**Source:** G5 — three mutually divergent status lineages (manifest
401/203/2, `final_status.json` 197/397/7, `STANDING.md` 318/145/2).
Unblocks G8.

Turns `scripts/report.py`'s already-correct-but-ephemeral manifest
projection into the actual writer for `release/final_status.json`,
`release/FINAL_STATUS.md`, and `release/replay_plan.json`, gated by a
byte-exact round-trip against the one verified fixpoint tag
(`v26.7.7-procint-certified` @ `184e3a3`).

- **Phases:** 5 phases — diagnostic pin, build the projector
  (`write_release_surfaces`), regression gate against the historical
  fixpoint (blocking), live re-projection + honest `STANDING.md`
  drift banner, a `release/DRIFT_DECISION.md` presenting both live
  options without executing either.
- **Real math assets:** none new — this is a projection-correctness fix
  over `scripts/report.py`'s existing `gather()`, confirmed to already
  compute the correct live numbers with nowhere to write them.
- **Falsifiable artifact:** the round-trip diff against commit `184e3a3`
  (must be empty), regenerated `final_status.json`/`FINAL_STATUS.md`
  carrying live numbers, `DRIFT_DECISION.md` naming both options.

### 3.4 g1-certified-release-truth-wire

**Source:** G1 — `release/standing.env`'s `CERTIFIED_RELEASE=PASS` while
`mfact certify` exits 1 (`evidenceComplete=false`).

Wires `CERTIFIED_RELEASE` to a script-derived boolean that mirrors
`Mfact.GateResults.allPass` exactly, so it can never assert PASS while
certify exits nonzero — a G4-agnostic prerequisite (no script currently
writes this field at all).

- **Phases:** 5 phases — reproduce & sweep for any existing writer (none
  found), implement `scripts/derive_certified_release.py` as an exact
  Python mirror of the Lean `allPass` Prop, hook it into both the pass
  and fail paths of `just certify`, adversarial verify (exit code
  unchanged, field now reads FAIL, diff touches only standing.env + the
  new script), ledger write-back.
- **Real math assets:** `Mfact.GateResults.allPass`
  (`CertifiedRelease.lean:16-18`), `Cli.lean:36-37,65-67` — the live
  binary re-invoked, confirmed this session to exit 1.
- **Falsifiable artifact:** `mfact certify ...; echo $?` still 1;
  `CERTIFIED_RELEASE=FAIL`; `git diff --stat` touches only
  `standing.env` + the new script + a justfile hook.

### 3.5 g11-reachability-repair

**Source:** G11 — `crates/mfact-core/src/lib.rs` declares only 2 of 6
real modules; `cargo check` falsely reports green.

Wires the dependency-free orphan modules (`lean`, `broker`, `thermo`)
into the public module tree so `cargo check --lib` goes green with zero
new deps, leaving the SSE/link surface (`transport.rs`, `main.rs`, the
FFI-bound thermo/broker functions) explicitly documented as still blocked.

- **Phases:** 4 phases — reachability audit, FFI-surface classification
  (partition FFI-free vs FFI-bound symbols), minimal-scope `pub mod`
  wiring fix (verified this session: `cargo check --lib` goes from
  orphaned to `Finished` in 0.47s), ledger correction splitting the
  binary "ship/abandon" framing into two independently-decidable items.
- **Real math assets:** `scalar_dissipation`, `sparse_chaos_diagnostic`
  (`thermo.rs:58,63`, confirmed FFI-free); `procint/ProcInt/Planning/Pddl.lean`
  and `Models/Powl.lean` (tracked, real, compiled into
  `.lake/build/ir/ProcInt/{Planning/Pddl.c,Models/Powl.c}`) as the Lean
  carrier source behind `broker.rs`'s FFI declarations.
- **Falsifiable artifact:** a 3-line `lib.rs` diff, `cargo check --lib`
  transcript (0 errors), `cargo test --lib` transcript documenting the
  12 remaining undefined-symbol link failures as the honest boundary.

### 3.6 countermodel-gate-closure

**Source:** G4 (same item as §3.1, independently re-derived).

Extends `GateResults`/`ValidObjection`/`GatesJson` from 4 to 5 fields so
the already-computed `countermodel_not_promoted` guard reaches CLI exit
codes, then replays the current live manifest state through the now-live
gate.

- **Phases:** 5 phases — reproduce (confirm the guard prints but exit
  code stays 0), Lean surface (5th `GateResults` field + re-proved
  `no_valid_objection`), CLI/build wiring, adversarial replay against the
  real tree, reporting.
- **Real math assets:** identical to §3.1 — `GateResults`/`allPass`
  (`CertifiedRelease.lean:8-21`), `no_valid_objection`
  (`Objection.lean:10-32`).
- **Falsifiable artifact:** same shape as §3.1. **This is the same fix as
  §3.1 `g4-countermodel-gate-wire`, discovered independently — do not
  launch both.**

### 3.7 prose-lint-tightener

**Source:** G44 (finalized rules never wired) and G24 (documented 8
rules, only 2 implemented) — G44 explicitly depends on G24; treated as
one fix here since they share one landing point.

Re-runs the 8 documented prose-lint grep rules verbatim against the live
paper, tightens Rules 2/5/7's false-positive patterns, rewords the 2
genuine Rule-4 hits, and replaces `justfile`'s 2-check placeholder with
the finalized 8-rule gate.

- **Phases:** 4 phases, 2 agents — reproduce all 8 rules live and
  correct G24's own stale Rule-7 count, triage genuine-vs-false-positive
  per rule, fix and wire (single commit), adversarial re-verification
  (confirm no genuine-violation class was silently widened into a
  whitelist to force a pass).
- **Real math assets:** none — prose/word-choice discipline over the
  D1 correspondence claim, not a Lean object.
- **Falsifiable artifact:** `just prose-lint` transcript, red before the
  fix (genuine Rule-4 hits) and green after (all 8 tightened checks),
  `GAP_LEDGER` G44/G24 both flipped to CLOSED with the transcript as
  evidence.

### 3.8 g2-mfact-core-workspace-gate

**Source:** G2 — `crates/mfact-core` excluded from the root Cargo
workspace; `cargo check --workspace` falsely prints "Finished."

Adds `crates/mfact-core` to the root workspace and to `rust-ci.yml` so
the check stops lying and instead fails honestly at G11's already-
ticketed defects.

- **Phases:** 5 phases — re-dispatch from a worktree at/after commit
  `c7413cb` (the prior attempt's blocker), add `[workspace] members`,
  add a `cargo test -p mfact-core` CI step, verify the now-honest
  failure is attributable to G11's error codes, reconcile.
- **Real math assets:** `GgenReceiptEngine::compute_receipt`
  (`receipt.rs:38-83`), `compute_genesis_fold` (`lib.rs:63-81`) — two
  already-committed but currently CI-invisible proptests exercising the
  BLAKE3 fold chain's non-commutativity/mutation-sensitivity.
- **Falsifiable artifact:** `[workspace] members` diff, `rust-ci.yml`
  diff, a captured `cargo check --workspace` transcript now failing on
  G11's exact error codes instead of silently passing.

### 3.9 independent-replay-refresh

**Source:** G8 — blocked by G5; stale replay evidence
(`v26.7.7-procint-certified`/`ff44b04`) never refreshed against a newer
tag.

Precondition-gated: re-runs `scripts/independent_replay.sh` against
whatever tag G5 eventually cuts, and refuses to write `REPLAY_PASS`
unless the replayed clone's own regenerated foldHash equals the tag's
`expectedCoreReleaseHash`.

- **Phases:** 4 phases — precondition gate (inert until a new
  qualifying tag exists — this is why it's safe to launch today), stand-in
  provisioning + replay execution, independent foldHash cross-check
  (does not trust the script's self-report), surface propagation.
- **Real math assets:** the foldHash gate is a BLAKE3 chain over
  kernel-checked theorem hashes, including `crownCounter_sound`,
  `crownCounter_not_bounded`,
  `WfNet.infinite_transition_countermodel_sound_not_bounded`
  (`procint/ProcInt/Workflow/Countermodel.lean:223,258,277`).
- **Falsifiable artifact:** regenerated `replay_plan.json`/
  `replay_report.json` with a foldHash independently re-derived inside
  the replay clone, cross-checkable via `git show <tag>:release/
  release-manifest.json | jq .foldHash`.

### 3.10 g6-release-identity-resync

**Source:** G6 — `standing.env`'s hand-typed release header drifts from
`v26.7.7` (every other surface) to a stale `v26.7.6`; 16 `research-papers/`
bridge dirs silently uncovered by `LEAN_BUILD`.

Single-sources the header from `scripts/build_manifest.py`'s own
`RELEASE` variable and adds an explicit `LEAN_BUILD` scope line excluding
the 16 bridge dirs — the unblocked sub-slice of G6 (the tag-cut half
stays G1/G4-gated).

- **Phases:** 4 phases — audit & freeze scope, single-source the header
  via the existing `upsert_standing_env` upsert pattern, regenerate +
  idempotency-check (two runs byte-identical), ledger correction marked
  partial, not fully CLOSED.
- **Real math assets:** none — release-provenance plumbing; the 16
  named `research-papers/*/.lean` dirs are the concrete objects the new
  scope line stops silently implying are covered.
- **Falsifiable artifact:** a commit where `release['release'] in
  standing.env`'s header line holds by direct check, a second
  `build_manifest.py` run is byte-identical, and CERTIFIED_RELEASE/
  LEAN_BUILD/tag are unchanged (proving no G1/G4-gated re-release was
  smuggled in).

### 3.11 g7-standing-guard-reconciliation

**Source:** G7 — gated on G4/G5/G6 closing; the Standing Guard's own
scanner currently reports 58+ REFUSED findings behind an ALIVE/PASS
claim, and 4 mutually-inconsistent hash values exist for
`release/standing.env` alone.

Precondition gate, then re-runs the repo's own read-only Standing Guard
scanner, reconciles or waives every REFUSED finding, and wires the
receipt into `artifacts.toml` + `regen-check` so ALIVE/PASS can never
again be claimed over an unexamined guard receipt.

- **Phases:** 6 phases — precondition check (no-op until G4-G6 close),
  regenerate surface, re-run the scanner, reconcile findings (fix or
  dated waiver, never silent deletion), close the self-reference gap,
  independent verifier re-runs everything from a clean checkout.
- **Real math assets:** none new — `pylab/src/mpops/standing_guard/
  server.py`'s `scan()`/`check_ledger_drift`/`check_regen_check_
  coverage_gap` functions, all confirmed live and already
  non-mutating (`test_no_mutation_capabilities` passes).
- **Falsifiable artifact:** a fresh `standing_guard_receipt.json` with
  zero un-waived REFUSED entries, `.mfact/artifacts.toml` gains a
  self-referential entry, a new `just standing-guard-gate` wired into
  `just certify`.

### 3.12 standing-env-live-gate-sync

**Source:** G1-adjacent — re-derives `CERTIFIED_RELEASE` from a
same-run, live `mfact certify` execution and wires CI to fail on future
disagreement.

- **Phases:** 4 agents — reproduce (rebuild + rerun certify, confirmed
  exit 1 with drift growing, not static), patch `Cli.lean`'s failing
  branch to also emit machine-parseable JSON, sync script writing
  `standing.env` fields including drift-commit-count, new CI job that
  fails the build on any disagreement.
- **Real math assets:** `GateResults`/`GatesJson`
  (`Cli.lean:29-37`), `Refusal::InvalidFormat` path, the live
  `evidenceComplete: false` field.
- **Falsifiable artifact:** a new `standing-sync-check` CI job; a
  corrected, committed `standing.env` reading FAIL with drift-commit
  count populated. *Overlaps with §3.4 — same underlying G1 defect from a
  CI-wiring angle rather than a script-derivation angle; complementary,
  not strictly redundant, but launch together deliberately, not by
  accident.*

### 3.13 g43-receipt-version-binding

**Source:** G43 — root `receipt.json`'s `certify()` fact set is bound
to a hardcoded version-free literal, not the live manifest release id.

Binds `certify()`'s initial facts to the live `release-manifest.json`
release id + foldHash, refusing loudly via the already-declared-but-dead
`ManualReleaseHash`/`ManualReleaseCount` `Refusal` variants when no
manifest is available.

- **Phases:** 5 phases — recon/correspondence audit correcting the
  ledger's producer attribution (root `src/lib.rs::Receipt::compute`,
  not `crates/mfact-core::GgenReceiptEngine`), construct, wire into the
  release step, differential falsification (two manifests, two different
  foldHash values must produce two different receipts), ledger close.
- **Real math assets:** `Receipt::compute` (`src/lib.rs:78-92`,
  order-independence already exhibited by `test_receipt_computation`),
  `Refusal::ManualReleaseHash`/`ManualReleaseCount` (`src/lib.rs:15-16`,
  declared but never reached by any call site today).
- **Falsifiable artifact:** rebuilt `receipt.json` carrying two new
  version/coreReleaseHash triples sourced live; a diff transcript
  proving two different manifests produce two different receipts.

### 3.14 g31-receipt-engine-reachability

**Source:** G31 — `GgenReceiptEngine::compute_receipt`,
`compute_genesis_fold`, `validate_manifest_concurrently`, `parse_manifest`
are reachable only from unit tests, never from a real binary.

Wires `parse_manifest -> validate_manifest_concurrently ->
compute_genesis_fold -> GgenReceiptEngine::compute_receipt` into a new
`verify_manifest` bin target run against the repo's own tracked
`release-manifest.json` (401 artifacts, 260 evidence entries).

- **Phases:** 4 phases — reachability re-confirmation, entrypoint
  construction (no new deps needed), independent verification from a
  second clean worktree (including the predicted `Refusal::InvalidFormat`
  on the manifest's `"mfact.release.v1"` schema field), ledger closure.
- **Real math assets:** `GgenReceiptEngine::compute_receipt`
  (`receipt.rs:59`), `compute_genesis_fold` (`lib.rs:63`),
  `validate_manifest_concurrently` (`validate.rs:5`), `parse_manifest`
  (`lib.rs:83`) — all real, all already property-tested, none reachable
  from a binary today.
- **Falsifiable artifact:** `cargo run --bin verify_manifest --
  release/release-manifest.json` producing a fact count, recomputed
  fold, and an explicit match/mismatch verdict on stdout.

### 3.15 g30-g41-verif-report-assembly

**Source:** G30 + G41 — assembles the 13-field Phase-15 verifier report
from receipts that already exist.

Same generator as §3.2, described here from the G30 angle: 7 of 13
fields are honestly LIVE today, 6 are UNAVAILABLE by design (no chaos
test, no benchmark, no undecided-stack claim attempted).

- **Phases:** 4 phases — audit (LIVE vs UNAVAILABLE classification per
  field), build, wire into `just release`/`just check` + register in
  `build_ledger.py`'s tracked-artifact list, verify + honest ledger
  update for both G30 (PARTIAL) and G41 (OPEN, not CLOSED).
- **Real math assets:** `verif-receipt.json`'s DECLARED→EXTRACTED→
  STATED→PROVEN ladder, `standing.env`'s `LEAN_BUILD`/5 `ORPHAN_*`
  counts/`INDEPENDENT_REPLAY` fields — all live, all reused verbatim.
- **Falsifiable artifact:** `release/verif-report.json`, tracked in
  `.mfact/artifacts.toml`. **Same underlying generator as §3.2
  `g41-verif-report-liveness` and §3.16 below — launch one.**

### 3.16 verif-report-field-unifier

**Source:** G30 + G41, third independent angle on the same missing
generator (same underlying gap as §3.2 and §3.15).

- **Phases:** 4 phases — evidence-gather from the 4 live receipt files,
  schema definition (13 canonical field names verbatim from
  `CLAUDE_ROADMAP.md:1369-1380`), build generator (re-executes
  `build_verif.py`'s 3 refusal checks rather than copying a static
  number), wire + adversarial verify (delete a source file, confirm the
  affected field degrades to UNAVAILABLE rather than crashing).
- **Real math assets:** identical set to §3.2/§3.15.
- **Falsifiable artifact:** identical shape. **Do not launch all three of
  §3.2/§3.15/§3.16 — pick exactly one; they were discovered independently
  and would otherwise triple-build the same file.**

### 3.17 g35-vacuous-scratch-purge

**Source:** G35 — 13 ungated vacuous-`True`/duplicate scratch files
sitting in `procint`'s production module tree; a prior fix attempt was
lost because its worktree branched too early and became unreachable.

Re-derives and lands the lost fix: `git rm` all 13 files, with a
regression proof that two real, already-kernel-checked theorems are
untouched.

- **Phases:** 5 phases — fresh dispatch from current HEAD (not the stale
  base that caused the original failure), independent re-verification
  the gap is still open, the deletion itself (pure `git rm`, no edits),
  regression proof against `Soundness.lean`/`Countermodel.lean`, a
  post-merge sentinel confirming the fix branch stays reachable.
- **Real math assets:** none proven or consumed — deliberately a
  hygiene/deletion workflow; `WfNet.sound_iff_shortCircuit_live_bounded`
  and `infinite_transition_countermodel_sound_not_bounded`
  (`Soundness.lean:270`, `Countermodel.lean:277`) serve only as the
  negative-control regression anchor.
- **Falsifiable artifact:** a commit with a deletion-only diff, pre/post
  `lake build` transcripts, matching `#print axioms` on the two anchor
  theorems before and after, landed on a branch verified reachable from
  HEAD (directly addressing why the first attempt silently failed).

### 3.18 g17-vacuous-theorem-repair

**Source:** G17 — two self-discharging "Core Theorem" proofs
(`pair_correlation`, `smfdcca`) that never consume their own hypotheses.

Replaces both with either a real construction or an honest CONJECTURAL
downgrade.

- **Phases:** 5-6 agent-turns — re-derive both findings from HEAD,
  vendor Mathlib into `smfdcca` (currently `packages: []`), attempt a
  real mixing-orbit construction for `pair_correlation` (fall through to
  an explicit theorem card if no correspondence exists), construct the
  real Cauchy-Schwarz bound for `smfdcca` from three fluctuation
  functions, kernel-verify, ledger close.
- **Real math assets:** `Finset.sum_mul_sq_le_sq_mul_sq`
  (`Mathlib.Algebra.Order.BigOperators.Ring.Finset:159`, confirmed
  present at the pinned rev via the sibling `random_walk` package),
  `PddlAction.mem_add_mem_apply`-style induction pattern reused.
- **Falsifiable artifact:** a kernel-checked `Smfdcca.lean` with a
  non-vacuous `smfdcca_bounded` proof (construction depends on the
  Cauchy-Schwarz lemma), plus either a hypothesis-consuming
  `pair_correlation` theorem or an explicit CONJECTURAL theorem card.

### 3.19 procint-orphan-module-wireup

**Source:** G19 — 4 modules (`ProcInt.Workflow.Multifractal`,
`ProcInt.Graph.Semantic`, `ProcInt.Planning.SemanticBridge`,
`ProcInt.Thermo`) compiled but never imported into `ProcInt.lean`'s root,
so their proven theorems are unreachable from `AxiomAudit`.

Imports all four, fixes a namespace/path mismatch (`Thermo.work_bounds`
vs. its real path `ProcInt.Thermo.work_bounds`), tracks the untracked
`Graph/Semantic.lean`, and adds `#guard_msgs` axiom-audit entries.

- **Phases:** 5 phases — survey (confirm 3 real theorems, 11
  zero-proof-content defs), construct (4 imports in dependency order +
  namespace fix), track (`git add` the untracked file), certify (new
  `#guard_msgs` lines), verify (`lake build` across all 6 lean_lib
  targets).
- **Real math assets:** `projection_path_independence`,
  `edge_to_in_boundary`, `edge_from_out_boundary`
  (`Workflow/Multifractal.lean:53,67,77`), `Thermo.work_bounds`
  (`Thermo.lean:30-35`, proven via `linarith`) — all proven, all
  currently kernel-checkable only standalone, never as part of the
  named target closure.
- **Falsifiable artifact:** `AxiomAudit.lean` diff with `#guard_msgs`
  entries whose recorded axiom sets are checked by the compiler itself;
  green `lake build ProcInt AxiomAudit Quadrature PostRelease Playground
  Tests`; `git status --porcelain procint/ProcInt/Graph` clean.

### 3.20 powl-expansion-foundation-closure

**Source:** G32 — `broker.rs`'s POWL depth cap comment (`≤256`)
contradicts its own hardcoded literal (`513`); the underlying FFI symbol
`lp_procint_ProcInt_Powl_expansionDepth` is a fake stub with no Lean
counterpart.

Closes G32/PA24-26 by replacing the fake FFI stubs with a real,
kernel-checked hierarchical-POWL constructor and two genuinely-computed
typed results — deliberately scoped down from the item's full 9-typed-
result spec to the smallest honest constructive slice.

- **Phases:** 5 waves — ontology wave (new `procint:Decl_Powl_expansion`
  TTL, `ggen sync`), Lean proof wave (`lake build`, one non-vacuous
  example theorem), Rust FFI truth wave (delete/re-link the fake stub,
  fix the unclamped 513 literal, branch on `validCheck`'s result instead
  of discarding it), reachability wave (`pub mod broker; pub mod lean;`,
  implement exactly 2 of the 9 typed results as real, the other 7 marked
  `BLOCKED_ON_CORRESPONDENCE`), ledger-truth wave.
- **Real math assets:** `ProcInt.Models.Powl` inductive and
  `Powl.WellFormed` (`Powl.lean:17-44`, real, kernel-checked, already
  proves bound-shaped side conditions the new depth constructor extends);
  `PddlAction.applicable`/`PddlPlan.validCheck`
  (`Pddl.lean:22-24,50-55`, real, already compiled and linked but its
  result discarded by `broker.rs` today).
- **Falsifiable artifact:** a Lean diff with a real `Powl.expansion`
  constructor and depth-bound proof obligation, `#print axioms`; a Rust
  diff that either genuinely calls the compiled symbols or deletes the
  fake stubs, re-verified against `PRAXIS_SELF_AUDIT.md`'s PA24/PA25/PA26
  evidence greps. *Overlaps with §3.21, §3.83-§3.86 (in §5) which target
  the same POWL/expansionDepth defect from narrower angles — pick one
  scope, not all.*

### 3.21 g32-powl-depth-provenance-audit

**Source:** G32 (same item as §3.20, narrower scope).

Mechanically proves `lp_procint_ProcInt_Powl_expansionDepth` has no
compiled Lean symbol behind it, closes the `rigor_linter.py` gap that let
the 256-vs-513 contradiction through, and records the cap-value question
as `BLOCKED` on a human decision instead of unilaterally picking 256 or
513.

- **Phases:** 3 phases, 3 agents — provenance audit (diff the compiled
  `Powl.c`'s real exported symbols against the fake FFI declaration),
  linter fix (`rigor_linter.py`'s claim-without-mechanism check
  extended, regression-proved 0→1 violations on `broker.rs`'s own
  lines), ledger correction that states the fork explicitly without
  resolving it.
- **Real math assets:** same `Powl` inductive and `WellFormed.xor_length`
  theorem as §3.20, cited as the substrate any real depth measure would
  recurse over — not itself extended in this narrower scope.
- **Falsifiable artifact:** a provenance memo with rerunnable zero-hit
  grep/`lake build` transcripts; a patched `rigor_linter.py` with a
  captured before/after violation-count transcript; `G32` moved
  `OPEN → BLOCKED` with the fork stated, not resolved.

### 3.22 g18-thermo-witness-refusal

**Source:** G18 — `ROADMAP.md`'s "Zero-Cost Mechanisms" claim asserts a
compile-time Lean-Rust bond for every verified boundary; no
`PhantomData`/typestate pattern exists anywhere in `crates/`.

Builds a real, checkable `LeanDischarged<M>` witness type gated on the
existing `Artifact.proven` field, proves in a compiled test that it
correctly refuses to authorize `scalar_dissipation` today, and scopes
`ROADMAP.md`'s claim down to an honest MISSING edge for this bridge.

- **Phases:** 5 phases — evidence lock (re-verify zero `PhantomData`
  hits, the stub Lean sources, the empty ledger entry), land the single
  admitted prerequisite (`pub mod thermo;`), build the witness type with
  a real branching constructor consuming `crate::Artifact`/`Refusal`,
  compiled test proving the refusal branch fires today, doc correction
  citing `AGENTS.md` section 4's edge taxonomy.
- **Real math assets:** `thermo.rs:58` (`scalar_dissipation`, zero FFI),
  `Artifact{name,hash,axioms,proven}` and `Refusal`
  (`lib.rs:25-30,7-21`) — reused, not reinvented.
- **Falsifiable artifact:** `cargo test -p mfact-core thermo` passing on
  the refusal branch (constructed with `proven:false`); `ROADMAP.md:31`
  corrected to name the edge MISSING per AGENTS.md's taxonomy.

### 3.23 thermo-bridge-standing-correction

**Source:** G16 — `ROADMAP.md` Phase-2 items #8-11 claim formalizations
(Sparse Chaos Diagnostics, Terminal Breakdown, Weighted Random Networks,
Combinatorial Topology) that have zero matching directories anywhere.

Re-audits live, then downgrades the four items and the orphaned
`scalar_dissipation`/`sparse_chaos_diagnostic` Rust functions from
implied-PROVEN to explicit CONJECTURAL/`MISSING` — no math fabricated,
because none exists to fabricate honestly.

- **Phases:** 4 sequential single-purpose agents — re-audit (zero hits
  confirmed live), explicitly reject creating new stub directories (that
  would replicate G15's own condemned anti-pattern), annotate
  (`STANDING: CONJECTURAL` doc comments + `[UNSTARTED]` tags), verify +
  close (comment-only diff, `cargo check` unchanged).
- **Real math assets:** none — `thermo.rs:58-66`'s
  `scalar_dissipation`/`sparse_chaos_diagnostic` are confirmed pure
  affine `f64` arithmetic with zero Lyapunov/DAG/random-graph/simplicial
  content.
- **Falsifiable artifact:** `grep -c "\[UNSTARTED\]" ROADMAP.md` returns
  4 at the exact 4 line items; `cargo check -p mfact-core` exits 0
  (comment-only diff proven).

### 3.24 g13-star-graph-betti-construction

**Source:** G13 — `research-papers/star_graphs` is a 21-byte
`def hello := "world"` stub; `ROADMAP.md` claims "Constructed &
Verified."

Replaces the stub with a kernel-checked proof that the star graph's
first Betti number is 0, wired into a real `just` gate recipe.

- **Phases:** 4 phases — add a `mathlib` require block (same pin as the
  sibling `random_walk` package), construct `bettiOne` and
  `starGraph_bettiOne_eq_zero` by composing two real Mathlib lemmas,
  verify + `#print axioms`, wire `star-graphs-verify` into `just check`
  and correct the ledger to PARTIAL (this closes only the star_graphs
  third of a three-part Phase-1 claim).
- **Real math assets:** `SimpleGraph.isTree_starGraph`
  (`Mathlib/Combinatorics/SimpleGraph/Star.lean`),
  `SimpleGraph.IsTree.card_edgeFinset`
  (`Mathlib/Combinatorics/SimpleGraph/Acyclic.lean:318-319`), both
  present at pinned rev `fabf563a`.
- **Falsifiable artifact:** `lake build` exit 0, `#print axioms
  starGraph_bettiOne_eq_zero`, a new `star-graphs-verify` justfile
  recipe reachable from `just check`. *Overlaps with §5.78
  `star-graphs-betti-construction` (prior-session, PB12 angle) — same
  math, different source item; launch once.*

### 3.25 g14-rigor-linter-harden

**Source:** G14 — `rigor_linter.py` can flip FAIL to PASS on an empty
research-papers stub, honors no `argv`, and is missing two of
`CLAUDE_ROADMAP.md`'s own section-10 tripwires.

Hardens the linter against an empty/hello-stub-as-verified-target,
adds the orphaned-modules and public-fn-referenced-only-by-tests
tripwires, honors `sys.argv[1]`, and adds a `lake build` pass flag.

- **Phases:** 1 gap-closer dispatch, 5 steps — reconfirm still open,
  construct the 3 new checks against concrete already-confirmed
  violations (`crates/mfact-core/src/lib.rs`'s 4 orphaned files,
  `star_graphs`'s stub), independently re-verify with captured literal
  output on 3 separate invocations, ledger close in the same commit as
  the fix.
- **Real math assets:** none — Python tooling fix; the fixtures are
  `crates/mfact-core/src/lib.rs:4-5`'s module list and
  `research-papers/star_graphs/StarGraphs/Basic.lean`, both real,
  already-confirmed violations used as the regression fixtures.
- **Falsifiable artifact:** three captured terminal transcripts (against
  `crates/mfact-core/src`, against `research-papers/star_graphs`, and
  with an explicit non-default path arg), each showing the intended
  nonzero exit with named offenders.

### 3.26 g15-roadmap-merge-reconcile

**Source:** G15 — an untracked `ROADMAP.md` draft on
`v26.7.12-close` blocks a clean merge of worktree `wf_24b4eb65-119-19`'s
commit `e174fa3` (5 UNSTARTED annotations).

Reconciles the two, lands the merge git previously refused, flips G15
from BLOCKED to CLOSED.

- **Phases:** 3 phases — diff & verify (byte-diff confirms only lines
  23-27 differ), reconcile & merge (`mv` the draft aside, `git merge
  --no-ff`, re-diff to confirm the only delta is the 5 annotations),
  ledger closure with a re-run receipt (`grep -c 'Status: UNSTARTED'`
  returns 5, items 6-7 stay unannotated).
- **Real math assets:** `non_abelian_acquittal_of_parabolic_law`
  (`research-papers/quantum_hall/QuantumHall.lean:26-32`) and
  `smfdcca_bounded` (`Smfdcca.lean:21-23`) — both kernel-checked, used
  only to confirm items 6-7 correctly stay unannotated through the merge.
- **Falsifiable artifact:** a `--no-ff` merge commit; `grep -c
  'Status: UNSTARTED' ROADMAP.md` == 5; `GAP_LEDGER` G15 flipped to
  CLOSED with the merge commit hash.

### 3.27 gap-selection-law-wiring-workflow

**Source:** `GAP_LEDGER_v26.7.12.md`'s own Selection law
(`e* = argmax(UnlockMass·StandingCriticality·ScenarioCoverage/
ClosureMass)`) — stated in prose, never implemented as a runnable check,
so items get picked arbitrarily.

Implements the law as `scripts/gap_selector.py` and wires
`MFACT_SELF_IMPROVEMENT_LOOP.md`'s item-pick step to call it.

- **Phases:** 4 agents — extraction (structured JSON fixture from the
  ledger's own adjacency list and severity table, source-cited), Python
  implementation (exact counts for UnlockMass/StandingCriticality,
  explicitly labeled proxies for ScenarioCoverage/ClosureMass since no
  exact formula exists), wiring (same-commit loop-doc edit), independent
  verification against the live ledger.
- **Real math assets:** none — a decision-rule/combinatorial-
  optimization construction over the ledger's own DAG-precedence
  adjacency list, deliberately not dressed up as a Lean theorem.
- **Falsifiable artifact:** a committed, executable `gap_selector.py`
  whose stdout, run against the live ledger, names one `e*` with its
  four factor values and source-line citations; a one-commit diff making
  the loop's pick step actually call it.

### 3.28 g39-toolchain-pin-evidence-correction

**Source:** G39 — over-broad Evidence text names 6 dirs lacking a
`lean-toolchain` pin; only 2 (`aeneas_rust_verification`,
`sound_borrow_checking`) actually lack one.

Corrects the Evidence paragraph down to the 2 real offenders and adds
the matching pin file to both.

- **Phases:** 3 phases — correct `GAP_LEDGER`'s Evidence text (cite
  `PRAXIS_SELF_AUDIT.md` PA44, REFUTED), write the byte-identical
  `leanprover/lean4:v4.31.0` pin file into the 2 real offenders
  (does not commit the two wholly-untracked bridge dirs — separate,
  already-named G39 scope), verification (byte-diff against the sibling
  `random_walk` pin).
- **Real math assets:** none — build-hygiene; the pin string itself is
  the only "asset," confirmed byte-identical across root and 4
  already-pinned `research-papers/` dirs.
- **Falsifiable artifact:** two new 25-byte `lean-toolchain` files,
  byte-diffed against `random_walk`'s; corrected `GAP_LEDGER` Evidence
  text naming exactly 2 dirs. *Overlaps with §3.29 — same G39 item,
  independently derived; launch one.*

### 3.29 lean-toolchain-pin-audit

**Source:** G39 (same item as §3.28, independently re-derived).

Verifies (rather than "adds," since live inspection shows it's already
done for 11 of 13 dirs) the pin across every git-tracked
`research-papers` bridge dir, ships a rerunnable check script, and
corrects G39's stale ledger text to separate the closed tracked-dir set
from the still-blocked untracked set.

- **Phases:** 4 phases — audit (enumerate the tracked-dir universe, diff
  each pin byte-for-byte), commit a rerunnable
  `scripts/check_lean_toolchain_pins.sh`, adversarial verify (independent
  second pass, `cat` each pin by hand), ledger correction.
- **Real math assets:** the same four real theorem carriers G39's
  fix protects the build reproducibility of —
  `RandomWalk.lean:53,66,93`, `PairCorrelation.lean:23`,
  `QuantumHall.lean:18,26` — cited as the payload, not re-proven.
- **Falsifiable artifact:** `scripts/check_lean_toolchain_pins.sh`
  committed, its stdout ("11/11 tracked dirs pinned, 0 mismatches")
  pasted as G39's tracked-dir closure evidence. **Same G39 item as
  §3.28 — launch one, and prefer this one for its committed rerunnable
  script.**

### 3.30 lean-build-provenance-purge

**Source:** G37 — 28 stale `.olean` build artifacts under 9 named
`research-papers` dirs whose sources are empty or `def hello := "world"`
stubs, predating the same commit that emptied them.

Purges the stale `.lake/build` caches, replaces "build-dir presence"
with a machine-generated provenance record, and closes G37 with a
literal, reproducible re-count.

- **Phases:** 6 phases — re-verify the live 28-olean baseline,
  classify each dir via `rigor_linter.py`'s existing stub/empty checks
  (reused unmodified), purge strictly `.lake/build` (never
  `.lake/packages`, ~7.1GB out of scope), record a new
  `research_papers_build_provenance.json`, ledger update, independent
  re-verification.
- **Real math assets:** none new, and none should be claimed — citing
  the stub sources as math would itself violate the no-vacuous-
  tautologies rule; `rigor_linter.py:16,21`'s stub/`sorry` checks are
  the only reused tooling asset.
- **Falsifiable artifact:** `find ... -name '*.olean' | wc -l` drops
  from 28 to 0; a new `research_papers_build_provenance.json` stating
  `lake_build_evidence=NONE` for all 9 dirs; G37 flipped in the same
  commit as the purge.

### 3.31 random-walk-manifest-pin-and-axiom-receipt

**Source:** G38 — `research-papers/random_walk` has an already-generated
but uncommitted `lake-manifest.json`; the real prior audit ran against a
stale worktree.

Commits the manifest and emits a `#print axioms` receipt for its three
compiled theorems, closing G38 for real against the *main* checkout.

- **Phases:** 4 phases — verify (confirm the single uncommitted-file
  status, confirm the pin matches lakefile.toml, confirm the `.olean`
  already exists), build lens (clean `lake build` against the manifest-
  pinned graph), proof-audit lens (`#print axioms` on all 3 theorems),
  commit lens (only `lake-manifest.json`, nothing else touched).
- **Real math assets:** `log_additive_decomposition`,
  `local_modulation_freezing`, `workflow_cache_isolation`
  (`RandomWalk.lean:53,66,93`), the first built on Mathlib's
  `Real.log_mul` at the pinned rev.
- **Falsifiable artifact:** a committed `lake-manifest.json`;
  `#print axioms` output for all 3 theorems showing only the standard
  axiom trio.

### 3.32 g23-corr-status-prose-align

**Source:** G23 — `paper/main.tex:711` bare-asserts "PROVEN" while
`release/verif-receipt.json` reports the same obligation as DECLARED.

Rewords the paper's claim to match the machine-derived DECLARED status,
verifies the realignment by rerunning the actual builder chain, and adds
one narrow prose-lint rule so the exact overclaim can't silently regress.

- **Phases:** 4 phases — explore/confirm (re-grep, re-read), reword
  (the exact honest phrasing the ledger's own Fix note suggests), narrow
  regression-proof (one grep clause added to the existing prose-lint
  recipe), verify by rebuild (`just verif-status`, `just prose-lint`,
  `just paper`), close the ledger with a before/after prose quote.
- **Real math assets:** `token_replay_counts_corr` obligation
  (`release/verif-receipt.json`, status DECLARED,
  `pipelineJsonExists=false`) — the D1 correspondence obligation whose
  honest status this fix aligns the prose to, not re-derives.
- **Falsifiable artifact:** `just verif-status` unchanged (same
  catalogHash), `just prose-lint` exit 0 post-fix, a rebuilt `main.pdf`,
  G23 flipped with the before/after quote.

### 3.33 g26-ui-submodule-sync

**Source:** G26 — the embedded `web/mfact-ui` repo has 2 unpushed
commits and 17 modified/4 untracked files; the parent gitlink is 3
commits stale.

Commits and pushes the embedded repo's pending changes, then bumps the
parent gitlink to the new pushed SHA.

- **Phases:** 5 phases — audit (classify each stray file as
  intentional-fix vs. scratch, explicit include/exclude decision on the
  3 route-crawler scripts), build-verify (`npm run build`/`lint` against
  the dirty tree before pinning anything), commit + push (child repo,
  fast-forward), pin + commit (parent gitlink), receipt (clean status in
  both repos).
- **Real math assets:** none — infra/CI gap, matches the item's own
  tag; no MFW carrier object is touched.
- **Falsifiable artifact:** two clean `git status --short` outputs, one
  gitlink diff at the parent showing no dirty suffix, paired with a
  green `npm run build` log at the new HEAD.

### 3.34 g45-bundle-split-lazy-load

**Source:** G45 — `web/mfact-ui`'s eager bundle is 6.86MB, dominated by
`SemanticGraph.tsx`'s `three`/`deck.gl`/`react-force-graph-3d` imports
mounted on a single route.

Splits the bundle by `manualChunks` + `React.lazy(SemanticGraph)`, then
restores the default `chunkSizeWarningLimit`.

- **Phases:** 5 phases — recon (reproduce the 6.86MB baseline from a
  clean build), implement (`vite.config.ts` manualChunks + route-level
  lazy import), independent verify (a *different* agent than the
  implementer, per-chunk byte + gzip sizes), smoke test (confirm the
  lazy chunk is absent from other routes' network waterfall), ledger
  close with exact before/after byte counts.
- **Real math assets:** none — perf/infra gap, explicitly stated as
  such rather than forcing a math citation that would itself violate
  the no-ambient-analogy rule.
- **Falsifiable artifact:** `du -b dist/assets/*.js | sort -rn` showing
  the largest chunk strictly below 6,862,945 bytes; `npm run build`
  clean without the 10000kB override.

### 3.35 web-ui-typecheck-lint-gate

**Source:** G46 — `web/mfact-ui`'s build script is bare `vite build`;
neither `tsc -b` nor `oxlint` gate CI.

Wires `tsc -b` + `oxlint` into the build script and into
`deploy-pages.yml`/`ci.yml`'s test-e2e job, then proves the gate rejects
bad code with an injected-error test.

- **Phases:** 5 phases (single lens, 2 agents) — preflight (confirm
  descendant of the commit that introduced these files), diagnose
  (baseline error count), fix (`build: "tsc -b && vite build"` + CI
  steps), falsify (inject one deliberate type error on a scratch
  branch, confirm nonzero exit; revert, confirm zero), land + update
  the ledger with commit hash and before/after logs.
- **Real math assets:** none — infra gap; no Lean theorem, Mathlib/
  cslib lemma, or MFW carrier object is in play.
- **Falsifiable artifact:** a receipt file recording baseline error
  count, nonzero exit on the injected error, zero exit on the clean
  tree, landed as a real fix-forward commit.

---

## 4. Prior-session action lists (31 proposals)

Sources: `PRAXIS_SELF_AUDIT.md` (PA/PB/PC findings, 3 passes),
`PRAXIS_DOGFOODING_EXPLORATION.md` (DOG findings), and
`WASM4PM_AUTONOMIC_EXPLORATION.md` / `MFACT_SELF_IMPROVEMENT_LOOP.md`
(W4PM/F items, receipt schema, loop guards).

### 4.1 agents-md-standing-lesson

**Source:** PA1/PA2 (false-victory commit claims) and PA11/PA15
(standing-gate drift), `PRAXIS_SELF_AUDIT.md`.

Re-verifies PA1/PA2 and PA11/PA15 live against current HEAD, then drafts
and adversarially reviews a new `AGENTS.md` section stating the
false-victory-claim lesson and a standing-gate precedence rule — the
doctrine file that governs every other agent's behavior in this repo.

- **Phases:** 3 phases — live re-verification (halt with a no-op report
  if any of the four no longer reproduces), draft (one new numbered
  section, two rules, cited only to this session's fresh evidence, never
  the stored audit prose), adversarial self-check against `AGENTS.md`'s
  own trigger-word rules.
- **Real math assets:** none — text-discipline; the "assets" are the
  two reproduced command outputs themselves (zero external importers of
  `NewmanCorrespondence.lean`; `mfact certify` exit 1 reproduced a 4th
  independent time this session).
- **Falsifiable artifact:** one fix-forward commit touching only
  `AGENTS.md`, every claim traceable to a literal command output from
  this session.

### 4.2 gap-ledger-atomicity-retrofit

**Source:** `WASM4PM_AUTONOMIC_EXPLORATION.md:609-611`'s atomic-update
rule, applied retroactively to G14, G19, G39, G13.

Re-closes all four with one commit apiece that co-locates the real fix
(or corrected evidence text) with the ledger's own Status field update,
per the loop's own atomicity rule and `gap-closer.md`'s step 4.

- **Phases:** 3 phases — 4x parallel gap-closer agents (each in an
  isolated worktree branched from current HEAD, not the stale root that
  caused these items' earlier BLOCKED outcomes), sequential merge, 1x
  adversarial-auditor pass confirming every diff spans both the fix
  object and the Status field in the same commit.
- **Real math assets:** `rigor_linter.py:21`'s `sorry` regex false
  positive (G14), `AxiomAudit.lean`'s import list vs. Playground's ~101
  files (G19), the 2 real toolchain-pin offenders (G39),
  `research-papers`'s CI coverage gap (G13) — all re-confirmed live.
- **Falsifiable artifact:** 4 git commits, each with a diff touching
  both the fix and the Status field, plus a `PRAXIS_SELF_AUDIT.md`
  addendum verdicting each atomicity-honored or not.

### 4.3 reverify-before-pick

**Source:** `WASM4PM_AUTONOMIC_EXPLORATION.md` item 4 ("re-verify before
starting"), first fired against G1.

Before any self-improvement-loop firing works a picked ledger item,
replays that item's exact stored verifier command live and refuses to
trust the ledger's cached Status.

- **Phases:** 6 phases — extract the literal verifier command, rebuild
  + rerun it (reproduced live this session: exit 1, `evidenceComplete=
  false`), compare against every downstream claim assuming PASS, write a
  receipt with `oracle_rank:1`, correct `standing.env`/`PROJECT.md`
  atomically in the same commit, tag the firing `no_op` on G1 itself
  since the Selection law bars picking G1 before its root cause G4.
- **Real math assets:** `Mfact.no_valid_objection`
  (`Objection.lean:24-32`), independently axiom-audited zero-axiom; its
  hypothesis `R.gates.allPass` is the exact predicate the live
  `evidenceComplete=false` result falsifies.
- **Falsifiable artifact:** a fresh `.mfact/receipts/<run_id>.json` with
  literal exit code/gate booleans/HEAD sha, plus a corrected
  `standing.env`/`PROJECT.md` citing the receipt's run_id.

### 4.4 mfact-core-fake-ffi-purge

**Source:** PA22 (orphaned modules) + PA24 (fake Mathlib FFI stubs),
`PRAXIS_SELF_AUDIT.md`.

Deletes the 9 orphaned/untracked `mfact-core` files whose only compiled
surface is `broker.rs` calling `lean_ffi_wrapper.c`'s
argument-discarding fake Mathlib stubs, then reverifies the crate builds
and tests clean against the untouched real modules.

- **Phases:** 5 phases — live-reconfirm (4 evidence commands rerun
  fresh), delete (git rm, no edits to `lib.rs`/`receipt.rs`/`validate.rs`),
  build + test, adversarial reverify from a separate context, ledger
  update citing all cross-referencing PA entries.
- **Real math assets:** none produced — Rust build-hygiene; the real
  assets are the two tracked test files this deletion must leave
  untouched (`tests/proptest_invariants.rs`,
  `tests/concurrent_validation_tests.rs`) and the 4 hardcoded-constant
  fake C functions in `lean_ffi_wrapper.c:19-33` that disqualify the
  "fix the build" branch.
- **Falsifiable artifact:** a deletion-only diff; `cargo build`/
  `cargo test --lib -- --list` transcripts showing the same 19 tests,
  zero E0432/E0433/E0752; clean `git status --porcelain`. *Overlaps
  with §4.5 — same defect cluster; launch one.*

### 4.5 fake-ffi-symbol-purge

**Source:** PA24 (same fake-FFI cluster as §4.4, narrower scope).

Deletes the 4 hand-written fake `lp_mathlib_*`/`lp_procint_*` FFI
stand-ins in `lean_ffi_wrapper.c` and their matching call sites in
`broker.rs`, then closes PA24 with a live-command evidence card.

- **Phases:** 3 phases — re-verify (confirm the 4 unconditional-return
  bodies, confirm which have live call sites — only
  `expansionDepth` does), construct (delete, no replacement placeholder,
  replace the depth-lookup call site with an explicit `Refusal`),
  independent re-verification + ledger close-out.
- **Real math assets:** the 4 impersonated real Mathlib objects, cited
  precisely: `Finset.instDecidableRelSubset`
  (`Mathlib/Data/Finset/Defs.lean:349`), `Multiset.ndunion`
  (`FinsetOps.lean:125`), `Multiset.sub` (`AddSub.lean:278-282`), all
  present at pinned rev; `ProcInt.Powl.expansionDepth` confirmed absent
  from both `procint/ProcInt/Models/Powl.lean` and the real compiled
  `Powl.c`. **Same underlying defect as §4.4 — pick one scope.**
- **Falsifiable artifact:** zero-hit repo-wide grep for all 4 former
  symbol names; unchanged 19/19 passing tests; a new dated
  `PRAXIS_SELF_AUDIT.md` card with Verdict CLOSED.

### 4.6 receipt-delta-colocation

**Source:** `WASM4PM_AUTONOMIC_EXPLORATION.md` item 2 (F4 exemplar) +
PB5 (`release/standing.env` has 4 mutually distinct hash values).

Makes `verify_delta` a structurally-required, commit-co-located field of
every loop-firing receipt — kernel-checked in Lean, typestate-bonded in
Rust, gated (not just warned) in the Python checker that already
half-enforces it.

- **Phases:** 5 phases (parallel Lean/Rust/Python construction +
  serial verify/merge) — recon (confirm the schema gap), Lean carrier
  (`FiringReceipt` mirroring `RootCause.lean`'s pattern), Rust typestate
  bonding (a real, separately-named `LoopFiringReceipt` type, not a
  `Receipt`/`GgenReceiptEngine` change), Python `--strict` gate
  hardening, verification/merge.
- **Real math assets:** `RootCause.lean:34-53,69-97`
  (kernel-checked, `deriving DecidableEq`, `decide`-proved totality
  theorem — the template mirrored); `Receipt`/`GgenReceiptEngine`
  (`receipt.rs:27-33`, confirmed to lack `verify_delta`/`commit_sha`
  today).
- **Falsifiable artifact:** `Trajectory/Receipt.lean` with `#print
  axioms`, a passing `cargo test` proving the invalid construction
  doesn't type-check, `trajectory_annotate.py --strict` exiting 1 on a
  synthetic negative fixture and 0 on the one real receipt.

### 4.7 oracle-rank-ledger-tagger

**Source:** F3 (`oracle_validator.rs`'s Rank 1-4 axis) vs.
`MFACT_SELF_IMPROVEMENT_LOOP.md`'s competing re-verification-mechanism
axis — two committed docs disagree on what "Rank 1" means.

Reconciles the two taxonomies, then retroactively rank-tags the
ledger's 7 CLOSED entries, independently re-verified command-by-command.

- **Phases:** 5 phases — reconcile (one canonical axis), classify
  (assign `oracle_rank:N` to G3/G9/G10/G33/G34/G47/G48's evidence),
  guard (port `oracle_validator.rs`'s forbidden-keyword Rank-5 rejection
  into the ledger's Status legend, citing PA1/PA2 as the canonical
  negative example), independent re-verify (zero shared context with
  the tagger), commit atomically.
- **Real math assets:** none — process-integrity/prose discipline; the
  assets are `wasm4pm/tests/oracle_validator.rs:14-230`'s
  already-committed Rank enum and forbidden-keyword set, reused not
  reinvented.
- **Falsifiable artifact:** a commit with a new "Oracle rank"
  subsection, 7 inline tags, a verifier's literal fresh-output
  transcript for all 7 rerun commands, and a new Rank-5 rejection rule.

### 4.8 verify-step-decoupling

**Source:** `WASM4PM_AUTONOMIC_EXPLORATION.md` item 12, PA11/PA12.

Extracts the ad hoc verification logic embedded separately in the
fix-loop and self-audit-loop crons into one standalone, commit-
addressable callable step, proven faithful by replaying it against
PA11/PA12, which both loops already checked by hand.

- **Phases:** 4 phases — contract extraction (unify the two receipt
  schemas), build + wire (fix-loop's re-verify gate and the audit
  loop's recheck lens both call it), adversarial regression proof
  (invoke against PA11/PA12's exact commit, diff the fresh verdict
  against the recorded REFUTED verdict), ledger closure gated on that
  match.
- **Real math assets:** none — process tooling; cites
  `PRAXIS_SELF_AUDIT.md:38-50`'s pass-2 recheck lens as the existing
  proof-of-concept for a standalone re-verify step.
- **Falsifiable artifact:** a committed verify-step tool; two receipts
  from invoking it against PA11/PA12, each verdict matching the
  historical REFUTED record or the workflow reports non-closure rather
  than fabricating success.

### 4.9 stop-verdict-gate

**Source:** F19 (`WASM4PM_AUTONOMIC_EXPLORATION.md:236-246`, citing
`wasm4pm/.claude/hooks/stop-proof-gate.sh`'s pattern) — no such Stop
hook exists in this repo (`hooks.Stop` absent from `.claude/settings.json`).

Builds and wires a Stop-hook that blocks the loop from logging a firing
"done" until an independently re-run verifier prints one of two literal
machine-checkable tokens, generalized from
`countermodel_negative_controls.sh`'s existing pass/fail pattern.

- **Phases:** 4 phases — spec (two literal verdict tokens, gated on the
  loop's existing `oracle_rank` field), build (`.claude/hooks/
  stop-verdict-gate.sh`, wired into `settings.json`), adversarial
  negative control (poisoned/forged token must be refused), end-to-end
  verify (block-then-pass transcript against `MFACT_SELF_IMPROVEMENT_
  LOOP.md` itself).
- **Real math assets:** none — the reused asset is
  `countermodel_negative_controls.sh:9-53`'s literal two-token verdict
  pattern, confirmed live.
- **Falsifiable artifact:** `.claude/hooks/stop-verdict-gate.sh` +
  `settings.json` diff; a negative-control script that prints the
  refusal token and exits 1 against a poisoned receipt.

### 4.10 loop-diversity-guard-harden

**Source:** PC6/PC8 (`stuck_item_guard.py` unwired, wrong file mode) +
PB20 (cron `8123599b`'s collision-repetition blind spot).

Closes the two confirmed-open PC6/PC8 gaps and fixes the guard's
confirmed collision-repetition blind spot — the exact shape of PB20's
finding, which the guard as coded cannot detect.

- **Phases:** 5 steps — fix file mode (`chmod +x`), extend the guard
  with `find_stuck_collisions()` alongside the existing
  `find_stuck_gap_ids()`, build 2 fixtures (collision-stuck, not-stuck),
  wire in (`stuck-item-guard:` justfile recipe + doc mention),
  independent re-verification against real `.mfact/receipts/`.
- **Real math assets:** none — the reused asset is the existing
  deterministic `find_stuck_gap_ids()` (`scripts/stuck_item_guard.py:
  72-107`, commit `4fabb1c`) and the one real receipt on disk
  (`.mfact/receipts/20260713T071516Z.json`).
- **Falsifiable artifact:** a commit adding
  `find_stuck_collisions()` + executable mode + justfile recipe + 2
  fixture dirs, independently rerunnable via
  `just stuck-item-guard`.

### 4.11 self-audit-tally-reconciliation

**Source:** `WASM4PM_AUTONOMIC_EXPLORATION.md` item 13 —
`PRAXIS_SELF_AUDIT.md`'s own Quick Reference tallies (passes 1 and 3)
don't match the per-item Verdict fields they summarize.

A low-frequency meta-audit that mechanically recomputes the ledger's own
three tallies from each pass's per-item fields, cross-checks by two
independent extraction methods, and patches the two wrong tables.

- **Phases:** 4 phases — parse (walk every `### PA*/PB*/PC*` heading),
  adversarial cross-check (a second, differently-implemented extraction
  method), diff (reproduces the pass-1/pass-3 drift already hand-
  verified: pass 1 claims "6 REFUTED, 1 DRIFTED," actually 7 REFUTED, 0
  DRIFTED), patch + exhibit (fixed-point re-check: computed == table for
  all three passes).
- **Real math assets:** none — ledger bookkeeping; the mechanically-
  verified artifact is the fresh `awk`/`grep -c` recount itself, run
  live this session.
- **Falsifiable artifact:** `self_audit_tally_diff.json`, a patched
  `PRAXIS_SELF_AUDIT.md` (numeric cells only), a new dated finding card
  recording the defect and its fix.

### 4.12 cron-sole-cadence-audit

**Source:** W4PM-14 — the fix-loop's live cron job ID has already
drifted once in this session's own catalog (`8123599b` → `0e35feb8`).

Two-agent static audit that resolves the fix-loop's *actual* live cron
job ID and greps its retrievable prompt text plus its design spec for
internal loop/sleep/retry constructs.

- **Phases:** 4 phases — resolve target (call `CronList` live, don't
  trust a cited job ID), static grep audit (reuse F36/F47's proven
  no-internal-loop method), explicit unverifiable boundary (no tool
  exposes full cron prompt text — capped at `oracle_rank:3`, logged
  UNVERIFIABLE, not falsely closed), independent re-verify + write
  finding.
- **Real math assets:** none — the reused method is
  `WASM4PM_AUTONOMIC_EXPLORATION.md:404-413,520-527`'s grep-based
  no-internal-loop evidentiary pattern.
- **Falsifiable artifact:** one new dated finding block in
  `PRAXIS_SELF_AUDIT.md` with the literal `CronList` line and grep
  output, using the ledger's own PB/PC template.

### 4.13 gnn-fix-provenance-workflow

**Source:** F28 (`// GNN FIX` convention, 13 real hits in `wasm4pm`) +
PA41 (`rigor_linter.py`'s `\bsorry\b` regex flags `Swarm11Verifier.lean`'s
log string "sorry-bearing decls").

Institutes the `-- GNN FIX: <reason>` inline-comment convention and
applies it to its first real target: the confirmed-live PA41 false
positive.

- **Phases:** 5 phases — re-verify (rerun `rigor_linter.py`, confirm
  still failing), fix + tag (strip Lean string-literal spans before the
  regex, matching the existing comment-strip precedent), regression test
  (both the false-positive fix and a synthetic true-positive preserved),
  ledger evidence, independent post-merge verify by a second agent.
- **Real math assets:** none — Python tooling; PA41 is re-confirmed
  live this session via `re.finditer` span check.
- **Falsifiable artifact:** a diff with an inline `# GNN FIX:` comment,
  a regression test exhibiting both fixed-false-positive and preserved-
  true-positive, `grep -n 'GNN FIX' scripts/rigor_linter.py` returning
  the new line. *Overlaps with §4.14 — same PA41 defect; launch one.*

### 4.14 rigor-linter-sorry-regex-fix

**Source:** PA41 (same defect as §4.13, narrower single-purpose scope).

Tightens the `\bsorry\b` regex so it stops false-flagging
`Swarm11Verifier.lean`'s log label, restoring `just lint` and
`report.py status` to a truthful signal.

- **Phases:** single pass — apply the targeted fix (mask string
  literals the same way comments are already masked), verify (no longer
  flags the real file, still catches an injected real `sorry` on a
  scratch fixture, then removed), confirm `just lint`/`report.py status`
  reach their true pass/fail state.
- **Real math assets:** none — the same confirmed artifact as §4.13:
  `Swarm11Verifier.lean:182`'s `IO.println` log label,
  `receipt.sorryDeclarationCount` populated at line 121/checked at 133.
  **Same fix as §4.13 — launch one.**
- **Falsifiable artifact:** before/after `rigor_linter.py` transcripts;
  a regression transcript showing a deliberately reintroduced real
  `sorry` is still caught.

### 4.15 rigor-linter-orphan-module-check

**Source:** PA29 — `rigor_linter.py` has no mod-vs-disk diff check, so
it PASSED over `crates/mfact-core/src/lib.rs`'s 4 orphaned files
(PA22's exact defect) without ever flagging them.

Extends the linter with a crate-root-to-disk mod-declaration diff — the
10th check, turning `CLAUDE_ROADMAP.md` section 10's "orphaned modules"
tripwire from prose into a real, currently-failing gate.

- **Phases:** 5 steps — baseline (reproduce the live false negative,
  `cargo check --bin mfact-core` fails with E0432 while the linter still
  exits 0), implement (transitive-closure diff per Cargo crate), positive
  + negative control fixtures (must flag exactly the 4 real orphans, zero
  false hits on `receipt.rs`/`validate.rs`/`build.rs`/test `mod` blocks),
  full-repo run (diff against pre-change baseline), ledger consistency
  (dated follow-up under PA29, original finding left intact).
- **Real math assets:** none — Python tooling fix; the fixtures are the
  same real `crates/mfact-core/src/lib.rs` orphans PA22/G11 already
  document.
- **Falsifiable artifact:** a diff to `rigor_linter.py` adding the
  10th check, plus a positive-control run against the live tree flagging
  exactly the 4 named orphans.

### 4.16 firing-outcome-classifier

**Source:** F35 — `MFACT_SELF_IMPROVEMENT_LOOP.md:35,85-88` documents a
`success|partial|failed|no_op` schema; no script anywhere implements the
`no_op` producer rule for an ordinary firing.

Mints a kernel-checked `FiringOutcome` Lean type mirroring
`RootCauseType`/`RecoveryBehavior`, then implements and fixture-tests
the actual `no_op` classification rule.

- **Phases:** 5 agents — survey (confirm the grep gap), Lean
  construction (`FiringOutcome` inductive + totality theorem, same
  header convention as `RootCause.lean`), classifier (pure Python
  `classify(before, after, commit_sha, diff_stat)`), fixture tests
  (PB13/PB14 encoded as literal synthetic receipts), wire-in +
  independent verify.
- **Real math assets:** `RootCauseType`/`RecoveryBehavior`
  (`Playground/Trajectory/RootCause.lean:34-107`, kernel-checked,
  `decide`-proved totality — the reused template).
- **Falsifiable artifact:** `Trajectory/FiringOutcome.lean` with
  `#print axioms`, `scripts/classify_firing_outcome.py`, a passing
  `pytest` naming PB13/PB14 explicitly.

### 4.17 metrics-history-convergence-tap

**Source:** W4PM-8 — `.mfact/metrics-history.jsonl` is a 0-byte stub;
no convergence signal exists for the self-improvement loop.

Builds a per-firing metrics-history writer (git_head, gaps_open,
gaps_closed_this_firing, lake_build_pass, sorry_count, axiom_count) plus
a read-time `convergence_ratio`, with axiom_count/sorry_count computed by
PA4's exact scratch-probe-and-`lake env lean` mechanism.

- **Phases:** 5 phases — ground (reconcile the ticket's wording against
  the loop doc's already-refined schema), build the writer, axiom probe
  reusing PA4's exact live module set, independent re-check by a second
  agent, wire in + close in the same commit.
- **Real math assets:** PA4's confirmed-live axiom-probe method
  (`PRAXIS_SELF_AUDIT.md:301-329`) over 19 headline theorems, all clean
  against `[propext, Classical.choice, Quot.sound]`.
- **Falsifiable artifact:** `scripts/metrics_snapshot.py` appending a
  schema-conformant JSONL line; a `--convergence` mode that refuses
  "insufficient data" rather than fabricating a ratio under 10 lines.

### 4.18 mfact-core-divergence-fix

**Source:** PB8/PA22/PA29 — no `[lints]` block in either `Cargo.toml`;
`cargo build --bin turbulence` fails with E0425; unfiltered `cargo
build` also fails on `main.rs`'s undeclared `transport`/`tokio`.

Fixes 4 live, independently-reproduced mechanical divergences with a
before/after transcript rather than a claim.

- **Phases:** 6 phases (1 verify-before + 4 parallel single-lens fixes +
  1 verify-after) — lints-baseline, build-break-fix (resolve
  `simulate_workload` per the file's own stated intent, plus `pub mod
  transport;` + the missing `tokio` dep, since unfiltered `cargo build`
  fails for the same orphan reason), orphaned-module-check (Lens C, see
  §4.15), version-policy decision doc, convergent verification.
- **Real math assets:** none — mechanical Rust/Cargo hygiene, matching
  the item's own tag.
- **Falsifiable artifact:** a `cargo build` transcript with all 4
  compiler errors replaced by exit 0; a `cargo clippy` transcript; a
  regression probe proving check #10 actually fires.

### 4.19 reachability-taxonomy-retag

**Source:** PB7 / DOG-2 (`PRAXIS_SELF_AUDIT.md:1094-1098`,
`PRAXIS_DOGFOODING_EXPLORATION.md:502-512`) — a wired/reachable
vocabulary (REAL_EDGE/TEST_ONLY_EDGE/CausalHole) exists but two
finding-groupings cite the wrong gaps.

Adds this vocabulary to `GAP_LEDGER`'s Status legend, corrects the two
mis-grouped "reachability gaps" citations in
`PRAXIS_DOGFOODING_EXPLORATION.md`, and anchors it with two live worked
examples.

- **Phases:** 5 phases — definition (new subsection, explicit
  Rust-caller-graph-to-Lean-import-graph analogy note per AGENTS.md's
  predicate-namespace-separation rule), retag (cite each gap's real
  `Lens` field individually), worked examples (`NewmanCorrespondence.lean`,
  `MFW/Residue` chain, freshly re-run grep evidence), adversarial verify,
  commit.
- **Real math assets:** live-reverified: 0 external importers of
  `NewmanCorrespondence.lean`; 3 internal-only importers of
  `ProcInt.MFW.Residue`.
- **Falsifiable artifact:** a diff to both docs with two command+output
  evidence lines reproducing the greps live.

### 4.20 pack-drift-reconciliation-audit

**Source:** PB13-related — three vendored ggen packs (`lean-math-pack`,
`quadrature-pack`, `post-release-pack`) have never been diffed against
praxis's copies.

File-level content-hash diff of mfact's vendored packs against praxis's,
producing a mechanically-checkable drift ledger flagging mfact-only
fragments a naive future sync would silently destroy.

- **Phases:** 4 phases — scope confirmation (praxis's own `ggen.lock`
  doesn't even track these 3 packs, so comparison must be a direct
  read-only file-tree diff), per-pack diff (3 parallel agents, b3sum
  every file both sides), ledger construction (`.mfact/pack-drift-
  ledger.toml`, extending the existing artifacts.toml row schema),
  adversarial verification, freeze note.
- **Real math assets:** `packs/lean-math-pack/fragments/
  workflow_countermodel.ttl` — confirmed the constructive source of the
  PB13-verified `Countermodel.lean` hash (`a22d1848...`,
  `.mfact/artifacts.toml:413-416`), confirmed absent from praxis's copy.
- **Falsifiable artifact:** `.mfact/pack-drift-ledger.toml`, every row
  independently reproducible by re-running `b3sum` on both sides;
  `PACK_DRIFT_LEDGER.md`.

### 4.21 atomic-ledger-regen-hook

**Source:** PB13/PB9 — no pre-commit hook regenerates
`.mfact/artifacts.toml`/`ggen.lock` atomically with the source change
that necessitates them; `.git/hooks/pre-commit` is itself untracked.

Wires `just regen-check`'s existing ledger-regeneration lock into a
tracked, installable pre-commit hook.

- **Phases:** 4 phases — repro (live-recreate the drift condition),
  implement (`scripts/hooks/pre-commit` + a `just install-hooks`
  target), adversarial verify (repeat the benign edit — ledger lands
  atomically; hand-tamper a hash — the hook's rerun overwrites or
  refuses), receipt (before/after commit pair + `regen-check`
  transcript).
- **Real math assets:** none — the reused assets are
  `scripts/build_ledger.py` (74 lines, deterministic) and the existing
  `just regen-check` recipe (`justfile:158-170`), neither reinvented.
- **Falsifiable artifact:** a tracked `scripts/hooks/pre-commit`, a
  real commit whose `--stat` shows source + ledger landing together,
  `just regen-check` exiting 0 immediately after.

### 4.22 countermodel-promotion-regate

**Source:** PB2/PB13/PB14 — the STATED→PROVEN promotion at
`standing.env:43` was a manual, ungated edit; the negative-control guard
only ever checks a synthetic scratch manifest, never the real files.

Replaces the manual edit with a promotion mechanically re-derived
through `justfile`'s `test` recipe and validated by a repaired
`countermodel_negative_controls.sh` that reads the live standing.env/
manifest pair.

- **Phases:** 6 phases — baseline, mechanized re-derivation via `just
  test`, certify replay, guard-premise repair (add a live-file
  consistency check alongside the existing synthetic self-test), proof
  of the fix via a forced negative control, kernel re-confirmation,
  ledger write-up.
- **Real math assets:**
  `WfNet.infinite_transition_countermodel_sound_not_bounded`
  (`Countermodel.lean:277`), already `#guard_msgs`-checked
  (`AxiomAudit.lean:372-375`) at `[propext, Classical.choice, Quot.sound]`.
- **Falsifiable artifact:** `release/certify.log` showing PASS from both
  the old synthetic self-test and the new live-consistency check; a
  forged-promotion run demonstrating the new check fails closed.

### 4.23 standing-crown-jewel-resync

**Source:** PA11/PB3 — `STANDING.md`'s Certification/Crown-jewel prose
is hand-edited text, not regenerated from `release-manifest.json`'s
live proven-status fields.

Blocked on §4.3's certify-exit-0 fix landing; mechanically regenerates
the prose from live fields once it does, preserving the real mixed state
(the sibling `_statement` theorem stays `proven:false`).

- **Phases:** 5 phases — precondition gate (`mfact certify` must exit
  0; today it doesn't), extract (5 named fields only, no hand-typed
  numbers), render (template-substitute, preserving the mixed
  proven/stated state), verify (`standing_guard.scan()`, zero BLOCKER
  findings), receipt.
- **Real math assets:** `WfNet.sound_iff_shortCircuit_live_bounded`,
  `infinite_transition_countermodel_sound_not_bounded`,
  `crownCounter_sound`, `crownCounter_not_bounded` — all `proven:true`
  in the live manifest; the sibling `_statement` theorem confirmed
  still `proven:false`.
- **Falsifiable artifact:** a `git diff` on `STANDING.md`'s two
  sections, field-traceable to the manifest, bundled with a fresh
  exit-0 certify transcript.

### 4.24 mutation-kill-staged-port

**Source:** praxis's `thm_kill.lean` (read-only reference,
`/Users/sac/praxis/tools/paper-factory/lean-pilot/thm_kill.lean`) + PA4.

Ports `thm_kill.lean`'s self-contained `StagedValidator`/
`MutationOperator`/`kill_correct` machinery verbatim into a new
`Playground/MutationKill/StagedValidator.lean`, instantiated with a
3-gate state mirroring `Swarm11Verifier.lean`'s real audit fields, and
applies it to `swap_disjoint_confluent`.

- **Phases:** 4 phases — port (literal transcription, zero praxis
  writes per the read-only boundary), instantiate (3-gate state mirroring
  `Swarm11Verifier.lean`'s real `sorryDeclarationCount`/axiom-set
  fields), verify (`#print axioms` on both the ported theorem and the
  instantiated example), wire into the `Playground.lean` aggregator.
- **Real math assets:** `kill_correct` (praxis, read-only source);
  `swap_disjoint_confluent` (`NewmanCorrespondence.lean:154-169`,
  PA4-confirmed `[propext]`-only); `Swarm11Verifier.lean`'s real
  compiled-environment audit (708 declarations / 179 theorems / 0
  project axioms / 0 sorry, confirmed live via `just swarm11-verify`).
- **Falsifiable artifact:** a new kernel-checked `StagedValidator.lean`,
  `#print axioms` on both terms, a re-run `just swarm11-verify`
  transcript showing counts rise with gates unchanged.

### 4.25 sa-pa32-lean-repair

**Source:** PA32 — `pair_correlation`/`quantum_hall`/`smfdcca` fail to
build on a doc-comment-before-`namespace` syntax error;
`random_walk` has 3 stacked, independently-discovered proof gaps.

Fixes the syntax break in 3 packages and the `abs_add`/
`add_le_add_left`/`dsimp` proof gaps in `random_walk`, then closes with
an independently re-derived `leanchecker` + `#print axioms` pass on all
4 packages.

- **Phases:** 4 phases — isolated git-HEAD extraction (not a live-tree
  copy — sidesteps a second, unrelated `smfdcca/lakefile.lean` defect),
  syntax repair (`/-- -/` → `/-! -/`, 3 packages) + smfdcca's second
  defect (missing mathlib require), `random_walk` repair (rename
  `abs_add`→`abs_add_le`, `linarith` substitution, a third dsimp gap
  found only by iterating the real build), independent re-verification
  from a second, separately-checked-out worktree.
- **Real math assets:** `Mathlib.Algebra.Order.Group.Unbundled.Abs`'s
  `abs_add_le` at the pinned rev (confirmed; old name `abs_add` has 0
  hits); `mixing_orbits_asymptotic_iid`
  (`PairCorrelation.lean:19-23`, confirmed axiom-free once the syntax
  fix lands); `RandomWalk.lean`'s 3 theorems.
- **Falsifiable artifact:** kernel-checked `.olean` + `leanchecker`
  exit 0 + `#print axioms` for all 4 packages, quoted in the PR
  description.

### 4.26 quantum-hall-correspondence-audit

**Source:** PA32-adjacent — `QuantumHall.lean` fails to build on the
same syntax defect; `ROADMAP.md:17` separately claims a CI/CD
deployment-path correspondence with no Rust carrier anywhere.

Fixes the syntax defect first, then attempts (or formally refuses) a
correspondence morphism from `PhaseTransitionState` to a concrete
Rust typestate for the CI/CD claim.

- **Phases:** 4 phases — repro & mechanical fix (`lake build` exit 0),
  correspondence construction attempt (a new `quantum_hall.rs`
  `PhantomData` typestate, original construction — no existing pattern
  to imitate), adversarial verification against AGENTS.md's edge
  taxonomy (reject as ANALOGY if it only relabels), resolve & record
  (land it or strike the ROADMAP.md claim and file a new gap entry).
- **Real math assets:** `FieldTheoryType`, `PhaseTransitionState`,
  `non_abelian_acquittal_of_parabolic_law`
  (`QuantumHall.lean:8,13,26-32`, a real, non-vacuous proof once it
  builds).
- **Falsifiable artifact:** `lake build` exit 0 + `#print axioms`; then
  either a compiling, consumed Rust typestate with
  `Standing=PROVEN_CONDITIONALLY`, or a `ROADMAP.md` correction + new
  ledger entry with `Standing=BLOCKED_ON_CORRESPONDENCE`.

### 4.27 star-graphs-betti-construction

**Source:** PB12 — `ROADMAP.md:11` claims "Constructed & Verified" for
star-graph Betti/Euler numbers; `research-papers/star_graphs` is
unbuilt source only (no mathlib require, no root file).

Constructs a kernel-checked star-graph tree/Betti-number theorem, or
downgrades the claim to match the unbuilt reality.

- **Phases:** 4 phases — repro (confirm `lake build` fails on missing
  root file + no `[[require]]`), construction (add the require block,
  add the missing root file, instantiate `SimpleGraph.starGraph` and
  derive `b_1=0` as an explicit arithmetic corollary, not a bare
  `IsAcyclic` citation), kernel verification (`#print axioms`), ledger
  reconciliation (either cite the new theorem or downgrade the claim —
  no silent middle state).
- **Real math assets:** same as §3.24 —
  `SimpleGraph.isTree_starGraph`, `SimpleGraph.IsTree.card_edgeFinset`
  at pinned rev. **Same underlying construction as §3.24
  `g13-star-graph-betti-construction` — launch one.**
- **Falsifiable artifact:** a populated `.lake/build/lib` tree where
  none exists today, `#print axioms` output, `ROADMAP.md:11` corrected
  to cite it or downgraded.

### 4.28 thermo-helmholtz-honest-transliteration

**Source:** PA23 — `thermo_helmholtz`'s doc comment borrows Lean
authority via an ABI-broken FFI extern into a Thermo.c artifact whose
Lean source is a 0-byte stub.

Deletes the borrowed-authority doc comment and ABI-broken FFI extern,
replaces with a directly-cited pure-Rust transliteration of
`ProcInt/Thermo.lean:12-13`'s `helmholtz`, and adds a numeric regression
test that would have caught the original defect.

- **Phases:** 4 phases — reconfirm (fresh repro of the ABI mismatch and
  the 0-byte Lean source), construct (transliterate the formula, cite
  `Thermo.lean:12-13` by file:line with an explicit non-transfer
  disclaimer for `work_bounds`), falsify (a numeric assertion replacing
  the old `.is_ok()`-only check), ledger (record the FFI-wire branch as
  `BLOCKED_ON_CORRESPONDENCE`).
- **Real math assets:** `ProcInt.Thermo.helmholtz`
  (`Thermo.lean:12-13`) and `work_bounds`
  (`:30-35`, proven via `linarith`, explicitly NOT transferred to Rust).
- **Falsifiable artifact:** a `thermo.rs` diff with zero
  `lp_thermo_energy_bio_signals` references, a numeric test asserting
  the exact transliterated value.

### 4.29 sa-pa26-powl-cap-honesty-fix

**Source:** PA26 — `broker.rs`'s comment says the POWL expansion cap is
`≤256`; the literal passed is `513`; the FFI symbol behind it names no
admitted Lean object at all.

Removes the self-contradiction with a named `<=256` const and a
compile-time assertion, rewrites the comment to state truthfully that no
real cap is enforced yet, and adds a tracked `#[ignore]`d test.

- **Phases:** 4 phases — reproduce (confirm the literal/comment
  mismatch and that `ProcInt.Models.Powl` has zero `expansionDepth`
  declaration), constructive fix (named const + `const _: () =
  assert!(...)`), verify (`cargo build`/`cargo test`), ledger closure
  split DEFINITIONAL (closed) / `BLOCKED_ON_CORRESPONDENCE` (open).
- **Real math assets:** `Powl` inductive, `Powl.WellFormed`
  (`Powl.lean:17-44`, real, 0-sorry) — cited as negative context only;
  no depth definition exists yet to enforce a bound with.
- **Falsifiable artifact:** a `broker.rs` diff with the compile-time
  assert, a tracked `#[ignore]`d test naming the exact blocking file:
  line, `PRAXIS_SELF_AUDIT.md` split-standing update.

### 4.30 sa-pa27-transport-deps-reconcile

**Source:** PA27 — `transport.rs`/`main.rs`/`sse_transport_test.rs`
import 6 crates absent from `Cargo.toml`.

Adds the six crates at versions already sitting in the offline registry
cache, without touching the separate missing-`mod transport;` defect.

- **Phases:** 4 phases — evidence-lock (snapshot the 5-dependency list
  + confirm the 6 target crates are cached offline), construct (5
  `[dependencies]` + 1 `[dev-dependencies]` addition, versions pinned to
  what's actually cached), verify (`cargo metadata --offline` exit 0;
  the residual error must shift from missing-crate to missing-module,
  proving the fix is precisely scoped), ledger correction to PARTIAL.
- **Real math assets:** none — pure dependency-resolution hygiene, no
  Lean/Mathlib content.
- **Falsifiable artifact:** a `Cargo.toml` diff (6 crates), `cargo
  metadata --offline` exit 0, a captured residual-error transcript
  proving the fix didn't silently absorb PA22's scope.

### 4.31 sa-pb4-typestate-bond-or-correct

**Source:** PB4 — `ROADMAP.md` claims all "Core Five" theorems are
bonded into Rust via `PhantomData` typestates; zero `PhantomData`/`type
Proof` hits exist anywhere in `crates/`.

Attempts a real, compiling `PhantomData` typestate on
`GgenReceiptEngine` that is an admitted correspondence morphism for the
one real Lean-proven candidate (`workflow_cache_isolation`); if it
cannot be honestly discharged, corrects `ROADMAP.md` instead.

- **Phases:** 4 phases — evidence lock (re-run the defect check live),
  theorem card (AGENTS.md-mandated, `Standing` starts
  `BLOCKED_ON_CORRESPONDENCE`), construction attempt (author +
  adversarial reviewer in parallel, reviewer rejects any doc comment
  using a trigger word not discharged by a real compiler artifact),
  adjudication (`cargo build`/`cargo test` decide success vs. refusal —
  no third option).
- **Real math assets:** `WorkflowTurbulence.workflow_cache_isolation`
  (`RandomWalk.lean:93-112`, proven, 0 sorry) — the only real candidate
  in the tree; `GgenReceiptEngine::compute_receipt`
  (`receipt.rs:59`) as the Rust attach point.
- **Falsifiable artifact:** either a real compiling `PhantomData`
  typestate with `cargo build`/`cargo test` exit 0 and a corrected,
  narrowed `ROADMAP.md:8`, or a `ROADMAP.md:8/31` diff marking the claim
  aspirational with the specific hypothesis that resisted encoding named
  in the commit.

---

## 5. ROADMAP_GAP_*.md — AUTONOMIC, SEMANTIC, THERMO (6 proposals)

### 5.1 mfw-m0-datalog-closure-pddl-bridge

**Source:** `ROADMAP_GAP_SEMANTIC.md` (zero Lean RDF/Datalog/SHACL
representations) + `ROADMAP_GAP_AUTONOMIC.md` (no execution/planning
loop) — the largest single item in this group.

Instantiates the already-proven, fully-generic Wave M0 residue apparatus
at a concrete finite Datalog immediate-consequence closure operator over
RDF ground facts, then proves a soundness correspondence into
`PddlAction.applicable`.

- **Phases:** 5 phases — survey/reconcile (delete or re-export the
  duplicate dead `SemanticBridge.lean` RDF vocabulary before building a
  second one), concrete closure operator (a real
  `Mathlib.Order.Closure.ClosureOperator (Finset (Triple Node))`
  term), instantiate Wave M0 (specialize `residue`/`residue_purity`/etc.
  essentially for free), PDDL soundness bridge (the new theorem), kernel
  + tracking discharge.
- **Real math assets:** `SemanticClosure`, `Entails`
  (`EntailmentOrder.lean:59,65-67`); `eq_of_subset_of_sufficient_of_
  IsMinimalSupport`, `residue_purity`, `residue_isAntichain`
  (`MinimalSupport.lean`, `Antichain.lean`); `PddlAction.applicable`
  (`Pddl.lean:22-24`); `Mathlib.Order.Closure.ClosureOperator`.
- **Falsifiable artifact:** `Graph/DatalogClosure.lean` +
  `Graph/DatalogResidue.lean`, kernel-checked, `#print axioms` per
  theorem, plus deletion/re-export of the dead duplicate vocabulary.

### 5.2 powl-runtime-expansion

**Source:** `ROADMAP_GAP_AUTONOMIC.md:16-18` — the codebase has no
runtime-manufactured recursion (`W_n -> W_{n+1}`); well-formedness rules
have no depth bound.

Adds a kernel-checked runtime-expansion operator to
`ProcInt.Playground.MFW.POWL` that replaces an already-Admitted atom
with a newly manufactured, depth-bounded child workflow, instantiated
concretely on the existing `Examples.productionWorkflow` object.

- **Phases:** 5 phases — construct the depth measure + atom-locator
  (mirroring `ChoiceGraph.Reach`'s existing pattern), construct
  `expandAt` + prove `expand_preserves_admitted` (a genuine structural-
  induction correspondence, not an asserted identity), exhibit the
  concrete `W0 -> W1` instance on `admittedProduction`, verify + ledger
  (leaving sections 2.2/2.3/3 explicitly untouched, never invoking
  praxis).
- **Real math assets:** `POWL`, `Reach`, `ChoiceGraph`, `POWL.Admitted`,
  `AdmittedPOWL` (`Playground/MFW/POWL.lean:21-67`);
  `productionWorkflow`, `productionWorkflow_admitted`
  (`Playground/MFW/Examples.lean:46-57`, already kernel-checked).
- **Falsifiable artifact:** extended `POWL.lean`/new `Expansion.lean`
  with `POWL.expand_preserves_admitted`, a concrete
  `admittedProductionExpanded : AdmittedPOWL` example, `lake build
  Playground` clean, `#print axioms`.

### 5.3 pddl-goal-deferral-trichotomy

**Source:** `ROADMAP_GAP_AUTONOMIC.md:19-21` (AU4) — `validCheck`
returns a bare Boolean; no distinction between closed/inadmissible/
deferred-with-unresolved-atoms.

Extends `PddlPlan.validCheck`'s Boolean into a three-constructor outcome
via the procint TTL pack, with a machine-checked compatibility theorem
back to the existing Boolean API and a machine-checked exhaustiveness
theorem.

- **Phases:** 5 phases — scope/dedup (confirm no overlap with any
  G-item or in-flight worktree), construct (`PddlOutcome`
  inductive + `PddlPlan.classify` in the TTL pack, mirroring the
  existing `Decl_PddlPlan_validCheck` block), render/admit (`ggen sync`
  + `lake build`), independent verify (fresh worktree, confirm the
  ledger's recorded hash actually changes), ledger honesty (the
  `deferred` case formalizes only a decidable per-plan fact, not general
  STRIPS reachability).
- **Real math assets:** `PddlAction.applicable`, `PddlAction.apply`,
  `PddlAction.mem_add_mem_apply`, `PddlPlan.validCheck`, `PddlPlan.valid`
  (`Pddl.lean:22-63`, all real, all reused as the induction base case).
- **Falsifiable artifact:** two new `#guard_msgs in #print axioms`
  entries in `AxiomAudit.lean` for `classify_closed_iff_validCheck` and
  `deferred_unresolved_eq_sdiff`, both kernel-checked.

### 5.4 pddl-validcheck-admission-gate

**Source:** `ROADMAP_GAP_AUTONOMIC.md` AU1, step 5 of
`CLAUDE_ROADMAP.md`'s Phase 8 — `CrownLoopBroker::sequence_cycle`
computes `PddlPlan.validCheck`'s real, Lean-verified result and then
discards it into a debug string instead of branching on it.

Makes `sequence_cycle` actually branch on the FFI-derived `valid`
result, closing Phase 8 step 5 only (step 6 explicitly spun off as a
separate, still-OPEN item).

- **Phases:** 4 phases — diagnose (characterizing test proving current
  vacuity), construct (pure `crown_dispatch_decision(valid: bool)`
  function, scoped to `broker.rs` alone — no `pub mod` changes, no G11
  presupposition), independent re-verify (a second agent re-derives the
  branch matches Phase 8 step 5's English exactly), ledger + theorem
  card (Standing: IMPORTED, flags the untouched `s0`/`sGoal` argument-
  aliasing suspicion for a separate item).
- **Real math assets:** `PddlPlan.validCheck`
  (`Pddl.lean:50-55`, compiled symbol confirmed present in the real
  `Pddl.c`, matching 5-arg signature).
- **Falsifiable artifact:** a before/after test proving the branch
  now actually short-circuits on `valid == true`; a new `GAP_LEDGER`
  entry closing AU1's step-5 scope only.

### 5.5 wf-powl-expansiondepth-corr

**Source:** `ROADMAP_GAP_AUTONOMIC.md` AU2 — `broker.rs`'s POWL depth
call is fabricated (same underlying defect as §3.20/§3.21/§4.5).

Either admits a real, kernel-checked `Powl.expansionDepth` bound on top
of the existing `Powl`/`Powl.WellFormed` carrier and regenerates the
FFI, or deletes the fake C stub and marks the POWL-depth call MISSING
per AGENTS.md's edge taxonomy — closing AU2 one way or the other, not
leaving it silently fabricated.

- **Phases:** 4 phases — re-verify the fabrication claim standalone,
  theorem-card decision (definable now vs. needs the unbuilt
  hierarchical `subworkflow` variant — the one substantive judgment
  call), CONSTRUCT branch (add `Powl.expansionDepth` by structural
  recursion, regenerate `Powl.c`, rewire `broker.rs`) or MARK-MISSING
  branch (delete the stub + call site, replace with a typed `Refusal`),
  verification (both branches converge on a compiling `cargo build -p
  mfact-core`).
- **Real math assets:** `Powl` inductive, `Powl.WellFormed`
  (`Powl.lean:17-44`, real, already proves bound-shaped side conditions
  on the `xor`/`po` cases the new depth measure would extend).
- **Falsifiable artifact:** either a Lean diff with the new constructor
  + `#print axioms` and a regenerated non-stub `Powl.c`, or a Rust diff
  with zero `expansionDepth` grep hits and `ROADMAP_GAP_AUTONOMIC.md`
  recording the edge MISSING. *Overlaps with §3.20/§3.21 — same
  underlying defect, three independent scopes; pick one.*

### 5.6 thermo-functional-goal-blindness-repair

**Source:** `ROADMAP_GAP_THERMO.md` — `thermo_f`/
`evaluate_thermodynamic_pressure` ignore their own `G`/`T` parameters;
`ROADMAP_GAP_THERMO.md`'s own "zero structural matches" claim is itself
now stale.

Re-audits G16 live, then downgrades `ROADMAP.md` Phase-2 items #8-11 and
the orphaned Rust functions to explicit CONJECTURAL/MISSING status — no
math is fabricated because verification confirms none exists to
fabricate honestly.

- **Phases:** 4 phases — re-audit (live-reconfirm `thermo_f`/
  `evaluate_thermodynamic_pressure` are goal- and temperature-blind,
  worse than previously documented — the FFI arg is hardcoded to `0`),
  decide-and-reject stub directories (would replicate G15's own
  condemned anti-pattern), annotate (`STANDING: CONJECTURAL` doc
  comments + `[UNSTARTED]` tags), verify-and-close (comment-only diff).
- **Real math assets:** none — `thermo.rs:24-35`'s functions are
  confirmed to ignore `_g`/`_t` entirely.
- **Falsifiable artifact:** `grep -c "\[UNSTARTED\]" ROADMAP.md`
  returns 4 at the right items; a new `#[test]` in
  `thermo_integration_test.rs` exhibiting a literal witness pair proving
  goal-blindness. *Overlaps with §3.23 `thermo-bridge-standing-
  correction` — same underlying defect; launch one.*

---

## 6. CLAUDE_ROADMAP.md (8 proposals)

### 6.1 close-ar1-autonomic-marker

**Source:** `CLAUDE_ROADMAP.md:1129` — `MFW_AUTONOMIC_RESOLUTION_ALIVE
=true` is hand-asserted with no producer and no `standing.env` entry,
directly contradicting `ROADMAP_GAP_AUTONOMIC.md`'s own evidence.

Applies the already-3x-validated Marker Schema fix (used verbatim for
G20/G21/G22) to blank the marker and frame Phase 8 as a target, per the
same document's own section-7 precedent.

- **Phases:** 3 steps, 2 lenses — verify (re-derive the defect live),
  fix (blank the marker with a producer/evidence comment, insert a
  framing sentence before the Phase 8 procedure), ledger + re-verify
  (new `GAP_LEDGER` entry in the exact G20/G21/G22 format).
- **Real math assets:** none new — applies an existing, already-
  validated law and template (`ROADMAP_MATH_SPINE.md:368-418`'s Marker
  Schema + section-7 framing sentence) to an untouched location.
- **Falsifiable artifact:** a 2-hunk diff; `grep -n
  "MFW_AUTONOMIC_RESOLUTION_ALIVE" CLAUDE_ROADMAP.md` no longer matches
  `=true`.

### 6.2 phase0-tree-truth-matrix

**Source:** `CLAUDE_ROADMAP.md:884-909`, Phase 0 — no six-state
capability matrix has ever been built; three divergent status lineages
(G5) are exactly the kind of drift Phase 0 is meant to prevent.

Read-only, multi-lens audit that builds the six-state capability matrix
(ALIVE/PARTIAL_ALIVE/BLOCKED/BUILD_BROKEN/UNKNOWN/UNSUPPORTED) Phase 0
requires and only then flips `CURRENT_TREE_TRUTH_REESTABLISHED`, with
zero implementation edits.

- **Phases:** 4 stages, 7 agents — recon (seed the entrypoint list,
  flag absent tickets index/diagrams dir as findings, not blockers),
  5 parallel lens audits (rust-build, release-artifacts, tickets-truth,
  web-ui, research-papers — each command + exit code, no prose-only
  claims), reconciliation (flag lens disagreement explicitly), gate
  (only fires on zero unresolved contradictions).
- **Real math assets:** none — a read-only audit step, not a
  construction; forcing a theorem citation here would itself be the
  kind of hollow padding this catalog's own discipline forbids.
- **Falsifiable artifact:** `CAPABILITY_MATRIX_v26.7.12.md`, one row
  per entrypoint with an exact re-runnable command and literal exit
  code, `CURRENT_TREE_TRUTH_REESTABLISHED=true` appended only after the
  matrix exists.

### 6.3 dispatch-single-actuation-authority

**Source:** `CLAUDE_ROADMAP.md` Phase 2 markers
`DUPLICATE_DISPATCH_SINGLE_ACTUATION`, `PUBLIC_ID_TOKEN_BYPASS_REFUSED`,
`RETURN_AUTHORITY_ENFORCED` — `broker.rs`'s dispatch loop is
unconditionally re-actuating and has no authority-token scheme at all.

Replaces the unconditionally-re-actuating dispatch loop with atomic CAS-
based dedup and secret/nonce authority tokens, proven by a live race
harness and seven adversarial fixtures.

- **Phases:** 5 agents, sequential lenses — concurrency-adversary (a
  race harness that must currently FAIL, showing >1 actuation, before
  any fix lands), systems-correctness (atomic dedup closing the TOCTOU
  window), adversarial-crypto (HMAC-backed tokens, never derivable from
  public fields), red-team-fixtures (7 explicit refusal cases), verify.
- **Real math assets:** none — pure Rust concurrency/cryptography
  engineering. A tempting near-miss (`TokenReplay.lean`) was checked and
  ruled out: it formalizes Petri-net conformance-checking fitness, a
  different mathematical object from a dispatch-authority nonce — citing
  it would be an ANALOGY edge dressed as PROVEN, which AGENTS.md
  section 4 forbids.
- **Falsifiable artifact:** `cargo test --test race_dispatch` output
  showing N tasks against one dispatch key producing exactly 1
  actuation; a 7-case adversarial fixture file, 7/7 pass.

### 6.4 process-science-triad-genesis

**Source:** `CLAUDE_ROADMAP.md` Phase 12's 9 named process-science
breeds — 3 (PDDL, POWL, Multifractal) already have sorry-free,
artifact-ledgered Lean proofs; the other 6 do not.

Composes the three proven breeds into one receipted admitted-process-
field pipeline via a new boundary-preservation theorem, and produces an
honest theorem-card ledger showing the other six remain unproven —
explicitly not flipping `EXECUTABLE_PROCESS_SCIENCE_ALIVE`.

- **Phases:** 5 phases, ~6 agents — audit (theorem-card table per
  breed, re-verified live, not from memory), instantiate
  `MultifractalWorkflow` with PDDL/POWL carriers and prove the new
  boundary-preservation theorem (the admitted correspondence morphism
  AGENTS.md section 4 requires before these standings compose), a
  bounded Datalog-to-PDDL bridge lemma (not general closure semantics),
  receipt wiring, honest ledger.
- **Real math assets:** `PddlAction`, `PddlPlan.valid`
  (`Pddl.lean:15-66`); `Powl.WellFormed.*` (4 theorems, `Powl.lean:
  48-79`); `DAG`, `Region`, `MultifractalWorkflow`,
  `projection_path_independence` (`Workflow/Multifractal.lean:6-83`);
  `Scale`, `concaveLegendre_le` (`Playground/Multifractal/*.lean`) — all
  confirmed 0-sorry this session.
- **Falsifiable artifact:** a new `Workflow/ProcessScienceTriad.lean`
  with `#print axioms`, new hash-chained `.ggen-v2/receipt-log.jsonl`
  records, `ROADMAP_GAP_PHASE12.md` stating exactly 3-4 of 9 breeds
  reached PROVEN, the marker left `false`.

### 6.5 pddl-plan-validity-gate

**Source:** `CLAUDE_ROADMAP.md` Phase 8, step 5 (same underlying defect
as §5.4, from the roadmap angle rather than the AU1 angle).

Makes `CrownLoopBroker::sequence_cycle` actually branch on the
Lean-verified `PddlPlan.validCheck` result.

- **Phases:** 4 phases — same shape as §5.4: diagnose the discarded
  value, construct the pure decision function scoped to `broker.rs`
  only, independent re-verify against Phase 8's own English, theorem
  card + ledger split (step 5 CLOSED, step 6 explicitly OPEN — no
  admissibility signal exists yet to branch on).
- **Real math assets:** `PddlPlan.validCheck`
  (`Pddl.lean:50-55`). **Same fix as §5.4 `pddl-validcheck-admission-
  gate` — launch one.**
- **Falsifiable artifact:** same shape as §5.4.

### 6.6 otel-rdf-ocel-receipt-bridge

**Source:** `CLAUDE_ROADMAP.md` Phase 3, marker
`OTEL_OCEL_PRODUCTION_REACHABLE` — no RDF/SPARQL/CONSTRUCT vocabulary
exists anywhere in `crates/`.

Builds the OTel-span-admission-to-typed-named-graph-to-BLAKE3-receipt
production pipeline, reusing the already-tested `GgenReceiptEngine` as
the digest primitive, while explicitly refusing to claim Lean/OCEL
theorem standing for the new CONSTRUCT projector.

- **Phases:** 5 steps, 3 agents — typed named-graph model (`NamedGraph`
  enum replacing `Fact.graph: Option<String>`), OTel admission
  entrypoint, a declared (non-Turing-complete) CONSTRUCT projector
  labeled UNVERIFIED per AGENTS.md section 4 — `ProcInt.Ocel` is cited
  as vocabulary inspiration only, no correspondence morphism claimed —
  per-graph receipt chaining, an independent verification oracle that
  re-derives the receipt from emitted facts alone.
- **Real math assets:** `GgenReceiptEngine::compute_receipt`
  (`receipt.rs:38-90`, BLAKE3-chained, order-independence already
  proven); `validate.rs:5-26`'s `Refusal`-typed pattern, reused.
  Explicitly not drawn on for standing: `ProcInt/Ocel/*.lean` (real,
  kernel-built, but no admitted correspondence to the Rust projector).
- **Falsifiable artifact:** a green `cargo test -p mfact-core`, a
  receipt file with 5 per-graph digests + a chained meta-digest,
  reproduced bit-identically across two independent oracle runs, with an
  adversarial mutation test proving a stale fact is refused.

### 6.7 thermo-process-work-grounding

**Source:** `CLAUDE_ROADMAP.md` Phase 13's F(S,G) functional — `thermo.rs`
is unreachable from `lib.rs` (same root cause as §3.5/§4.18), and its
FFI-bound energy functions have no live Lean source.

Repairs the module wiring, then rebuilds F(S,G) from four real measured
process-pressure quantities already sitting in the crate (depth,
dispatch count, refusal density, receipt cost) instead of the
constant-returning energy stub — self-play injection and roadmap
emission explicitly left out of scope.

- **Phases:** 5 phases — build repair (the same `pub mod` fix as
  §3.5), FFI correspondence audit (remove/correct the phantom
  `expansionDepth` extern, flag the orphaned `lp_thermo_energy_*`
  externs whose Lean sources post-date their own compiled artifacts),
  F(S,G) construction from real Rust-side measured quantities only,
  regression verification (monotonicity test, cross-checked against
  `pylab`'s real Western Electric implementation), ledger update to a
  precise per-function table.
- **Real math assets:** `CrownLoopBroker::sequence_cycle`
  (`broker.rs:68-72`), `Refusal` enum (`lib.rs:6-21`),
  `GgenReceiptEngine::compute_receipt` (`receipt.rs:59`),
  `scalar_dissipation` (`thermo.rs:58-60`, real Clausius-form formula,
  standing CONJECTURAL not PROVEN since its Lean anchor is a stub).
- **Falsifiable artifact:** a green `cargo test --test
  thermo_integration_test` (currently red with E0432) with a new
  monotonicity assertion, and an updated `ROADMAP_GAP_THERMO.md`
  per-function status table.

### 6.8 ticket-state-graph-workflow

**Source:** `CLAUDE_ROADMAP.md` Phase 14 ("Tera does not decide status;
status is graph consequence") — the real `pylab/docs/jira/26.7.7/
tickets/index.md` is hand-maintained prose, the exact anti-pattern
Phase 14 forbids.

Authors a new `packs/ticket-state-pack` ggen pack that models tickets
as RDF individuals and derives status via SPARQL aggregation, replacing
the hand-maintained index and reconciling G5's three divergent status
lineages.

- **Phases:** 4 waves — ontology design + baseline capture (parallel),
  SPARQL status-derivation (named queries, no Python pre-computation),
  Tera-render (zero status branching in templates, matching the
  `module.lean.tmpl` pattern), verifier-report + tickets-truth
  reconciliation (row count must equal the real file count on disk).
- **Real math assets:** none — infrastructure; reuses the proven
  `packs/lean-math-pack/templates/module.lean.tmpl:1-19` Tera+SPARQL
  pattern and flags `post-release-pack`'s literal-status anti-pattern as
  the concrete counter-example being fixed.
- **Falsifiable artifact:** a new registered pack with a blake3
  content-hash, a regenerated `tickets/index.md` whose row count equals
  `ls tickets/*.md | wc -l`, and a `ggen sync --dry-run` idempotence
  receipt.

---

## Considered but not viable (39 items)

This repo's own rule is no silent caps — every item that was surveyed
and rejected is listed here with the specific reason, not hidden.

### ROADMAP_MATH_SPINE.md (3)

- **Wave M3** (recursive-coalgebra/replay-uniqueness). No workflow
  proposed: M3's required order starts from Wave M1's Dershowitz-Manna
  well-foundedness result, and M1 itself does not yet exist
  (`procint/ProcInt/MFW/Termination/` is absent). Any M3 workflow today
  would either sorry-stub the ordering (barred by AGENTS.md §3) or
  assume it without an admitted correspondence (barred by §4). Launch
  §1.1 (`wave-m1-crown-descent`) first.
- **Wave M5** (spine calculus, spectra, freezing test). The document's
  own governing marker states this wave is `BLOCKED_ON_EVIDENCE` until
  the measurement rail produces an admitted OCEL corpus. Verified live:
  zero `.xes`/event-log evidence files exist anywhere in the tree, and
  Correction 9's marked offspring kernel has zero Lean presence. No
  workflow proposed rather than inventing the missing corpus.
- **Corollary 21.2 / A10** (POWL→AIR compile adequacy). `A10` blocks
  Corollary 21.2, and discharging A10 requires either building a fresh
  POWL→AIR compiler from scratch (duplicating praxis's already-built,
  adversarially-reverified `multifractal-workflow` crate per
  `PRAXIS_DOGFOODING_EXPLORATION.md:229-241`) or admitting a
  correspondence to that crate — both routes silently decide the one
  reserved architectural question this catalog does not presuppose.

### ROADMAP_SWARM_SUPPLY_CHAIN.md (4)

- **Problems P1-P12** ("carried from Rail B"). The entire textual
  footprint of P1-P12 in this repo is seven words pointing at a document
  ("the Rail B review exchange") that was never committed. No content
  exists to formalize; inventing it would violate AGENTS.md §3.
- **Problem P15** (coalition antichain generalization). Verbatim
  duplicate of Wave S2 — same theorem, same target files, same closing
  correction (C5). Closed by §2.4 `s2-coalition-capability-port`, not a
  separate entry.
- **Problem P16** (pipeline-stock conservation). Verbatim duplicate of
  Wave S3 — the document cross-references its own P16 from inside the
  Wave S3 paragraph. Closed by §2.1 `wave-s3-pipeline-conservation`.
- **Problem P17** (`Terminating (Swap step)`). The construction task is
  refuted (a real, unconditional counterexample already exists,
  kernel-checked) and independently CONFIRMED closed in
  `PRAXIS_SELF_AUDIT.md` PA20. The one open thread (an orientation/
  priority structure) is explicitly owned by Problem P22, closed by
  §2.6 `oriented-swap-newman-closure`.

### GAP_LEDGER_v26.7.12.md (10)

- **G12** (untracked `mfact-core` sources + roadmap docs). Every
  actionable branch is downstream of G11's still-open ship-or-delete
  fork and the reserved praxis-architecture question; not independently
  actionable.
- **G24** (prose-lint doc overclaims). Folded into §3.7
  `prose-lint-tightener`, which the ledger's own text says shares one
  landing point with G44.
- **G25** (`web/mfact-ui` unregistered gitlink). Real and confirmed
  open, but carries zero math/Lean content — pure git-plumbing (register
  a submodule or vendor the directory). Standing up a workflow around a
  one-command fix would be hollow padding.
- **G42** (`verif-report` doc hint + missing `just` target). Half is a
  2-line doc-hint edit; the other half is structurally a consequence of
  §3.2/§3.15/§3.16 (G41) and would duplicate that entry if launched
  separately.
- **G2-dup-note**. A bookkeeping stub with `status`/`realMathAssets`
  both `n/a` — not a file-backed ledger row. The real item is G4
  (`g4-countermodel-gate-wire`, §3.1).
- **G27** (`vite.config.ts` base-path mismatch). One-line string fix
  with no math content, gated on G25/G26 landing first; not
  independently actionable at workflow scale.
- **G28** (`vite.config.ts` absolute `/Users/sac/unrdf` aliases). Same
  worktree-provenance blocker as G27, same one-line-fix scale.
- **G29** (missing `run_e2e.sh`). Pure CI-hygiene gap; author or
  disable the script in one commit, no math/phases involved.
- **G36** (7 untracked, 0-byte `lakefile.lean` shadow files). Confirmed
  0 bytes and untracked; `git rm` on an untracked file stages nothing,
  so there is no commit for a dispatched workflow to land against —
  structurally unrepresentable in this session's worktree-commit model.
- **G40** (4233 tracked `target/` paths). Already resolved by commit
  `c0872bf`, which the ledger's BLOCKED note predates. `git ls-files
  crates/mfact-core/target | wc -l` returns 0 today.

### Prior-session action lists (14)

- **NOTE-PASSES** ("only 2 of 3 audit passes exist"). Stale: Pass 3 now
  exists in `PRAXIS_SELF_AUDIT.md` (dated 2026-07-13, lines 1415-end).
  The gap already closed itself.
- **NOTE-EXCLUDED** ("decide the CLAUDE_ROADMAP/multifractal-workflow
  relationship"). This *is* the reserved architectural question itself —
  proposing a workflow for it would either silently decide it or
  degrade into a hollow "draft a memo" entry. Correctly excluded, not
  padded.
- **DOG-7** (asymmetric praxis↔mfact Bash permission grants). A
  governance/policy question for the user, not a mathematical
  construction task; no theorem/lemma/carrier object applies.
- **W4PM-1** (add the receipt schema + `.mfact/receipts/`). Already
  done at current HEAD (commit `c741d46`) — schema, both files, and a
  real logged firing all exist. Nothing left to construct.
- **SA-PA31** (`main.rs` link check). Zero independent content — a
  zero-edit downstream consequence of §3.5 (`g11-reachability-repair`)
  and §4.30 (`sa-pa27-transport-deps-reconcile`) landing.
- **SA-PB6** (one false `find`-based citation in a doc sentence). No
  math content; a single-line `Edit`, not a workflow.
- **SA-PB15** (`validate.rs` test-helper rename). Confirmed pure rename,
  zero behavioral change — already REFUTED as a concern; nothing to fix.
- **SA-PB19** (`AGENTS.md` "never touch praxis" phrasing). Reconfirmed
  already correct and internally consistent; no defect exists.
- **RM1** (star_graphs/scalar_dissipation "Constructed & Verified"
  claim). Verbatim duplicate of G13, closed by §3.24.
- **RM3** (SMFDCCA Cauchy-Schwarz claim). Verbatim duplicate of G17,
  closed by §3.18.
- **RM4** (items #8-11 + #12-16 formalization claims). Duplicate of
  G15/G16, closed by §3.26/§3.23.
- **RM5** (PhantomData/typestate "Zero-Cost Mechanisms" claim).
  Duplicate of G18, closed by §3.22.
- **RM6** ("rigor gate is blind" execution rule). Duplicate of G14,
  closed by §3.25.
- **AU6** (autonomous-resolution receipt requirement). Restates Crown V
  / Wave M3 / G11 verbatim with no new target file or theorem.

### CLAUDE_ROADMAP.md (8)

- **Phase 1** (Arazzo return-loop trace). Every required object is
  defined entirely in praxis's own F13-F21 vocabulary; the one candidate
  mfact artifact (`broker.rs`) is confirmed dead (G11) and buggy (G32)
  even if wired, and still wouldn't supply AIR/dispatch/return-authority
  machinery. Real progress requires deciding the reserved question.
- **Phase 4** (Arazzo 1.1 conformance feature matrix). Zero Arazzo
  parser/types exist in `crates/`; `CLAUDE_ROADMAP.md` itself ties this
  to "wasm4pm," which is a praxis crate, not an mfact one. A checklist
  workflow starting all-`NOT_IMPLEMENTED` produces no falsifiable
  artifact and presupposes the reserved question either way.
- **Phase 5** (freeze AIR representation). No AIR/Erlang/wasm4pm
  implementation exists independently in mfact; the only adjacent Lean
  file is an unbuildable, wrong-phase DECLARED-only stub. Any real work
  here presupposes the reserved question.
- **Phase 6** (OTP Arazzo runner). Zero `.erl`/`rebar.config` files
  exist in mfact; praxis's `multifractal-workflow` F16 chain already
  implements this family with adversarially-verified tests. Building
  from scratch or depending on praxis both presuppose the reserved
  question.
- **Phase 7** (AtomVM live-runtime proof). Downstream of Phases 5-6,
  neither of which is achieved; the one AtomVM-adjacent Lean object
  (`Correspondence/AtomVM.lean`) is theorem-authority, not the
  production-authority runtime Phase 7 needs.
- **Phase 9** (contractor-allegation flagship scenario). Strictly
  downstream of Phases 1/2/3/5/6/7/8, none of which have a completion
  marker anywhere in the repo; no domain vocabulary or working
  Arazzo/AIR/PDDL/POWL layer exists to route an event through yet.
- **Phase 10** (public-ontology self-play). Presupposes an RDF/Datalog/
  SHACL formalization layer that `ROADMAP_GAP_SEMANTIC.md` confirms does
  not exist (one UI stub literally comments "Simulates" the layer).
  Becomes proposable once §5.1 (`mfw-m0-datalog-closure-pddl-bridge`)
  lands real Lean content to mutate.
- **Phase 11** (thermo/SPC/broker bridge). Stacked on ≥4 independent
  blockers: G11's ship-or-abandon fork, FFI args fed from a hardcoded
  literal (vacuous SPC signal), a dangling `Powl.expansionDepth` FFI
  symbol (only masked by this environment's absent Lean toolchain), and
  zero Western-Electric/enterprise-hierarchy Lean formalization anywhere
  to cite as an Object for a theorem card.

---

## Ready to launch on request

This document is a menu, not an execution log. None of the 96 proposals
above were actually run as part of producing this catalog — no
Workflow tool calls were fired, no worktrees were dispatched, no commits
were made. Every phase count, agent-lens assignment, and file:line
citation above was checked against the live tree during the survey, but
the work itself has not started.

Say which entry (or entries) to launch, by its numbered heading (e.g.
"launch 3.1" or "launch wave-m1-crown-descent"), and it will be
dispatched as a real Claude Code Workflow — nothing here fires
automatically.

