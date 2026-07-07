"""FastMCP server: read-only Lean/Lake/just introspection + pylab research tools.

Run with `uv run python -m mpops.mcp_procint.server`.
"""

from __future__ import annotations

import re
import subprocess
from pathlib import Path
from typing import Any

from fastmcp import FastMCP

mcp = FastMCP("procint-pylab")

# pylab/src/mpops/mcp_procint/server.py -> mfact/
REPO_ROOT = Path(__file__).resolve().parents[4]
PROCINT_DIR = REPO_ROOT / "procint"
LAKE = "/Users/sac/.elan/bin/lake"


def _run(cmd: list[str], cwd: Path, timeout: int = 300) -> dict[str, Any]:
    """Run a subprocess and return a structured, JSON-serializable result."""
    try:
        result = subprocess.run(
            cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout, check=False
        )
        return {
            "success": result.returncode == 0,
            "returncode": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        }
    except subprocess.TimeoutExpired as e:
        return {
            "success": False,
            "returncode": None,
            "stdout": "",
            "stderr": f"timed out after {timeout}s: {e}",
        }
    except FileNotFoundError as e:
        return {"success": False, "returncode": None, "stdout": "", "stderr": str(e)}


# ---------------------------------------------------------------------------
# Lean / Lake tools — read-only introspection only. No source, ontology, or
# ledger writes happen through this MCP server.
# ---------------------------------------------------------------------------


@mcp.tool
def lake_build(target: str = "") -> dict[str, Any]:
    """Run `lake build [target]` in `procint/`.

    Compiles whatever is already on disk; does not modify any source file,
    TTL fragment, or template. Pass an empty string for the default targets.
    """
    cmd = [LAKE, "build", *([target] if target else [])]
    return _run(cmd, cwd=PROCINT_DIR)


@mcp.tool
def lake_env_lean(file: str) -> dict[str, Any]:
    """Typecheck a single Lean file via `lake env lean <file>`.

    Fast single-file feedback loop (no full `.olean` rebuild). `file` is
    relative to `procint/` (e.g. `ProcInt/Playground/PddlPlanningWalkthrough.lean`).
    """
    return _run([LAKE, "env", "lean", file], cwd=PROCINT_DIR)


@mcp.tool
def just_status() -> dict[str, Any]:
    """Read-only cockpit status summary (`just status`)."""
    return _run(["just", "status"], cwd=REPO_ROOT)


@mcp.tool
def just_doctor() -> dict[str, Any]:
    """Read-only health check: required tools on PATH, toolchain pins,
    pack sources, tag gate (`just doctor`)."""
    return _run(["just", "doctor"], cwd=REPO_ROOT)


@mcp.tool
def just_next() -> dict[str, Any]:
    """Read-only: what to run next, derived from the first non-passing
    gate/lane found (`just next`)."""
    return _run(["just", "next"], cwd=REPO_ROOT)


@mcp.tool
def just_trace(target: str) -> dict[str, Any]:
    """Read-only provenance of one ledgered artifact: producer, sources,
    content hash, receipt (`just trace <target>`)."""
    return _run(["just", "trace", target], cwd=REPO_ROOT)


@mcp.tool
def just_why(target: str) -> dict[str, Any]:
    """Read-only: why an artifact or quadrature claim exists and what it's
    computed from (`just why <target>`)."""
    return _run(["just", "why", target], cwd=REPO_ROOT)


@mcp.tool
def just_theorem_status() -> dict[str, Any]:
    """Read-only correctness-ladder theorem counts: proven/stated/total
    from the manifest (`just theorem-status`)."""
    return _run(["just", "theorem-status"], cwd=REPO_ROOT)


# ---------------------------------------------------------------------------
# Registry lookup — reads the TTL source directly (no Lean invocation
# needed), matching how `Registry.Breeds`/`Registry.Algorithms` are
# rendered from `ontology/procint-schema.ttl`.
# ---------------------------------------------------------------------------

_BREED_RE = re.compile(
    r'compat:Breed_\w+ a compat:CognitionBreed\s*;\s*'
    r'compat:breedId\s+"([^"]*)"\s*;\s*'
    r'compat:breedLabel\s+"([^"]*)"\s*;\s*'
    r'compat:breedDoc\s+"((?:[^"\\]|\\.)*)"\s*;\s*'
    r'compat:citation\s+"((?:[^"\\]|\\.)*)"\s*\.',
    re.DOTALL,
)

_ALGO_RE = re.compile(
    r'pi:Algo_\w+ a pi:ProcessIntelligenceAlgorithm\s*;\s*'
    r'pi:algorithmId\s+"([^"]*)"\s*;\s*'
    r'pi:algorithmLabel\s+"([^"]*)"\s*;\s*'
    r'pi:algorithmDoc\s+"((?:[^"\\]|\\.)*)"\s*;\s*'
    r'pi:citation\s+"((?:[^"\\]|\\.)*)"\s*;',
    re.DOTALL,
)


