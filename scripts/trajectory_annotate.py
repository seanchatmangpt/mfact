#!/usr/bin/env python3
"""Annotate mfact self-improvement-loop receipts with trajectory timestamps.

Adapts the three-timestamp failure decomposition from arXiv:2607.09510
("Failure as a Process: An Anatomy of CLI Coding Agent Trajectories",
Zhao et al.) to the receipt schema documented in
MFACT_SELF_IMPROVEMENT_LOOP.md. Read in full, that paper decomposes a coding
agent's failure into three timestamps measured at **per-LLM-step**
granularity inside a single trajectory: t_err (the decisive wrong action),
t_lock (the point after which recovery becomes impossible), and t_obs (the
first point at which the error becomes observable to any external check).
It also gives a root-cause taxonomy (Table II: Epistemic 57.9%, Competence
32.8%, Environment 9.4%) and a five-behavior recovery taxonomy (Table III)
for what an agent does after t_err.

mfact's self-improvement loop (MFACT_SELF_IMPROVEMENT_LOOP.md) does not
capture per-step trajectories at all -- each receipt is one JSON file
written once per *cron firing* (currently every 30 minutes), summarizing an
entire pick-fix-verify-commit cycle after the fact. There is no intra-firing
step log to mine. This module therefore narrows the paper's per-step
definitions to the coarsest granularity the receipt schema actually
supports -- one point estimate per firing, not per step:

  t_err  ~ the time the receipt's input was read/hashed, i.e. the moment
           the loop committed to a specific gap-ledger item for this
           firing. The receipt schema does not store this directly (there
           is no "input_hash computed at" field), so this tool uses the
           firing's own `timestamp` field as the best available proxy for
           "when the firing's decisive pick was made." This is an honest
           downgrade from the paper's per-action t_err: it can only ever
           be "the firing started around here," never "this specific
           action was the wrong one."

  t_lock ~ the commit timestamp (`git show -s --format=%cI <commit_sha>`)
           when `status` is "success" or "partial" and a `commit_sha` is
           present. This is the last point in the firing where the loop's
           own work became irreversible-by-the-loop (it never force-pushes
           or amends per AGENTS.md's fix-forward discipline, so the commit
           is a genuine lock point). For `failed` or `no_op` receipts, or
           any receipt missing a resolvable commit, there is no lock event
           to report and this tool says so rather than guessing.

  t_obs  ~ the wall-clock time *this tool itself* is invoked against the
           receipt. This is not a narrowing of the paper's definition, it
           is a documented absence: mfact's loop has no automatic
           observability step of its own. A receipt sits in
           .mfact/receipts/ unexamined until a human or a later audit pass
           (like this one) reads it. So t_obs is not "when the system
           noticed" -- it is "when someone finally looked," which is
           exactly the failure mode this repo hit for real on 2026-07-12
           (16 truncated Lean files under research-papers/, mtime
           17:12:27 PDT, not discovered until a self-audit pass around
           23:12 PDT -- roughly six hours later, recovered losslessly via
           `git checkout --`). This tool's own t_obs column is therefore
           evidence *for* that finding, not a fix for it: running this
           tool by hand is still "a human finally looked."

None of this makes arXiv:2607.09510's Table II/III percentages apply to
mfact directly -- per AGENTS.md section 4 (No Ambient Theorem Authority),
that paper's empirical distribution describes the trajectories it measured,
not mfact's loop, until mfact's own receipts are actually classified
against it. This tool exposes a `root_cause_type` field for exactly that
future classification (manually populated per receipt; absent by default)
and reports it in the aggregate table only when present, rather than
inventing a mapping from `status` to Table II's categories.

Usage:
    trajectory_annotate.py RECEIPT.json          # annotate one receipt
    trajectory_annotate.py .mfact/receipts/       # aggregate a directory
    trajectory_annotate.py                        # defaults to .mfact/receipts/
    trajectory_annotate.py --json ...             # machine-readable output
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Optional

REQUIRED_FIELDS = (
    "run_id", "gap_id", "input_hash", "output_hash", "status",
    "timestamp", "verify_delta", "commit_sha", "duration_ms",
    "oracle_rank", "collision",
)

LOCKABLE_STATUSES = ("success", "partial")

# Root-cause category mapping, hand-mirrored from
# procint/ProcInt/Playground/Trajectory/RootCause.lean's
# `RootCauseType.category` function (Table II of arXiv:2607.09510). This is
# a Python copy, not an import -- Lean and Python share no runtime here --
# so `verify_category_mapping_against_lean` below re-parses the actual
# .lean source at call time and reports drift rather than assuming this
# dict stays correct forever. Order matches the paper's own Table II order
# (5 epistemic, then 2 competence, then 2 environment).
ROOT_CAUSE_CATEGORY: dict[str, str] = {
    "falsePremise": "epistemic",
    "specificationNeglect": "epistemic",
    "outputMisreading": "epistemic",
    "ignoredSignal": "epistemic",
    "prematureAction": "epistemic",
    "knowledgeGap": "competence",
    "capabilityLimitation": "competence",
    "environmentBlocker": "environment",
    "other": "environment",
}
ROOT_CAUSE_ORDER: tuple[str, ...] = tuple(ROOT_CAUSE_CATEGORY.keys())
CATEGORY_ORDER: tuple[str, ...] = ("epistemic", "competence", "environment")

# Table III of the paper is flat -- 5 recovery behaviors, no category
# grouping -- mirrored from
# procint/ProcInt/Playground/Trajectory/RecoveryBehavior.lean's
# `RecoveryBehavior` constructors, in the paper's own order.
RECOVERY_BEHAVIOR_ORDER: tuple[str, ...] = (
    "givesUpImmediately",
    "repairsWrongProblem",
    "keepsRepeatingApproach",
    "performsUselessChecks",
    "fabricatesSuccess",
)

LEAN_ROOT_CAUSE_PATH = Path("procint/ProcInt/Playground/Trajectory/RootCause.lean")


def verify_category_mapping_against_lean(repo_root: Path) -> list[str]:
    """Parse RootCause.lean's `category` match arms and diff them against
    ROOT_CAUSE_CATEGORY above. Returns a list of human-readable mismatch
    descriptions; an empty list means the two are in sync right now. Never
    raises on a missing/unparsable file -- returns a single explanatory
    entry instead, since a stale hand-mirrored dict silently drifting from
    the real, kernel-checked Lean classifier is exactly the kind of
    unverified claim AGENTS.md section 4 (No Ambient Theorem Authority)
    forbids: this Python dict borrows no standing from the Lean proofs
    unless it demonstrably matches what they classify.

    The parser distinguishes `category`'s match arms (`| .ctor => .cat`,
    dot-prefixed on both sides) from the `inductive RootCauseType`
    constructor list a few lines above (`| ctor`, no dot, no arrow) --
    the two patterns don't overlap, so this only ever picks up the
    classifier's actual mapping, not the type's constructor declarations.
    """
    lean_path = repo_root / LEAN_ROOT_CAUSE_PATH
    if not lean_path.exists():
        return [f"cannot verify: {lean_path} not found"]
    text = lean_path.read_text()
    pairs = re.findall(r"\|\s*\.(\w+)\s*=>\s*\.(\w+)", text)
    if not pairs:
        return [f"cannot verify: no '| .ctor => .category' arms found in {lean_path}"]
    lean_mapping = dict(pairs)

    mismatches: list[str] = []
    for ctor, expected in ROOT_CAUSE_CATEGORY.items():
        actual = lean_mapping.get(ctor)
        if actual is None:
            mismatches.append(f"{ctor}: in Python mapping, missing from Lean category function")
        elif actual != expected:
            mismatches.append(f"{ctor}: Python says {expected!r}, Lean says {actual!r}")
    for ctor in lean_mapping:
        if ctor not in ROOT_CAUSE_CATEGORY:
            mismatches.append(f"{ctor}: in Lean category function, missing from Python mapping")
    return mismatches


def _git_commit_timestamp(commit_sha: str, repo_root: Path) -> Optional[str]:
    """Resolve a commit's committer date via `git show -s --format=%cI`.

    Returns None (not a guess) if the sha is missing, unresolvable, or the
    call otherwise fails -- e.g. a receipt referencing a commit that was
    later garbage-collected, or `commit_sha: null` for a failed/no_op run.
    """
    if not commit_sha:
        return None
    try:
        out = subprocess.run(
            ["git", "show", "-s", "--format=%cI", commit_sha],
            cwd=repo_root, capture_output=True, text=True, timeout=10,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    if out.returncode != 0:
        return None
    ts = out.stdout.strip()
    return ts or None


@dataclass
class Annotation:
    path: Path
    receipt: dict[str, Any]
    missing_fields: list[str] = field(default_factory=list)
    t_err: Optional[str] = None
    t_err_basis: str = ""
    t_lock: Optional[str] = None
    t_lock_basis: str = ""
    t_obs: str = ""
    t_obs_basis: str = "tool invocation time (mfact has no automatic observability)"

    def to_dict(self) -> dict[str, Any]:
        r = self.receipt
        return {
            "path": str(self.path),
            "run_id": r.get("run_id"),
            "gap_id": r.get("gap_id"),
            "status": r.get("status"),
            "commit_sha": r.get("commit_sha"),
            "oracle_rank": r.get("oracle_rank"),
            "collision": r.get("collision"),
            "root_cause_type": r.get("root_cause_type"),
            "missing_fields": self.missing_fields,
            "t_err": self.t_err,
            "t_err_basis": self.t_err_basis,
            "t_lock": self.t_lock,
            "t_lock_basis": self.t_lock_basis,
            "t_obs": self.t_obs,
            "t_obs_basis": self.t_obs_basis,
        }


def annotate_receipt(path: Path, repo_root: Path, now: datetime) -> Annotation:
    receipt = json.loads(path.read_text())
    ann = Annotation(path=path, receipt=receipt)

    ann.missing_fields = [f for f in REQUIRED_FIELDS if f not in receipt]

    # t_err: firing's own `timestamp`, the best available proxy for "pick
    # committed" -- see module docstring for why this is a narrowing, not
    # an exact match to the paper's per-action t_err.
    ts = receipt.get("timestamp")
    if ts:
        ann.t_err = ts
        ann.t_err_basis = "receipt.timestamp (firing start proxy)"
    else:
        ann.t_err_basis = "unavailable: receipt has no 'timestamp' field"

    # t_lock: commit's committer date, only when the firing actually
    # locked in a change.
    status = receipt.get("status")
    commit_sha = receipt.get("commit_sha")
    if status in LOCKABLE_STATUSES and commit_sha:
        resolved = _git_commit_timestamp(commit_sha, repo_root)
        if resolved:
            ann.t_lock = resolved
            ann.t_lock_basis = f"git committer date of {commit_sha}"
        else:
            ann.t_lock_basis = (
                f"unresolvable: commit_sha={commit_sha!r} not found in this "
                f"checkout (status={status!r})"
            )
    elif status in LOCKABLE_STATUSES:
        ann.t_lock_basis = f"unavailable: status={status!r} but commit_sha is null/empty"
    else:
        ann.t_lock_basis = f"not applicable: status={status!r} has no lock event"

    # t_obs: this invocation, always. Documented as an absence, not a
    # feature -- see module docstring.
    ann.t_obs = now.astimezone(timezone.utc).isoformat()

    return ann


def discover_receipts(target: Path) -> list[Path]:
    if target.is_file():
        return [target]
    if target.is_dir():
        return sorted(
            p for p in target.glob("*.json") if p.name != "latest.json"
        )
    return []


def format_single(ann: Annotation) -> str:
    r = ann.receipt
    lines = [
        f"receipt:        {ann.path}",
        f"run_id:         {r.get('run_id')}",
        f"gap_id:         {r.get('gap_id')}",
        f"status:         {r.get('status')}",
        f"oracle_rank:    {r.get('oracle_rank')}",
        f"collision:      {r.get('collision')}",
        f"commit_sha:     {r.get('commit_sha')}",
        f"root_cause_type: {r.get('root_cause_type', '(not yet annotated)')}",
    ]
    if ann.missing_fields:
        lines.append(f"WARNING: missing schema fields: {', '.join(ann.missing_fields)}")
    lines += [
        "",
        f"t_err  = {ann.t_err or '(unavailable)'}",
        f"         basis: {ann.t_err_basis}",
        f"t_lock = {ann.t_lock or '(unavailable)'}",
        f"         basis: {ann.t_lock_basis}",
        f"t_obs  = {ann.t_obs}",
        f"         basis: {ann.t_obs_basis}",
    ]
    return "\n".join(lines)


def compute_category_share(anns: list[Annotation]) -> dict[str, Any]:
    """Roll up receipts' `root_cause_type` values into the 3 Table-II
    categories via ROOT_CAUSE_CATEGORY. Only receipts carrying a
    manually-annotated `root_cause_type` contribute to the share -- an
    unannotated receipt is reported as unannotated, never silently dropped
    or counted as a guessed category, so the denominator is never
    fabricated.
    """
    annotated = [a for a in anns if a.receipt.get("root_cause_type")]
    unannotated = len(anns) - len(annotated)

    type_counts: dict[str, int] = {}
    unrecognized: list[str] = []
    for a in annotated:
        rc = str(a.receipt["root_cause_type"])
        type_counts[rc] = type_counts.get(rc, 0) + 1
        if rc not in ROOT_CAUSE_CATEGORY:
            unrecognized.append(rc)

    category_counts: dict[str, int] = {c: 0 for c in CATEGORY_ORDER}
    for rc, n in type_counts.items():
        cat = ROOT_CAUSE_CATEGORY.get(rc)
        if cat is not None:
            category_counts[cat] += n

    return {
        "total_receipts": len(anns),
        "annotated": len(annotated),
        "unannotated": unannotated,
        "total_classified": sum(category_counts.values()),
        "category_counts": category_counts,
        "type_counts": type_counts,
        "unrecognized_values": sorted(set(unrecognized)),
    }


def format_category_share(share: dict[str, Any], lean_sync_issues: list[str]) -> str:
    lines = ["category share (Table II style, rolled up from root_cause_type):"]
    if share["annotated"] == 0:
        lines.append(
            "  unavailable: no receipt in this set has a manually-annotated "
            f"'root_cause_type' yet ({share['total_receipts']} receipt(s) total, "
            "0 annotated). Not reported as 0% for any category -- there is "
            "nothing to divide."
        )
    else:
        total = share["total_classified"]
        for cat in CATEGORY_ORDER:
            n = share["category_counts"][cat]
            pct = (100.0 * n / total) if total else 0.0
            lines.append(f"  {cat.capitalize():<12} {n:>3}/{total} ({pct:5.1f}%)")
            for rc in ROOT_CAUSE_ORDER:
                if ROOT_CAUSE_CATEGORY[rc] != cat:
                    continue
                c = share["type_counts"].get(rc, 0)
                if c:
                    lines.append(f"      {rc:<24} {c}")
        if share["unrecognized_values"]:
            lines.append(
                "  unrecognized root_cause_type value(s) (not one of the 9 "
                "RootCauseType constructors, excluded from the share above): "
                + ", ".join(share["unrecognized_values"])
            )
        if share["unannotated"]:
            lines.append(
                f"  ({share['unannotated']}/{share['total_receipts']} receipt(s) have "
                "no root_cause_type yet and are excluded from this share)"
            )

    if lean_sync_issues:
        unverifiable = [i for i in lean_sync_issues if i.startswith("cannot verify")]
        mismatches = [i for i in lean_sync_issues if not i.startswith("cannot verify")]
        if unverifiable:
            lines.append("  WARNING: could not verify the mapping above against Lean:")
            for issue in unverifiable:
                lines.append(f"    - {issue}")
        if mismatches:
            lines.append(
                "  WARNING: this Python mapping and "
                f"{LEAN_ROOT_CAUSE_PATH}'s category function disagree:"
            )
            for issue in mismatches:
                lines.append(f"    - {issue}")
    else:
        lines.append(
            f"  (mapping verified against {LEAN_ROOT_CAUSE_PATH} at run time: in sync)"
        )
    return "\n".join(lines)


def compute_recovery_behavior_breakdown(anns: list[Annotation]) -> dict[str, Any]:
    """Flat count of `recovery_behavior` values (Table III has no category
    grouping, unlike root_cause_type/Table II)."""
    annotated = [a for a in anns if a.receipt.get("recovery_behavior")]
    counts: dict[str, int] = {}
    unrecognized: list[str] = []
    for a in annotated:
        rb = str(a.receipt["recovery_behavior"])
        counts[rb] = counts.get(rb, 0) + 1
        if rb not in RECOVERY_BEHAVIOR_ORDER:
            unrecognized.append(rb)
    return {
        "total_receipts": len(anns),
        "annotated": len(annotated),
        "counts": counts,
        "unrecognized_values": sorted(set(unrecognized)),
    }


def format_recovery_behavior_breakdown(rb: dict[str, Any]) -> str:
    lines = [
        "recovery_behavior breakdown (Table III style -- flat, the paper "
        "has no category grouping for these 5):"
    ]
    if rb["annotated"] == 0:
        lines.append(
            "  unavailable: no receipt in this set has a manually-annotated "
            f"'recovery_behavior' yet ({rb['total_receipts']} receipt(s) total, "
            "0 annotated)."
        )
        return "\n".join(lines)
    total = rb["annotated"]
    for behavior in RECOVERY_BEHAVIOR_ORDER:
        n = rb["counts"].get(behavior, 0)
        if n:
            pct = 100.0 * n / total
            lines.append(f"  {behavior:<24} {n:>3}/{total} ({pct:5.1f}%)")
    if rb["unrecognized_values"]:
        lines.append(
            "  unrecognized recovery_behavior value(s) (not one of the 5 "
            "RecoveryBehavior constructors): " + ", ".join(rb["unrecognized_values"])
        )
    return "\n".join(lines)


def format_aggregate(anns: list[Annotation], lean_sync_issues: Optional[list[str]] = None) -> str:
    if not anns:
        return (
            "No receipts found in .mfact/receipts/ (excluding latest.json).\n"
            "This is the expected, honest empty case: the cron-driven fix loop\n"
            "(job 0e35feb8, MFACT_SELF_IMPROVEMENT_LOOP.md) had not written a\n"
            "single-run receipt as of this invocation. There is nothing to\n"
            "annotate yet -- nothing here is being faked or stubbed to fill\n"
            "the gap; this table is genuinely empty because the input is."
        )

    lines: list[str] = []
    lines.append(f"{len(anns)} receipt(s) found.\n")

    # count by status
    status_counts: dict[str, int] = {}
    for a in anns:
        s = str(a.receipt.get("status", "(missing)"))
        status_counts[s] = status_counts.get(s, 0) + 1
    lines.append("count by status:")
    for s, c in sorted(status_counts.items(), key=lambda kv: -kv[1]):
        lines.append(f"  {s:<10} {c}")

    # count by collision
    collisions = sum(1 for a in anns if a.receipt.get("collision") is True)
    lines.append(f"\ncollisions flagged: {collisions}")

    # t_lock resolvability
    locked = sum(1 for a in anns if a.t_lock)
    lines.append(f"receipts with a resolvable t_lock (commit found in this checkout): {locked}/{len(anns)}")

    # root_cause_type / recovery_behavior aggregation -- rolled up into the
    # paper's own Table II categories (epistemic/competence/environment)
    # and Table III's flat behavior list, respectively. Both gracefully
    # report "unavailable" rather than a fabricated 0%/100% when no
    # receipt has been manually annotated yet (the current, real state of
    # .mfact/receipts/).
    lines.append("")
    lines.append(
        format_category_share(
            compute_category_share(anns),
            lean_sync_issues if lean_sync_issues is not None else [],
        )
    )
    lines.append("")
    lines.append(format_recovery_behavior_breakdown(compute_recovery_behavior_breakdown(anns)))

    # per-receipt table
    lines.append("\nper-receipt detail:")
    header = f"{'run_id':<20} {'gap_id':<8} {'status':<9} {'t_err':<22} {'t_lock':<26} {'missing_fields'}"
    lines.append(header)
    lines.append("-" * len(header))
    for a in anns:
        r = a.receipt
        lines.append(
            f"{str(r.get('run_id'))[:20]:<20} "
            f"{str(r.get('gap_id'))[:8]:<8} "
            f"{str(r.get('status'))[:9]:<9} "
            f"{(a.t_err or '-')[:22]:<22} "
            f"{(a.t_lock or '-')[:26]:<26} "
            f"{', '.join(a.missing_fields) or '-'}"
        )

    lines.append(
        "\nNote on t_obs: every row above was observed at "
        f"{anns[0].t_obs} (this invocation). mfact has no automatic "
        "observability step of its own -- a bad receipt is only ever "
        "noticed when a human or a later audit pass runs a tool like this "
        "one against it. See module docstring for the 2026-07-12 truncation "
        "incident this finding is grounded in."
    )
    return "\n".join(lines)


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="trajectory_annotate.py",
        description=(
            "Derive t_err/t_lock/t_obs-equivalent timestamps for mfact "
            "self-improvement-loop receipts, adapted from the per-step "
            "definitions in arXiv:2607.09510 to this repo's per-firing "
            "receipt granularity (see module docstring for the exact "
            "mapping and its honest limits)."
        ),
    )
    parser.add_argument(
        "target", nargs="?", default=None,
        help=(
            "Path to a single receipt JSON file, or a directory of "
            "receipts (globs *.json, excludes latest.json). Defaults to "
            "<repo>/.mfact/receipts/."
        ),
    )
    parser.add_argument(
        "--repo-root", default=None,
        help="Repo root for resolving commit timestamps (default: this script's parent's parent).",
    )
    parser.add_argument(
        "--json", action="store_true",
        help="Emit machine-readable JSON instead of the formatted table.",
    )
    args = parser.parse_args(argv)

    script_dir = Path(__file__).resolve().parent
    repo_root = Path(args.repo_root).resolve() if args.repo_root else script_dir.parent

    if args.target is not None:
        target = Path(args.target)
    else:
        target = repo_root / ".mfact" / "receipts"

    if not target.exists():
        print(f"error: path does not exist: {target}", file=sys.stderr)
        return 2

    receipt_paths = discover_receipts(target)
    now = datetime.now(timezone.utc)

    anns: list[Annotation] = []
    parse_errors: list[tuple[Path, str]] = []
    for p in receipt_paths:
        try:
            anns.append(annotate_receipt(p, repo_root, now))
        except (json.JSONDecodeError, OSError) as e:
            parse_errors.append((p, str(e)))

    for p, err in parse_errors:
        print(f"warning: could not parse {p}: {err}", file=sys.stderr)

    lean_sync_issues = verify_category_mapping_against_lean(repo_root)

    if args.json:
        payload = {
            "target": str(target),
            "mode": "single" if target.is_file() else "directory",
            "count": len(anns),
            "parse_errors": [{"path": str(p), "error": e} for p, e in parse_errors],
            "receipts": [a.to_dict() for a in anns],
            "category_share": compute_category_share(anns),
            "recovery_behavior_breakdown": compute_recovery_behavior_breakdown(anns),
            "lean_category_mapping_sync_issues": lean_sync_issues,
        }
        print(json.dumps(payload, indent=2))
    elif target.is_file():
        if not anns:
            print(f"error: could not annotate {target}", file=sys.stderr)
            return 1
        print(format_single(anns[0]))
    else:
        print(format_aggregate(anns, lean_sync_issues))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
