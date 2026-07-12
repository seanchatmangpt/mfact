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
| 011 | *(intentionally absent — see note below)* | — | — |
| [012a](ticket_012_crown_countermodel.md) | Crown-jewel countermodel: infinite-transition soundness characterization | Crown / Formal Proof | Formalizes the STATED Lean-admitted countermodel theorem `WfNet.infinite_transition_countermodel_sound_not_bounded`, repairing van der Aalst's soundness characterization for the infinite-transition case |
| [012b](ticket_012_receipt.md) | Ticket 012 receipt (theorem identity, files changed, guard) | Crown / Governance | Receipt for 012a's countermodel theorem: status key `WFNET_INFINITE_TRANSITION_COUNTERMODEL`, guard `countermodel_not_promoted`, files changed |
| [012c](ticket_012_workflow_state.md) | Workflow state baseline (crown rail ALIVE snapshot) | Foundation | Baseline-state snapshot preceding the countermodel formalization work |
| [013](ticket_013_v26_7_7_gap_audit.md) | v26.7.7 release gap audit | Governance | Five-rail gap audit before release cut; found a false PROVEN promotion on the countermodel theorem and an unbound D1 correspondence claim |
| [014](ticket_014_standing_guard_mcp.md) | Standing Guard MCP server | Governance / Tooling | Read-only MCP server that continuously re-runs ticket 013's 8 check classes so the same gaps can't silently reappear between audits |
| [015](ticket_015_v26_7_7_reconciliation.md) | v26.7.7 reconciliation and re-certification | Governance | Re-verifies ticket 013's findings against current disk truth (some closed by ticket 012's session work, some still open), fixes the standing.env dedup bug, re-certifies the release tag |
| [016](ticket_016_paper_standing_graph_restructure.md) | Paper restructure: the standing-manufacturing graph | Paper | Reorders `main.tex` around the five-rail architecture (formal / process-law / benchmark / correspondence / paper), promotes Aeneas to a top-level section, opens praxis-graphlaw and rslab placeholders |
| [017](ticket_017_rslab_skeleton.md) | rslab skeleton: the empirical evidence rail | rslab rail | Greenfield `rslab/` directory — schemas, manifest, benchmark plan; DECLARED only, no results yet |
| [018](ticket_018_praxis_graphlaw_benchmark_import.md) | praxis-graphlaw benchmark import | rslab rail | Runs the real, verified-runnable praxis-graphlaw benches/tests and receipts the raw evidence into rslab |
| [019](ticket_019_rslab_paper_fragment_wiring.md) | rslab normalization and paper fragment wiring | rslab rail | Builder scripts turn the rslab receipt into ledgered, gate-wired `.tex` fragments the paper can cite |
| [020](ticket_020_praxis_rslab_paper_sections.md) | praxis-graphlaw and rslab paper sections | Paper | Fills the two placeholder sections with prose once the rslab fragments exist to cite |

**Note on ticket 011**: the number is intentionally absent. Ticket work branched
directly from 010 to the 012 companion set (crown_countermodel / receipt /
workflow_state) with no separate 011 scope ever drafted — this is a numbering
gap in the sequence, not a missing file to recover or backfill.

## Suggested build order

001 → 002 → 003 (the search stack), then 004 and 006 in parallel (both consume 001),
then 007 (needs 001-003 producing search traces to mine), then 005 and 008 are
independent of the rest and can be picked up any time.

For the v26.7.7 paper/rslab track: 015 (governance reconciliation) first, then 016
(paper restructure) and 017 (rslab skeleton) in parallel — both only depend on 015 —
then 018 (needs 017's schemas), then 019 (needs 017 + 018), then 020 (needs 016 + 019).

## What's deliberately not here

- Training any model. Every training pipeline in the 11 papers (TheoremLlama, HTPS,
  HOList) is cited for its *harness* design, never proposed as work here — this repo
  has no GPU fleet and no reason to acquire one for a research surface that never
  feeds standing.
- Anything that writes to `packs/*/fragments/*.ttl` or flips a TTL `status` field.
  Every ticket below produces Candidates; promotion to Admitted stays a human,
  reviewed, separate step through `just render && just build && just audit && just
  manifest && just certify`.
