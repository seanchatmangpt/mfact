# ROADMAP: The Mathematical Spine (Rail B Admission)

Updated 2026-07-12. Source: the Rail B review exchange of 2026-07-12. This document supersedes
the "attach 26 advanced mathematical rails" framing. The dissertation mathematics is one theorem
chain — the spine — plus three evaluation geometries that grow from the admitted execution field.
Every entry below carries an explicit standing marker; no entry may be quoted at a stronger
standing than its marker. Related docs: `AGENTS.md` (§4, the No Ambient Theorem Authority Law),
`CLAUDE_ROADMAP.md`, `ROADMAP.md`, `paper/PROSE_LINT_RULES_CORRESPONDENCE.md`.

## Quick Reference

1. The Theorem Spine — Crown I–V and the Causal Crown
2. Standing Corrections Ledger — nine refused or downgraded Rail B statements
3. Failure Modes and Mechanical Preventions
4. Lean Formalization Waves M0–M5 (with verified environment facts)
5. Problem Ledger Additions
6. Marker Schema (claim ceilings vs. achievement markers)
7. Operational Manufacturing Loop
8. Claim Status Table
9. Falsification Surface

---

## 1. The Theorem Spine

The spine replaces both the "Autonomous Resolution Crown Theorem" and the 26-rail catalogue:

```text
minimal antichain residue
→ Dershowitz–Manna multiset descent
→ free-monad / operadic substitution
→ recursive coalgebra
→ unique replay
→ autonomous resolution
```

### Crown I — Minimal Residue

Semantic contraction yields an antichain of minimal completion supports; every obligation in
every support is load-bearing. The residue is typed as

```text
ρ : State × Goal → Antichain (Finset Obligation)
```

not as a single residue state. Disjunction in the goal is multiplicity in the antichain, not a
planner special case. Standing: `TARGET_THEOREM` (Wave M0).

### Crown II — Productive Descent

Every admitted recursive manufacture replaces a frontier obligation by finitely many obligations
strictly lower in the admitted obligation order; therefore the active obligation multiset
strictly decreases in the Dershowitz–Manna extension. Workflow size may grow while the measure
descends — growth toward completion is a two-line consequence of DM descent, with no global
workflow-size bound in the termination argument. Standing: `TARGET_THEOREM` (Wave M1).

### Crown III — Compositional Manufacture

Recursive child attachment (`graft_child`) is selective Kleisli substitution in the free process
monad over the admitted signature; nested grafting is associative and independent grafts commute
(`graft_commutes_of_socket_independent`). The colored operad is the typed multi-hole presentation
of the same substitution discipline — keep both: free monad as the implementation law, operad as
the context-composition law. Standing: `TARGET_THEOREM` (Wave M2).

### Crown IV — Unique Replay

DM descent makes the crown coalgebra well founded; under the recursive-coalgebra hypotheses
(Adámek–Milius–Moss) the coalgebra admits a unique coalgebra-to-algebra morphism into the receipt
algebra. Replay determinism is a uniqueness theorem, not a test outcome: tests become
correspondence witnesses; uniqueness is the law. The hylomorphic presentation
(`replay = cata ∘ ana`) is proved only after the manufacture/execution factorization is
exhibited, and is not asserted before. Standing: `TARGET_THEOREM` (Wave M3).

### Crown V — Autonomous Resolution

Every productive MFW execution reaches semantic closure or typed refusal; no execution performs
unreceipted actuation; the resulting receipt replay is unique. This composes Crowns I–IV with
the broker factorization law. Standing: `TARGET_THEOREM`, conditional on A1–A10 of the Rail B
assumption ledger (see Correction 1 below for the mandatory split).

### Causal Crown — Experiment Genesis

Causal identification is closure in the causal dialect (do-calculus completeness, Huang–Valtorta,
scoped to the causal-effect identifiability setting they study). A nonempty minimal
identification residue specifies alternative minimal information augmentations; an admissible
intervention capability lets MFW manufacture the experiment targeting that residue.
Non-identifiability is unfinished causal work — at the type level, via the same
`MinimalCompletion(C, x, A)` operator that types planning and abduction. Standing:
`TARGET_THEOREM` (Wave M4); the unification claim requires the shared operator to be literally
instantiated three times, not three parallel developments.

### The three evaluation geometries

