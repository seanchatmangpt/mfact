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
| `/Users/sac/mfact/packs/lean-math-pack/fragments/*.ttl` | Yes | source declaration catalog |
| `/Users/sac/mfact/packs/{lean-math-pack,quadrature-pack}/templates/*.tmpl` | Yes | projection templates |
| `scripts/*.py`, `scripts/*.sh` | Yes | builders, gates, controls |
| `paper/main.tex` | Limited | stable prose spine only — no volatile numbers |
| `paper/refs.bib`, `README*`, `STANDING.md` prose | Yes | narrative (no standing values by hand) |
| ledgered fragments (`paper/*.tex` listed in `.mfact/artifacts.toml`) | **No** | rendered by ggen |
| `procint/ProcInt/**/*.lean`, `procint/AxiomAudit.lean`, `procint/ProcInt.lean` | **No** | rendered by ggen |
| `procint/Playground/**/*.lean` | **Yes** | hand-authored demo/examples surface — never ggen-rendered, never ledgered; ordinary code, edit freely |
| `pylab/**` | **Yes** | hand-authored Python research/experimentation surface (TPOT2, pm4py, powl, ocpa, pddl-plus-parser) — never ggen-rendered, never ledgered; ordinary code, edit freely |
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

## Ledger law

There are no generated files; there are only artifacts with receipts.
All repository files are first-class and live at canonical paths. Do not
rely on directories, file headers, or path naming to decide authority —
authority comes from the artifact ledger (`.mfact/artifacts.toml`). If a
file is ledgered as produced by ggen or a builder script, do not patch it
directly as a final solution: modify its declared sources or template,
re-render, and verify `just regen-check` passes (any unreplayable edit is
`ARTIFACT_DRIFT_REFUSED`). If a file is NOT ledgered but contains release
standing, counts, audit status, or certification data, classify it as
`ORPHAN_ARTIFACT_REFUSED` and either ledger it or refuse the task.

`procint/Playground/**` is intentionally unledgered: it carries no standing,
counts, or certification data, so its absence from `.mfact/artifacts.toml`
is correct, not an omission. Do not add it to the ledger.

`pylab/**` is likewise intentionally unledgered: it carries no standing,
counts, or certification data, so its absence from `.mfact/artifacts.toml`
is correct, not an omission. Do not add it to the ledger.

## Rules

- **No direct pyproject.toml modifications:** Do not edit `pyproject.toml` files directly to manage Python dependencies. Use `uv add` or other package manager commands via a `just` recipe instead.
- **No unrequested Lean-Python integration:** Do not implement custom Lean 4 integration infrastructure (such as LSP clients or subprocess runners for Lean) in the Python workspace (`pylab/`) unless explicitly requested.
- **Deprecate `l2p`:** Do not install, reference, or use the `l2p` planning library.
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
`MANUAL_RELEASE_COUNT`, `MANUAL_RELEASE_HASH`,
`RECEIPT_RECURSION_REFUSED`, `SOURCE_CHANGE_ASSERTION_UNSUPPORTED` (planned:
`MFACT_SOURCE_CHANGED=1` will require a changed source/template/TTL in the
same commit, not a bare assertion).

## Agent cockpit

Agents actuate only through `just` recipes. Do not call raw lake/ggen/mfact
commands unless a recipe explicitly instructs it for debugging. If a task
needs a new actuation path, add a `just` recipe first, then use it. Final
reports name the recipes used, not an ad hoc shell history.
`just status/next/doctor/trace/why` are READ-ONLY — they never dirty the
tree. Only `just check` / `just release` write `.mfact/reports/latest.*`
(ephemeral, gitignored, never ledgered). Certified status lives only in
`release/` artifacts.

## Core release identity (frozen)

The v26.7.7 core release is tag `v26.7.7-procint-certified`:
`CORE_RELEASE_HASH` = the manifest foldHash, `CORE_PROVEN`,
`CORE_TOTAL_DECLS` as recorded in `release/release-manifest.json` at the
tagged commit. **Post-release artifacts must not mutate the identity of the
core certified release they report.** If an operation would change the core
foldHash, proven count, decl count, or manifest, either refuse it as
`RECEIPT_RECURSION_REFUSED` or promote it explicitly into a new core
certification cycle with new manifest values — never both silently.
Post-release witnesses (e.g. `ProcInt.Release.PostRelease`) are counted as
`POST_RELEASE_WITNESSES`, never folded into `CORE_PROVEN`. The core tag is
pinned to the core release commit and is not moved by packet work; packets
get their own tags and their own packet hashes.

Status taxonomy: `ALIVE`, `PARTIAL_ALIVE`, `BLOCKED`, `BLOCKED_EXTERNAL`,
`BUILD_BROKEN`, `REFUSED`, `PENDING_EXTERNAL_ACTUATION` (packet complete,
actuation is the user's), `VALID` (scoped, evidence-backed), `UNSUPPORTED`
(claim without evidence — must not ship), `PLANNED` (declared, not built),
`STATED` (formalized, not proven), `REPLAY_NOT_RUN`, `IN_PROGRESS`.

## Agent actuation constitution

Agents actuate only through just recipes.

Do not call raw Lake, ggen, mfact, LaTeX, git, or packaging commands as
the final actuation path unless a just recipe or doctor report explicitly
instructs it.

If a new actuation path is needed, add a just recipe first.

Final reports must name just recipes used, not ad hoc shell history.

Diagnostic commands (`status`, `next`, `trace`, `why`, `doctor`,
`theorem-status`, `proof-blockers`, `fixtures`, `docs-check`) are
read-only. Only `report-write`, `check`, and `release` write the
ephemeral cockpit reports; only the manufacturing recipes write ledgered
artifacts.

No standing value may be inferred from terminal prose. Standing comes
from the manifest, ledger, audit, fixture keys, quadrature report, and
certified status artifacts.

## Completion report

Every completed task reports: source files changed, generated files
regenerated, commands run, build/certification result, and whether any
generated file was edited directly. End with exactly one status:
`ALIVE`, `PARTIAL_ALIVE`, `BLOCKED`, `BUILD_BROKEN`, or `REFUSED`.
