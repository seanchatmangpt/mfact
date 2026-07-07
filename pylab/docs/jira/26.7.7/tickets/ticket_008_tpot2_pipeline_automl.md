# Ticket: Actual TPOT2 Pipeline Evolution Over Process-Mining Pipelines

## Title
Answer the original "what about TPOT2" question with a real execution surface:
TPOT2-driven pipeline search over pm4py/ocpa process-mining pipelines, in pylab

## Description
This whole line of work started from the question "what about TPOT2" — TPOT2 being a
genetic-programming AutoML tool that evolves scikit-learn pipelines as DAGs, CV-scored.
The earlier plan (`~/.claude/plans/ok-so-which-should-toasty-axolotl.md`) correctly
found that `procint`'s two placeholder registry entries citing genetic-programming
process mining (`Algo_automl_classify`, `Algo_automl_forecast`, `alg_genetic_algorithm`)
have **no execution runtime behind them in Lean** — mfact is a proof-manufacturing
pipeline, not an interpreter, and building the actual TPOT2-style algorithm there was
correctly scoped out to `wasm4pm`.

But `pylab` already has an execution runtime, and already has `tpot_fit` wired into
`mcp_procint` (currently a single `TPOTClassifier` call over a CSV, per
`PYLAB-PRD-ARD-v26.7.7.md` §10). It also already has `pm4py`, `ocpa`, and `powl`. TPOT2
evolving pipelines *of process-mining operations* (not just scikit-learn estimators) is
a real, buildable answer to the original question, entirely inside pylab's existing
governance tier — the piece the earlier plan correctly deferred, now with a concrete
target.

## Design

- TPOT2's public API (per the existing `tpot_fit` tool's own finding: no
  `.score()`/`.fitted_pipeline_` the way TPOT1 had) supports custom search spaces via
  its `search_space` configuration — pipelines of arbitrary scikit-learn-compatible
  estimators/transformers, not only classifiers.
- Wrap `pm4py`/`ocpa` operations that have a natural fit/transform-style signature
  (e.g. DFG discovery parameters, conformance-checking thresholds, object-centric
  discovery parameters) as scikit-learn-compatible transformer stubs — thin adapters,
  not reimplementations of pm4py/ocpa internals.
- Define a fitness metric appropriate to process mining (not classification accuracy):
  candidate starting point is a conformance-checking fitness (e.g. token-based replay
  fitness from `pm4py`, already a library primitive) scored against a held-out slice of
  an XES/OCEL log.
- `tpot_process_pipeline_search(log_path, param_space, generations, population_size) ->
  PipelineResult` — new MCP tool alongside the existing `tpot_fit`, `pm4py_discover_dfg`,
  `ocpa_import_ocel2`. Read/analysis-oriented: it searches and reports, it does not
  write back into any ledgered artifact.
- Natural test corpus: the OCEL event logs Ticket 007 produces from tactic-search runs
  are themselves valid inputs — this ticket and Ticket 007 can validate each other
  (TPOT2 pipeline search run *on* the proof-search-as-event-log data), which is worth
  noting as a demonstration but is not required for this ticket's own acceptance.

## Acceptance Criteria
- `tpot_process_pipeline_search` implemented and callable via `mcp_procint`, using
  TPOT2's actual custom-search-space API (confirmed against the installed package,
  the same discipline `tpot_fit` and `powl_discover` already followed — inspect the
  installed API directly rather than assuming TPOT1-era interfaces transfer).
- Runs end-to-end against at least one real event log (an XES sample from `pm4py`'s own
  test fixtures, or an OCEL log — `procint` process traces if Ticket 007 exists, or any
  publicly available sample otherwise) and returns a non-trivial evolved pipeline
  (more than one stage) plus its fitness score.
- Explicitly does not claim correspondence to, or a proof about, any Lean formalization
  in `procint/ProcInt/` — per `PYLAB-PRD-ARD-v26.7.7.md` §2's existing non-goal, this
  ticket inherits that constraint unchanged.
- Closes the loop explicitly in its own docstring/README note: cites the original
  registry placeholders (`Algo_automl_classify`, `alg_genetic_algorithm`) as the
  citation this ticket makes *executable*, without claiming this pylab code
  *implements* those Lean registry entries — they remain citation-only metadata in
  `procint`, unchanged, per the governance boundary this document has maintained
  throughout.

## Dependencies
None strictly required. Optionally validated against Ticket 007's output once that
exists.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_tpot_process_pipeline.py` — end-to-end run
   against a small fixture XES log, asserting a pipeline with >1 stage is returned and
   its fitness score is computed via a real pm4py conformance metric (not a stub).
2. MCP smoke test: `tpot_process_pipeline_search` callable via the `mcp_procint` server
   harness, returns valid JSON.
3. Manual note in the PR: which specific pm4py/ocpa operations were wrapped as search
   space components, and what the evolved pipeline actually looks like on the test
   fixture — logged plainly, not summarized as a headline metric this repo's own
   `prose-lint` conventions would flag as unsupported.
