# Ticket: Local Premise Retrieval — LeanExplore's Recipe Over procint

## Title
`premise_search` MCP tool: LeanExplore's hybrid ranking recipe run against procint's
own declarations, not just Mathlib

## Description
**LeanExplore** (arXiv:2506.11085, Asher) ships as a pip-installable package: a
synchronous local `Service` class (offline, downloadable prebuilt index) plus its own
MCP server. Its ranking recipe is fully specified and light: embed the query with
**bge-base-en-v1.5** (109M params), FAISS IVF search (4096 cells), a semantic-similarity
threshold (default 0.525) to filter candidates, then combine **BM25+** lexical score
and **log-transformed PageRank** over the declaration dependency graph, min-max
normalized and linearly combined with default weights semantic:BM25+:PageRank =
1.0:1.0:0.2. On a 300-query benchmark judged by an independent model, this configuration
ranked the correct result first 55.4% of the time vs 46.3% for a prior tool
(LeanSearth) using a much larger 7B embedding model — the paper's evidence that the
hybrid recipe, not model size, is doing the work.

The prebuilt LeanExplore index covers Mathlib, Std, Batteries, Init, PhysLean — **not**
`procint`'s own declarations. Wiring the prebuilt package in as a thin MCP wrapper
(same shape as the existing `registry_lookup` tool) is a same-day integration and gives
retrieval over the Mathlib surface `procint` actually imports from. Building a *local*
index over `procint/ProcInt/**` using the same recipe is the ticket's second half — it
answers a question the published tool cannot: "what's the closest existing lemma to
this goal, inside this repo."

## Design

**Part A — prebuilt Mathlib index wrapper (small, do first)**:
- `premise_search(query: str, k: int = 10) -> list[Result]` MCP tool wrapping
  LeanExplore's local `Service` class directly. Read-only, same governance tier as
  `registry_lookup`.

**Part B — local procint index (the actually novel half)**:
- Extract `procint/ProcInt/**` declarations (name, docstring, signature, defining file)
  via a `lake env lean` metaprogram dump or by walking `.olean`/source in the same way
  `registry_lookup` already parses `ontology/procint-schema.ttl`-adjacent structure —
  reuse whatever extraction `registry_lookup` already does if it's close enough;
  otherwise a small new extractor.
- Embed each declaration's name + docstring + signature text with bge-base-en-v1.5
  (already a light, local, CPU-feasible model — no informal-translation LLM step
  required, at the recall cost the paper itself notes for that simplification).
- Build a FAISS index (scale down the 4096-cell IVF setting for procint's much smaller
  declaration count — a flat index may be entirely sufficient at this scale; measure
  before assuming IVF is needed) plus BM25+ over the same text, and a PageRank over the
  import/reference dependency graph within `procint/ProcInt/**`.
- Combine with the paper's default weights (1.0/1.0/0.2, threshold 0.525) as a starting
  configuration, not a fixed final one — re-tune only if procint-scale results are
  visibly worse than that default suggests, and log any deviation with a reason.

This tool is what parameterizes the `aesop (add <lemma>)` / premise-taking genes
proposed for the GP vocabulary in the broader search work (Tickets 002-003) — instead
of a fixed hand-picked lemma list, the GP can query "what's near this goal" and use the
answer as a mutation.

## Acceptance Criteria
- Part A: `premise_search` MCP tool live, queryable, read-only, tested against at least
  3 known Mathlib lemmas relevant to `procint`'s own imports (e.g. something from the
  metric/topology or Petri-net-adjacent Mathlib surface `procint` actually uses).
- Part B: a local index build script (`build_procint_index.py`) that runs over
  `procint/ProcInt/**`, producing an index file `pylab` can query; a `premise_search_local`
  tool (or a `scope` parameter on the existing tool distinguishing "mathlib" vs
  "procint") returns results from it.
- Both parts stay read-only, pylab-tier, never touch `procint/ProcInt/**` source or the
  ledger.
- The index-build step for Part B is idempotent and re-runnable (procint's declarations
  will grow over time) — document how to regenerate it in `docs/`.

## Dependencies
None strictly required, though Part B is more useful once Tickets 002-003 exist to
consume it.

## Verification Mechanism
1. `cd pylab && uv run pytest tests/test_premise_search.py` — Part A queries against
   known Mathlib lemmas return sane top-k results; Part B queries against a known
   `procint` declaration return that declaration (or a close relative) in the top-k.
2. MCP smoke test for both tools via the existing `mcp_procint` server harness.
3. Manual spot-check: query the local procint index with the goal text from one of the
   `TacticSearchWarmup.lean` targets, confirm the top result is plausible (logged in
   the PR, not a formal metric — this is a research-surface sanity check, not a claim
   of retrieval quality parity with the paper's 300-query benchmark).
