# Project Execution Plan — Tickets 015-020

## Overview
Decompose the final launch phase into sequential milestones:
1. **R0. Freeze Certified State**: Confirm git cleanliness, head commit, and Standing Guard blockers. Collect baselines.
2. **R1. Governance Reconciliation (Ticket 015)**: Verify previous ticket outcomes, fix `standing.env` deduplication in `justfile`, and re-run canonical certification.
3. **R2. Paper Restructure and rslab Skeleton (Tickets 016 & 017)**: Restructure LaTeX paper around 5 rails. Create `mfact/rslab/` layout, manifest, and JSON schemas.
4. **R3. Import Benchmarks and Normalize (Tickets 018 & 019)**: Autonomously run praxis benchmarks from `/Users/sac/praxis`. Write collector and renderer scripts, generate receipts/fragments, and integrate into release.
5. **R4. Final Paper Prose (Ticket 020)**: Complete structural prose in `paper/main.tex` referencing fragments, perform validation, and run audits.
6. **Final Audit**: Verify all DoD items, check tags, run Forensic Auditor, and report final status to the sentinel.

## Verification Checklist
- `just check` passes
- `just release` passes
- `just regen-check` passes
- `just paper-check` passes
- Zero blockers in Standing Guard
- Schema-validated receipts and generated LaTeX fragments
- No handcoded numbers in `paper/main.tex`