Tropical concurrency, Perron pressure, and multifractal frontier analysis grow from the admitted
execution field. They are measurement mathematics (Rail C), gated on real OCEL evidence
(Wave M5). Cubical concurrency dimension and tropical schedule evaluation measure different
things (independence geometry versus temporal realization); do not collapse them — study the
inequalities linking them (e.g. barrier price).

---

## 2. Standing Corrections Ledger

Nine Rail B statements were refused or downgraded during the 2026-07-12 review. Each entry
records the original claim, the defect class, and the corrected claim. Prose anywhere in the
repository must not restate the original claim at its original strength.

### Correction 1 — The Crown was not "proven under declared assumptions"

- Original: §21 "Theorem (Crown, Rail B form) — PROVEN UNDER DECLARED ASSUMPTIONS", with
  assumption A10 (compile adequacy) itself labeled a target theorem.
- Defect: a conclusion consuming an unproven assumption presented in the tone of a discharged
  theorem — ambient authority leaking from the assumption ledger into the headline.
- Corrected: split into Theorem 21.1 (abstract crown composition,
  `(A1 ∧ … ∧ A10) ⇒ Crown`, standing `PROVEN_CONDITIONALLY`) and Corollary 21.2 (MFW runtime
  crown, standing `BLOCKED_ON_CORRESPONDENCE` until A10 and the correspondence assumptions are
  discharged).

### Correction 2 — Receipt ledger injectivity is a category error

- Original: §4 "under collision resistance the ledger homomorphism is injective up to negligible
  probability; replay against identical evidence is a decision procedure for consequence
  ancestry."
- Defect: cryptographic computational binding restated as set-theoretic injectivity. A fixed-size
  digest cannot be injective over unbounded histories, and an iterated hash chain is not
  automatically a monoid homomorphism into raw digest values.
- Corrected: define the canonical receipt fold (domain-separated `h_{n+1} = H(tag ∥ h_n ∥
  enc(r_{n+1}))`) and claim `COMPUTATIONALLY_BINDING_RECEIPT_FOLD`: for a PPT adversary,
  producing distinct canonical receipt sequences with equal heads reduces to the declared
  binding assumption. Head equality alone does not decide ancestry; ancestry verification
  requires the candidate receipt chain (or inclusion witness) plus deterministic fold replay.
  Predicate namespaces (`Math.Injective`, `Crypto.ComputationallyBinding`,
  `Runtime.Deterministic`, `Evidence.ReplayEquivalent`) never silently interchange.

### Correction 3 — Algebraicity was stated one generality too high

- Original: §1 algebraicity of `Fix(C)` asserted for an arbitrary complete lattice `L` with
  finitary `T`.
- Defect: generalization drift — the proof intuition lives in the powerset case; the statement
  inherited the arbitrary-lattice scope.
- Corrected: specialize to `L = P(Atoms)` (RDF ground facts) with a finitary closure operator;
  prove algebraicity there; weaken hypotheses only after that proof exists. The Immerman–Vardi
  import is scoped to ordered finite structures and data complexity for a fixed rule program,
  not combined complexity.

### Correction 4 — The claim-ceiling adjunction needs complete lattices

- Original: §3 "Req monotone and join-preserving on a poset of claims ⇒ Req has a right
  adjoint."
- Defect: theorem-shape matching — the adjoint-functor pattern recognized before its signature
  was checked.
- Corrected: `Cl` and `S` complete lattices, `Req` preserving arbitrary joins; then
  `Ceil(s) = ⋁{c ∈ Cl : Req(c) ≤ s}` with `Req(c) ≤ s ⟺ c ≤ Ceil(s)`. The fibrational
  standing-leak result is relabeled `[PROP, INTERNAL TO DIALECT-FIBRATION MODEL]`: inside the
  model, per-arrow (cartesian) discipline is necessary and sufficient; the claim that every
  real-world epistemic leak is characterized by cartesianness failure is not proved.

### Correction 5 — CKA is scoped to the series-parallel POWL fragment

- Original: §5 "POWL terms are CKA terms."
- Defect: the completeness package (Gischer; Kappé–Brunet–Silva–Zanasi) covers series-parallel
  pomset fragments; POWL 2.0 choice graphs exceed that fragment.
