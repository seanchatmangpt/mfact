# Project: Ticket 013 & 014 Remediation and Guarding

## Architecture
This project focuses on two tracks:
- **Implementation Track**: Restoring the v26.7.7 release to clean certified standing by demoting the countermodel theorem, implementing the `countermodel_not_promoted` guard, fixing `AxiomAudit.lean`, and re-binding the D1 correspondence theorem.
- **E2E Testing Track**: Designing a comprehensive opaque-box test suite to verify all features and boundary cases, resulting in `TEST_READY.md`.

## Code Layout
- `packs/lean-math-pack/fragments/`: Catalog of source declarations (TTL fragments).
- `packs/lean-math-pack/templates/`: Projection templates for ggen.
- `procint/ProcInt/`: Lean source code.
- `pylab/src/mpops/standing_guard/`: Standing Guard MCP server and checks.
- `release/`: Certification manifests, gates, and statuses.
- `scripts/`: Builders, gates, and negative controls.

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|---|---|-------------|--------|
| 1 | Establish Baseline Failure | Run initial diagnostic checks, extract current tag/commit, and verify baseline failures. | None | DONE |
| 2 | Build Standing Guard MCP Server | Implement read-only MCP server at `pylab/src/mpops/standing_guard/` checking 8 gap classes. | M1 | DONE |
| 3 | Fix Ticket 013 Certification Gaps | Remediate the 013 gaps in Lean, manifests, and scripts. | M1 | DONE |
| 4 | Final Scan and Validation | Run Standing Guard final scan (zero blockers) and verify `just check` & `just release`. | M2, M3 | DONE |
| 5 | Release Tag & Certification | Verify tag ancestry and re-cut `v26.7.7-procint-certified` tag. | M4 | DONE |

## Interface Contracts
### Standing Guard MCP ↔ Release Toolchain
- `scan()` tool reads `.mfact/artifacts.toml`, `release/`, `procint/`, and `packs/` to verify release cleanliness without modifying any files.
