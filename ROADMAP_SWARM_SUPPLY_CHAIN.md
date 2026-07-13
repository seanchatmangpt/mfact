# ROADMAP: Swarm and Supply-Chain Calculus (Spine Extension)

Updated 2026-07-12. Source: an externally-authored "Global AtomVM Swarm" supply-chain calculus
(`# Preserve` / "Yes. The math is now clear.", 649 lines), reviewed in full by six adversarial
lenses (physical-optimization, correspondence-bridges, concurrency-confluence, sheaf-theory,
multifractal-joint, stability-termination). All six lenses read the complete document; this
supersedes an earlier round that produced a roadmap without reading it. The document is not yet
committed to this repository. This roadmap **extends** the mathematical spine
(`ROADMAP_MATH_SPINE.md`) into distributed swarm coordination and physical supply-chain calculus;
it does not replace or supersede that document, and it inherits its discipline in full: no entry
below may be quoted at a stronger standing than its marker, and no imported theorem lends standing
to a swarm-calculus claim until an explicit correspondence morphism is admitted and its
structure-preservation obligations are discharged (`AGENTS.md` §4, the No Ambient Theorem
Authority Law). Related docs: `AGENTS.md` (§4), `ROADMAP_MATH_SPINE.md` (the theorem spine and
its own Standing Corrections Ledger, §2 — the exact prior-art pattern this document follows).

## Quick Reference

1. The Swarm Calculus — six definitions and three theorem targets, each with a standing marker
2. Standing Corrections Ledger — 47 findings from six lenses, deduped to 45 corrections (C1–C45)
3. Lean Formalization Waves S0–S9, cheapest-first, with verified environment facts
4. Problem Ledger Additions — P14–P22, continuing `ROADMAP_MATH_SPINE.md`'s P1–P13
5. Marker Schema (claim ceilings vs. achievement markers)

---

## 1. The Swarm Calculus

Per `AGENTS.md` §2, the source document is legitimately in the Explore phase: it names a coherent
conceptual shape (four planes, per-actor state, stoichiometric flow, causal geometry, three
research rails) before the rigor is filled in. That is not a defect by itself. The defect this
roadmap tracks is claims rendered at Exploit-phase confidence — "boxed:", "therefore", "is",
"mathematically, not metaphorically" — while their hypotheses remain Explore-phase open. Section 2
below is the itemized ledger; this section sorts the calculus into what is a plain naming act
(fine as stated, modulo terminology fixes) versus what is a named target theorem still missing
its hypotheses.

### 1.1 Definitions

**D1 — Four-plane bridge `G --κ_GW--> W --κ_WF--> F --κ_FR--> R`.** Naming four state planes
(admitted semantic state, workflow geometry, physical flow, receipted consequence) is a
DEFINITION with no proof debt by itself. The bridges between them are not: `κ_GW` and `κ_WF` are
given domain/codomain sketches but no preserved-structure clause or admission predicate (edge
type `CORRESPONDENCE`, signature only); `κ_FR` never receives a signature anywhere in the document
despite being named in the headline diagram (edge type `MISSING`). See Corrections C1–C5.

**D2 — Per-actor state `x_i(t) = (G_i, Q_i, I_i, K_i, P_i, R_i)`.** A tuple naming with no
internal proof obligation. DEFINITION, fine as stated. The global state
`X(t) = product_{i in V} x_i(t)` is likewise a DEFINITION (an unconditional product, always
exists) — see Correction C31 for the place this gets silently reused for a different, conditional
object in §10.

**D3 — Stoichiometric ledger recursion `x_{t+1} = x_t + S z_t + B f_t - d_t`.** The recursion
itself is a DEFINITION (a per-node bookkeeping update). The document's own label for it —
"the supply-chain conservation spine" — asserts a conservation property that is never proven: no
incidence property of `B` is stated, and no invariant quantity is ever exhibited. Standing for the
recursion: DEFINITION. Standing for "conservation spine": OVERCLAIM (Correction C6).

**D4 — Delayed transport law
`x_i(t+1) = x_i(t) + S_i z_i(t) - d_i(t) - sum_{out} f_e(t) + sum_{in} f_e(t - l_e)`.** DEFINITION,
conditional on a genesis boundary condition (`f_e(s) := 0` for `s < 0`, or a named exogenous
pipeline vector) that the document never states, without which `x_i(t)` and the
`RESOURCE_CONSERVATION_REFUSED` predicate built on it are undefined for the first `max_e l_e`
steps (Correction C7). Per-edge (not per-edge-per-resource) lead time `l_e` is an unstated
homogeneity assumption (Correction C8).

**D5 — Coalition antichain law `rho_coalition(o) = MinimalAdmissibleCoalitions(o)`.** DEFINITION.
This is the cleanest object in the document: `AdmissibleCoalition(A,o) iff CapabilityCover ∧
ResourceFeasible ∧ TemporalFeasible ∧ TypedComposable` names a monotone closure condition and
asserts its minimal witnesses form an antichain — structurally the same shape as Crown I's
`ρ : State × Goal → Antichain (Finset Obligation)` (`ROADMAP_MATH_SPINE.md` §1, Wave M0). No
finding below is filed against §7 itself; the capability-only special case
(`CapabilityCover` alone, dropping `ResourceFeasible`/`TemporalFeasible`/`TypedComposable`) is
already `theorem minimalCovers_incomparable` in
`procint/ProcInt/Playground/Swarm11/Swarm.lean` (hand-authored, not yet ledgered in
`.mfact/artifacts.toml`, no `sorry`). The full four-conjunct antichain is a THEOREM TARGET, not
yet formalized anywhere (Problem P15).

**D6 — Causal poset `H = (E, prec)`.** DEFINITION of a causality partial order on events
`e = (i, a, t, P, R)`. The document's own name for `H` — "a partially ordered event structure" —
borrows a specific technical object (Winskel event structures: causality order **plus** a
symmetric irreflexive conflict relation, plus, in the standard finitary presentation, a
local-finiteness axiom) neither of which is supplied. Rename "causal poset" until both are added;
`dim_square(X)` is an upper bound on realizable concurrency, not, as claimed, a measurement of
"real global swarm parallelism" (pairwise independence does not imply joint simultaneous
realizability) (Corrections C23–C24).

### 1.2 Theorem Targets

**T1 — Causal-DAG replay theorem** (source §9, "boxed: same admitted causal DAG + deterministic
transitions + independent-step commutation => topological-order-invariant replay"; restated
verbatim in Operationalization as `DeterministicLocalSteps + IndependentStepsCommute +
SameCausalDAG => UniqueGlobalReplay`). Standing: **WELL_POSED_BUT_UNPROVEN**, retitled Target
Theorem 9.1. Missing hypotheses, all named in Corrections C25–C28: (a) `H` restricted to a finite
order ideal, since §1/§5 frame the swarm as perpetual and the classical fact this section leans on
(any two linear extensions of a poset differ by finitely many adjacent transpositions of
incomparable elements) is false in general for infinite posets; (b) a correspondence morphism
`κ : StructuralIndependence (§8, prec-based) → SemanticCommutation (the actual `delta_a`,
`delta_b` agreeing in both orders with enabledness preserved)`, currently asserted by bare
"Suppose"; (c) the local-to-global lifting step itself, which is exactly the shape of Newman's
Lemma (local confluence + termination ⇒ confluence) and is *already proven, abstractly, in this
project's pinned `cslib` dependency* as `LocallyConfluent.Terminating_toConfluent` in
`Cslib/Foundations/Relation/Confluence.lean` — see Wave S7 and Problem P17 for the correspondence
this document would need to admit, not reprove, that lemma; (d) a label-level (not
instance-level) independence relation if the Mazurkiewicz-trace citation is to be kept, or else
the citation is dropped in favor of labeled partial orders / pomsets, which need no such relation.

