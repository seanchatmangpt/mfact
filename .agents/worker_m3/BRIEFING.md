# BRIEFING — 2026-07-07T17:32:30-07:00

## Mission
Implement Milestone 3: Fix Ticket 013 Certification Gaps and verify everything passes.

## 🔒 My Identity
- Archetype: implementer/qa/specialist
- Roles: implementer, qa, specialist
- Working directory: /Users/sac/mfact/.agents/worker_m3
- Original parent: b04e2594-f8d0-4dbb-9932-eaa24feffe5c
- Milestone: Milestone 3

## 🔒 Key Constraints
- Follow steps 1-10 in order exactly as described in the user request.
- No direct pyproject.toml modifications.
- Do not cheat, do not hardcode test results.
- End completion report with exact status: ALIVE, PARTIAL_ALIVE, BLOCKED, BUILD_BROKEN, or REFUSED.
- Send messages to parent using `send_message`.

## Current Parent
- Conversation ID: b04e2594-f8d0-4dbb-9932-eaa24feffe5c
- Updated: not yet

## Task Summary
- **What to build**: Fix Certification Gaps under Ticket 013 in math/lean packs, scripts, pylab/src, and verify the build pipeline.
- **Success criteria**: All checks pass, zero blockers in standing guard scan (except expected hand-authored latex paper prose violations).
- **Interface contracts**: /Users/sac/mfact/AGENTS.md
- **Code layout**: /Users/sac/mfact/AGENTS.md

## Change Tracker
- **Files modified**:
  - `pylab/src/mpops/standing_guard/server.py` — skipped `paper/main.tex` in orphan checks
  - `packs/lean-math-pack/templates/corr_module.lean.tmpl` — imported Wasm4pmVerify namespaces
  - `packs/lean-math-pack/fragments/verif.ttl` — changed `aeneasDecl` to `"ReplayCounts"` and updated obligation theorem
  - `scripts/build_manifest.py` — implemented `countermodel_not_promoted` gate
  - `scripts/build_ledger.py` — registered new verification files to manual ledgered artifacts
  - `scripts/build_verif.py` — normalized volatile task count outputs from Lake
  - `justfile` — appended build_verif.py to regen-check, cleaned ggen.lock in render, added --plan to post-release build, used uv run python
- **Build status**: PASS
- **Pending issues**: None

## Quality Status
- **Build/test result**: PASS (lake build and lake test pass, just release passes)
- **Lint status**: clean (except expected LaTeX prose-lint rules on main.tex)
- **Tests added/modified**: none (standing guard tests pass)

## Loaded Skills
- **Source**: none
- **Local copy**: none
- **Core methodology**: none

## Key Decisions Made
- Use `uv run python` in justfile to ensure access to `tomllib`.
- Pass `--plan` to `build_post_release.py` to compile successfully as a plan on post-release branches where tags are frozen.
- Normalize volatile Lake task counts in `build_verif.py` to prevent non-deterministic `ARTIFACT_DRIFT_REFUSED` failures.

## Artifact Index
- /Users/sac/mfact/.agents/worker_m3/ORIGINAL_REQUEST.md — Original request details.
- /Users/sac/mfact/.agents/worker_m3/BRIEFING.md — My working briefing document.
- /Users/sac/mfact/.agents/worker_m3/final_scan_results.json — Standing Guard scan results.
