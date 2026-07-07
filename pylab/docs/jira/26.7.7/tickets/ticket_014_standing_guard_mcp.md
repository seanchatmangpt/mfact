# Ticket 014 — Standing Guard MCP Server

## Standing

`DECLARED` — proposed tooling, not yet built.

## Motivation

Ticket 013's five-rail audit found real gaps only because five agents spent
an afternoon manually cross-checking ledger hashes, `git diff`, TTL status
literals, receipt fields, and tag ancestry by hand. None of these checks are
individually hard — the problem is that no single always-on process runs
them, so drift accumulates silently between audits. This ticket proposes an
MCP server whose entire job is to run the same checks continuously (or
on-demand from any agent/session) and refuse to say "clean" unless every
class of gap from ticket 013 is actually re-verified against current disk
state.

Per `AGENTS.md`'s governance: this server **observes and reports only**. It
never writes to `.mfact/artifacts.toml`, `release/*.json`, TTL fragments, or
Lean files, and it never sets standing itself. It is a read-only diagnostic
surface, same tier as `just status/next/doctor/trace/why` — it just knows
about more failure classes than those currently do, and is queryable as an
MCP tool from any agent session rather than only via `just`.

## What it monitors (one check per ticket-013 finding class)

1. **Status-promotion guard** — for every `procint:status "proven"` literal
   in `packs/lean-math-pack/{ontology.ttl,fragments/*.ttl}`, resolve the
   Lean declaration and run `lake env lean --stdin` with
   `import <decl>\n#print axioms <decl>` (the same fixed invocation from
   `scripts/build_verif.py`'s `sorry_free()`); flag any `"proven"` literal
   whose axiom list contains `sorryAx`. This is the exact check that would
   have caught the countermodel false-promotion in ticket 013.
2. **Ledger hash drift** — for every `[[artifact]]` entry in
   `.mfact/artifacts.toml`, b3sum the file on disk and compare to
   `content_hash`. Flag mismatches. Separately flag any ledgered path that
   is untracked in git (`git ls-files --error-unmatch` failure) — this is
   the "double blind spot" class from ticket 013 (drift invisible to both
   `regen-check`'s `git diff` and the ledger check that only runs when
   someone remembers to invoke it).
3. **Orphan artifact scan** — walk `release/*.json`, `paper/*.tex`, and any
   file matching known standing-bearing patterns (proven/PROVEN counts,
   `foldHash`, theorem totals) that is NOT present in `.mfact/artifacts.toml`
   and is not `procint/Playground/**` or `pylab/**` (both intentionally
   unledgered per AGENTS.md). Flag as `ORPHAN_ARTIFACT_REFUSED` candidates.
4. **regen-check coverage gap scan** — parse the `regen-check` recipe body
   in the `justfile`; for every ledgered artifact, confirm its declared
   producer script (from `artifacts.toml`'s `producer =` field) is actually
   invoked somewhere in the `regen-check` recipe chain. Flag ledgered
   artifacts whose producer is only reachable via a recipe outside
   `check`/`release`/`regen-check` — the exact gap that let
   `correspondence_status.tex` drift unnoticed.
5. **Correspondence binding check** — for each obligation in
   `release/verif-receipt.json` (or successor receipt files) marked
   `PROVEN`, parse its Lean statement's `import` list and check it
   references the declared extraction module (e.g. any
   `*.Generated.*` decl named in the receipt's `aeneasDecl` field). Flag
   `aeneasDecl: "TBD"` or any receipt where the theorem doesn't `import`
   the named extraction module — the exact D1 gap from ticket 013.
6. **Tag ancestry check** — for the frozen core release tag (currently
   `v26.7.7-procint-certified`), run `git merge-base --is-ancestor <tag>
   HEAD` (or the reverse, whichever direction the core-identity rule
   requires) and compare against the current `release/release-manifest.json`
   `runIdentifier`. Flag when the tagged commit is not an ancestor of the
   commit that produced the current manifest — the exact
   `RENDERED_COMMIT_IS_ANCESTOR_OF_TAG=FAIL` finding from ticket 013.
7. **Untracked-fragment-feeds-ontology check** — list every file matched by
   `packs/*/fragments/*.ttl` glob and flag any that is untracked in git.
8. **Prose/paper consistency check** — grep `paper/main.tex` for the 8
   patterns proposed in `paper/PROSE_LINT_RULES_CORRESPONDENCE.md`, not just
   the 1 currently wired into `just prose-lint`; also diff any hand-written
   number in `main.tex` near standing-vocabulary words against the
   corresponding generated fragment's actual value (catches the
   145-vs-197 class of inconsistency).

## Proposed shape

- Location: `pylab/src/mpops/standing_guard/` (Python, MCP server package;
  pylab is the correct home per `AGENTS.md` — hand-authored, unledgered,
  never feeds `release/gates.json` directly).
- Exposed as MCP tools, e.g.:
  - `standing_guard.scan()` → structured list of findings, one per check
    class above, each with severity (BLOCKER/WARN/INFO), evidence paths,
    and the exact refusal code from `AGENTS.md`'s typed refusal vocabulary
    (reusing `STATED_PROMOTED_TO_PROVEN`, `ORPHAN_ARTIFACT_REFUSED`,
    `ARTIFACT_DRIFT_REFUSED`, `RECEIPT_RECURSION_REFUSED`, plus the three
    new codes from the Guardrails section: `WFNET_INFINITE_TRANSITION_COUNTERMODEL`,
    `countermodel_not_promoted`, `COUNTERMODEL_PROMOTION_REFUSED`).
  - `standing_guard.check(class_name)` → run a single check class on
    demand (fast path for a pre-commit hook or CI step).
  - `standing_guard.watch()` — optional: a long-running mode that re-scans
    on file-change (e.g. via `watchfiles`) and surfaces new findings as they
    appear, rather than only at request time.
- No mutation capability at all — the server should not even expose a tool
  that could write a file. This is enforced by simply not writing that code,
  not by a runtime permission check, consistent with mpops's existing
  "mpops observes, scripts admit" boundary (ticket 009).
- Should reuse existing builder logic rather than reimplement it:
  `scripts/build_verif.py`'s `sorry_free()` invocation pattern, and
  `scripts/build_ledger.py`'s b3sum/hash logic, are both already correct
  and tested — call them as library functions or subprocess them, don't
  duplicate the Lean invocation string.

## Definition of Done

- [ ] MCP server exposes at least `scan()` covering all 8 check classes
      above.
- [ ] Running `scan()` against the exact dirty tree state from ticket 013
      (before any of its fixes were applied) reproduces every BLOCKER
      finding in ticket 013 — this is the acceptance test; check out or
      simulate that tree state and confirm the server flags all of them.
- [ ] Running `scan()` against a tree state after ticket 013's action items
      are completed reports zero BLOCKER findings.
- [ ] No write capability exists anywhere in the server's tool surface —
      confirmed by code review, not just by not calling it.
- [ ] Documented as a read-only diagnostic surface in this repo's tool
      docs, cross-referenced from `AGENTS.md`'s Guardrails section.
- [ ] Ticket 013's `## Action items` checklist item "regen-check coverage
      gap" is satisfied by check class 4 without needing to hand-audit
      the justfile again.

## Out of scope

- Auto-fixing any finding. The server reports; humans/agents fix through
  the normal `just render`/`build`/`certify` pipeline.
- Any new `just` recipe wrapping this server — it's an MCP tool surface,
  queryable directly by agent sessions, not a build-pipeline step. (A thin
  `just standing-guard-scan` convenience wrapper is fine if wanted later,
  but is not required for DoD.)
- Enforcing these checks as a git pre-commit hook — worth considering in a
  follow-up ticket, but this ticket is scoped to the MCP server itself.