@mcp.tool
def registry_lookup(entry_id: str) -> dict[str, Any]:
    """Look up a breed or algorithm by id in the ProcInt Registry.

    Reads `ontology/procint-schema.ttl` directly (the TTL source that
    renders into `ProcInt.Registry.{Breeds,Algorithms}` via `just render`).
    Read-only; does not invoke Lean or ggen.
    """
    ttl_path = REPO_ROOT / "ontology" / "procint-schema.ttl"
    text = ttl_path.read_text()

    for m in _BREED_RE.finditer(text):
        if m.group(1) == entry_id:
            return {
                "kind": "breed",
                "id": m.group(1),
                "label": m.group(2),
                "doc": m.group(3),
                "citation": m.group(4),
            }

    for m in _ALGO_RE.finditer(text):
        if m.group(1) == entry_id:
            return {
                "kind": "algorithm",
                "id": m.group(1),
                "label": m.group(2),
                "doc": m.group(3),
                "citation": m.group(4),
            }

    return {"kind": None, "error": f"no breed or algorithm found with id={entry_id!r}"}


# ---------------------------------------------------------------------------
# Pylab tools — one per library. Each library is imported lazily inside its
# tool function so that one broken/incompatible dependency (see `powl_discover`
# below) can never prevent the other tools, or the server itself, from
# starting.
# ---------------------------------------------------------------------------


@mcp.tool
def tpot_fit(csv_path: str, target_column: str, max_time_mins: float = 1.0) -> dict[str, Any]:
    """Run TPOT2 (genetic-programming AutoML) classification search on a
    CSV dataset.

    `target_column` is the label column; every other column is a feature.
    `max_time_mins` bounds the search (kept small by default so this tool
    call returns promptly). Returns the fitted pipeline's repr and test
    accuracy.
    """
    import pandas as pd
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import train_test_split
    from tpot import TPOTClassifier

    df = pd.read_csv(csv_path)
    x = df.drop(columns=[target_column])
    y = df[target_column]
    x_train, x_test, y_train, y_test = train_test_split(x, y, random_state=42)

    est = TPOTClassifier(max_time_mins=max_time_mins, random_state=42, verbose=0)
    est.fit(x_train, y_train)
    accuracy = accuracy_score(y_test, est.predict(x_test))

    return {
        "fitted_pipeline": repr(getattr(est, "fitted_pipeline_", est)),
        "test_accuracy": float(accuracy),
    }


@mcp.tool
def pm4py_discover_dfg(xes_path: str) -> dict[str, Any]:
    """Discover a Directly-Follows Graph from an XES event log via pm4py.

    Returns the DFG edges (as `"a->b": frequency`) plus start/end activity
    counts.
    """
    import pm4py

    log = pm4py.read_xes(xes_path)
    dfg, start_activities, end_activities = pm4py.discover_dfg(log)

    return {
        "dfg": {f"{a}->{b}": count for (a, b), count in dfg.items()},
        "start_activities": dict(start_activities),
        "end_activities": dict(end_activities),
    }


@mcp.tool
def powl_discover(log_path: str) -> dict[str, Any]:
    """Discover a POWL v2 model from an XES event log via the `powl` package.

    Known issue (as of this writing): the currently-resolved `powl==2.3.7`
    / `pm4py==2.2.32` version pair has a real import-time incompatibility
    (`powl.main` imports `pm4py.algo.discovery.inductive.variants.imf`, a
    module absent from this pm4py release). This tool reports that failure
    structurally rather than crashing the whole MCP server; re-run once the
    two packages' released versions are compatible again.
    """
    try:
        import powl
    except ImportError as e:
        return {
            "error": (
                "powl import failed — known pm4py/powl version incompatibility "
                f"(see docstring): {e}"
            )
        }

    log = powl.import_event_log(log_path)
    model = powl.discover(log)
    return {"powl_model": str(model)}


@mcp.tool
def ocpa_import_ocel2(sqlite_path: str) -> dict[str, Any]:
    """Import an OCEL 2.0 sqlite log via ocpa, returning summary counts.

    Returns the object types present and the number of discovered process
    executions (object-centric "cases").
    """
    from ocpa.objects.log.importer.ocel2.sqlite import factory as ocel2_factory

    ocel = ocel2_factory.apply(sqlite_path)
    return {
        "object_types": list(ocel.object_types),
        "num_process_executions": len(ocel.process_executions),
    }


if __name__ == "__main__":
    mcp.run()
