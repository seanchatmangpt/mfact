# Ticket: Persistent Proof Environment (LSP Fitness Oracle)

## Title
Replace subprocess-per-candidate fitness checking with a persistent, incrementally-checked LSP session — `pylab/src/math_factory_pylab/proof_env.py`

## Description
`scripts/genetic_tactic_search.py` currently pays a full `lake env lean <scratch-file>`
subprocess — cold interpreter start, fresh import elaboration — for every candidate in
every generation. Three of the eleven papers independently converge on the fix:

- **Lean Copilot** (arXiv:2404.12534): never recompile a file to check a tactic —
  simulate the tactic against the live elaborator state and read back
  success/remaining-subgoals. Its `search_proof` (Aesop + LLM-suggested rules injected
  per-node) automates 74.2% of proof steps on Mathematics in Lean, vs 40.1% for Aesop
  alone — the delta is attributed to exactly this cheap-recheck loop, not model quality.
- **HOList** (arXiv:1904.03241): a *stateless* `ApplyTactic(goal, tactic, args) →
  subgoals | failure` API over a library loaded once (not per query) is what let them
  plug in arbitrary search strategies and run thousands of distributed workers; startup
  time dropped from up to 20 minutes (full HOL Light load) to seconds once state was
  external to the loop.
- **LeanNavigator** (arXiv:2503.04772): measured 0.12s per tactic application through
  an interactive session (LeanDojo) vs multi-second cold subprocess starts — the paper's
  own throughput comparison (2035 states/theorem in 2 minutes vs a baseline's 21.7)
  is driven almost entirely by this.

`pylab` already has 70% of this: `lean_lsp.py` is a working async JSON-RPC client for
`lake env lean --server` with `initialize`, `didOpen`, `get_hover`. It has no
`didChange`, no diagnostics-to-candidate attribution, and no goal-state query.

## Design

- One persistent `lake env lean --server` process per search run (started once via
  `Lean4LSPClient.start()`, already implemented).
- `didOpen` a scratch file once: a frozen prefix (imports + the target theorem's
  statement with `sorry`) followed by a mutable candidate region.
- Per generation, pack up to N candidates as N sibling `example ... := by <candidate>`
  blocks in a single `didChange`, so the server's incremental re-elaboration reuses the
  frozen prefix's snapshot instead of re-elaborating imports N times.
- Add `get_diagnostics_for_range(uri, start_line, end_line)` and
  `get_goal_state(uri, line, character)` (wraps `$/lean/plainGoal`, not currently in
  `lean_lsp.py`) so each candidate's outcome can be classified, not just pass/fail.
- Classify every candidate as one of **Error / Stagnation / Progress / Solved**
  (Lean Copilot's green/blue distinction, generalized): Error = diagnostics show a
  failure in that candidate's line range; Stagnation = no error but the resulting goal
  state hash is unchanged or previously seen (needs a goal-state hash cache — see
  Ticket 003 for where this is reused); Progress = no error, new non-redundant goal
  state; Solved = no error, no remaining goals.
- **Final acceptance stays a cold, independent check.** Any candidate the search
  reports as Solved is re-verified with one `lake env lean` subprocess run on the fully
  assembled file before it is ever logged as accepted. The persistent-server harness
  never becomes the trust boundary — this mirrors HOList's own discipline (its search
  infrastructure proposes; a ~400-line trusted kernel, run separately, checks).

## Acceptance Criteria
- `proof_env.py` exports a `ProofEnv` class: `open(prefix: str) -> None`,
  `check_batch(candidates: list[str]) -> list[Outcome]` where `Outcome` has
  `{verdict: Error|Stagnation|Progress|Solved, diagnostics: list[str], goal_state: str
  | None}`, `close() -> None`.
- Measured wall-clock: batch-checking 12 candidates (current default GP population)
  via `ProofEnv` is faster than 12 sequential `lake env lean` subprocess calls on the
  same machine — record the actual ratio in the PR description, do not assume a
  number from the papers transfers unmeasured.
- `genetic_tactic_search.py` is updated to use `ProofEnv` instead of per-candidate
  subprocess calls, with subprocess-based checking kept as a `--legacy-subprocess`
  fallback flag for one release cycle (in case incremental re-elaboration has edge
  cases the current code doesn't).
- No changes outside `pylab/**` and `scripts/genetic_tactic_search.py` — this is a
  pylab-tier and Playground-adjacent-script change only.
- Never writes to `packs/*/fragments/*.ttl`; unchanged from the existing script's
  governance note.

## Dependencies
None — extends existing, working `lean_lsp.py`.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_proof_env.py` — new tests covering
   Error/Stagnation/Progress/Solved classification on the existing
   `TacticSearchWarmup.lean` targets (`warmup_nat_add_comm`, `warmup_list_length_append`,
   `warmup_reach_refl`), each with a hand-picked candidate known to produce that verdict.
2. `just tactic-search warmup_nat_add_comm` end-to-end run, output log shows a
   `mode=persistent-server` marker and the same eventual kernel-accepted result as
   before this change (regression check against known-good behavior).
3. Manual timing comparison, logged in the PR: N candidates via `ProofEnv.check_batch`
   vs N candidates via the old subprocess loop, same target, same seed.
