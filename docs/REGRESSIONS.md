# Falsifiable-Constants Regression Protocols

Standing: UNVERIFIED — protocols defined, none executed; every constant below is unmeasured or
single-sample.

This document turns the scaling models asserted in conversation into runnable regressions.
Each protocol names the model, the data schema it requires, the estimator, a decision rule
with thresholds, and — critically — which side each outcome falsifies. Swarm-architecture
claims and monolith claims both carry named falsifiers; a protocol that can only confirm one
side is not admitted here. No result in this file is measured. Docs explain standing; they do
not create it (root `AGENTS.md`, Documentation and Claims).

Threshold values below are protocol parameters chosen for decidability, not measured
quantities. Where a ballpark number from the conversation appears, it is labeled UNVERIFIED
and single-sample.

## Protocol 1: Job-Size Tail Index (alpha)

1. **Model and claim.** Job service times S follow a heavy-tailed distribution with survival
   function P(S > x) ~ x^(-alpha). By Pollaczek–Khinchine, FCFS mean waiting under mixed job
   classes depends on E[S^2]; alpha <= 2 makes E[S^2] diverge, so mixed-class FCFS waiting
   diverges. The claim decided: whether size-based segregation of job classes is structurally
   required rather than merely convenient.
2. **Data required.** OCEL event logs of job traces: one event per lifecycle transition with
   `job_id`, `start_ts`, `end_ts`, `class`, `tokens_consumed`. Service time is derived per
   `job_id`. Minimum ~10^4 completed jobs for tail stability.
3. **Estimator.** Hill estimator over the upper order statistics, with a Hill plot across
   k = 10 .. n/10 to select a stable plateau; bootstrap CI on the plateau estimate.
4. **Decision rule.** If the 95% CI for alpha lies entirely at or below 2.0: heavy-tail
   regime confirmed. If the CI lies entirely above 2.5: light-enough tail. CI straddling
   (2.0, 2.5]: UNKNOWN, collect more data.
5. **Falsification.** alpha <= 2 falsifies the monolith-side claim that a single FCFS queue
   over mixed classes is serviceable (P-K divergence). alpha > 2 (finite second moment)
   weakens the swarm-side segregation argument: segregation may still help, but it is no
   longer forced by divergence.

## Protocol 2: USL Contention and Coherence (sigma, kappa)

1. **Model and claim.** Universal Scalability Law: throughput
   X(N) = lambda * N / (1 + sigma * (N - 1) + kappa * N * (N - 1)). kappa > 0 implies
   retrograde scaling past N* = sqrt((1 - sigma) / kappa). The claim decided: whether
   plan-artifact coordination (star topology over admitted artifacts) achieves kappa ≈ 0
   with flat sigma, versus pairwise coherence costs growing with N.
2. **Data required.** Swarm scaling runs at varying N (e.g., N in {1, 2, 4, 8, 16, 32}),
   fixed workload, >= 5 replicates per N; schema: `run_id`, `N`, `throughput`, `hub_wait_ts`,
   `coordination_msgs`.
3. **Estimator.** Nonlinear least squares fit of X(N) for (lambda, sigma, kappa), with
   residual bootstrap CIs; separately, linear regression of hub service time on N to test
   sigma flatness.
4. **Decision rule.** kappa CI containing 0 and |kappa| < 10^-3 with hub-sigma slope CI
   containing 0: flat-star coordination holds. kappa CI entirely above 10^-3: coherence cost
   real; report the implied N*. Hub-sigma slope CI entirely above 0: hub is a growing
   bottleneck.
