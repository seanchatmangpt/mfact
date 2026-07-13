#!/usr/bin/env python3
"""Static stuck-item guard for mfact self-improvement-loop receipts.

This is NOT the real-time trajectory-prefix monitor described in
arXiv:2607.09510 ("Failure as a Process: An Anatomy of CLI Coding Agent
Trajectories", Zhao et al.) RQ1 -- that monitor is a model trained/evaluated
against 2,659 labeled prefixes drawn from 600 annotated trajectories, scored
by precision/recall/lead-time against a t_lock ground truth. mfact's loop
has, as of this writing, zero receipts on disk and at most one genuine
labeled full-trajectory incident anywhere in this repo (the 2026-07-12
research-papers/ truncation; see TRAJECTORY_MONITOR_FEASIBILITY.md). No
statistical model can honestly be fit, let alone validated, on that much
data. Building one and calling it a "monitor" would be exactly the fake
stand-in AGENTS.md's Combinatorial Maximalism Mandate forbids.

What this script *is*: a direct implementation of the "Stuck-item guard"
already specified in prose in MFACT_SELF_IMPROVEMENT_LOOP.md (see that
file's "## Stuck-item guard" section) -- a deterministic, cross-firing
repetition rule with a real, statable justification independent of any
paper: if the loop has attempted the same gap_id repeatedly across its most
recent firings without ever recording a success, attempting it again is
very unlikely to differ from the last N attempts, so the loop should flag
it and move on rather than loop forever. This is a tripwire on *repetition*,
not a *prediction* from partial trajectory evidence -- it never estimates
precision/recall/lead-time and makes no claim to.

Rule (verbatim from MFACT_SELF_IMPROVEMENT_LOOP.md):
    Before picking, read the last 10 receipts' `gap_id` fields. If one
    `gap_id` appears in more than 7 of them with no `status: success`
    among those attempts, skip it and log a `no_op` receipt with
    `"collision": false` and a note that it may be stuck -- do not retry
    it again this run.

Usage:
    stuck_item_guard.py                    # check .mfact/receipts/, human output
    stuck_item_guard.py --json             # machine-readable
    stuck_item_guard.py --receipts DIR     # check an alternate receipts dir
    stuck_item_guard.py --window 10 --threshold 7   # override the defaults
                                                       (defaults match the doc)
"""
from __future__ import annotations

import argparse
import json
import sys
from collections import Counter
from pathlib import Path
from typing import Any, Optional


def discover_receipts(target: Path) -> list[Path]:
    """Same discovery rule as scripts/trajectory_annotate.py: glob *.json,
    exclude the overwritten latest.json pointer file."""
    if target.is_file():
        return [target]
    if target.is_dir():
        return sorted(p for p in target.glob("*.json") if p.name != "latest.json")
    return []


def load_receipts(paths: list[Path]) -> tuple[list[dict[str, Any]], list[tuple[Path, str]]]:
    receipts: list[dict[str, Any]] = []
    errors: list[tuple[Path, str]] = []
    for p in paths:
        try:
            receipts.append(json.loads(p.read_text()))
        except (json.JSONDecodeError, OSError) as e:
            errors.append((p, str(e)))
    return receipts, errors


def find_stuck_gap_ids(
    receipts: list[dict[str, Any]],
    window: int = 10,
    threshold: int = 7,
) -> list[dict[str, Any]]:
    """Apply the stuck-item guard to an ordered list of receipts.

    `receipts` must already be in chronological order, oldest first (e.g.
    sorted by `run_id`, which is a UTC timestamp string per the receipt
    schema) -- this function takes the *last* `window` entries as-is and
    does not re-sort, so the caller is responsible for ordering.

    Returns one dict per flagged gap_id: {"gap_id", "count", "window_size"}.
    Empty list means nothing is stuck (including the honest case of fewer
    than `window` receipts existing at all -- the guard simply operates on
    whatever window is available, per the doc's "last 10 receipts", and a
    gap_id cannot exceed `threshold` occurrences in a window smaller than
    `threshold + 1` firings anyway).
    """
    last_n = receipts[-window:] if window > 0 else list(receipts)
    counts = Counter(r.get("gap_id") for r in last_n if r.get("gap_id") is not None)

    stuck: list[dict[str, Any]] = []
    for gap_id, count in counts.items():
        if count <= threshold:
            continue
        occurrences = [r for r in last_n if r.get("gap_id") == gap_id]
        if any(r.get("status") == "success" for r in occurrences):
            continue
        stuck.append({
            "gap_id": gap_id,
            "count": count,
            "window_size": len(last_n),
            "statuses": [r.get("status") for r in occurrences],
        })
    return sorted(stuck, key=lambda d: -d["count"])


def _sort_key(r: dict[str, Any]) -> str:
    # run_id is documented as a UTC timestamp string (e.g. "20260713T001200Z"),
    # so lexicographic order is chronological order. Receipts missing run_id
    # sort first (empty string) rather than crashing the guard.
    return str(r.get("run_id") or "")


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="stuck_item_guard.py",
        description=(
            "Deterministic cross-firing repetition guard for mfact "
            "self-improvement-loop receipts (MFACT_SELF_IMPROVEMENT_LOOP.md "
            "'Stuck-item guard'). A static heuristic, not a trajectory "
            "predictor -- see module docstring."
        ),
    )
    parser.add_argument(
        "--receipts", default=None,
        help="Receipts directory or single receipt file (default: <repo>/.mfact/receipts/).",
    )
    parser.add_argument("--window", type=int, default=10, help="Window size (default: 10, per the doc).")
    parser.add_argument("--threshold", type=int, default=7, help="Occurrence threshold (default: 7, per the doc).")
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON instead of text.")
    args = parser.parse_args(argv)

    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent
    target = Path(args.receipts) if args.receipts else repo_root / ".mfact" / "receipts"

    if not target.exists():
        print(f"error: path does not exist: {target}", file=sys.stderr)
        return 2

    paths = discover_receipts(target)
    receipts, errors = load_receipts(paths)
    for p, err in errors:
        print(f"warning: could not parse {p}: {err}", file=sys.stderr)

    receipts.sort(key=_sort_key)
    stuck = find_stuck_gap_ids(receipts, window=args.window, threshold=args.threshold)

    if args.json:
        print(json.dumps({
            "target": str(target),
            "receipts_considered": len(receipts),
            "window": args.window,
            "threshold": args.threshold,
            "stuck": stuck,
        }, indent=2))
        return 0

    if not receipts:
        print(
            f"0 receipts found under {target}. Nothing to check -- this guard "
            "operates on real receipts only; it will not fabricate a verdict "
            "from an empty input."
        )
        return 0

    print(f"{len(receipts)} receipt(s) considered (window={args.window}, threshold={args.threshold}).")
    if not stuck:
        print("No gap_id exceeds the threshold with zero successes in the window. Nothing flagged.")
        return 0

    print(f"\n{len(stuck)} gap_id(s) flagged as possibly stuck:")
    for s in stuck:
        print(
            f"  {s['gap_id']}: {s['count']}/{s['window_size']} recent firings, "
            f"no success among them (statuses: {s['statuses']})"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
