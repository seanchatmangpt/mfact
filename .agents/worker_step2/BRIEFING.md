# BRIEFING — 2026-07-07T17:55:42-07:00

## Mission
Restructure paper/main.tex and create the rslab skeleton under rslab/.

## 🔒 My Identity
- Archetype: worker
- Roles: implementer, qa, specialist
- Working directory: /Users/sac/mfact/.agents/worker_step2
- Original parent: 20c65592-2085-438d-b840-67958478044b
- Milestone: Step 2: Ticket 016 & 017

## 🔒 Key Constraints
- CODE_ONLY network mode.
- Do not modify pyproject.toml directly.
- Actuate only through just recipes.
- No direct editing of generated artifacts ledgered in .mfact/artifacts.toml.

## Current Parent
- Conversation ID: 20c65592-2085-438d-b840-67958478044b
- Updated: 2026-07-07T17:55:42-07:00

## Task Summary
- **What to build**: 
  - Restructured paper/main.tex following the 17-section layout.
  - Greenfield rslab/ folder structure containing README.md, manifest.toml, schemas, experiments, and .gitkeep files.
- **Success criteria**: 
  - paper/main.tex compiles cleanly with `just paper-check` and `just prose-lint`.
  - rslab/ contains correct schemas, manifest, README, and no numeric benchmark results.
  - `just regen-check` passes successfully.
  - Changes staged and committed with `just commit "Ticket 016 & 017: Paper Restructure and rslab Skeleton"`.
- **Interface contracts**: /Users/sac/mfact/AGENTS.md
- **Code layout**: /Users/sac/mfact/

## Key Decisions Made
- [TBD]

## Artifact Index
- [TBD]

## Change Tracker
- **Files modified**: [TBD]
- **Build status**: [TBD]
- **Pending issues**: [TBD]

## Quality Status
- **Build/test result**: [TBD]
- **Lint status**: [TBD]
- **Tests added/modified**: [TBD]

## Loaded Skills
- **Source**: None
- **Local copy**: None
- **Core methodology**: None
