# CLAUDE.md

## Prime Directive

This repository is a mathematical manufacturing system. Do not hand-code
manufactured outputs.

Claude is an untrusted candidate producer. Claude may propose changes to
source declarations, templates, fixtures, tests, and hand-authored prose.
Claude may not confer standing by directly editing generated artifacts.

The standing law is `R_B ⊢ A = μ(O*_B)`. In this repository, ggen projects,
Lean admits, mfact certifies, and the manifest records standing.

## Edit surfaces

| Surface | Edit? | Role |
|---|---|---|
| `/Users/sac/praxis/packs/lean-math-pack/fragments/*.ttl` | Yes | source declaration catalog |
| `/Users/sac/praxis/packs/{lean-math-pack,quadrature-pack}/templates/*.tmpl` | Yes | projection templates |
| `scripts/*.py`, `scripts/*.sh` | Yes | builders, gates, controls |
| `paper/main.tex` | Limited | stable prose spine only — no volatile numbers |
| `paper/refs.bib`, `README*`, `STANDING.md` prose | Yes | narrative (no standing values by hand) |
| `paper/generated/*.tex` | **No** | rendered by ggen |
| `procint/ProcInt/**/*.lean`, `procint/AxiomAudit.lean`, `procint/ProcInt.lean` | **No** | rendered by ggen |
| `release/release-manifest.json`, `release/gates.json`, `release/quadrature.*` | **No** | emitted by builders/certification |

If a change affects standing, counts, theorem status, generated fragments,
module declarations, release hashes, or audit claims: edit the source
declaration or template, then rerun the pipeline.

## Required workflow

1. Edit the source (fragment TTL, template, builder, gate).
2. `just render` (corpus) and/or `just standing-quadrature` (quadrature + paper fragments).
3. `just build` / `just audit`.
4. `just manifest && just certify` if release standing changed.
5. `just regen-check` — hand-edited generated output cannot pass admission.
6. Report commands run and resulting standing.

## Rules

- Never manually write release counts, hashes, theorem totals, sorry counts,
  audit status, fixture status, quadrature status, or crown-jewel status —
  these come only from generated files.
- Never upgrade STATED to PROVEN anywhere. The crown-jewel WF-net soundness
  equivalence remains STATED unless a Lean-admitted theorem and manifest
  entry prove otherwise.
- If the source/template for a generated artifact cannot be found, do not
  patch the output; refuse with `MISSING_GGEN_SOURCE` / `MISSING_GGEN_TEMPLATE`
  and name the file.

Typed refusal vocabulary: `HAND_CODED_GENERATED_OUTPUT`,
`GENERATED_OUTPUT_DRIFT`, `MISSING_GGEN_SOURCE`, `MISSING_GGEN_TEMPLATE`,
`ORPHAN_GENERATED_FILE`, `UNREGISTERED_PAPER_FRAGMENT`,
`UNSUPPORTED_STANDING_CLAIM`, `STATED_PROMOTED_TO_PROVEN`,
`MANUAL_RELEASE_COUNT`, `MANUAL_RELEASE_HASH`.

## Completion report

Every completed task reports: source files changed, generated files
regenerated, commands run, build/certification result, and whether any
generated file was edited directly. End with exactly one status:
`ALIVE`, `PARTIAL_ALIVE`, `BLOCKED`, `BUILD_BROKEN`, or `REFUSED`.