- Corrected: `POWL_SP ⊆ POWL_2`; the CKA interpretation and equational discharge apply to the
  series-parallel fragment only. The N-free (Valdes–Tarjan–Lawler) check is the admission gate
  proving a generated region lies inside `POWL_SP`. Outside it, the process is still POWL but
  inherits no CKA theorem package. This is a claim ceiling, not a defect of POWL 2.0.

### Correction 6 — Two tropical operators were conflated

- Original: §6/§16 "the planner is the frozen phase."
- Defect: operator conflation — `A` (capability-weighted state-transition/Bellman operator) and
  `M(q)` (tilted multitype offspring operator) both tropicalize, but no cycle-mean-preserving
  correspondence between them has been exhibited.
- Corrected: what is available is the dequantization limit
  `lim (1/β) P(βq) = λ_trop(W(q))` for the offspring operator under bounded support. The
  identification with the planner's operator is Problem P13. Until P13 is discharged:
  `PLANNER_IS_FROZEN_PHASE=CONJECTURAL`. The sentence must be unrenderable as a theorem
  statement while P13 is open.

### Correction 7 — Adaptive submodularity is an admission condition, not an import

- Original: §11 conditional independence promotes EIG to (adaptive) submodularity with the
  Golovin–Krause guarantee.
- Defect: imported-result authority bleed — the classical theorem is real; the bridge into the
  MFW observation model was not established.
- Corrected: `[CONJ/ADMISSION CONDITION]` — if the admitted investigation model makes EIG
  adaptive monotone and adaptive submodular, adaptive greedy receives the guarantee. The
  Bayesian breed checks the declared observation model's factorization assumptions and emits
  `GREEDY_INVESTIGATION_GUARANTEE_ACTIVE` or `ADAPTIVE_SUBMODULARITY_UNESTABLISHED`. The theorem
  becomes an executable profile capability.

### Correction 8 — Freezing failure is a model rejection, not an estimator verdict

- Original: §15 "a fitted spectrum that fails to linearize at extreme tilts indicates estimator
  artifact, not exotic process physics."
- Defect: the theory granted itself authority to blame the instrument.
- Corrected: under the admitted BRW boundary/freezing model and its validated assumptions
  (A1–A4, boundary normalization, regime stability), failure of the predicted extreme-tilt
  linearization rejects either the estimator or the model; independent estimator validation is
  required before attributing the failure to the process field. The Bramson-correction
  prediction stays model-scoped: `BRW_FRONTIER_CORRECTION_HYPOTHESIS`, spectacularly falsifiable
  and never asserted as "MFW exhibits the Bramson correction."

### Correction 9 — The spine calculus needs the marked offspring kernel

- Original: §14 `∇P(q) = E_{π_q}[X]` with `π_q` the tilted type-transition kernel.
- Defect: `X` is not determined by the type transition `i → j`; a distribution of increments
  rides on each transition.
- Corrected: tilt the marked offspring kernel
  `K_q(i, j, dx) = e^{⟨q,x⟩} v_j(q) K_{ij}(dx) / (ρ(q) v_i(q))`; then `∇P(q) = E_{K_q}[X]`
  under the stationary spine law, and `∇²P(q)` is the Green–Kubo covariance of the resulting
  Markov additive process under the required mixing assumptions.

---

## 3. Failure Modes and Mechanical Preventions

All nine corrections instantiate one defect: a nearby classical result was recognized correctly,
but its standing was transferred to the MFW object before the correspondence map, hypotheses, or
operator identity had been closed. This is the mathematical form of the production-reachability
island: both sides real, the edge between them imaginary.

The five failure modes, each with its prevention (the preventions are law in `AGENTS.md` §4):

1. **Theorem-shape matching** — pattern recognized before the full signature is checked.
   Prevention: theorem cards; no prose inheritance until the card's hypotheses are instantiated.
2. **Generalization drift** — proved on the concrete object, stated on the abstraction.
   Prevention: specialize first (`L = P(Atoms)` before arbitrary lattices); generalize only
   after the concrete proof, by explicit assumption minimization.
3. **Operator conflation** — two operators with the same flavor spoken as one object.
   Prevention: operator identity checks (domain, codomain, composition law, order, observable)
   or an explicit relating morphism, before any "A is B" sentence.
4. **Imported-result authority bleed** — a named classical theorem lends its authority to the
   neighboring MFW sentence. Prevention: unscoped theorem inheritance is banned; the internal
   record is `Hypotheses(Import)(M_MFW) ⇒ Conclusion`, and the hypotheses instance must be
   proved before the prose renders.
