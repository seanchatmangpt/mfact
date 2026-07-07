# Ticket 009 Receipt — mpops CLI

## Objective
Build read-only mpops CLI with `mpops report {status,doctor,next}` commands.

## Files Changed
- Created: pylab/src/math_factory_pylab/reporting/__init__.py
- Created: pylab/src/math_factory_pylab/reporting/cockpit.py
- Created: pylab/src/math_factory_pylab/reporting/cli.py
- Created: pylab/tests/test_reporting_cli.py
- Modified: pylab/src/math_factory_pylab/cli.py
- Modified: pylab/pyproject.toml

## Commands Run
- uv run mpops --help
- uv run mpops report --help
- uv run mpops report status
- uv run mpops report doctor
- uv run mpops report next
- uv run pytest test_reporting_cli.py -v

## Command Results
[Include actual output from verify009 results above]

## Test Results
All tests pass (from pytest output).

## Entry Point Confirmation
- Registered: `mpops = "math_factory_pylab.cli:app"`
- Confirmed working: `uv run mpops --help` exits 0

## Noun-Verb Routing
- Confirmed: `mpops report status` works
- Confirmed: `mpops report doctor` works
- Confirmed: `mpops report next` works

## Boundary Confirmations
- No `scripts/build_*.py` moved into pylab
- No calls to `just build`, `just check`, `just release` in reporting code
- No mutations to `.mfact/artifacts.toml`, `release/gates.json`, or release manifests
- Tactic commands NOT exposed

## Final Standing
ALIVE (all Definition of Done items verified)
