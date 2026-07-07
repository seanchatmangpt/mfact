# Ticket 009 — Build the `mpops` Outside-In CLI Without Moving Standing Authority

## Type

DX / Tooling / Product Surface

## Standing

DECLARED

## Objective

Create the first read-only `mpops` CLI surface for MathProofOps using Typer and the `<noun> <verb>` command pattern, while preserving the certification boundary between exploratory `pylab/` tooling and standing-producing `scripts/` builders.

This ticket has one deterministic deliverable:

`mpops report`

No tactic search is included in this ticket.

## Core Law

`mpops` observes and assists.
`scripts/` admits and receipts.

`mpops` must not create standing, promote status, mutate generated artifacts, run certification, or replace builders.

## Non-Goals

This ticket must not:

* move `scripts/build_manifest.py` into `pylab`
* move `scripts/build_quadrature.py` into `pylab`
* move `scripts/build_ledger.py` into `pylab`
* move `scripts/build_verif.py` into `pylab`
* move `scripts/build_post_release.py` into `pylab`
* move `scripts/build_evaluation_tex.py` into `pylab`
* move certification, audit, negative-control, replay, or manifest authority into `pylab`
* implement `mpops tactic evolve`
* create `tactics/` modules
* expose tactic-search commands
* promote any artifact status
* infer PROVEN from prose, comments, or prior agent reports

## Required Command Surface

Implement exactly these commands:

* `mpops --help`
* `mpops report --help`
* `mpops report status`
* `mpops report doctor`
* `mpops report next`

Do not implement additional public commands in this ticket.

## Required Package Structure

Create or verify exactly this structure:

`pylab/src/mpops/cli.py`
Root Typer app. Registers noun subcommands only.

`pylab/src/mpops/reporting/__init__.py`
Reporting package marker.

`pylab/src/mpops/reporting/cli.py`
Typer app for the `report` noun.

`pylab/src/mpops/reporting/cockpit.py`
Read-only reporting logic.

No `tactics/` package is created in Ticket 009.

## CLI Registration

Update `pylab/pyproject.toml`:

`mpops = "mpops.cli:app"`

Ensure `math-factory-pylab` is not registered as a public script entry.

## Standing Vocabulary

The CLI may display only these standing values:

* DECLARED
* EXTRACTED
* STATED
* PROVEN
* REFUSED
* BLOCKED
* BUILD_BROKEN
* UNKNOWN
* UNSUPPORTED
* PARTIAL_ALIVE
* ALIVE

The CLI must never manufacture these statuses. It may only report them from observed files, manifests, receipts, or deterministic local checks.

When evidence is missing, the command must report `UNKNOWN`.

When a required artifact is absent for the current rail, the command must report `BLOCKED`.

## Command Behavior

### `mpops report status`

Read-only.

Output must include:

* repository root detected
* git branch
* git commit
* dirty-tree indicator
* manifest presence
* foldHash when present
* crown rail standing
* correspondence rail standing
* blocker summary
* evidence source for each reported standing

Must not run:

* `just render`
* `just build`
* `just test`
* `just audit`
* `just manifest`
* `just certify`
* `just regen-check`
* any `scripts/build_*.py`

### `mpops report doctor`

Read-only.

Output must check and report presence/version for:

* python
* uv
* elan
* lean
* lake
* rustup
* cargo
* opam
* charon
* aeneas

Each tool must be reported as one of:

* FOUND
* MISSING
* ERROR

Missing optional tools are reported as `MISSING`, not as command failure.

### `mpops report next`

Read-only.

Output must print exactly one conservative next action.

Decision order:

1. If crown rail is BLOCKED by missing `[Finite T]`, print:
   `Repair crown TTL statement with [Finite T], then run canonical admission recipes.`

2. Else if correspondence rail is DECLARED, print:
   `Run correspondence-factory holistic audit, then proceed to D1 TokenReplay extraction.`

3. Else if manifest is missing, print:
   `Run canonical project review before claiming standing.`

4. Else print:
   `No deterministic next action found from current read-only evidence.`

## Implementation Constraints

* Use Typer.
* Keep CLI layer thin.
* Put filesystem/status logic in `reporting/cockpit.py`.
* Use typed dataclasses for report results.
* Report commands must be read-only.
* Report commands must not mutate files.
* Report commands must not run certification recipes.
* Missing files must be handled explicitly.
* Missing tools must be handled explicitly.
* No broad exception swallowing. Errors must be reported as structured `ERROR`.

## Required Verification Commands

Run from `pylab/`:

`uv run mpops --help`
`uv run mpops report --help`
`uv run mpops report status`
`uv run mpops report doctor`
`uv run mpops report next`
`uv run pytest`

`uv run pytest` is mandatory. If no tests exist, create tests for the first-slice CLI.

## Required Tests

Create or update tests under:

`pylab/tests/`

Tests must verify:

1. `mpops --help` exits successfully.
2. `mpops report --help` exits successfully.
3. `mpops report status` exits successfully.
4. `mpops report doctor` exits successfully.
5. `mpops report next` exits successfully.
6. report commands do not call standing-producing builders.
7. `mpops` does not expose `tactic evolve`.

## Documentation

Create or update:

`pylab/docs/jira/26.7.7/tickets/ticket_009_mpops_cli.md`

Include:

* objective
* boundary
* non-goals
* command examples
* verification commands
* statement that `mpops` reports standing but does not create standing

## Receipt

Create:

`pylab/docs/jira/26.7.7/tickets/ticket_009_receipt.md`

It must include:

* files changed
* commands run
* command results
* test results
* whether `mpops` registered successfully
* whether noun-verb routing works
* confirmation that standing-producing builders stayed in `scripts/`
* confirmation that no tactic commands were exposed
* final standing

## Definition of Done

Ticket 009 is done only when all of the following are true:

1. `mpops` is registered as the CLI.
2. `mpops --help` passes.
3. `mpops report --help` passes.
4. `mpops report status` passes.
5. `mpops report doctor` passes.
6. `mpops report next` passes.
7. `uv run pytest` passes.
8. tests verify that no tactic command is exposed.
9. tests verify report commands do not invoke standing-producing builders.
10. no `scripts/build_*` authority moved into `pylab`.
11. docs exist.
12. receipt exists.
13. final standing is `ALIVE`.

## Final Standing Rule

This ticket has only three possible terminal states:

* `ALIVE`: every Definition of Done item passed.
* `BLOCKED`: an external dependency or repository condition prevents execution.
* `BUILD_BROKEN`: implementation exists but required verification fails.

Do not use `PARTIAL_ALIVE` for this ticket.

Partial work is not a terminal state.

The key repair is the terminal-state rule:

```text
ALIVE / BLOCKED / BUILD_BROKEN
```

No soft completion. No optional scope. No hidden branch.
