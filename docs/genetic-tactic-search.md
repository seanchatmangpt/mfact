# Genetic tactic search — design notes

Status: exploratory, off-ledger tooling. Not part of the certified pipeline.

## Motivation

`research/wfnet/obligations.toml` has two open proof obligations
(`WfNet.sound_iff_shortCircuit_live_bounded_statement`,
`BranchingProcess.isUnfoldingOf_statement`) that are `status = "stated"`, not
`"proven"`. Closing either requires new lemmas, not recombination of existing
tactics, so this tool does not target them directly. Instead it warms up against
small synthetic lemmas in `procint/ProcInt/Playground/TacticSearchWarmup.lean`
and measures kernel-accept rate over generations, following the "smallest diff,
reuse first" invariant.

## Approach

A genetic-programming loop, modeled on the TPOT2 pipeline-search paradigm
(evolve/select structured candidates via mutation and crossover, score by a
fitness function) but applied to tactic sequences instead of ML pipelines. The
loop runs entirely outside Lean, in `scripts/genetic_tactic_search.py`: each
candidate genome is a sequence of tactic calls drawn from a small vocabulary
(`aesop`, `simp`, `omega`, `exact`, `apply`, `rcases`, `constructor`, `intro`,
`decide` — `aesop` is already a pinned `procint` dependency); each is spliced
into a scratch `.lean` file and checked with `lake env lean <file>`.

**Fitness is kernel accept/reject** — a hard, computed signal, never an LLM
self-report or heuristic estimate. This follows the repo's "receipts are
computed, never asserted-in" invariant: nothing here claims a proof exists
without the Lean kernel confirming it.

## Why this is plausible: prior work

Existing tooling has shown that native LLM-tactic integration into Lean 4 can
reach substantial proof-step automation rates — Lean Copilot reports 74.2%
step-level automation versus a 40.1% `aesop`-only baseline
[leancopilot2024]. Separately, empirical analysis of tactic selection found
that tactics conforming to expert proof patterns are more likely to advance a
proof successfully than arbitrary tactic choices [tacticexpertalign2026]. This
motivates using expert-pattern conformance as a **secondary, shaping** term in
the fitness function — it never substitutes for the primary kernel-accept
signal, only breaks ties among sequences that already type-check or biases
mutation toward more plausible candidates.

Two structural risks are worth naming going in, per prior surveys of Lean 4 ML
tooling. First, general-purpose LLMs show a documented Lean 3/Lean 4 syntax
confusion problem — models sometimes emit deprecated Lean 3 constructs despite
explicit Lean 4 instructions [langconfusion2025], which is one reason this
tool does not call an LLM directly for tactic proposal in v1 and instead
mutates a small hand-vetted tactic vocabulary. Second, closing genuinely new
theorems (as opposed to routine proof steps) remains hard even for
purpose-built systems — HyperTree Proof Search reports 82.6% on Metamath with
online training [hypertree2022], and HOList's benchmark work on higher-order
theorem proving [holist2019] likewise targets a large but bounded tactic
library, not open-ended lemma discovery. This is consistent with treating
warm-up lemmas, not the two crown-jewel obligations, as the v1 target.

Related infrastructure not used in v1 but relevant context: Lean4Lean provides
an independently verified typechecker for Lean 4 itself
[lean4lean2024]; Lean-auto integrates external ATPs (CVC5, Vampire, Z3) as a
richer automation backend [leanauto2025]; LeanExplore provides semantic and
lexical search over Lean declarations, useful for premise selection if this
tool grows beyond a fixed vocabulary [leanexplore2025]; large synthetic
Mathlib4-derived theorem corpora exist for training proof-synthesis models at
scale [mathlib4dataset2025]; and TheoremLlama [theoremllama2024] and
APOLLO [apollo2025] describe fine-tuning and solver-guided refinement
approaches for adapting general LLMs to Lean 4 specifically. None of these are
dependencies of the v1 script; they are cited here as the basis for possible
v2 extensions (external ATP fallback, premise search, LLM-guided mutation).

## Candidate → Admission boundary

A kernel-accepted tactic sequence found by this script is a legitimate
`Mfact.Candidate` (`producer = "genetic_tactic_search"`). Promotion to
`Admitted` — flipping a TTL fragment's `status` from `"stated"` to `"proven"`
and re-running `just render && just build && just audit && just manifest &&
just certify` — is a human-reviewed, separate step. The script itself never
writes to `packs/*/fragments/*.ttl`.

## Verification

Success = `lake env lean <candidate-file>` exit 0, logged verbatim. No claim of
STATED→PROVEN without the full `just check` / `just manifest && just certify`
chain passing on a human-promoted candidate.
