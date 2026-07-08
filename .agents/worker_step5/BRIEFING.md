# BRIEFING — 2026-07-07T18:41:58-07:00

## Mission
Implement Ticket 020: praxis-graphlaw and rslab Paper Prose

## 🔒 My Identity
- Archetype: worker
- Roles: implementer, qa, specialist
- Working directory: /Users/sac/mfact/.agents/worker_step5
- Original parent: 20c65592-2085-438d-b840-67958478044b
- Milestone: Ticket 020

## 🔒 Key Constraints
- CODE_ONLY network mode.
- Actuate only through `just` recipes (No raw lake/ggen/mfact commands unless instructed).
- Minimal change principle.
- No direct pyproject.toml modifications.
- Deprecate `l2p`.

## Current Parent
- Conversation ID: 20c65592-2085-438d-b840-67958478044b
- Updated: not yet

## Task Summary
- **What to build**: Replace placeholder sections in `paper/main.tex` with detailed prose for Section 9 (praxis-graphlaw) and Section 10 (rslab).
- **Success criteria**:
  1. `just prose-lint` and `just paper-check` pass.
  2. `just regen-check` passes.
  3. `just release` passes and outputs `release/FINAL_STATUS.md`.
  4. `just arxiv-package` produces `paper/arxiv-submission.tar.gz` containing four paper fragments under `rslab/paper_fragments/...`.
  5. Commit with `just commit "Ticket 020: praxis-graphlaw and rslab Paper Prose"`.
- **Interface contracts**: /Users/sac/mfact/AGENTS.md
- **Code layout**: /Users/sac/mfact/AGENTS.md

## Key Decisions Made
- None yet

## Artifact Index
- None yet