5. **Falsification.** kappa > 0 falsifies the swarm claim of coherence-free scaling and
   names its ceiling N*. Hub sigma growing with N falsifies flat-star coordination
   specifically (the swarm side's own architecture claim). kappa ≈ 0 with flat sigma
   falsifies the monolith-side claim that multi-agent coordination necessarily pays a
   quadratic coherence tax.

## Protocol 3: Multifractal Spectrum Width (Delta-alpha)

1. **Model and claim.** Workflow event density is a multiplicative cascade with a nontrivial
   singularity spectrum f(alpha). Delta-alpha > 0 means heterogeneous cascade (bursty,
   multi-scale workload); Delta-alpha ≈ 0 means monofractal/homogeneous. The claim decided:
   whether "workflows are multifractal" is a characterization or a metaphor.
2. **Data required.** Partition-function estimates over window sizes epsilon: from OCEL event
   timestamps, compute Z_q(epsilon) = sum_i mu_i(epsilon)^q for q in [-5, 5], epsilon over
   >= 2 decades of dyadic window sizes.
3. **Estimator.** Linear regression of log Z_q on log epsilon per q to get tau(q); Legendre
   transform of tau(q) yields f(alpha); Delta-alpha = alpha_max - alpha_min where f > 0.
   Require R^2 >= 0.98 on each tau(q) fit for the scaling regime to be admitted.
4. **Decision rule.** Delta-alpha >= 0.3 with scaling-regime fits admitted: heterogeneous
   cascade confirmed. Delta-alpha < 0.1: effectively monofractal. In between, or fits below
   R^2 threshold: UNKNOWN.
5. **Falsification.** Delta-alpha ≈ 0 falsifies the multifractal-workflow characterization
   (and with it any scheduling argument that leans on cascade heterogeneity). Delta-alpha > 0
   falsifies the monolith-side simplification that a single mean-rate model of the workload
   suffices.

## Protocol 4: Task-State Entropy Rate (h)

1. **Model and claim.** Working task state emits information at entropy rate h (bits per
   step). If h > 0, a context of size L_max sustains coherent work for at most
   T_max <= L_max / h steps — the coherence-horizon bound. If h ≈ 0, state compresses to a
   bounded core and the bound never binds.
2. **Data required.** OCEL job traces with serialized task-state snapshots per step:
   `job_id`, `step`, `state_blob`, `blob_bytes`.
3. **Estimator.** Compression-based entropy-rate estimate: incremental compressed size of the
   state sequence (e.g., Lempel–Ziv) divided by step count, with a shuffled-sequence control
   to bound estimator bias; report slope of compressed size vs steps over the trace tail.
4. **Decision rule.** Tail slope CI entirely above 0 (compressed size grows linearly in
   steps): h > 0. Slope CI containing 0 with bounded compressed size: h ≈ 0. Sublinear but
   unbounded growth: UNKNOWN, refine model.
5. **Falsification.** h ≈ 0 falsifies the claim that the coherence-horizon bound binds (a
   swarm-side motivation for handoff and re-grounding). h > 0 supports T_max <= L_max / h and
   falsifies the monolith-side claim that one long-lived context can carry arbitrary-length
   work without loss.

## Protocol 5: Context-Reload Cost vs Working-Set Size (c(L))

1. **Model and claim.** The cost of a context switch/reload as a function of working-set size
   L. Processor-sharing (PS) discipline for monoliths is affordable iff c(L) is sublinear;
   c(L) ~ L (linear or worse) supports the PS-unaffordability argument for segregated
   dedicated workers.
2. **Data required.** Controlled reload runs: `run_id`, `working_set_tokens` (L),
   `reload_tokens`, `reload_wall_ms`, varied L over >= 1.5 decades.
3. **Estimator.** Regression of log c on log L; the exponent b in c(L) ~ L^b with bootstrap
   CI.
4. **Decision rule.** b CI entirely below 0.8: sublinear, PS rescued. b CI containing 1.0 or
   above: linear-or-worse, PS unaffordable at scale. Otherwise UNKNOWN.
5. **Falsification.** Sublinear c(L) rescues processor-sharing for monoliths and falsifies
   the swarm-side claim that time-slicing a monolith is structurally unaffordable. c(L) ~ L
   falsifies the monolith-side claim that a single agent can cheaply interleave many jobs.

## Protocol 6: Size-Prediction Error (Router Service-Time Estimates)

1. **Model and claim.** Segregation-beats-PS in practice requires the router to predict job
   service size well enough to route by class. The claim decided: whether size prediction is
   accurate enough for segregation to realize its theoretical advantage.
2. **Data required.** OCEL job traces with router predictions: `job_id`, `predicted_size`,
   `actual_size`, `class_assigned`.
3. **Estimator.** Relative absolute error distribution; primary statistic: median
   |log(predicted / actual)|; secondary: fraction of jobs misrouted across a class boundary.
4. **Decision rule.** Median log-error <= log(2) (within 2x) and misroute fraction <= 15%:
   prediction adequate. Median log-error > log(4) or misroute fraction > 30%: prediction
   inadequate. Between: UNKNOWN.
5. **Falsification.** High error falsifies segregation-beats-PS in practice (swarm side):
   with unpredictable sizes, size-based routing degenerates toward random assignment. Low
   error falsifies the monolith-side objection that segregation is unimplementable because
   sizes are unknowable in advance.

## Protocol 7: Kernel-Loop Closure Rate

1. **Model and claim.** Fraction of conjecture-engine outputs discharged by
   kernel-in-the-loop iteration per unit cost, giving effective proof service rate mu_eff.
   The claim decided: whether mu_eff >= lambda_gen (proof closure keeps pace with conjecture
   generation) is achievable on the certificate branch. This is currently a forecast, not a
   theorem.
2. **Data required.** Logs of conjecture-to-proof attempts: `conjecture_id`, `attempts`,
   `tokens_spent`, `outcome` in {PROVEN, CONJECTURAL, BLOCKED}, `wall_ms`. Generation-side
   rate lambda_gen from the same window.
3. **Estimator.** Closure rate = PROVEN count / total; mu_eff = PROVEN count / total tokens
   spent; compare against lambda_gen per token of generation budget; binomial CI on closure
   rate.
4. **Decision rule.** mu_eff CI entirely at or above lambda_gen: the certificate branch is
   self-sustaining at current cost. mu_eff CI entirely below 0.5 * lambda_gen: the queue of
   open conjectures grows without bound at this budget. Between: UNKNOWN.
5. **Falsification.** mu_eff < lambda_gen falsifies the swarm-side forecast that
   kernel-in-the-loop closure can keep the conjecture ledger bounded. mu_eff >= lambda_gen
   falsifies the monolith-side (skeptic) claim that formal closure is a fixed unpayable
   overhead per generated statement.

## Protocol 8: Recovery-vs-Lookup Token Ratio

1. **Model and claim.** Ratio R of tokens to re-derive a fact from a codebase sweep versus
   tokens to read its admitted artifact. Large R is the economic argument for admitted
   artifacts (ledgers, receipts, design docs) over re-derivation.
2. **Data required.** Paired trials on the same fact set: `fact_id`, `sweep_tokens`,
   `lookup_tokens`, `answer_correct` (both arms must answer correctly for the pair to count).
   >= 30 facts across >= 3 codebases.
3. **Estimator.** Geometric mean of per-fact ratio sweep_tokens / lookup_tokens with
   bootstrap CI, correctness-conditioned.
4. **Decision rule.** Ratio CI entirely above 10: artifact economy confirmed. CI containing
   1: no economy. Between: report the interval, UNKNOWN on the strong claim.
5. **Falsification.** R near 1 falsifies the swarm-side artifact-economy argument (admitted
   artifacts would be bookkeeping overhead). R >> 10 falsifies the monolith-side claim that
   re-derivation from source is an acceptable substitute for maintained artifacts.
6. **Prior anchor.** The conversation's ballpark of ~100–400x (from one session's ~800k-token
   sweep vs ~3k-token doc reads) is UNVERIFIED, single-sample, reported from another session,
   and not re-measured here. It sets the hypothesis, not the evidence.

