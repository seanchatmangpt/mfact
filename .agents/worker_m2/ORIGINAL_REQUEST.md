## 2026-07-07T23:47:16Z

Your identity: teamwork_preview_worker (worker_m2).
Your working directory is: /Users/sac/mfact/.agents/worker_m2.

Your task is to implement Milestone 2: Build Standing Guard MCP Server.

1. Implement the read-only MCP server under `pylab/src/mpops/standing_guard/` with:
   - `__init__.py`
   - `server.py`

The server must expose a callable `scan()` tool.
`scan()` must return a list of findings, where each finding is a dictionary containing:
- `gap_class` (1 to 8)
- `severity` ("BLOCKER", "WARNING", or "INFO")
- `refusal_code` (e.g. "SORRY_THEOREM_PROMOTED", "ARTIFACT_DRIFT_REFUSED", "ORPHAN_ARTIFACT_REFUSED", "REGEN_CHECK_COVERAGE_GAP", "STALE_PROOF_BINDING", "TAG_ANCESTRY_FAIL", "UNTRACKED_ONTOLOGY_FRAGMENT", "STALE_PAPER_PROSE_COUNT")
- `path_or_target` (file path or theorem name)
- `evidence` (the exact issue found)
- `expected` (expected value/state)
- `actual` (actual value/state)
- `recommended_action` (how to fix it)
- `standing_status` (associated standing status, e.g. "PROVEN", "STATED", "DECLARED", "REFUSED")

Implement the 8 check classes inside `scan()`:
Class 1 (Sorry Theorem Promotion):
- Scan `packs/lean-math-pack/fragments/*.ttl` and `ontology.ttl` for `procint:status "proven"`.
- Extract the declaration names (e.g. `ProcInt.WfNet.infinite_transition_countermodel_sound_not_bounded` or `ProcInt.crownCounter_sound`).
- For each proven decl, run `lake env lean --stdin` (with cwd `procint/`) to execute `#print axioms <name>`. If `sorryAx` is in the output, it is a SORRY_THEOREM_PROMOTED finding.

Class 2 (Ledger Drift):
- Read `.mfact/artifacts.toml`. Compute the blake3 hash (b3sum) of each artifact file.
- If it disagrees with `content_hash` (stripped of "blake3:"), flag it.
- Also, check if any ledgered artifact is untracked in git. If git command `git ls-files --error-unmatch <path>` fails or `git status` shows it as untracked, flag it.

Class 3 (Orphan Artifact Scan):
- Scan the directory tree for files matching `release/*.json`, `paper/*.tex`, and check if they are NOT in `.mfact/artifacts.toml` (excluding `procint/Playground/**` and `pylab/**`).
- If any match and contain standing-bearing patterns or are part of release/paper, flag as ORPHAN_ARTIFACT_REFUSED.

Class 4 (regen-check coverage gap):
- Parse the `justfile` at the root and look at the `regen-check:` recipe body.
- For every artifact in `artifacts.toml`, check if its declared `producer` script/command is executed or referenced in the `regen-check:` recipe body. If not, flag it.

Class 5 (Correspondence binding check):
- Read `release/verif-receipt.json`. If `aeneasDecl` is `"TBD"` or if any obligations marked PROVEN do not import or reference the extraction module, flag it as STALE_PROOF_BINDING.

Class 6 (Tag ancestry check):
- Check if tag `v26.7.7-procint-certified` is cut. If so, verify if it is an ancestor of HEAD using `git merge-base --is-ancestor v26.7.7-procint-certified HEAD`. Compare with `release/release-manifest.json` `runIdentifier`. If ancestry check fails, flag as TAG_ANCESTRY_FAIL.

Class 7 (Untracked-fragment-feeds-ontology check):
- List files in `packs/*/fragments/*.ttl` and check if any are untracked in git. If untracked, flag as UNTRACKED_ONTOLOGY_FRAGMENT (e.g. `packs/lean-math-pack/fragments/workflow_countermodel.ttl`).

Class 8 (Prose/paper consistency check):
- Search `paper/main.tex` for stale counts (like "145" when actual proven count from release-manifest is 197 or 202) and any violations of rules in `paper/PROSE_LINT_RULES_CORRESPONDENCE.md` (like "Aeneas proves/verified/checked/certified").

2. Add a pytest test file at `pylab/tests/test_standing_guard.py` verifying that:
   - `scan()` is callable and returns findings.
   - The Standing Guard server contains absolutely no mutation capabilities (write, open in write mode, git commits, release, etc.). Add a static test that reads `pylab/src/mpops/standing_guard/server.py` and asserts that there are no write commands, no `open(..., "w")`, and it only uses read operations.
   - Run `pytest pylab/tests/test_standing_guard.py` and make sure it passes.

3. Run the baseline scan (with no repairs applied yet) using `scan()`. Capture its output and save it to `/Users/sac/mfact/.agents/worker_m2/baseline_scan_results.json`.

Ensure all code follows the styling of pylab/src/mpops/mcp_procint/server.py.
MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.
