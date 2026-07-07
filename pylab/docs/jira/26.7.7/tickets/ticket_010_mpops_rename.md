# Ticket 010 — Rename All `math-factory-pylab` References to `mpops`

## Type

DX / Naming / Product Surface

## Standing

DECLARED

## Objective

Complete the full rename from `math_factory_pylab` and `math-factory-pylab` to `mpops` throughout the repository.

This includes:
- Python package directory: `math_factory_pylab` → `mpops`
- All Python imports: `math_factory_pylab` → `mpops`
- Public command name: `mpops` (already registered)
- All documentation and references: `math-factory-pylab` → `mpops`

After this ticket, `mpops` is the only name used for the Python package, directory, imports, and public command.

## Dependency

Ticket 009 must be ALIVE before this ticket is executed.

Absence of Ticket 009 ALIVE yields terminal state:

`BLOCKED`

## Core Rule

The public CLI is `mpops`.

The old command name `math-factory-pylab` must not remain in docs, tests, examples, scripts, receipts, pyproject entry points, README text, Jira tickets, or help examples.

## Scope

Search and update the repository for the literal hyphenated string:

`math-factory-pylab`

Required search root:

`/Users/sac/mfact`

Required command:

`rg -n "math-factory-pylab" /Users/sac/mfact`

Every match must be removed or rewritten to `mpops`.

## Non-Goals

This ticket must not:

* move standing-producing builders into `pylab`
* change `scripts/build_*` authority
* implement new CLI behavior
* add tactic commands
* alter certification, manifest, ledger, audit, or negative-control logic

## Required Changes

### 1. Python Package Directory Rename

Rename:
`pylab/src/math_factory_pylab/` → `pylab/src/mpops/`

Update all imports from `math_factory_pylab` to `mpops` throughout:
- Python files in src/ and tests/
- Test imports
- pyproject.toml configuration

### 2. `pyproject.toml`

Update the public script entry to:

`mpops = "mpops.cli:app"`

Verify no reference to `math_factory_pylab` or `math-factory-pylab` remains in pyproject.toml.

### 3. Documentation

Replace all command examples: `math-factory-pylab` → `mpops`

This includes:
* README files
* pylab docs
* Jira ticket docs
* receipts
* examples
* developer notes
* command snippets

### 4. Tests

Update all test imports and invocations:
- Change `from math_factory_pylab.cli import app` → `from mpops.cli import app`
- Change any other `math_factory_pylab` imports to `mpops`
- Verify `mpops --help` works
- Verify no `math-factory-pylab` command is documented or exposed

### 5. CLI Help Text

Any help text, docstring, or example text must be updated to use `mpops`.

### 6. Receipts

Ticket 010 must produce its own receipt and must not preserve the old command name except in the explicit “searched literal” field.

The receipt may contain the searched string only as evidence of the search target:

`searched_literal: math-factory-pylab`

No command example may use the old name.

## Required Verification Commands

Run from `/Users/sac/mfact/pylab`:

`uv run mpops --help`
`uv run mpops report --help`
`uv run mpops report status`
`uv run mpops report doctor`
`uv run mpops report next`
`uv run pytest`

Run from `/Users/sac/mfact`:

`rg -n "math-factory-pylab" .`

Expected result:

no matches outside Ticket 010 receipt metadata field:

`searched_literal: math-factory-pylab`

Run:

`rg -n "mpops" /Users/sac/mfact/pylab`

Expected result:

matches in `pyproject.toml`, docs, tests, and CLI examples.

## Required Tests

Create or update tests under:

`pylab/tests/`

Tests must verify:

1. `mpops --help` exits successfully.
2. `mpops report --help` exits successfully.
3. `mpops report status` exits successfully.
4. `mpops report doctor` exits successfully.
5. `mpops report next` exits successfully.
6. the old public command name is absent from CLI docs/help examples.
7. the old public command name is not exposed as a script entry point.

## Documentation

Create:

`pylab/docs/jira/26.7.7/tickets/ticket_010_mpops_rename.md`

Include:

* objective
* exact string replaced
* non-goals
* verification commands
* final grep result
* statement that `math_factory_pylab` remains the Python package name

## Receipt

Create:

`pylab/docs/jira/26.7.7/tickets/ticket_010_receipt.md`

It must include:

* searched literal
* replacement literal
* files changed
* commands run
* command results
* final `rg -n "math-factory-pylab" .` result
* final `rg -n "mpops" /Users/sac/mfact/pylab` summary
* test results
* final standing

## Definition of Done

Ticket 010 is done only when all of the following are true:

1. `mpops` remains the registered CLI.
2. no public script entry named `math-factory-pylab` exists.
3. all command examples use `mpops`.
4. all docs use `mpops`.
5. all tests use `mpops`.
6. CLI help exposes `mpops`, not `math-factory-pylab`.
7. `uv run mpops --help` passes.
8. `uv run mpops report --help` passes.
9. `uv run mpops report status` passes.
10. `uv run mpops report doctor` passes.
11. `uv run mpops report next` passes.
12. `uv run pytest` passes.
13. repository grep finds no unauthorized `math-factory-pylab` occurrences.
14. no `scripts/build_*` authority moved into `pylab`.
15. `ticket_010_mpops_rename.md` exists.
16. `ticket_010_receipt.md` exists.
17. final standing is `ALIVE`.

## Terminal States

This ticket has only three possible terminal states:

* `ALIVE`: every Definition of Done item passed.
* `BLOCKED`: Ticket 009 is not ALIVE or repository state prevents deterministic rename.
* `BUILD_BROKEN`: implementation exists but required verification fails.

No partial terminal state is allowed.
