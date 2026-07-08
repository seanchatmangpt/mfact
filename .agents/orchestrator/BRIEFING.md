# BRIEFING — 2026-07-07T16:45:25-07:00

## Mission
Restore the v26.7.7 release to clean certified standing (Ticket 013) and build the Standing Guard MCP server (Ticket 014).

## 🔒 My Identity
- Archetype: teamwork_preview_orchestrator
- Roles: orchestrator, user_liaison, human_reporter, successor
- Working directory: /Users/sac/mfact/.agents/orchestrator
- Original parent: parent
- Original parent conversation ID: 6368409e-7f0c-4e82-b553-fdb9a554042a

## 🔒 My Workflow
- **Pattern**: Project
- **Scope document**: /Users/sac/mfact/PROJECT.md
1. **Decompose**: Split into distinct tracks and milestones: Baseline exploration, Ticket 014 Standing Guard MCP, Ticket 013 repairs, E2E testing, release pipeline checks, and final release tag execution.
2. **Dispatch & Execute** (pick ONE):
   - **Delegate (sub-orchestrator)**: Spawn sub-orchestrators for milestones or run Explorer -> Worker -> Reviewer loop via dispatching specialized subagents.
3. **On failure** (in this order):
   - Retry: nudge stuck agent or re-send task
   - Replace: spawn fresh agent with partial progress
   - Skip: proceed without (only if non-critical)
   - Redistribute: split stuck agent's remaining work
   - Redesign: re-partition decomposition
   - Escalate: report to parent (sub-orchestrators only, last resort)
4. **Succession**: Self-succeed at 16 spawns, write handoff.md, spawn successor.
- **Work items**:
  1. Establish Baseline Failure [pending]
  2. Build Standing Guard MCP Server [pending]
  3. Fix Ticket 013 Certification Gaps [pending]
  4. Run Final Standing Guard Scan [pending]
  5. Run Canonical Release Pipeline [pending]
  6. Cut Clean Release Tag [pending]
- **Current phase**: 1
- **Current focus**: Establish Baseline Failure

## 🔒 Key Constraints
- Never write, modify, or create source code files directly.
- Never run build/test commands yourself — require workers to do so.
- Never reuse a subagent after it has delivered its handoff.
- All implementations must be genuine (no cheating/hardcoding/facades).
- Auditor verdict must be CLEAN for milestones to pass (binary veto).

## Current Parent
- Conversation ID: 6368409e-7f0c-4e82-b553-fdb9a554042a
- Updated: not yet

## Key Decisions Made
- [TBD]

## Team Roster
| Agent | Type | Work Item | Status | Conv ID |
|-------|------|-----------|--------|---------|
| worker_init | teamwork_preview_worker | Write PROJECT.md, check status | completed | 46aeb4bd-0cce-4a8b-83ef-db49ca717847 |
| worker_m2 | teamwork_preview_worker | Build Standing Guard MCP server | completed | 0b01c611-2c22-41ee-bfa9-59783c374395 |
| worker_m3 | teamwork_preview_worker | Fix Ticket 013 Gaps, run pipeline | stuck/replaced | dd9df1cb-f680-4e42-b789-54ede255f09d |
| worker_m4 | teamwork_preview_worker | Final Validation & Re-cut Tag | completed | 8cadebc7-8bab-46fc-a94e-315f3ca404c1 |

## Succession Status
- Succession required: no
- Spawn count: 4 / 16
- Pending subagents: none
- Predecessor: none
- Successor: not yet spawned

## Active Timers
- Heartbeat cron: none
- Safety timer: none
- On succession: kill all timers before spawning successor
- On context truncation: run `manage_task(Action="list")` — re-create if missing

## Artifact Index
- /Users/sac/mfact/.agents/orchestrator/plan.md — Project plan
- /Users/sac/mfact/.agents/orchestrator/progress.md — Liveness heartbeat and recovery state
- /Users/sac/mfact/.agents/orchestrator/handoff.md — Final handoff report
