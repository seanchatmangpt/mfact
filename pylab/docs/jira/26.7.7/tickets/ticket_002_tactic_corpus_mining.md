# Ticket: Data-Derived Tactic Vocabulary + Bigram Re-Ranking

## Title
Replace the hand-picked 9-tactic GP vocabulary with a mined, templated vocabulary and a parent→child bigram prior — `pylab/src/math_factory_pylab/tactic_mine.py`

## Description
`scripts/genetic_tactic_search.py`'s `TACTIC_VOCAB` is nine hand-picked tactics
(`aesop`, `simp`, `omega`, `decide`, `rfl`, `trivial`, `constructor`, `intro x`,
`rcases x with x | x`). Two papers give a data-derived alternative with measured effect
sizes:

- **LeanNavigator** (arXiv:2503.04772): tactic **templates** — variables replaced with
  `{var0}`, `{var1}`, hypotheses with `{hypothesis}` — collapse `rw [mul_comm a b]` and
  `rw [mul_comm x y]` into one mined pattern `rw [mul_comm {var0} {var1}]`, solving the
  vocabulary sparsity a raw-string 9-tactic list has by construction.
- **"Understanding and Improving Automated Proof Synthesis"** (arXiv:2604.24354, the
  PGTS paper): mines *contiguous, parameter-normalized* tactic bigrams — (parent
  tactic, child tactic) transitions — from 57,719 human Coq proofs via PrefixSpan at
  ≥1% support, then **re-ranks** a base model's candidate tactics at each search node,
  putting pattern-matching candidates first (sorted by mined frequency), the rest after.
  Measured on four DFS-based Coq provers: **+8.05% theorems proved on average**
  (ASTactic +5.64%, Tac +12.14%, Tok +9.24%, Passport +5.17%), **20.8% shorter proofs**
  on average, and a **+85.14% average relative increase** in higher-order-logic
  theorems newly proved.

**Precision constraint carried over from the reading pass:** the PGTS paper's finding
about "expert alignment correlating with success" is a *distributional ordering*
(Progress > Stagnation > Error in pattern-conformance, Figure 10 of that paper) across
four tools, not a reported correlation coefficient. The intervention that earned
+8.05% is candidate **re-ranking by mined bigram frequency**, not a fitness bonus term.
Any write-up citing this must say "re-ranking" and "conformance ordering," not
"correlation," to stay accurate to the source.

## Design

- **Mining pass**: walk `.lean` sources under `procint/` (starting with
  `procint/ProcInt/Playground/**`, expandable to the full `procint/ProcInt/**` tree
  once this ticket proves the mining code works), extract tactic-block token sequences,
  normalize identifiers to `{var}`/`{hyp}` placeholders (LeanNavigator's scheme).
  Compute (a) template frequency and (b) a parent→child bigram count table.
- **Instantiation**: when the GP mutates a genome to insert a mined template, fill
  `{var}`/`{hyp}` placeholders from the current goal's in-scope hypothesis names, read
  via `ProofEnv.get_goal_state` (Ticket 001).
- **Re-ranking, not scoring**: when the GP's mutation/crossover operators choose among
  candidate next-tactics for a genome, sort candidates whose (parent, chosen) pair
  matches a mined bigram to the front, ordered by mined frequency, then fall back to
  the existing random/uniform selection for the rest — mirroring PGTS's Algorithm 1
  exactly, not inventing a fitness-bonus variant.
- Persist the mined tables to a checked-in or `.gitignore`d cache (decide at
  implementation time based on table size) so mining doesn't re-run every search
  invocation.

## Acceptance Criteria
- `tactic_mine.py` exports `mine_templates(paths: list[Path]) -> TemplateTable` and
  `mine_bigrams(paths: list[Path]) -> BigramTable`, both pure functions over `.lean`
  source text (no Lean process invocation needed for mining itself — this is a text
  processing step).
- `genetic_tactic_search.py`'s candidate-selection step is updated to consult the
  bigram table for re-ranking when one is supplied via a new `--bigram-table` flag;
  behavior is unchanged (falls back to current uniform random choice) when no table is
  supplied, so this is additive, not a breaking change to the existing script.
- A test asserts the template normalization round-trips on a known example (e.g.
  confirms `rw [mul_comm a b]` and `rw [mul_comm x y]` mine to the same template).
- Docs (`docs/genetic-tactic-search.md`) updated to describe the mining step and cite
  the PGTS paper's actual claim (re-ranking + conformance ordering) accurately.

## Dependencies
Ticket 001 (`ProofEnv.get_goal_state`) for hypothesis-name instantiation at mutation
time. The mining pass itself has no dependency on Ticket 001 and can be built first.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_tactic_mine.py` — template normalization and
   bigram counting on a small fixture corpus.
2. `just tactic-search warmup_nat_add_comm --bigram-table <mined-table-path>` — confirm
   the run completes and the log records which candidates were bigram-prioritized.
3. Before/after comparison on the three existing `TacticSearchWarmup.lean` targets:
   generations-to-solution with and without the bigram table, logged (not claimed) in
   the PR — this repo's own measurement, not an assumed transfer of the Coq-tool
   +8.05% figure to a 9-tactic Lean vocabulary.
