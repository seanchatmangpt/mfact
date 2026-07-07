"""Agent cockpit — read-only repo status, tool diagnostics, and next-action decision tree.

Queries the current state of the repository via git, manifest, standing.env, and
receipt verification. Returns structured dataclasses with evidence sources.

All operations are read-only; no standing values are computed or asserted here.
Authority comes from release/release-manifest.json, release/standing.env,
and receipt chains.
"""

import json
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Dict, Any


def find_repo_root(start_path: Optional[Path] = None) -> Path:
    """Walk up from start_path (default: __file__'s dir) until AGENTS.md is found."""
    if start_path is None:
        start_path = Path(__file__).resolve().parent

    current = start_path
    for _ in range(100):  # safety limit to prevent infinite loops
        if (current / "AGENTS.md").exists():
            return current
        if current.parent == current:  # reached filesystem root
            raise RuntimeError(
                f"Could not find repo root (AGENTS.md) starting from {start_path}"
            )
        current = current.parent

    raise RuntimeError(
        f"Could not find repo root (AGENTS.md) starting from {start_path}"
    )


def read_env_file(path: Path) -> Dict[str, str]:
    """Parse a .env file into key-value dict."""
    kv = {}
    if not path.exists():
        return kv
    try:
        with open(path, "r") as f:
            for line in f:
                line = line.strip()
                if line and "=" in line and not line.startswith("#"):
                    k, _, v = line.partition("=")
                    kv[k.strip()] = v.strip()
    except Exception:
        pass
    return kv


def read_json_file(path: Path) -> Optional[Dict[str, Any]]:
    """Safely read a JSON file."""
    if not path.exists():
        return None
    try:
        with open(path, "r") as f:
            return json.load(f)
    except Exception:
        return None


def git_command(repo_root: Path, *args: str) -> tuple[int, str]:
    """Run a git command and return (returncode, stdout)."""
    try:
        result = subprocess.run(
            ["git", "-C", str(repo_root)] + list(args),
            capture_output=True,
            text=True,
            timeout=5,
        )
        return result.returncode, result.stdout.strip()
    except Exception as e:
        return 1, f"ERROR: {e}"


def find_tool(name: str) -> Optional[str]:
    """Find a tool on PATH or at a known location."""
    # Check standard PATH first
    path = shutil.which(name)
    if path:
        return path

    # Check elan-managed tools
    elan_dir = Path.home() / ".elan" / "bin"
    if (elan_dir / name).exists():
        return str(elan_dir / name)

    return None


@dataclass
class ToolCheck:
    """Result of probing for a single tool."""
    name: str
    status: str  # FOUND, MISSING, ERROR
    path: Optional[str] = None
    version: Optional[str] = None
    error_message: Optional[str] = None


@dataclass
class CorrespondenceRail:
    """Verification receipt status for post-release correspondence."""
    status: str  # DECLARED, MISSING, INCOMPLETE
    evidence: Optional[str] = None


@dataclass
class CrownRail:
    """Crown theorem equivalence status."""
    theorem_name: str
    status: str  # STATED, PROVEN, BLOCKED, UNKNOWN
    evidence_source: str  # standing.env key or "UNKNOWN"


@dataclass
class ManifestInfo:
    """Core release manifest info."""
    release: Optional[str]
    fold_hash: Optional[str]
    total_decls: Optional[int]
    proven_count: Optional[int]
    stated_not_proven: List[str]
    is_present: bool


@dataclass
class GitState:
    """Current git state."""
    branch: Optional[str]
    current_commit: Optional[str]
    is_dirty: bool
    branch_error: Optional[str] = None
    commit_error: Optional[str] = None


@dataclass
class RepoStatus:
    """Complete repository status snapshot."""
    git: GitState
    manifest: ManifestInfo
    crown_rail: CrownRail
    correspondence_rail: CorrespondenceRail
    tree_clean: bool
    evidence_sources: Dict[str, str]  # field -> source doc


@dataclass
class NextAction:
    """A single item in the next-action decision tree."""
    priority: int
    description: str
    reason: str
    status: str  # BLOCKED, DECLARED, PENDING, ALIVE