**T2 — Queue-stability criterion** (source §5, "the perpetual swarm remains queue-stable under
bounded admitted arrival and service conditions"; `sup_t E[|Q(t)|] < infinity`). Standing:
**MISSING_HYPOTHESES**, retitled Target Theorem 5.1. `Terminates(j)` for admitted jobs under
`StrictChildReduction(j)` is real (this is Crown II / Wave M1 of `ROADMAP_MATH_SPINE.md`,
standing `TARGET_THEOREM` there, not re-litigated here) — but the slide from that per-job result
to an aggregate stochastic queue-stability claim supplies zero derivation. Missing, all named in
Corrections C9–C15: a declared probability space and stochastic primitive for `E[.]`; a Lyapunov
function and drift condition (Foster / Meyn–Tweedie shape) rather than a bare inequality; a fixed
symbol for "the queue" (`Q(t)`, `M_global(t)`, `M_j(t)`, and `Q_i` are never identified with one
another); correction of the stated inequality direction (the time-average criterion is implied by,
not stronger than, the sup criterion); and, since sections 3–7 describe a multi-hop, multi-class,
capacitated, dual-decomposition-routed network rather than a single queue, a scheduling/routing
discipline strong enough to rule out the classical multi-class network instability examples
(Kumar–Seidman/Rybko–Stolyar-type) where per-node nominal-load bounds alone are insufficient.

**T3 — Joint multifractal routing spectrum** (source §11, "So the multifractal spectrum becomes
a routing signal. Not metaphorically. Mathematically:" `alpha(x)`, `E_alphavec`,
`pi : alphavec -> CoordinationPolicy`). Standing: **MISSING_HYPOTHESES**, retitled Target Theorem
11.1. This is the one major claim the document itself flags as premature via its own Falsifier
item 9 ("a multifractal routing claim is made before measure and scale correspondences are
admitted") — and then makes anyway, in the same section, without the "boxed:" hedge the document
applies to every other headline claim. Missing, all named in Corrections C39–C45: a box-partition
scheme `B_eps` and a regularity class for `mu` even in the single-measure base case (partially
de-risked — see Wave S9, `procint/ProcInt/Playground/Multifractal/` already carries a `sorry`-free
single-measure `tau(q)`/Legendre/level-set development, hand-authored, unledgered); a pointwise
definition of `alpha_k(x)`; a cross-measure regularity or correlation condition for the joint
partition sum `Z(q_vec, eps) = sum_B product_k mu_k(B)^{q_k}` (no such condition exists for any
measure pair in the repo — genuinely new); the joint Legendre transform from `tau(q_vec)` to a
dimension function on `E_alphavec`; and an actual defining rule for `pi`, which is currently a
bare, uninhabited type signature.

---

## 2. Standing Corrections Ledger

Forty-seven findings were confirmed across the six lenses; two pairs were near-identical across
lenses and are merged below (C1, C16), giving 45 corrections. Each entry: original claim
(quoted or closely paraphrased from the reviewed document, with its section) / defect class /
corrected claim / source lens(es). Prose anywhere in the repository must not restate an original
claim below at its original strength. Ordered by document section, matching the convention of
`ROADMAP_MATH_SPINE.md` §2.

### Fence and Extension (the four-plane bridge and `κ_runtime`) — C1–C5

- **C1** (Extension; merges the correspondence-bridges lens's two closely related findings).
  Original: *"AtomVM is downstream of the calculus"* / *"The theorem surface does not care
  whether an actor is: OTP BEAM; AtomVM; Rust/WASM; edge hardware"*, backed only by
  `kappa_runtime: AbstractActorTransition -> AtomVMTransition`, with no preserved structure named
  — and, unlike the cohomology correspondence of §10 ("candidate-only until we define the actual
  coefficient structure"), no `Fence:` hedge applied to it at all, despite `κ_runtime` having
  strictly less content than the hedged §10 correspondence. Standing: **OVERCLAIM**. Corrected:
  do not assert the universal claim; replace with a theorem card naming domain, codomain, and the
  specific properties claimed preserved (causal order `prec`, determinism, DM ranking,
  independent-step commutativity — the exact three hypotheses Target Theorem 9.1 needs). Standing
  for AtomVM is `BLOCKED_ON_CORRESPONDENCE` for every unlisted property. Apply the same
  `Fence: candidate-only` marker §10 uses. Source: correspondence-bridges.

- **C2** (Fence). Original: *"G --κ_GW--> W --κ_WF--> F --κ_FR--> R ... The bridges are
  explicit."* `κ_FR` is named in the headline diagram and never receives a signature, an example,
  or any further mention anywhere in the document, including the Operationalization file list.
  Standing: **OVERCLAIM** — "the bridges are explicit" is false for at least one of the three
  bridges it introduces. Corrected: either supply `κ_FR`'s domain/codomain and preserved structure
  (e.g. `κ_FR : PhysicalTransition -> ReceiptEvent`, preserving the §3/§4 conservation law) or mark
  the F→R edge `MISSING` per `AGENTS.md` §4's edge taxonomy. Source: correspondence-bridges.

- **C3** (Fence). Original: `κ_GW : SemanticResidue -> WorkflowObligation`,
  `κ_WF : WorkflowAction -> PhysicalTransition`, both hedged "for example" (illustrative, not
  formal), neither stating what structure is preserved nor what predicate makes an instance
  "admitted" — yet the section's entire boundary claim ("WorkflowStanding does NOT imply
  PhysicalConsequence without admitted actuation correspondence") rests on that undefined word.
  Standing: **WELL_POSED_BUT_UNPROVEN**. Corrected: name the admission predicate explicitly (e.g.
  "`κ_WF` is admitted iff the resulting transition satisfies the §3 stoichiometric law and the §4
  delayed-transport law") and state what is preserved. Source: correspondence-bridges.

- **C4** (Extension). Original: `kappa_runtime: AbstractActorTransition -> AtomVMTransition`.
  `AbstractActorTransition` is not a term used anywhere else in the document — not matching `G`,
  `W`, `F`, `R` (Fence) nor `x_i`, `O_i`, `A_i`, `z_t`, `f_t`, `e`, `H`, `P_i` (Calculus) — so it
  is impossible to check which earlier boxed claims `κ_runtime` is meant to transport. Standing:
  **CONFLATION**. Corrected: identify `AbstractActorTransition` with a specific already-defined
  object (e.g. "`:= the local-step relation δ on H from §8`") before invoking Target Theorem 9.1
  or Crown-shaped descent on AtomVM through it. Source: correspondence-bridges.

- **C5** (Fence / §4 / §7). Original: `κ_GW : SemanticResidue -> WorkflowObligation` (singular
  codomain) versus §4's `rho(G,g) = {...}` and §7's
  `rho_coalition(o) = MinimalAdmissibleCoalitions(o)` (both antichain-typed). No map reconciles
  the singular codomain with the antichain typing used
  everywhere else the document produces obligations. `ROADMAP_MATH_SPINE.md` Crown I already flags
  precisely this defect for its own residue operator ("typed as `ρ : State × Goal → Antichain
  (Finset Obligation)` not as a single residue state"); the Fence section's `κ_GW` example reverts
  to exactly that already-corrected typing. Standing: **CONFLATION**. Corrected: type `κ_GW` as
  `SemanticResidue -> Antichain(WorkflowObligation)`, matching D1/D5 above and Crown I. Source:
  correspondence-bridges.

### Stoichiometric conservation and delayed transport (§3–§4) — C6–C8

- **C6** (§3). Original: *"x_{t+1} = x_t + S z_t + B f_t - d_t. This is the supply-chain
  conservation spine."* No property of `B` is stated, and §4's own refinement shows outgoing flow
  is deducted from the sender at departure while credited to the receiver only after `l_e`
  periods — so shipped quantity is not represented anywhere in `X(t)` while in transit, and
  `sum_i x_i(t)` is not invariant as claimed. Standing: **OVERCLAIM**. Corrected: demote the bare
  recursion to a DEFINITION (D3 above) with no conservation claim, or state and prove
  `sum_i x_i(t) + sum_e T_e(t)` invariant, with `T_e(t) = sum_{s=t-l_e+1}^{t} f_e(s)` the
  in-flight pipeline stock and `B` shown to satisfy a stated incidence property. Source:
  physical-optimization.

- **C7** (§3 / §4). Original: §3's `RESOURCE_CONSERVATION_REFUSED` is defined against the
  instantaneous-transport law and never re-derived for §4's delayed law
  `x_i(t+1) = x_i(t) + S_i z_i(t) - d_i(t) - sum_out f_e(t) + sum_in f_e(t - l_e)`. For
  `t < max_e l_e`, `f_e(t - l_e)` references time before swarm genesis with no boundary condition
  stated. Standing: **MISSING_HYPOTHESES**. Corrected: add `f_e(s) := 0` for `s < 0` (or a named
  exogenous genesis pipeline vector), then restate the refusal predicate over the
  currently-decidable variables (`z_i(t)`, `{f_e(t)}_{out(i)}`) holding the already-committed
  historical inflow fixed, so admission is decidable at time `t` using only data available at `t`.
  Source: physical-optimization.

- **C8** (§4). Original: *"For logistics edge e, let: l_e in N be lead time."* A single scalar per
  edge silently assumes every resource type transported on `e` shares one transit delay — never
  stated as an assumption, and unrealistic for perishable versus bulk cargo on the same link.
  Standing: **MISSING_HYPOTHESES**. Corrected: index as `l_{e,k}` (per edge, per resource type) or
  explicitly name and scope the homogeneous-transit-time simplification. Source:
  physical-optimization.

### Recursive termination versus swarm stability (§5) — C9–C15

- **C9** (§5). Original: *"Your Dershowitz-Manna rail applies locally ... Therefore:
  JobAdmitted(j) and StrictChildReduction(j) => Terminates(j). But globally: M_global(t) may
  increase ... So global health is instead: sup_t E[|Q(t)|] < infinity ... This is the right crown
  theorem shape."* A real per-job DM-descent result (Wave M1 of `ROADMAP_MATH_SPINE.md`) is
  connected by pure prose ("Therefore... But... So...") to an unestablished aggregate stochastic
  claim, with no Lyapunov function, no drift inequality, and no correspondence map from
  `{M_j(t)}_j` to `Q(t)`. Standing: **MISSING_HYPOTHESES**. Corrected: keep `Terminates(j)` as its
  own `PROVEN` (Wave M1) statement; state `SwarmQueueStable` (Target Theorem 5.1, T2 above)
  separately with an explicit Lyapunov function `V` and drift condition
  `E[V(X(t+1)) - V(X(t)) | X(t)] <= -eps + b*1_{finite set}(X(t))`. Source: stability-termination.

- **C10** (§5). Original: `sup_t E[|Q(t)|] < infinity`. `E[.]` appears for the first time here
  with no probability space, filtration, or stochastic primitive ever declared; every prior state
  object (§1, §3, §4) is deterministic, and `d_t` is never declared random. Standing:
  **MISSING_HYPOTHESES**. Corrected: name the stochastic primitive explicitly (e.g. "admitted
  demand arrivals `{d_t}` form a stochastic process of class X") before any expectation-valued
  criterion is stated; otherwise the criterion collapses to (still-unproven) deterministic
  boundedness. Source: stability-termination.

- **C11** (§5). Original: *"That is a queue stability condition. A stronger long-run criterion
  is: limsup_T (1/T) sum_{t<T} E[|Q(t)|] < infinity."* The direction is backwards:
  `sup_t E[|Q(t)|] < infinity` implies the Cesàro/time-average bound, not the reverse (a process
  with `E[Q(t)] = sqrt(t)` on perfect squares and `0` elsewhere has unbounded sup but bounded
  Cesàro average). This is the standard distinction between "uniformly bounded in expectation" and
  Neely-style "strong stability." Standing: **OVERCLAIM**. Corrected: state the correct
  implication direction; if a weaker fallback criterion was intended, label it "a weaker,
  easier-to-establish long-run criterion," not "stronger." Source: stability-termination.

- **C12** (§1 / §5). Original: `Q_i` (§1's per-actor obligation multiset), `M_j(t)` (§5's
  per-job open obligations), `M_global(t)` (§5, no formula given), and `Q(t)` (used in the
  stability criteria) are four distinct symbols for obligation/queue quantities, never identified
  with one another. Standing: **CONFLATION**. Corrected: fix one object of record, e.g.
  `Q(t) := sum_i |Q_i(t)|`, state it equals `M_global(t)`, and use one symbol consistently; state
  whether the claim concerns this scalar or a per-resource-type vector (§1's `I_i`, §3's `x_t` are
  `m`-dimensional). Source: stability-termination.

- **C13** (§5, cross-referencing §3, §4, §6, §7). Original: *"the perpetual swarm remains
  queue-stable under bounded admitted arrival and service conditions."* The described system is a
  multi-hop, multi-class, capacitated, delay-laden network with dual-decomposition routing (§6)
  and ad hoc coalition formation (§7) — not a single queue. Bounded per-node nominal utilization is
  known, classically, to be insufficient for network-wide stability once non-trivial
  routing/scheduling is present (Kumar–Seidman/Rybko–Stolyar-type instability under certain
  disciplines despite every station's nominal load below 1). Standing: **MISSING_HYPOTHESES**.
  Corrected: either restrict to the single-queue case (whose classical analogue is Loynes' G/G/1
  criterion) or state a fluid-limit Lyapunov condition and the specific scheduling discipline under
  which network-wide stability is claimed (Dai-1995 shape). Source: stability-termination.

- **C14** (§5). Original: *"That is much stronger and more accurate than 'the workflow
  terminates.'"* `Terminates(j)` (deterministic, per-object, `PROVEN` at Wave M1) and
  `SwarmQueueStable` (statistical, aggregate, unestablished per C9–C13) are different logical
  types placed on one ordering; neither implies the other (every job can DM-descend to empty while
  the aggregate queue is unstable — precisely what the document's own preceding sentence,
  "`M_global(t)` may increase because new demand arrives," already says). Standing:
  **CONFLATION**. Corrected: drop the comparative framing; state both as logically independent,
  matching the document's own Exclusions-section discipline ("job termination != swarm
  termination") instead of contradicting it in the adjacent sentence. Source: stability-termination.

- **C15** (Preserve, opening claim). Original: *"We prove: for all o in AdmittedJobs,
  Refinement(o) is well-founded, while requiring the global field to be stable, viable, and
  recurrent."* "Recurrent" is a precise Markov-chain term (e.g. positive Harris recurrence) never
  mentioned again; "viable" is never defined at all. Only "stable" receives any later content
  (§5), and even that is unproven (C9–C13). Standing: **MISSING_HYPOTHESES**. Corrected: define
  "recurrent" and "viable" with the same rigor attempted for "stable," each with its own drift or
  forward-invariance condition and Falsifier item, or drop them from the opening claim until they
  do. Source: stability-termination.

### Distributed coordination as dual decomposition (§6) — C16–C22

- **C16** (§6; merges the near-identical findings from physical-optimization and
  stability-termination). Original: `z_i^{k+1} = argmin_{z_i} L_i(z_i, lambda^k)`;
  `lambda^{k+1} = lambda^k + eta*(demand - supply)`; "No central scheduler needs to enumerate
  every global plan," stated as an achieved property. No convexity/closedness/properness of
  `c_i`, `tau_e`, `Shortage`, `Risk`; no constraint qualification or saddle-point existence
  argument; no stepsize regime for `eta` — the standard prerequisites for subgradient/dual-ascent
  convergence — appear anywhere, and Falsifier item 8 ("unbounded queue growth under the claimed
  operating assumptions") is consequently not checkable, since those assumptions are never
  enumerated. Standing: **OVERCLAIM**. Corrected: restate as a conditional target theorem naming
  every hypothesis above; until discharged, standing is `CONJECTURAL`/`TARGET_THEOREM`, not an
  operating property of the swarm. Sources: physical-optimization, stability-termination.

- **C17** (§6). Original: *"Interpretation: shortages increase shadow price; excess inventory
  decreases shadow price."* This is only an algebraic consequence of the one specific, unprojected
  update rule written down (`eta` never even signed positive); calling `lambda_{i,p}` a "shadow
  price" additionally borrows the classical LP-sensitivity theorem, which itself needs convexity
  plus a constraint qualification (see C16). No nonnegativity projection is specified for what
  should be an inequality-constraint multiplier, so under sustained oversupply the "price" could
  drift negative without bound. Standing: **CONFLATION**. Corrected: separate (a) the DEFINITION
  that `lambda` is monotone in `(demand - supply)` by construction (true by arithmetic alone) from
  (b) the TARGET_THEOREM that it converges to a marginal-value shadow price, provable only once
  convexity, a constraint qualification, and a nonnegativity projection are added. Source:
  physical-optimization.

- **C18** (§3 / §6). Original: §3's `RESOURCE_CONSERVATION_REFUSED` treats insufficiency as a
  hard, binary, always-blocking refusal; §6's `J(z,f) = ... + lambda_s*Shortage + ...` treats
  "Shortage" as a continuous, always-computable soft penalty. "Shortage" is never defined in terms
  connecting it to the refusal, so it is unstated whether the two notions of "not enough resource"
  ever coincide. Standing: **CONFLATION**. Corrected: define `Shortage` explicitly, e.g. via an
  elastic-demand curtailment operator `d_t' = min(d_t, servable)` with
  `Shortage_t := d_t - d_t' >= 0`, computed only after admissible curtailment and never itself
  producing `x_{t+1} < 0`, before "shortages increase shadow price" can describe the same shortage
  that triggers refusal. Source: physical-optimization.

- **C19** (§6). Original: *"Each AtomVM actor can solve a local problem:
  z_i^{k+1} = argmin_{z_i} L_i(z_i, lambda^k)."* This decomposition is exhibited only for the
  node-local variable `z_i`; the flow variable `f_e` is shared between two actors per edge with no
  local subproblem, edge-ownership rule, or variable-splitting/consensus step (the actual ADMM
  machinery for shared variables) given. Standing: **MISSING_HYPOTHESES**. Corrected: designate
  one endpoint as owner of `f_e`'s subproblem with an explicit rule, or introduce consensus
  variables `f_e^{(i)}`, `f_e^{(j)}` with an augmented-Lagrangian penalty, and state the
  convexity conditions under which that update converges. Source: physical-optimization.

- **C20** (§6). Original: *"...subject to conservation and capacity"* followed by a displayed
  constraint showing only conservation; the §3 capacity bounds (`0 <= z_t <= z_bar_t`,
  `0 <= f_t <= f_bar_t`) never reappear. Compactness of the feasible region (typically supplied by
  capacity bounds) is a standard ingredient for saddle-point existence, so its silent omission
  leaves the existence question needed by C16 unaddressed. Standing: **MISSING_HYPOTHESES**.
  Corrected: restate §6's program with the full constraint set (`0 <= z_t <= z_bar_t`,
  `0 <= f_t <= f_bar_t`, `x_t >= 0`, plus conservation, indexed over the actual horizon), and note
  which of these existence relies on. Source: physical-optimization.

- **C21** (§6). Original: *"The global optimization is: min_{z,f} J(z,f) subject to:
  x_{t+1} = x_t + Sz + Bf - d."* `z`, `f` drop the time subscripts used everywhere else, the
  constraint is written for a single unspecified `t` despite §1's "perpetual operation" framing,
  and `Shortage`/`Risk` inside `J` are used without definition (what quantity, what horizon,
  deterministic or stochastic). Standing: **WELL_POSED_BUT_UNPROVEN**. Corrected: specify
  receding-horizon versus fixed-horizon batch form, index the constraint over the chosen horizon,
  and define `Shortage_t`, `Risk_t` explicitly (e.g. via C18) before any solution property is
  claimed. Source: physical-optimization.

- **C22** (§6). Original: `J(z,f) = ... + lambda_s*Shortage + lambda_r*Risk` (fixed scalar
  weights) versus `lambda_{i,p}` (iteratively updated dual price). Reusing `lambda` for both
  leaves it ambiguous whether `Shortage`/`Risk` are themselves dualized or are separate hard-coded
  penalties. Standing: **CONFLATION**. Corrected: use distinct symbols (`mu_s`, `mu_r` for fixed
  penalty weights versus `lambda_{i,p}` for the iterated dual price), and state which terms of `J`
  sit inside the dualized `L_i` each local `argmin` solves. Source: physical-optimization.

### Causal event geometry (§8) — C23–C24

- **C23** (§8). Original: *"H = (E, prec) a partially ordered event structure."* "Event
  structure" is a specific technical object (Winskel): causality order plus a symmetric
  irreflexive conflict relation, plus, in the standard finitary presentation, a local-finiteness
  axiom (every event has finitely many causal predecessors). Only the causality order is defined;
  neither the conflict relation (which §4's residue antichains and §7's coalition antichains would
  need to represent at the event level) nor local finiteness (load-bearing for T1/C25) is stated.
  Standing: **DEFINITION** (naming fix required, not a proof debt). Corrected: rename "causal
  poset" or "dependence DAG," or, if event structures are intended, add the conflict relation
  `# ⊆ E × E` and local finiteness `∀e, {e' : e' prec e}` finite. Source: concurrency-confluence.

- **C24** (§8). Original: *"dim_square(X) = max{|A| : A ⊆ enabled(X), A pairwise independent}.
  That measures real global swarm parallelism."* Pairwise independence of every two elements of
  `A` does not guarantee joint/simultaneous realizability of all of `A` as one concurrent step.
  Standing: **OVERCLAIM**. Corrected: state `dim_square(X)` as an upper bound on realizable
  concurrency; assert equality only once a joint (not merely pairwise) consistency condition is
  proved from the admission machinery of §2–§3. This mirrors `ROADMAP_MATH_SPINE.md`'s own
  Correction 6 pattern: two structurally resembling notions (there: tropicalizing operators; here:
  pairwise versus joint independence) treated as one without an admitted correspondence. Source:
  concurrency-confluence.

### Replay by confluence, not serialization (§9) — C25–C28

- **C25** (§9). Original: boxed: `same admitted causal DAG + deterministic transitions +
  independent-step commutation => topological-order-invariant replay`. No finiteness or
  well-foundedness of `H` is stated, yet §1 says the swarm "should not terminate" and §5 says
  `M_global(t)` "may increase." The classical fact this leans on (any two linear extensions of a
  poset differ by finitely many adjacent transpositions of incomparable elements) is standard for
  *finite* posets and false in general for infinite ones. Standing: **MISSING_HYPOTHESES**.
  Corrected: restrict to a finite causal prefix / finite downward-closed order ideal of `H`, or add
  local finiteness plus an explicit compactness/inverse-limit argument extending finite-prefix
  invariance to the perpetual limit. Retitled Target Theorem 9.1 (T1 above), scoped to
  `FiniteCausalPrefix(H)`. Source: concurrency-confluence.

- **C26** (§9). Original: *"Suppose independent transitions commute: a I b =>
  delta_b(delta_a(x)) = delta_a(delta_b(x))."* This conflates the structural independence of §8
  (graph-theoretic, `prec`-based) with semantic commutation of the actual runtime transition
  functions applied to a concrete state; it also asserts only result-equality, not that
  enabledness is preserved in both orders. The document's own Falsifier items 2 and 5 concede this
  can concretely fail (shared inventory contention without a `prec` edge). Standing:
  **CONFLATION**. Corrected: name `StructuralIndependence(a,b)` and `SemanticCommutation(a,b)`
  separately; state and discharge (or admit as a separately falsifiable axiom) a correspondence
  `κ : StructuralIndependence => SemanticCommutation`, derived from §3's stoichiometric disjointness
  (independent events touch disjoint rows of `S`/disjoint inventory). Source:
  concurrency-confluence.

- **C27** (§9). Original: *"Then two linear extensions of the same causal DAG differ only by
  swaps of independent adjacent events. By repeated commutation: Replay(L1) = Replay(L2).
  Therefore: boxed: ..."* This is structurally Newman's Lemma / the Diamond Lemma's local-to-global
  step: pairwise adjacent commutation is local confluence, and lifting it to global confluence
  classically requires a termination/well-founded-measure argument (the well-founded measure here
  would be inversion count between `L1`, `L2`, finite only if `H` is finite — see C25). This
  exact lifting is already proven, abstractly, in this project's pinned `cslib` dependency as
  `LocallyConfluent.Terminating_toConfluent` (`Cslib/Foundations/Relation/Confluence.lean`).
  Standing: **OVERCLAIM** for "Therefore: boxed" as an already-discharged step; the correspondence
  into `cslib`'s theorem is Problem P17, not a reproof from scratch. Corrected: rewrite as
  "Target Theorem 9.1: given (a) [C25], (b) [C26], and (c) determinism of each `delta_a`, admit a
  correspondence into `LocallyConfluent.Terminating_toConfluent` and conclude
  `Replay(L1) = Replay(L2)`. Standing: `WELL_POSED_BUT_UNPROVEN` pending (a), (b), and the
  correspondence." Move the "huge theorem target" framing to precede, not follow, the boxed
  statement. Source: concurrency-confluence.

- **C28** (§9). Original: *"It connects: Mazurkiewicz traces; event structures; confluence;
  partial orders; receipts; replay."* Mazurkiewicz trace equivalence is defined over a fixed
  alphabet with a static, symmetric independence relation declared once at the label level; this
  document's independence is dynamic and instance-level (the same pair of action types can be
  independent in one execution and dependent in another, per C26). No correspondence from the
  instance-level notion to the classical alphabet-level relation is exhibited. Standing:
  **CONFLATION**. Corrected: either exhibit a fixed, label-level independence relation (e.g.
  derived from §3's stoichiometric matrix `S` — action types touching disjoint rows are
  unconditionally independent) and prove the runtime `prec`-DAG never contradicts it, or drop the
  Mazurkiewicz-trace citation in favor of labeled partial orders / pomsets, which need no static
  independence relation. Source: concurrency-confluence.

### Sheaf model for local knowledge (§10) — C29–C38

- **C29** (§10). Original: *"Let U_i be the region of the supply network visible to actor
  i ... F(U_i) = admitted supply-chain states visible on U_i ... restriction maps
  rho_{i,ij} : F(U_i) -> F(U_i ∩ U_j)."* No topological space, category of opens, or Grothendieck
  site is ever constructed; "region," "restriction map," and later "gluing"/"global section" are
  applied by structural resemblance, not by exhibiting the site `F` is a presheaf/sheaf on.
  Standing: **CONFLATION**. Corrected: name the actual site — a topological space `X` (built from
  the logistics graph `L`?) with `Open(X)` as index category, or a Grothendieck site `(C, J)` with
  an explicit stable, transitive coverage — before "presheaf"/"sheaf" is used; until then, relabel
  as an indexed family of local state-sets with pairwise comparison maps. Source: sheaf-theory.

- **C30** (§10). Original: `F` is defined only at `F(U_i)` and pairwise `F(U_i ∩ U_j)`, then used
  at `F(union_i U_i)` as if already defined there. A presheaf must assign a value to every object
  of the index category with `rho_{U,U} = id` and transitive composition; neither functoriality nor
  the general-union case is stated. Standing: **MISSING_HYPOTHESES**. Corrected: state `F` as an
  actual functor `Open(X)^op -> Set` (or site-appropriate target), define it on arbitrary
  unions/intersections, and verify identity and composition of restriction. Source: sheaf-theory.

- **C31** (§1 / §10). Original: §1's `X(t) = product_i x_i(t)` (unconditional product, always
  exists) and §10's boxed `global swarm truth = gluing compatible admitted local sections`
  (`x in F(union_i U_i)`, exists only if gluing holds) are both informally called "the global
  state" with no admitted correspondence between `x_i(t)` and `F(U_i)`. Standing: **CONFLATION**.
  Corrected: exhibit `π_i : (state space of x_i(t)) -> F(U_i)` and its properties, then reconcile
  "global swarm truth" with `X(t)` as a theorem ("`X(t)` glues to a section of `F` iff
  [conditions]"), not as two boxed definitions sharing a name. Source: sheaf-theory.

- **C32** (§10). Original: *"If every overlapping local state agrees and the gluing law holds,
  the local states define a global section."* "The gluing law holds" is stated as an assumable
  premise, not derived or checked for this specific `F` (the sheaf gluing axiom holds for some
  presheaves and famously fails for others, e.g. presheaves of bounded or constant functions).
  Standing: **OVERCLAIM**. Corrected: either prove the gluing axiom for this `F` by exhibiting the
  actual combination operation on `F(U_i ∪ U_j)`, or state "IF `F` satisfies gluing (unverified)
  THEN..." and mark the whole construction `WELL_POSED_BUT_UNPROVEN`. Source: sheaf-theory.

- **C33** (§10). Original: the section states an "agree ⇒ glue" *existence* condition and never
  requires *uniqueness* (separatedness: `F(U) -> product_i F(U_i)` injective). Standing:
  **MISSING_HYPOTHESES**. Corrected: state and require separatedness explicitly, without which
  "`x in F(union_i U_i)`" names an element but not the canonical, unique consequence later sections
  (e.g. §9 replay uniqueness) presumably want to rely on. Source: sheaf-theory.

- **C34** (§10). Original: *"d_{ij} = rho_{i,ij}(x_i) - rho_{j,ij}(x_j) (informally, as a defect
  indicator, not literal subtraction)."* The document's own parenthetical concedes the `-` is not
  literal subtraction but never supplies what it actually is — no group, poset, or even a stated
  equality relation is given for `F(U_i ∩ U_j)`, so "nonzero" has no defined meaning. This gap sits
  one level below the cohomology leap the section's own Fence hedges; the Fence therefore does not
  reach far enough. Standing: **MISSING_HYPOTHESES**. Corrected: specify the codomain structure of
  `F(U_i ∩ U_j)` before naming `SheafResidue` — a boolean indicator if `F` is `Set`-valued, or a
  redefinition of `F` as abelian-group-valued (stated as a hypothesis change) if a genuine additive
  defect is intended. Source: sheaf-theory.

- **C35** (§10). Original: *"nontrivial cohomological obstruction leads to global coordination
  hole,"* hedged only by "Fence: the cohomology correspondence is candidate-only until we define
  the actual coefficient structure and prove the gluing interpretation." Classical Čech-cohomology
  obstruction theory additionally needs a cocycle consistency check on triple overlaps
  `U_i ∩ U_j ∩ U_k`, never introduced; the stated Fence covers only the coefficient-structure gap,
  not this one. Standing: **MISSING_HYPOTHESES**. Corrected: state and verify the cocycle condition
  on triple overlaps before any obstruction language is used, even informally; widen the Fence text
  to name both gaps. Source: sheaf-theory.

- **C36** (§10). Original: boxed: `global swarm truth = gluing compatible admitted local
  sections`. Presented as the section's headline claim, it directly inherits the unproven "gluing
  law holds" premise of C32. Standing: **OVERCLAIM**. Corrected: re-tag as DEFINITION (a stipulated
  meaning for the phrase), not a boxed headline claim: "global swarm truth is DEFINED to be a
  glued section, when one exists and is unique" — with existence/uniqueness carried as the open
  obligations of C32/C33. Source: sheaf-theory.

- **C37** (§10). Original: *"I would call this: SheafResidue. And potentially: nontrivial
  cohomological obstruction leads to global coordination hole."* A pure naming act (DEFINITION)
  and a speculative structural claim are stated in the same breath with no standing marker
  separating them, exactly the pattern `ROADMAP_MATH_SPINE.md` §2 Correction 7's
  `[CONJ/ADMISSION CONDITION]` tagging exists to prevent. Standing: **OVERCLAIM**. Corrected:
  split into "DEFINITION: `SheafResidue := {d_{ij}}`" (fine once C34 is fixed) and "CONJECTURAL:
  `SheafResidue` nontriviality corresponds to a cohomological obstruction — unproven, blocked on
  C34 and C35." Source: sheaf-theory.

- **C38** (§10 vs §2). Original: `U_i` glossed as "the region of the supply network visible to
  actor i" (§10) versus §2's `O_i(t)`, "each actor receives partial observation `O_i(t)`," with its
  own admission machinery `a_i : O_i -> O_i* ∪ Refusal`. §10 never states whether `U_i` is a
  subset of a physical/logistics space, a relabeling of `O_i(t)`, or a third object, and if the
  latter, whether the sheaf machinery should be checked against admitted (`O_i*`) rather than raw
  observations. Standing: **CONFLATION**. Corrected: pick one — an explicit region of a stated
  topological space independent of the observation model, with a stated sampling map from `O_i(t)`,
  or `U_i := support of O_i*(t)` directly, inheriting §2's admission machinery. Source:
  sheaf-theory.

### Multifractal supply-chain field (§11) — C39–C45

- **C39** (§11). Original: *"So the multifractal spectrum becomes a routing signal. Not
  metaphorically. Mathematically:"* This directly contradicts the document's own Exclusions clause
  ("finite moment signature != multifractal formalism theorem") and its own Falsifier item 9 ("a
  multifractal routing claim is made before measure and scale correspondences are admitted") — no
  measure/scale correspondence is ever admitted in this section, and it is the only major claim not
  carrying the document's own "boxed:" hedge despite the strongest rhetorical insistence of any
  headline claim in the piece. Standing: **OVERCLAIM**. Corrected: remove "not metaphorically...
  mathematically"; relabel as Target Theorem 11.1 (T3 above) pending C40–C45. Source:
  multifractal-joint.

- **C40** (§11). Original: `alpha(x) = (alpha_W(x), alpha_I(x), alpha_R(x), alpha_L(x))`. First
  appearance of `alpha` anywhere in the document; no per-measure pointwise singularity/Hölder
  exponent `alpha_k(x) = lim_{eps->0} log mu_k(B_eps(x))/log eps` is ever defined, and existence of
  that limit is not automatic for a general measure — it requires the measure to be
  exact-dimensional or satisfy a stated regularity class. Standing: **DEFINITION** (missing, not
  yet supplied). Corrected: define `alpha_k(x)` explicitly, state the box-shrinking regime, and
  name the regularity class under which the limit exists. Source: multifractal-joint.

- **C41** (§11). Original: `Z(q_vec, eps) = sum_B product_{k=1}^m mu_k(B)^{q_k}`, presented as the
  direct generalization of the single-measure `Z(q,eps)`. A product of marginal box-values summed
  over one shared partition does not inherit marginal scaling behavior for free; it needs an
  explicit cross-measure condition (independence, bounded correlation, joint bounded distortion)
  that is never stated — especially implausible here since `mu_W`, `mu_I`, `mu_R`, `mu_L` are
  different functionals of the same co-located swarm activity. Standing: **CONFLATION**.
  Corrected: state an explicit cross-measure regularity/correlation condition before treating
  `tau(q_vec)` as inheriting anything from the marginal existence arguments. Source:
  multifractal-joint.

- **C42** (§11). Original: `pi : alphavec -> CoordinationPolicy`, "A swarm policy can route by
  singularity class." A bare type signature: `CoordinationPolicy` is never defined as a type, and
  no rule, formula, or recipe computes `pi(alphavec)`. Per `AGENTS.md` §1, a declared signature
  with no defining rule and an undefined codomain is not a construction. Standing: **OVERCLAIM**.
  Corrected: exhibit an actual map (even a toy formula on synthetic `alphavec`) with a stated
  property (measurability, monotonicity, Lipschitz), or relabel as a target/example sketch rather
  than an accomplished capability. Source: multifractal-joint.

- **C43** (§11). Original: `Z(q, eps) = sum_B mu(B)^q`; `tau(q) = liminf_{eps->0} log
  Z(q,eps)/log eps`. Even the single-measure base case is under-specified: the box-partition
  scheme `B_eps` (dyadic grid vs. arbitrary net vs. cell shape all change `tau(q)`) is never
  defined, and no regularity class (self-similarity, Gibbs, doubling/bounded distortion) is stated
  for `mu` — the actual prerequisite for `tau(q)` to be concave/differentiable, itself the
  prerequisite for a meaningful Legendre-dual `alpha(x)`. Standing: **MISSING_HYPOTHESES**.
  Corrected: define `B_eps` precisely and state a regularity class under which `tau(q)` exists as
  an actual limit and is concave, before introducing any Legendre-dual `alpha(x)`. Partially
  de-risked: `procint/ProcInt/Playground/Multifractal/{PartitionFunction,Legendre,LevelSet,
  Scale,...}.lean` already carry a `sorry`-free single-measure development (hand-authored,
  unledgered) that could supply this regularity discipline once ported. Source: multifractal-joint.

- **C44** (§11). Original: `E_alphavec = {x : alpha(x) = alphavec}`. Presupposes `alpha(x)` is
  well-defined pointwise (per C40, it is not even defined); the actual content of a multifractal
  spectrum — the map `alphavec -> dim_H(E_alphavec)`, i.e. the joint Legendre transform of
  `tau(q_vec)` — is never written down anywhere in §11. Standing: **MISSING_HYPOTHESES**.
  Corrected: after discharging C40/C41, state and sketch the joint Legendre transform connecting
  `tau(q_vec)` to a dimension function on `E_alphavec`, including the convexity/differentiability
  conditions a multivariate Legendre transform requires. Source: multifractal-joint.

- **C45** (§11). Original: `mu_W(B) = (workflow obligations in B) / (global workflow mass)`, and
  `mu_I`, `mu_R`, `mu_L` analogously. As literally defined these are ratios of finite physical
  counts to global totals — finite atomic (counting-type) measures over a real, finite swarm, not
  continuous singular measures. Classical multifractal scaling is an `eps -> 0` asymptotic
  statement that degenerates once box size drops below minimum inter-object spacing, unless a
  continuum/large-swarm limiting regime or a specific singular-generating process is specified;
  neither is stated. Standing: **MISSING_HYPOTHESES**. Corrected: state explicitly whether the
  claim is a continuum-limit asymptotic (naming the generating process) or a finite-size empirical
  regime (naming the box-size range and acknowledging degeneracy below minimum spacing). Source:
  multifractal-joint.

---

## 3. Lean Formalization Waves

Cheapest-first, mirroring `ROADMAP_MATH_SPINE.md` §4: the next target is always the highest-value,
lowest-risk bridge, not chapter order. Waves S0–S2 port or lean on material that already exists in
this repository (Playground scaffolding, unledgered) or in a pinned upstream dependency; S3–S5
build genuinely new but concrete objects; S6–S9 are gated on the Standing Corrections Ledger fixes
they depend on and are ordered last, per instruction, with sheaf and joint-multifractal rails last
of all.

### Verified environment facts (2026-07-12)

Checked mechanically against the live checkout, not quoted from memory, per `AGENTS.md` §4's
"verify against the live environment" rule.

- None of the 27 modules the source document's Operationalization section proposes exist yet.
  Verified by `find /Users/sac/mfact/procint/ProcInt/Swarm`,
  `find /Users/sac/mfact/procint/ProcInt/Supply`, `.../Coordination`, `.../Sheaf`,
  `.../SwarmMultifractal`, and `.../Correspondence` (all six directories: "No such file or
  directory"), plus an explicit per-file existence check against all 27 proposed paths (zero
  matches).
- `procint/ProcInt/Playground/Swarm11/Swarm.lean` and `.../Supply.lean` already exist (hand-
  authored, "Not rendered by ggen. Not ledgered in `.mfact/artifacts.toml`," i.e. informal scratch
  work, not part of the formal ledger). `Swarm.lean` proves `theorem minimalCovers_incomparable`
  (capability-only coalition antichain, D5/§7's `CapabilityCover` conjunct in isolation);
  `Supply.lean` proves `theorem total_applyActivity_of_conservative` (D3/§3's conservation claim,
  for the instantaneous-transport, single-invariant case). `grep -n "sorry"` over both files
  returns zero matches.
- `procint/ProcInt/Playground/Multifractal/` contains ten files
  (`HausdorffSpectrum`, `LocalExponent`, `BirkhoffSpectrum`, `Scale`, `PartitionFunction`,
  `Legendre`, `LevelSet`, `MassExponent`, `GeneralizedDimension`, `Spectrum`), all defining
  `theorem`/`lemma`, `grep -rn "sorry"` returns zero matches. This is the single-measure base case
  T3/C43 needs — already substantially built, unledgered, and never ported to the ledgered
  `ProcInt/` namespace.
- The pinned `cslib` dependency (`procint/lakefile.toml`, rev
  `1dbda5335e3fc06c414b84ca885a35d4c6d4ab7c`) contains
  `Cslib/Foundations/Relation/Confluence.lean`, which proves, abstractly over any
  `r : α → α → Prop`, `theorem LocallyConfluent.Terminating_toConfluent` — Newman's Lemma — plus
  `Diamond.toConfluent`, `StronglyConfluent.toConfluent`, and `Commute.join_confluent`. This is
  exactly the local-to-global confluence lifting Target Theorem 9.1 (T1, Correction C27) needs;
  per `AGENTS.md` §4 it lends no standing to T1 until a correspondence morphism from the swarm's
  step-commutation relation into this abstract `r` is constructed and admitted (Problem P17).
  `grep -rl "import Cslib" ProcInt` currently returns nothing — `cslib` is not yet imported
  anywhere in `ProcInt`.
- `grep -rl "Lyapunov\|Foster\|PositiveRecurrent"` over the entire pinned Mathlib tree, and
  `grep -rl "Markov\|Queue\|Drift"` over all of `cslib`, both return zero matches. Consequence: no
  Foster-Lyapunov / Markov-chain-stability apparatus exists in either pinned dependency; Target
  Theorem 5.1 (T2) is `BLOCKED_AT_PIN` for any imported stochastic-stability theorem, matching the
  precedent language `ROADMAP_MATH_SPINE.md` §4 uses for the Hessenberg-ordinal route. A
  from-scratch drift-condition development, or a pin move, is required.
- `grep -rl "EventStructure\|Mazurkiewicz\|Pomset"` over the pinned Mathlib tree returns no
  substantive match (one unrelated hit in `Topology/Homotopy/LocallyContractible.lean`).
  Consequence: D6/C23's Winskel event-structure apparatus (conflict relation, local finiteness)
  has no Mathlib asset to import; it must be built directly on `Mathlib.Order` primitives.

### Wave S0 — Actor state and admission

Target: `ProcInt/Swarm/State.lean`, `ProcInt/Swarm/Observation.lean`

`x_i(t) = (G_i, Q_i, I_i, K_i, P_i, R_i)` (D2) and `a_i : O_i -> O_i* ∪ Refusal` (D1's admission
gate) are pure typing — the swarm-domain instance of the repository's existing foundational law
"`O` does not imply `O*`" (`ROADMAP_MATH_SPINE.md` §8, Claim Status Table). No theorem obligation
in this wave; the cheapest possible start.

### Wave S1 — Stoichiometric ledger (port)

Target: `ProcInt/Supply/Stoichiometry.lean`, `ProcInt/Supply/Inventory.lean`

Port `procint/ProcInt/Playground/Swarm11/Supply.lean`'s `total_applyActivity_of_conservative` into
the ledgered namespace, restated per C6 as a bookkeeping recursion (D3) with no conservation claim
attached until Wave S3 supplies the pipeline-stock invariant. Lowest-risk wave with a genuine
proof: the Lean artifact already exists and is `sorry`-free; the work is porting and re-labeling,
not new proof.

### Wave S2 — Coalition antichain (port, then generalize)

Target: `ProcInt/Coordination/Capability.lean`, `ProcInt/Coordination/Coalition.lean`,
`ProcInt/Coordination/Residue.lean`

Port `Playground/Swarm11/Swarm.lean`'s `minimalCovers_incomparable` (capability-only case).
`Residue.lean` then generalizes to the full `AdmissibleCoalition` (`CapabilityCover ∧
ResourceFeasible ∧ TemporalFeasible ∧ TypedComposable`, D5) as an instance of the generic
`MinimalCompletion(C, x, A)` operator (`ROADMAP_MATH_SPINE.md` Wave M4) rather than a fresh
residue system (Problem P15) — structurally the same minimal-antichain-of-a-monotone-closure
argument as Crown I (`residue_is_antichain`, Wave M0), so genuinely "closest to already-proven."

### Wave S3 — Delayed transport and pipeline-stock conservation

Target: `ProcInt/Supply/DelayedFlow.lean`, `ProcInt/Supply/Capacity.lean`,
`ProcInt/Supply/Conservation.lean`

Discharges C7 (genesis boundary `f_e(s) := 0`, `s < 0`) and C6 (the pipeline-stock term `T_e(t)`
and a stated incidence property of `B`) before `Conservation.lean` states its first genuinely new
theorem: `sum_i x_i(t) + sum_e T_e(t)` invariant (Problem P16). First wave that is not a Playground
port.

### Wave S4 — Causal poset and event geometry

Target: `ProcInt/Swarm/Causality.lean`, `ProcInt/Swarm/EventStructure.lean` (internally renamed
`CausalPoset` per C23)

Discharges C23 (local-finiteness axiom stated; the Winskel conflict relation is out of scope for
this wave and deferred to S7, since nothing downstream of S0–S3 yet needs it). `dim_square`
restated per C24 as an upper bound on realizable concurrency, proved only as an inequality, not an
equality.

### Wave S5 — Correspondence bridges (`κ_GW`, `κ_WF`, `κ_FR`)

Target: `ProcInt/Correspondence/POWLPhysical.lean`, `ProcInt/Correspondence/ReceiptDAG.lean`

Discharges C2 (`κ_FR` signature), C3 (admission predicate for `κ_GW`/`κ_WF`), and C5 (antichain-
typed codomain for `κ_GW`, reusing Crown I's existing `Antichain (Finset Obligation)` type rather
than inventing a new one — Problem P14). Requires S0–S3's objects to exist as the bridges'
domains/codomains; blocked on C1/C4 for the AtomVM-specific correspondence, deferred to S7.

### Wave S6 — Dual-field coordination and queue stability

Target: `ProcInt/Coordination/DualField.lean`, `ProcInt/Coordination/Stability.lean`

Blocked on C16–C22 (convexity/closedness/properness of `c_i`, `tau_e`, `Shortage`, `Risk`; a
constraint qualification; an `f_e` splitting rule; restored capacity constraints; disambiguated
`lambda` symbols — Problem P18) and C9–C15 (a declared stochastic primitive, a Lyapunov drift
condition, network-stability discipline — Problem P21). Per the verified environment facts above,
Target Theorem 5.1's stochastic-stability half is `BLOCKED_AT_PIN` for any imported theorem; this
wave requires either a from-scratch drift-condition development or a pin move, so it is placed
after every wave with an available Lean asset (S0–S5) and before only the two most speculative
rails (S7 is dual-decomposition-adjacent territory once C16–C22 land, but the replay theorem has
the `cslib` asset in hand, so it is ordered ahead of S6's stability half specifically).

### Wave S7 — Causal-DAG replay confluence and the AtomVM correspondence

Target: `ProcInt/Swarm/Confluence.lean`, `ProcInt/Correspondence/AtomVMActor.lean`

Blocked on C25 (finite order ideal), C26/C28 (the `StructuralIndependence => SemanticCommutation`
correspondence, stated over a label-level independence relation, not an instance-level one), and
C1/C4 (`AbstractActorTransition` identified with a specific `Swarm/Causality.lean` object, and a
`Fence: candidate-only` marker on `κ_runtime` until it is). The payoff, once these land: the local-
to-global lifting itself (C27) does not need to be reproved — `cslib`'s
`LocallyConfluent.Terminating_toConfluent` is already sitting in the pinned dependency tree,
unimported by `ProcInt` today (Problem P17). This is the document's own "decisive call" theorem
(T1/Target Theorem 9.1), correctly last among the concurrency waves precisely because its
correspondence obligations, not its core lemma, are the open work.

### Wave S8 — Sheaf model for local knowledge

Target: `ProcInt/Sheaf/LocalState.lean`, `ProcInt/Sheaf/Restriction.lean`,
`ProcInt/Sheaf/Compatibility.lean`, `ProcInt/Sheaf/Gluing.lean`, `ProcInt/Sheaf/Residue.lean`

Blocked on C29–C38: no site or topological space has ever been constructed for `U_i`/`F` (C29);
no functoriality (C30); §1's product state `X(t)` and §10's glued section are unreconciled (C31);
the gluing axiom is unverified for this `F` (C32); no separatedness (C33); `SheafResidue`'s
codomain is undefined (C34); no triple-overlap cocycle check (C35); `U_i` is unreconciled with
`O_i(t)` (C38). Mathlib's `CategoryTheory/Sites/` machinery exists in the pinned checkout (95
files under `Mathlib/**/Sheaf*`) and is a plausible target for the eventual site construction, but
per `AGENTS.md` §4 that existence lends no standing until `F`'s actual site is admitted (Problem
P19). Placed second-to-last per instruction: most foundationally incomplete of the three research
rails — the object `F` is a presheaf/sheaf of is never named, unlike the multifractal rail's
single-measure case (S9), which at least has a concrete, `sorry`-free partial development.

### Wave S9 — Joint multifractal field

Target: `ProcInt/SwarmMultifractal/JointMeasure.lean`, `ProcInt/SwarmMultifractal/Partition.lean`,
`ProcInt/SwarmMultifractal/JointSpectrum.lean`, `ProcInt/SwarmMultifractal/Policy.lean`

Blocked on C39–C45. The single-measure base case (`tau(q)`, Legendre transform, level sets) has
real, `sorry`-free prior art in `Playground/Multifractal/` (per the verified environment facts) —
but even that base case needs `B_eps` and a regularity class for `mu` named before this document's
presentation of it is discharged (C43). The genuinely new work is entirely in the *joint* case: no
cross-measure regularity/correlation condition exists anywhere in this repo for any measure pair
(C41), `alpha(x)` has no pointwise definition (C40), and `pi : alphavec -> CoordinationPolicy`
(C42) is a bare, unimplemented signature with no Lean or Playground counterpart at all. Placed
last per instruction, alongside S8: most speculative rail, and the only one whose headline claim
the source document's own Falsifier item already flags as premature (C39).

---

## 4. Problem Ledger Additions

Carried from `ROADMAP_MATH_SPINE.md`: P1–P13 stand as written there. New:

- **P14 — `κ_FR` Bridge Construction.** Give `κ_FR : PhysicalTransition -> ReceiptEvent` a stated
  domain, codomain, and preserved structure (the §3/§4 conservation law), closing C2 and making
  "the bridges are explicit" true of all three named bridges, not two.

- **P15 — Coalition Residue Generalization.** Extend `minimalCovers_incomparable`
  (`Playground/Swarm11/Swarm.lean`, capability-only) to the full `AdmissibleCoalition` antichain
  (`CapabilityCover ∧ ResourceFeasible ∧ TemporalFeasible ∧ TypedComposable`) as the fourth
  instance of `MinimalCompletion(C, x, A)` (`ROADMAP_MATH_SPINE.md` Wave M4: planning, abduction,
  causal identification, and now coalition formation) rather than a fifth, independent residue
  system — a second residue system is a defect per that wave's own stated law. Closes C5.

- **P16 — Pipeline-Stock Conservation Invariant.** State and prove
  `sum_i x_i(t) + sum_e T_e(t)` invariant under a stated incidence property of `B` and the genesis
  boundary condition `f_e(s) := 0` for `s < 0`, with `T_e(t) = sum_{s=t-l_e+1}^{t} f_e(s)` the
  in-flight pipeline stock. Closes C6 and C7.

- **P17 — Structural-to-Semantic Independence Correspondence.** *(Corrected 2026-07-12 — see
  P22, which found the actual blocker was not on this problem's original list.)* Construct
  `κ : StructuralIndependence (§8) -> SemanticCommutation`, derived from stoichiometric
  disjointness of touched rows of `S`/inventory (C26), and admit `κ`'s image into `cslib`'s
  `LocallyConfluent` hypothesis. The original framing assumed a completed `κ` would let
  `LocallyConfluent.Terminating_toConfluent` discharge Target Theorem 9.1 directly once
  constructed. An implementation attempt
  (`procint/ProcInt/Playground/Swarm11/NewmanCorrespondence.lean`) found `LocallyConfluent` holds
  *unconditionally* for the natural swap relation — `κ` is not actually load-bearing for that
  half — but `Terminating` is *provably false* for that same relation (it is symmetric, so any
  nondegenerate commuting pair yields a two-cycle), independent of `κ`, independent of DAG
  finiteness (C25's original concern), independent of the ambient type's cardinality. P17 as
  originally stated cannot close Target Theorem 9.1 even with `κ` fully constructed. Remains open
  only as a possible ingredient of the P22 `OrientedSwap` construction (κ could inform the
  priority/reference structure that breaks symmetry), not as a direct path to Confluent. Closes
  C25, C28 (the `κ` domain/codomain obligation itself); does not close C27 (see P22).

- **P18 — Dual-Decomposition Admission Conditions.** State convexity/closedness/properness of
  `c_i`, `tau_e`, `Shortage`, `Risk`; a constraint qualification; a stepsize regime for `eta`; and
  an `f_e`-ownership or consensus-splitting rule. Then the classical subgradient/dual-ascent
  convergence theorem becomes an executable admission profile emitting
  `DUAL_DECOMPOSITION_GUARANTEE_ACTIVE` or `CONVEXITY_UNESTABLISHED`, mirroring
  `ROADMAP_MATH_SPINE.md` Correction 7's admission-condition pattern for adaptive submodularity.
  Closes C16, C17, C19, C20, C21, C22.

- **P19 — Sheaf Site Construction for Local Swarm Knowledge.** Exhibit the actual site `(C, J)`
  (or topological space) underlying `{U_i}`, prove `F` functorial, prove separatedness, and check
  the triple-overlap cocycle condition — before any gluing or cohomology language is used, even
  informally. Closes C29, C30, C32, C33, C35.

- **P20 — Joint Multifractal Cross-Measure Regularity.** State the cross-measure
  regularity/correlation condition linking `mu_W`, `mu_I`, `mu_R`, `mu_L` over shared boxes `B`;
  define `alpha_k(x)` pointwise for each `k`; and construct the joint Legendre transform from
  `tau(q_vec)` to a dimension function on `E_alphavec` — before any joint spectrum or routing
  policy `pi` is claimed. Closes C40, C41, C44.

- **P21 — Swarm Queue-Stability Drift Condition.** Declare a stochastic primitive for admitted
  demand arrivals, fix one symbol for the aggregate queue (`Q(t) := sum_i |Q_i(t)|`), and state a
  Foster/Meyn–Tweedie-shaped Lyapunov drift condition, or a fluid-limit Lyapunov condition with a
  named scheduling discipline if the multi-hop network case (not a single queue) is intended.
  Per the verified environment facts, no Foster-Lyapunov apparatus exists in the pinned Mathlib or
  `cslib` checkouts — this problem is `BLOCKED_AT_PIN` for any imported theorem until a
  from-scratch development exists or the pin moves. Closes C9, C10, C11, C12, C13.

- **P22 — Orientation for Newman's Lemma on the Swap Relation.** Added 2026-07-12, discovered
  during an implementation attempt at P17
  (`procint/ProcInt/Playground/Swarm11/NewmanCorrespondence.lean`, kernel-verified: `Swap.symm`,
  `not_terminating_of_cycle`, `not_terminating_swap_constUnit`, `swap_site_cases`,
  `swap_disjoint_confluent`, `swap_overlap_confluent`, `swap_locallyConfluent` — the last proving
  `LocallyConfluent (Swap step)` unconditionally, zero extra hypotheses, for every `step`).
  The raw one-step adjacent-transposition relation `Swap step` needed for
  `LocallyConfluent.Terminating_toConfluent` is symmetric by construction (`Commute` is symmetric
  on its two arguments), so it always admits a two-cycle and is never `Terminating` in `cslib`'s
  sense — refuted, not merely unproven, and independent of P17's `κ`, of DAG finiteness, and of
  the ambient type's cardinality. Construct `OrientedSwap`, parametrized by a priority/reference
  structure breaking `Swap`'s symmetry (fire only when the transposition strictly reduces
  position-inversions relative to a fixed reference — the standard bubble-sort-termination
  technique); prove `Terminating (OrientedSwap step priority)` via strict inversion-count
  decrease; reprove `LocallyConfluent (OrientedSwap step priority)` by reusing
  `swap_locallyConfluent`'s same/disjoint/overlap case structure (the disjoint case ports
  directly; the overlap case's two-step detour needs re-checking against the orientation
  constraint at each step); then apply `Terminating_toConfluent` for real. Delivers a different,
  provable theorem than Target Theorem 9.1's original ambition — not "any two `Swap`-reachable
  traces converge" but "every `Swap`-equivalence-class has a unique `OrientedSwap`-reachable
  normal form, and normal forms replay identically to every representative" — real and useful,
  but not the originally-named result. Closes the residual half of C27 that P17 does not.

---

## 5. Marker Schema

Two kinds of marker, per `ROADMAP_MATH_SPINE.md` §6's own law. Claim ceilings assert the *absence*
of standing and may be declared in prose because they only ever say less. Achievement markers
assert standing and must be derived from the artifact they name by a producer; no such producer
exists yet for this document's domain either, so every achievement value below is blank.

Claim ceilings (in force now):

```text
SWARM_CONSERVATION_SPINE_CEILING=STOICHIOMETRIC_LEDGER_RECURSION  # never "conservation spine"
KAPPA_FR_CEILING=MISSING                                          # no signature exists (C2)
KAPPA_RUNTIME_CEILING=CANDIDATE_ONLY                               # no preserved structure (C1)
KAPPA_GW_CEILING=CANDIDATE_ONLY                                    # no admission predicate (C3)
DIM_SQUARE_CEILING=UPPER_BOUND_ONLY                                # never "measures parallelism"
CAUSAL_DAG_REPLAY_CEILING=WELL_POSED_BUT_UNPROVEN                  # Target Thm 9.1; C25-C28
SWARM_QUEUE_STABILITY_CEILING=MISSING_HYPOTHESES                   # no Lyapunov drift stated
SWARM_QUEUE_STABILITY_ROUTE=BLOCKED_AT_PIN                # no Foster/Lyapunov in Mathlib/cslib
DUAL_DECOMPOSITION_CEILING=MISSING_HYPOTHESES              # convexity/QC/eta unstated
SHEAF_GLUING_CEILING=CANDIDATE_ONLY                        # no site constructed (C29)
JOINT_MULTIFRACTAL_CEILING=MISSING_HYPOTHESES              # cross-measure condition open
JOINT_MULTIFRACTAL_ROUTING_CEILING=CONJECTURAL             # trips the doc's own Falsifier 9
COALITION_ANTICHAIN_CEILING=TARGET_THEOREM                 # capability-only PROVEN in Playground
```

Achievement markers (blank until a producer derives them from evidence):

```text
SWARM_S0_STATE_FORMALIZED=
SWARM_S1_STOICHIOMETRY_PORTED=            # Playground/Swarm11/Supply.lean exists, unledgered
SWARM_S2_COALITION_ANTICHAIN_PORTED=      # Playground/Swarm11/Swarm.lean exists, unledgered
SWARM_S3_PIPELINE_CONSERVATION_PROVEN=
SWARM_S4_CAUSAL_POSET_FORMALIZED=
SWARM_S5_CORRESPONDENCE_BRIDGES_ADMITTED=
SWARM_S6_DUAL_FIELD_STABILITY_PROVEN=
SWARM_S7_REPLAY_CONFLUENCE_PROVEN=        # correspondence target: cslib Terminating_toConfluent
SWARM_S8_SHEAF_GLUING_PROVEN=
SWARM_S9_JOINT_MULTIFRACTAL_PROVEN=       # single-measure base case exists unledgered (S9 note)
```

The environment facts in §3 (Playground assets, `cslib`'s Newman's-Lemma theorem, the Mathlib/
`cslib` Lyapunov-apparatus absence) are mechanically true and cited there with their exact grep/
find commands; their markers above nonetheless stay blank until a producer re-derives and emits
them, so that no marker in this file is ever a hand-asserted value.
