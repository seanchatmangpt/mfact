# BRIEFING — 2026-07-07T19:08:28-07:00

## Mission
Finalize Ticket 020 by checking, releasing, committing, recutting release tag, and verifying status.

## 🔒 My Identity
- Archetype: Finalizer / Teamwork Agent
- Roles: implementer, qa, specialist
- Working directory: /Users/sac/mfact/.agents/teamwork_preview_worker_finalize_gen2/
- Original parent: 6b5e83bd-0355-4ec4-a8f4-22be6eca6a88
- Milestone: Ticket 020 Finalization

## 🔒 Key Constraints
- Actuate only through `just` recipes. Do not run ad-hoc commands for building/testing/tagging if `just` recipes exist.
- CODE_ONLY network mode. No internet/external API access.
- Do not edit release manifest, hashes, or generated artifacts by hand.
- End completion report with exact status: ALIVE, PARTIAL_ALIVE, BLOCKED, BUILD_BROKEN, or REFUSED.

## Current Parent
- Conversation ID: 6b5e83bd-0355-4ec4-a8f4-22be6eca6a88
- Updated: 2026-07-07T19:08:28-07:00

## Task Summary
- **What to build**: Verification, release packaging, committing, and tagging.
- **Success criteria**: `just check` passes, `just release` passes, git commit created, tag recut, `just status` and `just doctor` verify tag is green.
- **Interface contracts**: `/Users/sac/mfact/AGENTS.md`
- **Code layout**: `/Users/sac/mfact/AGENTS.md`

## Key Decisions Made
- Follow Workflow Protocol and Agent Actuation Constitution strictly.

## Artifact Index
- /Users/sac/mfact/.agents/teamwork_preview_worker_finalize_gen2/handoff.md — Handoff report for parent agent
