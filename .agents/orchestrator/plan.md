# Project Plan: Ticket 013 & 014 Remediation and Guarding

This document outlines the step-by-step milestones to restore the `v26.7.7` release to clean certified standing (Ticket 013) and construct the read-only Standing Guard MCP server (Ticket 014).

## Architecture & Scope
The project spans three main components:
1. **Introspection & Monitoring (`pylab/`)**: Implementing `pylab/src/mpops/standing_guard/` as a read-only MCP server exposing `scan()`.
2. **Lean Specification & Correctness (`procint/`, `mfact/`)**: Repairing the countermodel theorem, AxiomAudit, correspondence proofs, and negative controls.
3. **Release & Paper Packaging (`release/`, `paper/`)**: Regenerating manifest, ledger, eval-tex, and cutting the clean certified release tag.

## Milestones

| # | Milestone Name | Scope | Dependencies | Status |
|---|----------------|-------|--------------|--------|
| 1 | Establish Baseline Failure | Identify all 8 gap classes on baseline tree, run baseline `scan()` mock/draft to confirm detections. | None | PLANNED |
| 2 | Build Standing Guard MCP Server | Create read-only MCP server exposing `scan()` returning structured findings. | M1 | PLANNED |
| 3 | Fix Ticket 013 Certification Gaps | Demote countermodel, rebind correspondence theorem, fix AxiomAudit, run negative controls, rebuild ledger. | M1 | PLANNED |
| 4 | Final Scan and Validation | Run final `scan()` (zero BLOCKERs), run `just check` & `just release` to green status. | M2, M3 | PLANNED |
| 5 | Release Tag & Certification | Re-cut `v26.7.7-procint-certified` tag pointing to clean certified release commit. | M4 | PLANNED |

## Milestone Details & Verification

### Milestone 1: Establish Baseline Failure
- **Tasks**:
  - Run diagnostic recipes (`just status`, `just doctor`) on the current tree.
  - Identify and record the exact baseline commit hash.
  - Draft a temporary python script/mock `scan()` representing the 8 gap classes to verify they are all detected as blockers on this baseline.
- **Verification**: Handoff from explorer documenting baseline tag/commit, and logs of the initial failures detected.

### Milestone 2: Build Standing Guard MCP Server
- **Tasks**:
  - Implement read-only MCP server in `pylab/src/mpops/standing_guard/`.
  - Expose `scan()` tool checking the 8 gap classes from Ticket 013.
  - Add unit/integration tests verifying that the server has zero mutation capabilities.
- **Verification**: pytest results for pylab tests running successfully; documentation of the read-only boundary.

### Milestone 3: Fix Ticket 013 Certification Gaps
- **Tasks**:
  - Demote `infinite_transition_countermodel_sound_not_bounded` to `STATED` in both TTL files.
  - Implement `countermodel_not_promoted` guard, `WFNET_INFINITE_TRANSITION_COUNTERMODEL` status key, and `COUNTERMODEL_PROMOTION_REFUSED` refusal.
  - Fix `AxiomAudit.lean` expected messages block to expect the sorryAx-bearing output.
  - Rebind `token_replay_counts_corr` to `Generated/Abs.toSpec`, prove, render, and update `aeneasDecl` in the receipt.
  - Run negative controls and verify they refuse poisoned copies; record logs/receipts.
  - Rebuild ledger `.mfact/artifacts.toml` and eliminate ledger hash drift.
  - Re-materialize proofs and commit the changes selectively.
  - Fix paper inconsistencies in `evaluation.tex` via the evaluation script.
- **Verification**: `just build`, `just audit`, `just manifest`, `just eval-tex`, `just certify`, `just standing-quadrature` all passing.

### Milestone 4: Final Scan and Validation
- **Tasks**:
  - Run the final `scan()` via the newly built Standing Guard MCP server and verify zero `BLOCKER` findings.
  - Run `just check` and `just release`.
- **Verification**: Output log showing zero blockers from Standing Guard scan and successful completion of `just check` and `just release`.

### Milestone 5: Release Tag & Certification
- **Tasks**:
  - Verify that the release commit is an ancestor of the tag to be cut.
  - Cut the tag `v26.7.7-procint-certified`.
- **Verification**: git tag check showing tag points to the final clean release commit.
