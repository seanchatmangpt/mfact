#!/usr/bin/env python3
"""Consistency check between `.mfact/receipts/latest.json` and the receipts it
is supposed to be a fast-lookup copy of.

MFACT_SELF_IMPROVEMENT_LOOP.md's "Receipt schema" section documents
`.mfact/receipts/latest.json` as "(same content, overwritten each firing, for
fast last-run lookup)" of the per-firing `.mfact/receipts/<run_id>.json`
file. Nothing enforces that claim: the two scripts that already read this
directory (`scripts/trajectory_annotate.py`, `scripts/stuck_item_guard.py`)
both discover receipts by excluding `latest.json` by filename rather than
validating its content, so a firing that updates `<run_id>.json` but forgets
to refresh `latest.json` (or vice versa) would go unnoticed by either.

This script is a direct, static check on that one claim: it takes the
lexicographically-greatest `<run_id>.json` filename under the receipts
directory (run_id is a UTC timestamp string per the schema, so lexicographic
order is chronological order -- same assumption `stuck_item_guard.py` makes)
and compares its `run_id` field against `latest.json`'s `run_id` field.
Nothing more -- it does not diff the full JSON bodies, and it does not
attempt to re-derive whether a firing "should" have updated `latest.json`.

Usage:
    receipts_consistency.py                    # check .mfact/receipts/, human output
    receipts_consistency.py --json              # machine-readable
    receipts_consistency.py --receipts DIR      # check an alternate receipts dir

Exit code: 0 if `latest.json`'s run_id matches the max run_id on disk (or no
receipts exist at all -- nothing to be inconsistent with), 1 otherwise.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Optional


def discover_dated_receipts(target: Path) -> list[Path]:
    """Same discovery rule as scripts/stuck_item_guard.py: glob *Z.json,
    exclude the overwritten latest.json pointer file."""
    return sorted(p for p in target.glob("*Z.json") if p.name != "latest.json")


def load_json(path: Path) -> tuple[Optional[dict[str, Any]], Optional[str]]:
    try:
        return json.loads(path.read_text()), None
    except (json.JSONDecodeError, OSError) as e:
        return None, str(e)


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="receipts_consistency.py",
        description=(
            "Static check that .mfact/receipts/latest.json's run_id matches "
            "the max run_id among .mfact/receipts/*Z.json (MFACT_SELF_IMPROVEMENT_LOOP.md "
            "'Receipt schema'). See module docstring for exact scope."
        ),
    )
    parser.add_argument(
        "--receipts", default=None,
        help="Receipts directory (default: <repo>/.mfact/receipts/).",
    )
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON instead of text.")
    args = parser.parse_args(argv)

    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent
    target = Path(args.receipts) if args.receipts else repo_root / ".mfact" / "receipts"

    if not target.exists():
        print(f"error: path does not exist: {target}", file=sys.stderr)
        return 2

    latest_path = target / "latest.json"
    dated = discover_dated_receipts(target)

    if not dated or not latest_path.exists():
        result = {
            "target": str(target),
            "ok": True,
            "reason": "no dated receipts and/or no latest.json -- nothing to be inconsistent with",
            "max_run_id": None,
            "latest_run_id": None,
        }
        if args.json:
            print(json.dumps(result, indent=2))
        else:
            print(f"OK: {result['reason']} (target={target})")
        return 0

    max_path = dated[-1]
    max_receipt, max_err = load_json(max_path)
    latest_receipt, latest_err = load_json(latest_path)

    if max_err is not None or latest_err is not None:
        result = {
            "target": str(target),
            "ok": False,
            "reason": "failed to parse one or both receipt files",
            "max_path": str(max_path),
            "max_error": max_err,
            "latest_error": latest_err,
        }
        if args.json:
            print(json.dumps(result, indent=2))
        else:
            print(f"FAIL: could not parse receipts under {target}", file=sys.stderr)
            if max_err:
                print(f"  {max_path}: {max_err}", file=sys.stderr)
            if latest_err:
                print(f"  {latest_path}: {latest_err}", file=sys.stderr)
        return 1

    max_run_id = (max_receipt or {}).get("run_id")
    latest_run_id = (latest_receipt or {}).get("run_id")
    ok = max_run_id == latest_run_id

    result = {
        "target": str(target),
        "ok": ok,
        "max_path": str(max_path),
        "max_run_id": max_run_id,
        "latest_run_id": latest_run_id,
    }

    if args.json:
        print(json.dumps(result, indent=2))
    elif ok:
        print(f"OK: latest.json run_id ({latest_run_id}) matches max dated receipt ({max_path.name}).")
    else:
        print(
            f"FAIL: latest.json run_id ({latest_run_id!r}) does not match "
            f"max dated receipt {max_path.name} run_id ({max_run_id!r}). "
            "latest.json is stale.",
            file=sys.stderr,
        )

    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
