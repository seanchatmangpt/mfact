# Ticket: Genetic Population as the Policy Inside AND-Hypergraph Search

## Title
Combine TPOT2-style genetic-programming population dynamics with HyperTree Proof
Search's AND-hypergraph selection/backup — a search architecture not present in any of
the 11 surveyed papers

## Why this is the crown ticket for the paper
Across all 11 papers read this session, search architectures fall into two families
that are never mixed:

- **Learned-policy tree/hypergraph search** — HyperTree Proof Search (arXiv:2205.11491)
  builds an AND-hypergraph over goals, selects with PUCT/regularized-policy statistics
  (`N`, `W`, `Q` per (goal, tactic) edge), expands by sampling from a *trained neural
  policy*, backs up via product-of-children values with a *trained critic* providing
  leaf estimates for unsolved nodes. HOList (arXiv:1904.03241) similarly uses a trained
  action-generator network to rank tactic applications in its breadth-first search.
- **Population-based search with no tree structure** — the existing
  `genetic_tactic_search.py` is a flat GP loop over whole tactic-sequence genomes: no
  shared search tree, no per-goal statistics, no reuse of partial-proof structure
  across individuals, mutation/crossover with binary kernel-accept fitness.

No paper in this set proposes using an *evolving population* as the source of
expansion candidates and mutation pressure **inside** an AND-hypergraph's selection/
backup structure — HTPS gets its candidates from a trained network; TPOT2-lineage GP
has no tree at all. mfact has no training budget or GPU fleet (correctly out of scope
per this document's non-goals), so a trained policy is not available — but the mined
bigram table (Ticket 002) is a non-neural prior, and a GP population is a
non-neural, adaptive *proposal distribution* that a trained policy would otherwise
supply. Wiring population dynamics into HTPS's selection/expansion/backup loop, using
the mined bigram table as the initial prior instead of a trained network, is the
combination this repo can actually build and is worth writing up as a real
contribution — not "GP" and not "HTPS" but the specific substitution of one for the
other's model-dependent piece.

## Design

**Hypergraph structure** (from HTPS): nodes are goal states (hashed via
`ProofEnv.get_goal_state`, Ticket 001); hyperedges are tactic applications mapping one
goal to a set of subgoals; each (goal, tactic) edge tracks `N` (visit count), `W`
(total value), `Q = W/N`.

**Selection** (from HTPS, adapted): descend from the root goal, at each node choosing
the edge maximizing a PUCT-style score `Q(g,t) + c * prior(g,t) * sqrt(N(g)) / (1 +
N(g,t))`, where `prior(g,t)` comes from the **mined bigram table** (Ticket 002) instead
of a trained policy's softmax output — the direct substitution this ticket is about.

**Expansion — the actual novel step**: instead of HTPS's "sample B tactics from a
policy network," maintain a **GP population per unexpanded node**: a small pool of
candidate tactic genomes seeded from bigram-prioritized mutations of the parent
genome's surviving prefix. Mutation and crossover operate within a node's local
population (standard GP), while the *population itself* is what gets sampled from at
expansion time — the population is the "network" HTPS would otherwise train. Successful
mutations that produce new goal states create new hypergraph nodes; unsuccessful ones
inform local selection pressure via the node's own population fitness, without needing
a separately-trained critic.

**Backup** (from HTPS, unchanged mechanism): product-of-children value propagation;
Solved/Invalid status propagation with pruning of hyperedges leading only to Invalid
nodes (both directly reusable — this bookkeeping doesn't depend on where candidates
come from).

**No critic network**: HTPS's ablation (their Table/Section on critic variants) found
*no critic beats a hard-target critic* (65.6% vs 63.1% on their Metamath ablation) —
only a *soft*, learned critic beat no-critic (78.1%). Since this repo has no training
budget, the correct choice per that ablation is **no critic**, using only the
kernel-accept/Invalid signal at leaves — an evidence-based simplification, not a
missing feature.

## Acceptance Criteria
- New module `pylab/src/math_factory_pylab/hypertree_gp.py` implementing the
  hypergraph structure, selection, GP-population expansion, and product-of-children
  backup described above, built on `ProofEnv` (Ticket 001) and the bigram table
  (Ticket 002).
- Runs successfully end-to-end on all three existing `TacticSearchWarmup.lean` targets,
  producing kernel-accepted proofs verified the same way as the existing flat-GP script
  (cold `lake env lean` re-check on the assembled winning proof).
- A comparison run (flat GP vs hypertree-GP, same targets, same wall-clock budget,
  logged not claimed) is recorded in the PR — this is a new architecture, and its value
  over the existing flat loop must be demonstrated on this repo's own targets before
  any paper claim is made about it.
- Per HTPS's minimal-proof lesson (Ticket 002 already notes this): when a target is
  solved via multiple hypergraph paths, log only the minimal one as the search's
  reported result.
- Explicitly does not attempt the two real open obligations in
  `research/wfnet/obligations.toml` — those need new lemmas, not tactic recombination,
  regardless of search architecture (per the original approved plan's scoping).

## Dependencies
Ticket 001 (persistent proof environment, goal-state hashing) and Ticket 002 (mined
bigram table as the non-neural prior). Do not start before both land.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_hypertree_gp.py` — unit tests for the
   hypergraph bookkeeping (Solved/Invalid propagation, product-of-children backup) on a
   small synthetic hypergraph fixture, independent of Lean.
2. `just tactic-search warmup_reach_refl --search hypertree-gp` end-to-end run against
   the hardest of the three existing warm-up targets.
3. Written comparison (generations/nodes-expanded/wall-clock to first solution, flat GP
   vs hypertree-GP) included in the PR description, both figures measured on this
   repo's hardware, neither borrowed from the papers' own reported numbers.
