# Ticket: Proof Search as an OCEL 2.0 Event Log — Process-Mine the Search Process With This Repo's Own Tools

## Title
Emit every tactic-search run as an OCEL 2.0 event log; discover and conform-check the
search process itself using `pm4py`/`ocpa`, the same libraries used elsewhere in this
repo for process-intelligence work

## Why this is the crown ticket
`mfact` has two halves that, today, share only an RDF/TTL ontology (the `wf:`, `hook:`,
`prayer-kernel:`, `agent:` closed vocabularies referenced in the top-level CLAUDE.md):
a Lean proof-manufacturing pipeline, and a family of process-intelligence tools
(pm4py, ocpa, powl — already dependencies in `pylab/pyproject.toml`, already
exercised by `pm4py_discover_dfg`, `powl_discover`, `ocpa_import_ocel2` in
`mcp_procint`). Nothing in the repo today feeds *data* from one half to the other —
the process-intelligence tools have never been pointed at a process this repo actually
runs.

A genetic/hypertree tactic search (Tickets 001-003) *is* a process: goals visited,
tactics attempted, subgoals produced, backtracks taken, populations evolved. It has
cases (search runs, or individual root-goal attempts), events (tactic applications, with
timestamps, activity = tactic name, resource = generation/population index), and
objects (goal states, tactic genomes, hypergraph nodes) — an object-centric process by
construction, which is exactly what OCEL 2.0 (arXiv:2403.01975, already cited in
`refs.bib` as `ocel2`) and `ocpa`'s object-centric discovery are for, not a coincidence
of vocabulary. Logging the search this way and then running this repo's own
`pm4py_discover_dfg` / `ocpa_import_ocel2` / `powl_discover` tools against the result is
a genuinely new kind of evidence for the paper: *this repo's process-intelligence
tooling, applied to a process this repo itself generates*, rather than to an externally
sourced event log. That closes a real gap noted in `PYLAB-PRD-ARD-v26.7.7.md` §11 (no
concrete domain chosen yet for `pddl-plus-parser`/process-mining experimentation) with
the one domain already sitting in the repository.

## Design

- **Case**: one root-goal search attempt (a `just tactic-search <target>` invocation).
- **Objects**: `GoalState` (id = goal-state hash from `ProofEnv.get_goal_state`,
  Ticket 001), `TacticGenome` (id = a GP individual's identity across
  mutation/crossover, if Ticket 003's hypertree-GP is in use), `HypergraphNode` (if
  Ticket 003 is in use; degrades gracefully to just `GoalState` for the existing flat
  GP).
- **Events**: one event per tactic application attempt: `activity = tactic name`
  (or mined template, per Ticket 002), `timestamp`, `objects = [GoalState (from),
  GoalState (to, if produced), TacticGenome]`, attributes `{verdict: Error|Stagnation|
  Progress|Solved, generation, population_index}` (the same classification Ticket 001
  already computes — this ticket is substantially "persist what the fitness oracle
  already knows," per the smallest-diff invariant, not a new instrumentation
  subsystem).
- **Emission**: `pylab/src/math_factory_pylab/search_ocel.py` — a thin logger attached
  to `ProofEnv.check_batch` (Ticket 001) and, if present, the hypertree-GP loop
  (Ticket 003), writing OCEL 2.0 JSON (or sqlite, matching `ocpa_import_ocel2`'s
  existing importer) per search run to `pylab/reports/search-logs/` (gitignored —
  this is run-output data, not source).
- **Analysis**: after a search run, feed the log through the existing
  `pm4py_discover_dfg` (directly-follows graph of tactic transitions — literally the
  same bigram structure Ticket 002 mines from static source, now mined from *dynamic
  search behavior* instead, giving two independently-derived versions of the same
  artifact to cross-check) and `ocpa_import_ocel2` (object-centric view: which
  `GoalState`s were visited by which `TacticGenome`s, process-execution counts per
  search run).

## Acceptance Criteria
- `search_ocel.py` produces valid OCEL 2.0 output for at least one full run of the
  existing flat-GP search against a `TacticSearchWarmup.lean` target, importable
  without error by `ocpa_import_ocel2` (the existing pylab tool — this is the
  integration test: this repo's own importer must accept this repo's own emitter's
  output).
- `pm4py_discover_dfg` run against a search log produces a directly-follows graph;
  spot-compare its edge frequencies against Ticket 002's statically-mined bigram table
  for the same target — they are expected to differ (dynamic search behavior vs static
  corpus mining are different signals) and the comparison itself, written up honestly,
  is a citable observation, not a correctness check with a pass/fail bar.
- No claim that this event log or its analysis feeds release standing, gates, or the
  manifest — explicitly logged output only, same tier as everything else in `pylab/`.
- Works with the existing flat GP (degraded object set: `GoalState` +
  synthetic per-individual `TacticGenome` ids) so this ticket does not hard-depend on
  Ticket 003 landing first, even though the two are natural companions.

## Dependencies
Ticket 001 (`ProofEnv`, goal-state hashing, verdict classification) is required.
Ticket 003 (hypertree-GP) enriches the object model if present but is not required.
Ticket 002's static bigram mining is the natural comparison point for the DFG analysis
step but is not a hard dependency.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_search_ocel.py` — emits a log from a scripted
   fake search run, confirms OCEL 2.0 schema validity.
2. `just tactic-search warmup_nat_add_comm --emit-ocel` followed by
   `ocpa_import_ocel2(<produced-log-path>)` via the MCP tool — round-trip check.
3. `pm4py_discover_dfg` run against the produced log, output (edge list + frequencies)
   included in the PR alongside a short written comparison to Ticket 002's static
   bigram table for the same target, stated as an observation, not a validated claim.