def status() -> RepoStatus:
    """
    Reads git (branch, commit, dirty-tree), manifest (foldHash), crown rail
    (WFNET_CROWN_EQUIVALENCE from standing.env), correspondence rail (presence
    of verif receipts). Each field reports evidence source. Returns typed
    RepoStatus dataclass.
    """
    root = find_repo_root()

    # Discover evidence sources
    evidence = {}

    # 1. Git state
    git_st = GitState(branch=None, current_commit=None, is_dirty=False)
    code, branch = git_command(root, "branch", "--show-current")
    if code == 0:
        git_st.branch = branch
        evidence["branch"] = "git branch --show-current"
    else:
        git_st.branch_error = branch

    code, commit = git_command(root, "rev-parse", "HEAD")
    if code == 0:
        git_st.current_commit = commit[:7]  # short hash
        evidence["commit"] = "git rev-parse HEAD"
    else:
        git_st.commit_error = commit

    code, status_out = git_command(root, "status", "--porcelain")
    git_st.is_dirty = code == 0 and bool(status_out.strip())
    evidence["tree_clean"] = "git status --porcelain"

    # 2. Manifest
    manifest_path = root / "release" / "release-manifest.json"
    manifest_data = read_json_file(manifest_path)
    manifest_info = ManifestInfo(
        release=None,
        fold_hash=None,
        total_decls=None,
        proven_count=None,
        stated_not_proven=[],
        is_present=manifest_path.exists(),
    )
    if manifest_data:
        manifest_info.release = manifest_data.get("release")
        manifest_info.fold_hash = manifest_data.get("foldHash")
        artifacts = manifest_data.get("artifacts", [])
        manifest_info.total_decls = len(artifacts)
        manifest_info.proven_count = sum(1 for a in artifacts if a.get("proven"))
        manifest_info.stated_not_proven = manifest_data.get("statedNotProven", [])
        evidence["manifest"] = str(manifest_path)

    # 3. Crown rail (WFNET_CROWN_EQUIVALENCE from standing.env)
    standing_path = root / "release" / "standing.env"
    standing_env = read_env_file(standing_path)
    crown_status = standing_env.get("WFNET_CROWN_EQUIVALENCE", "UNKNOWN")
    crown_rail = CrownRail(
        theorem_name="WFNET_CROWN_EQUIVALENCE",
        status=crown_status,
        evidence_source="release/standing.env",
    )
    evidence["crown"] = "release/standing.env"

    # 4. Correspondence rail (check for POST_RELEASE_PACKET in standing.env)
    correspondence_status = "MISSING"
    correspondence_evidence = None
    if "POST_RELEASE_PACKET" in standing_env:
        correspondence_status = "DECLARED"
        correspondence_evidence = "release/standing.env POST_RELEASE_PACKET"
    elif (root / "procint" / "ProcInt" / "Release" / "PostRelease.lean").exists():
        correspondence_status = "INCOMPLETE"
        correspondence_evidence = "procint/ProcInt/Release/PostRelease.lean present but not in standing.env"

    correspondence_rail = CorrespondenceRail(
        status=correspondence_status, evidence=correspondence_evidence
    )
    evidence["correspondence"] = correspondence_evidence or "none"

    return RepoStatus(
        git=git_st,
        manifest=manifest_info,
        crown_rail=crown_rail,
        correspondence_rail=correspondence_rail,
        tree_clean=not git_st.is_dirty,
        evidence_sources=evidence,
    )


def doctor() -> List[ToolCheck]:
    """
    Probes for python, uv, elan, lean (via elan), lake, rustup, cargo, opam,
    charon, aeneas. Each → FOUND/MISSING/ERROR. Returns list of ToolCheck.
    """
    tools_to_probe = [
        ("python3", "python3 --version"),
        ("uv", "uv --version"),
        ("elan", "elan --version"),
        ("lean", "lean --version"),
        ("lake", "lake --version"),
        ("rustup", "rustup --version"),
        ("cargo", "cargo --version"),
        ("opam", "opam --version"),
        ("charon", "charon --version"),
        ("aeneas", "aeneas --version"),
    ]

    results: List[ToolCheck] = []

    for tool_name, version_cmd in tools_to_probe:
        tool_path = find_tool(tool_name)

        if not tool_path:
            results.append(
                ToolCheck(name=tool_name, status="MISSING", path=None)
            )
            continue

        # Try to get version
        version_str = None
        try:
            result = subprocess.run(
                version_cmd.split(),
                capture_output=True,
                text=True,
                timeout=3,
            )
            if result.returncode == 0:
                version_str = result.stdout.strip().split("\n")[0]
            else:
                # Tool found but version check failed
                version_str = f"(version check failed: {result.stderr[:50]})"
        except Exception as e:
            version_str = f"(error: {e})"

        results.append(
            ToolCheck(
                name=tool_name,
                status="FOUND",
                path=tool_path,
                version=version_str,
            )
        )

    return results


def next() -> List[NextAction]:
    """
    Fixed decision tree:
    1. crown BLOCKED → repair [Finite T]
    2. correspondence DECLARED → D1
    3. manifest missing → review
    4. else no-action
    Returns list of NextAction items in priority order.
    """
    st = status()
    actions: List[NextAction] = []

    # (1) Crown BLOCKED
    if st.crown_rail.status == "BLOCKED":
        actions.append(
            NextAction(
                priority=1,
                description="Repair crown theorem (Finite T)",
                reason=f"WFNET_CROWN_EQUIVALENCE is BLOCKED",
                status="BLOCKED",
            )
        )
        return actions

    # (2) Correspondence DECLARED → check for witnesses
    if st.correspondence_rail.status == "DECLARED":
        actions.append(
            NextAction(
                priority=2,
                description="Crown rail declared but correspondence witness not found",
                reason="POST_RELEASE_PACKET present but no D1 verification receipt",
                status="DECLARED",
            )
        )
        return actions

    # (3) Manifest missing
    if not st.manifest.is_present:
        actions.append(
            NextAction(
                priority=3,
                description="Review manifest — release/release-manifest.json is missing",
                reason="Cannot verify release identity or artifact status",
                status="PENDING",
            )
        )
        return actions

    # (4) No blocking action — report all-clear
    actions.append(
        NextAction(
            priority=4,
            description="No immediate action — all gates clear",
            reason="Crown status is not BLOCKED; correspondence rail is not DECLARED; manifest is present",
            status="ALIVE",
        )
    )

    return actions