5. **Metaphor becoming algebra too early** — an architecture intuition compressed into a formal
   predicate from the wrong dialect (binding → injective). Prevention: predicate namespace
   separation between `Math.*`, `Crypto.*`, `Runtime.*`, and `Evidence.*` predicates, to be
   enforced by a linter (target: `scripts/predicate_namespace_lint.py`, wired into
   `just check`). Until that linter runs green in the release path, separation is reviewer
   discipline only, and the corresponding marker stays blank.

Root cause at the process level: candidate manufacture outran bridge admission
(`d|V|/dt ≫ d|E_admitted|/dt`). The remedy is not slower exploration; it is automated bridge
admission — the edge taxonomy and theorem cards of `AGENTS.md` §4, plus (target, not yet
implemented) GGEN computing claim standing from the graph so that a sentence like "the planner
is the frozen phase" becomes literally unrenderable as a theorem while its correspondence edge
is missing. No such GGEN gate exists today; until it does, the taxonomy is applied by review.

An adversarial mathematics pass must run per section before any freeze, with dedicated roles: the
strongest sentence whose conclusion outruns its hypotheses; every pair of symbols rhetorically
identified without a map; every named import checked against its actual statement; every use of
"exactly", "is", "iff", "equivalent", "therefore", "for free", "by construction" classified.
Those words are the mathematical `unsafe` — each occurrence creates a proof obligation.

---

## 4. Lean Formalization Waves

Lean follows the bridge graph, not the chapter order: the next target is always the
highest-risk, cheapest-to-close bridge. Current order: M0 → M1 → M2 → M3 → M4 → M5.

### Verified environment facts (2026-07-12)

Checked mechanically against the live pinned toolchain, not quoted from memory. Pin:
`procint/lakefile.toml` requires Mathlib at rev `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`;
`lean-toolchain` is `leanprover/lean4:v4.31.0`.

- `Mathlib/Data/Multiset/DershowitzManna.lean` is present in the pinned checkout and already
  compiled (`.olean` exists). It provides `Multiset.IsDershowitzMannaLT` (finite replacement of
  removed elements by strictly smaller elements) and
  `Multiset.wellFounded_isDershowitzMannaLT [WellFoundedLT α]`.
- `grep -rln "nadd\|Hessenberg\|NaturalOps"` over the entire pinned Mathlib tree returns zero
  matches. At this pin there is no `Ordinal.nadd`, no Hessenberg natural sum, and no
  `NaturalOps` module at all.

Consequences: the Dershowitz–Manna route for Crown Descent is `ALIVE` with prebuilt Mathlib
support; the Hessenberg-ordinal route is `BLOCKED_AT_PIN`. Formalize termination directly
through the DM order. The ordinal rank `⊕ ω^{ℓ(o)}` survives only as a derived ranking
interpretation, proved (if at all) after the DM theorem, and only if a natural-sum development
is added or the pin moves. Any doc previously claiming "Mathlib already ships `Ordinal.nadd`"
is corrected by this section.

### Wave M0 — Obligation geometry

Target: `procint/ProcInt/MFW/Residue/{Obligation,EntailmentOrder,MinimalSupport,Antichain}.lean`

Definitions: obligation; admitted obligation preorder; support
(`C(G ∪ S) ⊨ g`); pointwise load-bearing minimality
(`∀ a ∈ S, C(G ∪ (S \ {a})) ⊭ g`); `ρ` as the minimal-support antichain.

Theorems: `residue_supports_goal`, `residue_atoms_load_bearing`
(the combined statement `residue_support_and_pointwise_load_bearing`), `residue_is_antichain`,
`orFree_residue_subsingleton`, and `residue_purity`
(for every minimal supplement `X`, `X ∩ C(c) = ∅` — the LogicalConsequence ≠ WorkflowActivity
law, holding for every minimal supplement with no uniqueness assumption).

No broad crown theorem in this wave.

### Wave M1 — Dershowitz–Manna crown descent

Target: `procint/ProcInt/MFW/Termination/{ObligationRank,MultisetDescent,ManufactureDecrease,
CrownWellFounded}.lean`

