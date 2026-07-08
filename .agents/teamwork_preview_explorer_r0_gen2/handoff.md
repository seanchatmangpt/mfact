# Handoff Report: Baseline Investigation (R0)

## 1. Observation
The following observations were made using read-only filesystem check tools and diagnostic repository commands:

### A. Git Status and Repository Cleanliness
* Running `git status` returned a dirty working directory with staged modifications to ledger, manifest, and paper files:
```
Changes to be committed:
	modified:   .ggen-v2/receipt-log.jsonl
	modified:   .ggen-v2/receipt.json
	modified:   .mfact/artifacts.toml
	modified:   ggen.lock
	modified:   justfile
	modified:   packs/quadrature-pack/ontology.ttl
	modified:   paper/main.tex
	modified:   paper/release_macros.tex
	modified:   procint/ProcInt/Release/Quadrature.lean
	modified:   release/quadrature.json
	modified:   release/quadrature.md
	modified:   release/release-manifest.json
	new file:   rslab/paper_fragments/rslab_praxis_graphlaw_benchmarks.tex
	new file:   rslab/paper_fragments/rslab_praxis_graphlaw_profiles.tex
	new file:   rslab/paper_fragments/rslab_praxis_graphlaw_summary.tex
	new file:   rslab/paper_fragments/rslab_readiness.tex
	new file:   rslab/scripts/collect_praxis_graphlaw.py
	new file:   rslab/scripts/render_paper_fragments.py
	modified:   scripts/build_ledger.py

Changes not staged for commit:
	modified:   .agents/orchestrator_tickets_015_020/BRIEFING.md
	modified:   .agents/sentinel/BRIEFING.md
	modified:   .agents/sentinel/handoff.md

Untracked files:
	.agents/orchestrator_tickets_015_020_gen2/
	.agents/teamwork_preview_explorer_r0_gen2/
	.agents/worker_step4/
	ORIGINAL_REQUEST.md
	rslab/experiments/praxis_graphlaw/processed/
```

### B. HEAD and Release Tag Commit Hashes
* Current HEAD commit:
```
945bfca5f1a91c4a20b97705b65fc695d16f973e
```
* Commit pointed to by tag `v26.7.7-procint-certified`:
```
aff3c95d887b623a38496854efba0464e5ffbec2
```

### C. Relationship Between HEAD and Tag
* Running `git log --oneline aff3c95d887b623a38496854efba0464e5ffbec2..HEAD` returned:
```
945bfca reconcile release artifacts and add git push recipe
e8a5709 Ticket 018: praxis-graphlaw Benchmark Import
```
* Running `git log --oneline HEAD..aff3c95d887b623a38496854efba0464e5ffbec2` returned nothing, confirming HEAD is a descendant of the tag.

### D. Standing Guard Implementation and Execution
* Standing Guard is defined as a FastMCP server in `pylab/src/mpops/standing_guard/server.py`.
* Line 3 of `pylab/src/mpops/standing_guard/server.py` states: `Run with uv run python -m mpops.standing_guard.server`.
* Running `uv run pytest tests/test_standing_guard.py` in `pylab/` succeeded:
```
tests/test_standing_guard.py::test_scan_callable PASSED                  [ 50%]
tests/test_standing_guard.py::test_no_mutation_capabilities PASSED       [100%]
============================== 2 passed in 41.78s ==============================
```
* Running Standing Guard's `scan()` function programmatically via Python `uv run python -c "from mpops.standing_guard.server import scan; import pprint; pprint.pprint(scan())"` returned a list of findings including:
  * Class 4 (Coverage Gaps) warnings for `release/release-manifest.json`, `release/gates.json`, `release/standing.env`, `release/replay_report.json`, `release/docs_report.json`, `paper/evaluation.tex`.
  * Class 6 (Tag Ancestry Fail) blocker: `Tag v26.7.7-procint-certified (aff3c95d) is not an ancestor of HEAD or runIdentifier (945bfca5)`.
  * Class 8 (Prose Lint Violations) warnings in `paper/main.tex`.
* Running `just doctor` confirmed the tag ancestry failure:
```
FAIL   tag gate: v26.7.7-procint-certified @ aff3c95 descends from rendered commit 945bfca
```

---

## 2. Logic Chain
1. **Repository Cleanliness:** Observations in Section 1.A show that there are staged modifications (including ontology, manifest, ledger, and paper changes), unstaged files, and untracked files. Thus, the repository is dirty.
2. **Commit Relationship:** Comparing the commit hash of HEAD (`945bfca5...`) and the tag `v26.7.7-procint-certified` (`aff3c95d...`) shows they do not match. The tag is an ancestor of HEAD, and there are exactly 2 commits separating them (Observations 1.B & 1.C).
3. **Standing Guard Viability:** The test suite targeted at Standing Guard passes, and programmatic execution of the `scan()` function succeeds (Observation 1.D). This confirms that Standing Guard can be run safely (without modifying filesystem state) to identify gaps.
4. **Tag Ancestry Failure Reason:** Standing Guard checks if the manifest's `runIdentifier` is an ancestor of the certified tag `v26.7.7-procint-certified`. Since the manifest was rendered at `945bfca5` (which is a descendant of the tag at `aff3c95d`), `945bfca5` is not an ancestor of `aff3c95d`, causing the gate to report a failure.

---

## 3. Caveats
* **Environment Configuration:** The Starlette/FastAPI pytest suite in `pylab/tests/test_api.py` failed compilation due to a deprecation warning about `httpx`/`httpx2` under Python 3.13.9. While we bypassed this by targeting only the Standing Guard tests, this environment warning blocks the full `just pylab` command.
* **Sibling Repositories:** The verification step targets obligations mapping rust files under a sibling repo (`wasm4pm-compat`). The path mapping is assumed to be `../wasm4pm-compat`. We did not verify the cleanliness or existence of files in that repository beyond confirming that the correspondence definitions compile in Lean.

---

## 4. Conclusion
* The repository is currently in a **DIRTY** post-release state, positioned 2 commits ahead of the certified release tag `v26.7.7-procint-certified`.
* Standing Guard is fully functional and can be executed programmatically or as an MCP server.
* The repository currently fails the tag ancestry gate because newer commits (`e8a5709` and `945bfca`) were applied to the tree, rendering new release artifacts whose `runIdentifier` commits succeed the tag commit.

---

## 5. Verification Method
To independently verify this baseline assessment, execute the following commands in the repository root:
1. **Verify Git Cleanliness & History:**
   `git status` (shows dirty files)
   `git rev-parse HEAD` (verifies HEAD is `945bfca5f1a91c4a20b97705b65fc695d16f973e`)
   `git rev-parse v26.7.7-procint-certified` (verifies tag is `aff3c95d887b623a38496854efba0464e5ffbec2`)
2. **Verify Standing Guard Tests:**
   `cd pylab && uv run pytest tests/test_standing_guard.py`
3. **Verify Standing Guard Scan Function:**
   `cd pylab && uv run python -c "from mpops.standing_guard.server import scan; import pprint; pprint.pprint(scan())"`
4. **Verify Tag Gate via Just:**
   `just doctor` (observe `FAIL   tag gate: v26.7.7-procint-certified @ aff3c95...`)
