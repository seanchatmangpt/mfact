# Baseline Exploration Analysis (R0)

## 1. Repository Git Status
The repository is **DIRTY** (not clean). It contains several staged changes, unstaged changes, and untracked files.

### A. Staged Changes (Changes to be committed)
These changes are already added to the index and ready to be committed:
* **Modified (Ledger & Manifests):**
  * `.mfact/artifacts.toml` (ledgered artifacts list)
  * `release/release-manifest.json` (release manifest)
  * `scripts/build_ledger.py` (ledger builder script)
* **Modified (Ontology & Lean):**
  * `packs/quadrature-pack/ontology.ttl` (ontological definitions)
  * `procint/ProcInt/Release/Quadrature.lean` (rendered quadrature witness module)
* **Modified (Ggen Infrastructure):**
  * `.ggen-v2/receipt.json` & `.ggen-v2/receipt-log.jsonl` (ggen generation state)
  * `ggen.lock` (lockfile)
  * `justfile` (added git push recipe and release artifact reconciliation)
* **Modified (Paper / Latex):**
  * `paper/main.tex` (prose spine)
  * `paper/release_macros.tex` (release stats/macros)
  * `release/quadrature.json` & `release/quadrature.md` (quadrature reports)
* **New Files (Rslab Experiment):**
  * `rslab/paper_fragments/rslab_praxis_graphlaw_benchmarks.tex`
  * `rslab/paper_fragments/rslab_praxis_graphlaw_profiles.tex`
  * `rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex`
  * `rslab/paper_fragments/rslab_readiness.tex`
  * `rslab/scripts/collect_praxis_graphlaw.py`
  * `rslab/scripts/render_paper_fragments.py`

### B. Unstaged Changes (Changes not staged for commit)
* **Modified (Agent Workspace Files):**
  * `.agents/orchestrator_tickets_015_020/BRIEFING.md`
  * `.agents/sentinel/BRIEFING.md`
  * `.agents/sentinel/handoff.md`

### C. Untracked Files
* **Directories & Files:**
  * `.agents/orchestrator_tickets_015_020_gen2/`
  * `.agents/teamwork_preview_explorer_r0_gen2/` (our workspace)
  * `.agents/worker_step4/`
  * `ORIGINAL_REQUEST.md` (root directory)
  * `rslab/experiments/praxis_graphlaw/processed/`

---

## 2. Current HEAD Commit Hash
The HEAD commit hash is:
`945bfca5f1a91c4a20b97705b65fc695d16f973e`

---

## 3. Tag `v26.7.7-procint-certified` Commit and History
* **Tag Commit Hash:**
  `aff3c95d887b623a38496854efba0464e5ffbec2`
* **HEAD Match:**
  HEAD does **not** match this tag. The tag points to an ancestor commit, and HEAD is 2 commits ahead of the tag.
* **Relationship:**
  HEAD is a direct descendant of the tag (the commit history is a straight line from the tag to HEAD).
* **Commits Between Tag and HEAD:**
  There are exactly 2 commits between `v26.7.7-procint-certified` (exclusive) and HEAD (inclusive):
  1. `e8a5709 Ticket 018: praxis-graphlaw Benchmark Import`
  2. `945bfca reconcile release artifacts and add git push recipe`

---

## 4. Standing Guard Execution
Standing Guard is implemented as a FastMCP server in `pylab/src/mpops/standing_guard/server.py`. 

### A. Execution Methods
1. **As an MCP Server:**
   `uv run python -m mpops.standing_guard.server` (starts the FastMCP server on stdio).
2. **Programmatically:**
   ```python
   from mpops.standing_guard.server import scan
   findings = scan()
   ```

### B. Execution Viability
Yes, we can run Standing Guard.
* Running `uv run pytest tests/test_standing_guard.py` in `pylab/` runs the test suite successfully and passes all tests (`test_scan_callable` and `test_no_mutation_capabilities`).
* Running `scan()` programmatically via Python (`uv run python -c ...`) successfully checks the repository integrity and produces a list of findings.

### C. Scan Findings (Summary)
Running the scan in the baseline state yields:
* **Class 4 (REGEN_CHECK_COVERAGE_GAP):** Several warnings. Multiple release artifacts (`paper/evaluation.tex`, `release/release-manifest.json`, `release/gates.json`, `release/standing.env`, `release/replay_report.json`, `release/docs_report.json`) have declared producers that are not executed or referenced in the `regen-check` recipe in `justfile`.
* **Class 6 (TAG_ANCESTRY_FAIL):** One blocker. Tag `v26.7.7-procint-certified` (`aff3c95d`) is not an ancestor of the currently-rendered commit (`945bfca5`). This is also reported by `just doctor` as:
  `FAIL   tag gate: v26.7.7-procint-certified @ aff3c95 descends from rendered commit 945bfca`
* **Class 8 (PROSE_LINT_VIOLATION):** Multiple warnings. `paper/main.tex` contains absolute adverbs (e.g. "completely", "never"), bare "hash"/"chain" references, or "proof"/"prove" words used without formal Lean/lake/kernel context.
* **Passed Gates:** Sorry Theorem Promotion (Class 1), Ledger Drift (Class 2), Orphan Artifacts (Class 3), Correspondence Binding (Class 5), and Untracked Ontology Fragments (Class 7) all pass without findings.
