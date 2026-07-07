# pylab v26.7.7 Tickets — Paper-Derived Feature Requests

Source: 11 arXiv papers in `~/mfact/papers/` read in full (four parallel passes,
2026-07-07). Findings are synthesized in `~/mfact/PYLAB-PRD-ARD-v26.7.7.md` §12;
these tickets are that section broken into buildable, independently-scoped units.

All tickets stay at **Playground/pylab governance tier**: off-ledger, never feeds
`release/gates.json` or `.mfact/artifacts.toml`, never added to `just build`/`just
check`/`just release`. Search/LLM output is always an untrusted Candidate; kernel
acceptance (`lake env lean` exit 0) is the only pass signal for anything Lean-side.
A ticket that would change that boundary must say so explicitly and is out of scope
here — that's a core-repo decision, not a pylab one.

| # | Title | Tier | Novelty for the paper |
|---|---|---|---|
| [001](ticket_001_persistent_proof_env.md) | Persistent proof environment (LSP fitness oracle) | Foundation | Enables everything below; not itself a paper claim |
| [002](ticket_002_tactic_corpus_mining.md) | Data-derived tactic vocabulary + bigram re-ranking | Search quality | Reproduces PGTS's mechanism on Lean 4/mfact, not Coq |
| [003](ticket_003_hypertree_gp_search.md) | Genetic population as the policy inside AND-hypergraph search | **Novel combination** | No read paper combines GP (TPOT2-style) with HTPS-style AND-hypergraph search — this pairing doesn't exist in the literature surveyed |
| [004](ticket_004_deterministic_repair_harness.md) | Deterministic sorry-repair harness + Lean-3-ism linter | Repair | LLM-free reconstruction of APOLLO's mechanical stages |
| [005](ticket_005_second_kernel_receipt.md) | Second-kernel receipt via Lean4Lean | Trust boundary | Directly receipt-relevant — the one ticket with a path into `release/gates.json`, gated on a human decision |
| [006](ticket_006_premise_retrieval.md) | Local premise retrieval (LeanExplore recipe over procint) | Search quality | LeanExplore's hybrid ranking has never been run against a project this small |
| [007](ticket_007_search_as_event_log.md) | Proof search as an OCEL 2.0 event log, process-mined by this repo's own tools | **Crown / groundbreaking** | Unifies the repo's two halves (Lean proof manufacturing, process intelligence) which currently only share an RDF ontology, not data |
| [008](ticket_008_tpot2_pipeline_automl.md) | Actual TPOT2 pipeline evolution over process-mining pipelines | Closes the loop | Answers the original "what about TPOT2" question with a real execution surface (pylab has one; procint doesn't) |
| [009](ticket_009_mpops_cli.md) | mpops Outside-In CLI | UX / Tooling | Establishes the product-shaped developer cockpit while strictly preserving the trusted manufacturing boundary |
| [010](ticket_010_mpops_rename.md) | Rename All mpops References (from math-factory-pylab) | DX / Naming | Finalizes the CLI namespace eradication of the old name |
| [012](ticket_012_workflow_state.md) | Workflow state baseline (crown rail ALIVE snapshot) | Foundation | Baseline-state snapshot preceding the countermodel formalization work |
| [013](ticket_013_v26_7_7_gap_audit.md) | v26.7.7 release gap audit | Governance | Five-rail gap audit before release cut; found a false PROVEN promotion on the countermodel theorem and an unbound D1 correspondence claim |
| [014](ticket_014_standing_guard_mcp.md) | Standing Guard MCP server | Governance / Tooling | Read-only MCP server that continuously re-runs ticket 013's 8 check classes so the same gaps can't silently reappear between audits |

## Suggested build order

001 → 002 → 003 (the search stack), then 004 and 006 in parallel (both consume 001),
then 007 (needs 001-003 producing search traces to mine), then 005 and 008 are
independent of the rest and can be picked up any time.

## What's deliberately not here

- Training any model. Every training pipeline in the 11 papers (TheoremLlama, HTPS,
  HOList) is cited for its *harness* design, never proposed as work here — this repo
  has no GPU fleet and no reason to acquire one for a research surface that never
  feeds standing.
- Anything that writes to `packs/*/fragments/*.ttl` or flips a TTL `status` field.
  Every ticket below produces Candidates; promotion to Admitted stays a human,
  reviewed, separate step through `just render && just build && just audit && just
  manifest && just certify`.