The load-bearing side condition is not assumed: `manufacture_children_strictly_descend` (every
admitted decomposition replaces a resolved frontier obligation only with obligations strictly
below it) is the theorem boundary. Then `crown_multiset_strictly_decreases` via
`Multiset.IsDershowitzMannaLT`, then `no_infinite_productive_mfw_chain` via
`Multiset.wellFounded_isDershowitzMannaLT`. The runtime event (remove one socket obligation,
manufacture finitely many strictly-smaller obligations) is a one-step DM descent witness.

### Wave M2 — Free process monad and grafting

Target: `procint/ProcInt/MFW/Workflow/{Signature,Free,SocketSubstitution,Graft,GraftLaws}.lean`

`graft_a(W, W') = μ ∘ T(k_a)(W)` with `k_a` the selective Kleisli substitution. Theorems: unit
at untouched sockets, exact socket replacement, nested associativity,
`graft_commutes_of_socket_independent` (subject to identity freshness and no cross-reference
into the sibling's socket namespace). Correspondence target:
`graft_child_corresponds_to_kleisli_substitution`. The operad presentation is derived from
these laws, not assumed.

### Wave M3 — Recursive crown coalgebra and unique replay

Target: `procint/ProcInt/MFW/{Coalgebra/{CrownFunctor,CrownCoalgebra,Recursive},
Replay/{ReceiptAlgebra,Unique}}.lean`

Order: `crown_coalgebra_wellFounded` → `crown_coalgebra_recursive` → `replay_exists` →
`replay_unique` → `replay_deterministic`. Only then the hylomorphic factorization. Do not call
replay a hylomorphism before the factorization is exhibited.

### Wave M4 — The generic minimal-completion operator

`MinimalCompletion(C, x, A)` — closure operator, target, admissible completion basis —
instantiated three times: planning (`C_semantic, g, A_actions`), abduction
(`C_causal, o, A_hypotheses`), causal identification (`C_do, Q, A_I`). One abstraction, three
instances; a second residue system is a defect.

### Wave M5 — Tropical and spectral runtime mathematics

Gated on real OCEL evidence: `BLOCKED_ON_EVIDENCE` until the measurement rail produces admitted
corpora. Pressure objects, spine calculus (with the marked offspring kernel of Correction 9),
spectra, and the freezing test (Correction 8) come after empirical model admission, not before.
Perron–Frobenius and CKA remain Mathlib gaps to scope before any promise.

---

## 5. Problem Ledger Additions

Carried from Rail B: P1–P12 stand as written there. New:

- **P13 — Planner–Field Tropical Correspondence.** Characterize when the capability-weighted
  PDDL transition operator and the zero-temperature tilted offspring operator are related by a
  cycle-mean-preserving lumping, conjugacy, or quotient. Until discharged, "the planner is the
  frozen phase" is `CONJECTURAL` and unrenderable as a theorem (Correction 6).

Epoch discipline for the field analysis: globally stationary models are presumed false; use
capability-regime epochs `B_0 … B_n` with per-epoch `M_{B_k}(q)`, `P_{B_k}(q)`; prove the
stationary epoch theory before random environments. Keep quenched and annealed pressure
distinct symbols (`P^que_ω`, `P^ann`) from the start. Deordering claims are
`SAFE_CAUSAL_LINK_DEORDERING`, never `MAXIMALLY_CONCURRENT_POWL`. DfCM governs candidate
manufacture; submodularity (where proven) governs candidate selection — diminishing returns is
never imposed on the exploration surface.

---

## 6. Marker Schema

Two kinds of marker, per this doc's own law. **Claim ceilings** assert the *absence* of
standing (a claim may not be stated stronger than the ceiling); they can be declared in prose
because they only ever say less. **Achievement markers** assert standing; their values must be
derived from the artifact they name (Lean build, grep evidence, receipt) by a producer
(target: `scripts/build_spine_markers.py` emitting into `release/standing.env`). No producer
exists yet, so every achievement value below is blank. Filling one by hand is the defect this
document exists to prevent.

Claim ceilings (in force now):

```text
RECEIPT_FOLD_CEILING=COMPUTATIONALLY_BINDING    # never "injective"
PLANNER_IS_FROZEN_PHASE=CONJECTURAL             # until P13 is discharged
ADAPTIVE_SUBMODULARITY=UNESTABLISHED            # until the observation-model check passes
BRW_FRONTIER_CORRECTION=HYPOTHESIS              # model-scoped, falsifiable
POWL_CKA_SCOPE=SERIES_PARALLEL_FRAGMENT
CROWN_I_TO_V=TARGET_THEOREM                     # per section 1; no Lean artifact exists yet
CROWN_RUNTIME=BLOCKED_ON_CORRESPONDENCE         # A10 and correspondence assumptions open
```

Achievement markers (blank until a producer derives them from evidence):

```text
NO_AMBIENT_THEOREM_AUTHORITY_ENFORCED=   # needs predicate_namespace_lint green in release path
MATHLIB_DM_SUPPORT_VERIFIED=             # evidence exists (section 4 grep) but is unwired
HESSENBERG_ROUTE_BLOCKED_AT_PIN=         # evidence exists (section 4 grep) but is unwired
CROWN_ABSTRACT_COMPOSITION=              # target: PROVEN_CONDITIONALLY, once formalized
RECEIPT_FOLD_IMPLEMENTED=                # the domain-separated fold exists nowhere yet
MFW_M0_RESIDUE_FORMALIZED=
MFW_M1_DM_DESCENT_FORMALIZED=
MFW_M2_GRAFT_LAWS_FORMALIZED=
MFW_M3_UNIQUE_REPLAY_FORMALIZED=
MFW_M4_MINIMAL_COMPLETION_UNIFIED=
MFW_M5_FIELD_ANALYSIS=                   # gated on OCEL evidence regardless of producer
```

The two section-4 environment facts (DM support present, Hessenberg absent at pin) are
mechanically true and cited there with their grep commands; their markers above nonetheless
stay blank until the producer re-derives and emits them, so that `standing.env` never contains
a hand-asserted value.

---

## 7. Operational Manufacturing Loop

The spine (section 1) describes what recursive workflow manufacture *is*; this is the target
procedure for what a runtime doing it would execute per unresolved obligation. It is a target,
not a description of code that exists — no step below has a Rust or Erlang implementation
today, and the loop itself carries no achievement marker until one does.

1. **Parse.** Interpret the requested target and its declared claim surface.
2. **Route.** Select the relevant semantic, causal, formal, or production closure.
3. **Admit or refuse.** Convert raw observation `O` into admitted observation `O*` (section 1
   of `CLAUDE_ROADMAP.md`), or issue a typed refusal.
4. **Close.** Compute `C(G)` (Wave M0) and determine what standing already entails.
5. **Diagnose residue.** Compute `ρ(G, g)` (Crown I), preserving every minimal incomparable
   completion as an antichain member.
6. **Select.** Choose a residue element by cost, standing criticality, unlock mass, capability
   shadow price (section 16 of the source review), or `ResearchValue` (below).
7. **Refine.** Decompose the selected obligation into strictly smaller children.
8. **Prove descent.** Verify reduction under the Dershowitz–Manna order (Crown II, Wave M1).
9. **Graft.** Perform free-monad substitution into the selected open socket (Crown III,
   Wave M2).
10. **Type-check composition.** Apply colored-operad admission to the resulting context.
11. **Compile.** Translate external POWL into AIR through an admitted compiler (compile
    adequacy, assumption A10 of the Crown V ledger — currently undischarged).
12. **Execute.** Unfold the workflow coalgebra on the selected runtime (Crown IV, Wave M3).
13. **Actuate.** Permit real-world consequence only through a `REAL_EDGE`
    (`CLAUDE_ROADMAP.md` §10) — never a `TEST_ONLY_EDGE` presented as production-reachable.
14. **Receipt.** Bind inputs, artifact, environment, transitions, outputs, and hashes via the
    canonical fold (Correction 2) — computationally binding, never asserted injective.
15. **Replay.** Reconstruct the unique interpretation authorized by the receipt (Crown IV).
16. **Capitalize.** Return the admitted consequence to the graph through CONSTRUCT.
17. **Repeat.** Recompute closure and residue against the strengthened standing graph.

A research task's priority within step 6 can be computed rather than guessed:

```text
ResearchValue(x) = ΔFormalStanding(x) · ΔRuntimeReachability(x) · ΔDownstreamTheoremClosure(x)
                    / FormalizationCost(x)
```

The multiplicative numerator is deliberate: a theorem with no runtime correspondence adds
formal standing but no reachability; an implementation with no theorem or receipt adds
behavior but no transferable standing; the highest-value target is usually the smallest
closure task that turns several existing real objects into one admitted consequence path —
not an isolated new feature on either side. This is the same value-density shape as the gap
ledger's frontier-edge selection law (`e* = UnlockMass · StandingCriticality · ScenarioCoverage
/ ClosureMass`, `GAP_LEDGER_v26.7.12.md` "Selection law"); the two are the same principle
applied to formalization work and to gap-closing work respectively.

## 8. Claim Status Table

Every load-bearing claim in this document carries one of these standing levels. This table is
the section-6 marker schema restated as prose for quick reference — consult section 6 for the
actual marker names and consult section 2 (Standing Corrections Ledger) before restating any
row below at a stronger level than shown here.

| Claim | Status |
|---|---|
| `O` does not imply `O*` (raw observation ⇏ admission) | Foundational law |
| Generation does not imply standing | Foundational law |
| Correspondence required to cross standing domains | Foundational law |
| Semantic closure extensive/monotone/idempotent | Theorem, scoped to `L = P(Atoms)` |
| Residue is a minimal-support antichain (Crown I) | Target theorem, Wave M0 |
| Strict DM descent bars infinite refinement (Crown II) | Target theorem, Wave M1; DM route |
| Free-monad grafting; independent grafts commute (III) | Target theorem, Wave M2 |
| Recursive coalgebra ⇒ unique replay (Crown IV) | Target theorem, Wave M3, conditional |
| POWL compilation preserves behavior | Undischarged assumption A10 |
| Lean graft corresponds to Rust `graft_child` | Candidate; no `κ` admitted |
| OTP/AtomVM zero behavioral distance | Conditional on declared metric; untested |
| Spectral-pressure calculus (Perron/pressure) | Standing under A1–A4, Wave M5 |
| Planner frozen phase = branching frozen phase | `CONJECTURAL`; P13 is `MISSING_EDGE` |
| Causal identification as closure (Causal Crown) | Target theorem, Wave M4 |
| Autonomous resolution (Crown V) | `PROVEN_CONDITIONALLY` at best; A1–A10 open |

DM route = confirmed available in the pinned Mathlib checkout (section 4). A10 blocks
Corollary 21.2 (Crown Runtime). `κ` is the pending Lean-to-Rust correspondence for grafting.

## 9. Falsification Surface

Same-object falsifiers only (`CLAUDE_ROADMAP.md` §12) — adjacent objections, stylistic
disagreement, or the existence of other workflow systems do not refute any claim here. The
theory fails at a specific boundary if any of the following is exhibited:

- `C` is not extensive, monotone, or idempotent on its declared domain.
- A reported residue element is not minimal (some proper subset still entails the goal).
- A proposition already in `C(G)` is emitted as unfinished work (violates Wave M0's
  `residue_purity`).
- A recursive refinement produces a child not strictly below its parent in the obligation
  order (violates the Crown II side condition, Wave M1).
- The Dershowitz–Manna multiset measure fails to strictly decrease across a manufacture step.
- Grafting violates a free-monad law (unit, associativity — Wave M2).
- Two independent grafts (by the declared independence relation) interfere or fail to commute.
- Typed socket substitution admits a color mismatch the operad forbids.
- The execution coalgebra admits two distinct lawful interpretations for the same admitted
  input (violates Crown IV uniqueness).
- A receipt omits state required to reconstruct the unique interpretation it claims to bind.
- POWL and its compiled AIR produce behaviorally distinct traces for the same admitted input
  (falsifies compile adequacy, assumption A10).
- A Lean graft and a Rust `graft_child` fail the declared equivalence relation once one is
  proposed (falsifies the pending `κ_graft` correspondence, Wave M2's correspondence target).
- A `TEST_ONLY_EDGE` (`CLAUDE_ROADMAP.md` §10) is presented as a `REAL_EDGE` in any claim
  surface, marker, or status doc.
- A proposed repair adds files or tests without increasing reachable crown consequences
  (`Progress ≠ ΔFiles`, `Progress ≠ ΔTests`).
- A spectral-pressure derivative is asserted without its regularity conditions (A1–A4) being
  checked for the specific matrix family in use.
- The planner-frozen-phase claim (Correction 6) is promoted before P13's correspondence map
  `ℒ : A_planner → M_offspring` is constructed and admitted.