## Protocol 9: Compounded Scaling Model (Five Multipliers)

1. **Model and claim.** The conversation composed five multipliers into one compounded
   monolith-vs-swarm cost model. Each is restated here as a separate fit-to-traces model.
   The composition multiplies them as if independent; that independence is ASSUMED, not
   established — no protocol below tests the joint model, only the axes. Any compounded
   number derived from these fits inherits UNVERIFIED standing plus the independence caveat.
2. **Sub-models and data.** All draw on OCEL job traces plus swarm scaling runs:
   - Conway coordination-channel count: fit channel count vs N; pairwise predicts ~N(N-1)/2,
     star predicts ~N. Data: `coordination_msgs` per pair per run.
   - Little staleness reload: fit reload frequency vs utilization rho against ~1/(1 - rho).
     Data: `rho`, `reload_events` per window.
   - Gall ratio: fit failure-to-first-success ratio vs system size n against e^(n * delta).
     Data: `n_components`, `attempts_to_green`.
   - Chesterton fence lookup vs archaeology: fit lookup-vs-rederive cost vs codebase age.
     Data: `repo_age_days`, `lookup_tokens`, `archaeology_tokens` (extends Protocol 8 with an
     age axis).
   - Rice finite-vs-divergent verification: classify verification tasks as decidable-slice
     (finite cost observed) vs open-ended (cost censored at budget); fit the censored
     fraction vs task class. Data: `task_class`, `verify_tokens`, `budget_hit` flag.
3. **Estimator.** Per axis: nonlinear least squares (or logistic fit for the censored Rice
   axis) with bootstrap CIs on the axis's shape parameter.
4. **Decision rule.** Each axis is decided independently by whether its fitted exponent or
   rate CI matches the claimed functional form (CI covering the claimed shape parameter) or
   excludes it. The compounded model is decided only if, additionally, pairwise residual
   correlations across axes have CIs containing 0; any pairwise correlation CI excluding 0
   falsifies the independence assumption and therefore the compounded multiplication.
5. **Falsification.** Each axis failing its form falsifies the swarm-side use of that
   multiplier; all five holding but residuals correlated falsifies the compounded model
   while leaving individual axes standing; all five holding with uncorrelated residuals
   would still leave the compounded prediction a fit, not a theorem. Conversely, pairwise
   channel growth ~N(N-1)/2 under a claimed star topology falsifies the swarm's own
   architecture claim, and observed lookup costs flat in codebase age falsifies the
   Chesterton-side archaeology penalty.

## Execution and Receipts

None of the protocols above have been executed. Executing one requires: (1) the named data
schema materialized under a receipted collection run, (2) the estimator run as a script under
`scripts/` per root `AGENTS.md` Command Discipline, (3) the outcome recorded here with the
receipt path, at which point the affected protocol's standing may move from UNVERIFIED to a
measured verdict. Until then, no constant in this file may be quoted as measured.

## See Also

- `MFACT_CORE_DESIGN.md` — core design the protocols exercise
- `AGENT_FAILURE_MODES.md` — failure modes several protocols quantify
- `../MFW_THESIS_SUMMARY.md` — thesis claims these regressions decide
- `../AGENTS.md` — Standing Law and Documentation and Claims (governs this file's claims)
- `LEXICON.md` — terminology this document's models and estimators build on
- `../procint/ProcInt/MFW/GapCalculus.lean` — formal anchors; existence confirmed at time of
  writing (2026-07-16), no correspondence claim made here beyond its presence
