"""FastMCP server: read-only integrity, correctness, and guardrail scan check tools.

Run with `uv run python -m mpops.standing_guard.server`.
"""

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path
from typing import Any

from fastmcp import FastMCP

mcp = FastMCP("standing-guard")

# Resolve repository root
# pylab/src/mpops/standing_guard/server.py -> mfact/
REPO_ROOT = Path(__file__).resolve().parents[4]


def is_untracked(path: Path, repo_root: Path) -> bool:
    """Check if a file path is untracked in git."""
    try:
        rel_path = path.relative_to(repo_root) if path.is_absolute() else path
        # 1. Check if git ls-files does not track the file
        res_ls = subprocess.run(
            ["git", "ls-files", "--error-unmatch", str(rel_path)],
            cwd=repo_root,
            capture_output=True,
            text=True,
            check=False
        )
        if res_ls.returncode != 0:
            return True
        # 2. Check if git status reports it as untracked
        res_status = subprocess.run(
            ["git", "status", "--porcelain", str(rel_path)],
            cwd=repo_root,
            capture_output=True,
            text=True,
            check=False
        )
        if res_status.stdout.startswith("??"):
            return True
        return False
    except Exception:
        return False


def check_sorry_theorem_promotion(repo_root: Path) -> list[dict[str, Any]]:
    """Class 1 (Sorry Theorem Promotion) check."""
    ttl_files = []
    fragments_dir = repo_root / "packs" / "lean-math-pack" / "fragments"
    if fragments_dir.exists():
        ttl_files.extend(fragments_dir.glob("*.ttl"))
    ontology_file = repo_root / "packs" / "lean-math-pack" / "ontology.ttl"
    if ontology_file.exists():
        ttl_files.append(ontology_file)

    proven_decls = []
    seen = set()
    for file_path in ttl_files:
        try:
            content = file_path.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
        blocks = re.split(r'\bprocint:Decl_\w+\s+a\s+procint:Decl\b', content)
        for block in blocks:
            status_match = re.search(r'procint:status\s+"([^"]+)"', block)
            if not status_match or status_match.group(1) != "proven":
                continue
            name_match = re.search(r'procint:declName\s+"([^"]+)"', block)
            if not name_match:
                continue
            name = name_match.group(1)

            module_match = re.search(r'procint:inModule\s+"([^"]+)"', block)
            module = module_match.group(1) if module_match else None

            if name not in seen:
                seen.add(name)
                proven_decls.append({
                    "name": name,
                    "module": module,
                    "file": str(file_path.relative_to(repo_root))
                })

    if not proven_decls:
        return []

    # Compile a single Lean file containing all imports and print axioms
    unique_modules = sorted(list({f"ProcInt.{d['module']}" for d in proven_decls if d['module']}))
    lines = [f"import {m}" for m in unique_modules]
    for d in proven_decls:
        lines.append(f"#print axioms {d['name']}")
    lean_code = "\n".join(lines)

    procint_dir = repo_root / "procint"
    lake_path = "/Users/sac/.elan/bin/lake"

    res = subprocess.run(
        [lake_path, "env", "lean", "--stdin"],
        cwd=procint_dir,
        input=lean_code,
        capture_output=True,
        text=True,
        errors="ignore",
        check=False
    )

    output = res.stdout + "\n" + res.stderr
    findings = []

    for d in proven_decls:
        name = d["name"]
        # Find the line that mentions the declaration and check for sorryAx
        pattern = rf"(?:'|){re.escape(name)}(?:'|)\s+(?:depends on:|does not depend|unknown identifier).*?(?=(?:ProcInt\.|\Z))"
        match = re.search(pattern, output, re.DOTALL)
        if match:
            block_text = match.group(0)
            if "sorryAx" in block_text:
                findings.append({
                    "gap_class": 1,
                    "severity": "BLOCKER",
                    "refusal_code": "SORRY_THEOREM_PROMOTED",
                    "path_or_target": name,
                    "evidence": f"Theorem {name} is marked proven in catalog but depends on sorryAx: {block_text.strip()}",
                    "expected": f"{name} does not depend on sorryAx",
                    "actual": block_text.strip(),
                    "recommended_action": "Complete the proof of the theorem in Lean to remove sorryAx.",
                    "standing_status": "PROVEN"
                })
        else:
            # If the block was not found, search the whole output for sorryAx
            # in case the name format varies slightly in stdout/stderr
            if f"unknown identifier '{name}'" in output or f"unknown constant '{name}'" in output:
                findings.append({
                    "gap_class": 1,
                    "severity": "BLOCKER",
                    "refusal_code": "SORRY_THEOREM_PROMOTED",
                    "path_or_target": name,
                    "evidence": f"Theorem {name} is marked proven in catalog but is unknown in Lean environment.",
                    "expected": f"Lean environment defines constant {name}",
                    "actual": f"Lean reported: unknown identifier '{name}'",
                    "recommended_action": "Check spelling and compilation of the theorem in Lean.",
                    "standing_status": "PROVEN"
                })

    return findings


def check_ledger_drift(repo_root: Path) -> list[dict[str, Any]]:
    """Class 2 (Ledger Drift) check."""
    import hashlib
    import tomllib

    artifacts_toml_path = repo_root / ".mfact" / "artifacts.toml"
    findings = []
    if not artifacts_toml_path.exists():
        return findings

    try:
        with open(artifacts_toml_path, "rb") as f:
            data = tomllib.load(f)
    except Exception as e:
        findings.append({
            "gap_class": 2,
            "severity": "BLOCKER",
            "refusal_code": "ARTIFACTS_TOML_UNREADABLE",
            "path_or_target": ".mfact/artifacts.toml",
            "evidence": f"Failed to parse artifacts.toml: {e}",
            "expected": "Valid TOML",
            "actual": str(e),
            "recommended_action": "Fix the syntax of .mfact/artifacts.toml",
            "standing_status": "REFUSED"
        })
        return findings

    for art in data.get("artifact", []):
        path_str = art.get("path", "")
        expected_hash = art.get("content_hash", "")
        if not path_str:
            continue

        file_path = repo_root / path_str

        # 1. Compute hash if file exists
        if not file_path.exists():
            findings.append({
                "gap_class": 2,
                "severity": "BLOCKER",
                "refusal_code": "ARTIFACT_MISSING",
                "path_or_target": path_str,
                "evidence": f"Ledgered artifact {path_str} is missing from disk.",
                "expected": "File exists on disk",
                "actual": "File is missing",
                "recommended_action": "Regenerate the artifact using the appropriate builder or ggen.",
                "standing_status": "REFUSED"
            })
            continue

        try:
            try:
                h = hashlib.blake3()
                with open(file_path, "rb") as f_art:
                    while chunk := f_art.read(8192):
                        h.update(chunk)
                actual_hash = h.hexdigest()
            except (AttributeError, ValueError, TypeError):
                # Fall back to b3sum CLI
                res_b3 = subprocess.run(
                    ["b3sum", str(file_path)],
                    cwd=repo_root,
                    capture_output=True,
                    text=True,
                    check=False
                )
                if res_b3.returncode == 0:
                    actual_hash = res_b3.stdout.strip().split()[0]
                else:
                    raise RuntimeError(f"b3sum failed with: {res_b3.stderr}")
        except Exception as e:
            findings.append({
                "gap_class": 2,
                "severity": "BLOCKER",
                "refusal_code": "HASH_COMPUTATION_FAILED",
                "path_or_target": path_str,
                "evidence": f"Failed to compute BLAKE3 hash for {path_str}: {e}",
                "expected": "Successful hash computation",
                "actual": str(e),
                "recommended_action": "Check file permissions.",
                "standing_status": "REFUSED"
            })
            continue

        expected_clean = expected_hash.replace("blake3:", "")
        if actual_hash != expected_clean:
            findings.append({
                "gap_class": 2,
                "severity": "BLOCKER",
                "refusal_code": "ARTIFACT_DRIFT_REFUSED",
                "path_or_target": path_str,
                "evidence": f"Ledgered artifact {path_str} hash changed (drift detected).",
                "expected": expected_clean,
                "actual": actual_hash,
                "recommended_action": "Re-run 'just render' or rebuild to align artifact or manifest.",
                "standing_status": "REFUSED"
            })

        # 2. Check if untracked in git
        if is_untracked(file_path, repo_root):
            findings.append({
                "gap_class": 2,
                "severity": "BLOCKER",
                "refusal_code": "ORPHAN_ARTIFACT_REFUSED",
                "path_or_target": path_str,
                "evidence": f"Ledgered artifact {path_str} is untracked in git.",
                "expected": "Tracked in git",
                "actual": "Untracked in git",
                "recommended_action": "Run 'git add' on the ledgered file.",
                "standing_status": "REFUSED"
            })

    return findings


def check_orphan_artifacts(repo_root: Path, ledgered_paths: set[str]) -> list[dict[str, Any]]:
    """Class 3 (Orphan Artifact Scan) check."""
    findings = []
    # Scan the directory tree for files matching release/*.json, paper/*.tex
    # excluding procint/Playground/** and pylab/**
    for folder, pattern in [("release", "**/*.json"), ("paper", "**/*.tex")]:
        dir_path = repo_root / folder
        if not dir_path.exists():
            continue
        for file_path in dir_path.glob(pattern):
            rel_str = str(file_path.relative_to(repo_root))
            if "procint/Playground" in rel_str or "pylab" in rel_str:
                continue
            if rel_str == "paper/main.tex":
                continue
            if rel_str not in ledgered_paths:
                content = ""
                try:
                    content = file_path.read_text(encoding="utf-8", errors="ignore")
                except Exception:
                    pass

                # Check standing-bearing patterns
                standing_bearing = any(p in content.lower() for p in [
                    "proven", "stated", "certified", "sorry", "hash", "audit", "quadrature", "verif"
                ])
                is_part_of_release_or_paper = rel_str.startswith("release/") or rel_str.startswith("paper/")

                if standing_bearing or is_part_of_release_or_paper:
                    findings.append({
                        "gap_class": 3,
                        "severity": "BLOCKER",
                        "refusal_code": "ORPHAN_ARTIFACT_REFUSED",
                        "path_or_target": rel_str,
                        "evidence": f"File {rel_str} is not registered in .mfact/artifacts.toml but exists on disk in release/paper.",
                        "expected": "Registered in .mfact/artifacts.toml",
                        "actual": "Not registered in .mfact/artifacts.toml",
                        "recommended_action": "Add the file to .mfact/artifacts.toml or remove it if it is obsolete.",
                        "standing_status": "REFUSED"
                    })
    return findings


def check_regen_check_coverage_gap(repo_root: Path, data_toml: dict[str, Any]) -> list[dict[str, Any]]:
    """Class 4 (regen-check coverage gap) check."""
    justfile_path = repo_root / "justfile"
    findings = []
    if not justfile_path.exists():
        return findings

    try:
        justfile_content = justfile_path.read_text(encoding="utf-8", errors="ignore")
    except Exception as e:
        findings.append({
            "gap_class": 4,
            "severity": "WARNING",
            "refusal_code": "REGEN_CHECK_COVERAGE_GAP",
            "path_or_target": "justfile",
            "evidence": f"Failed to read justfile: {e}",
            "expected": "Readable justfile",
            "actual": str(e),
            "recommended_action": "Fix justfile permissions",
            "standing_status": "REFUSED"
        })
        return findings

    # Extract regen-check recipe body
    lines = justfile_content.splitlines()
    body_lines = []
    in_recipe = False
    for line in lines:
        if line.startswith("regen-check:"):
            in_recipe = True
            continue
        if in_recipe:
            if line.startswith(" ") or line.startswith("\t") or not line.strip():
                body_lines.append(line)
            else:
                break
    body = "\n".join(body_lines)

    for art in data_toml.get("artifact", []):
        path_str = art.get("path", "")
        producer = art.get("producer", "")
        if not path_str or not producer:
            continue

        referenced = False
        if producer == "ggen":
            referenced = "ggen" in body
        elif "/" in producer:
            referenced = producer in body
        else:
            script_matches = re.findall(r'[\w\-./]+\.py\b|[\w\-./]+\.sh\b', producer)
            if script_matches:
                referenced = any(sm in body for sm in script_matches)
            else:
                referenced = producer in body

        if not referenced:
            findings.append({
                "gap_class": 4,
                "severity": "WARNING",
                "refusal_code": "REGEN_CHECK_COVERAGE_GAP",
                "path_or_target": path_str,
                "evidence": f"Artifact {path_str} has producer '{producer}' which is not executed or referenced in regen-check recipe.",
                "expected": f"Producer '{producer}' referenced in regen-check recipe",
                "actual": f"Not found in regen-check: {body.strip()}",
                "recommended_action": "Add the producer command or script to the 'regen-check' recipe in the justfile.",
                "standing_status": "REFUSED"
            })

    return findings


def check_correspondence_binding(repo_root: Path) -> list[dict[str, Any]]:
    """Class 5 (Correspondence binding check) check."""
    receipt_path = repo_root / "release" / "verif-receipt.json"
    findings = []
    if not receipt_path.exists():
        return findings

    try:
        with open(receipt_path, "r", encoding="utf-8") as f:
            receipt = json.load(f)
    except Exception as e:
        findings.append({
            "gap_class": 5,
            "severity": "BLOCKER",
            "refusal_code": "STALE_PROOF_BINDING",
            "path_or_target": "release/verif-receipt.json",
            "evidence": f"Failed to parse verif-receipt.json: {e}",
            "expected": "Valid JSON",
            "actual": str(e),
            "recommended_action": "Fix release/verif-receipt.json syntax",
            "standing_status": "REFUSED"
        })
        return findings

    for obl in receipt.get("obligations", []):
        aeneas_decl = obl.get("aeneasDecl", "")
        aeneas_module = obl.get("aeneasModule", "")
        corr_name = obl.get("corrName", "")
        status = obl.get("status", "")

        is_tbd = (aeneas_decl == "TBD")
        stale_binding = False
        evidence_msg = ""

        if is_tbd:
            stale_binding = True
            evidence_msg = "aeneasDecl is TBD"
        elif status == "PROVEN":
            lean_file_path = repo_root / "dist" / "verif" / "lean" / "Wasm4pmVerify" / "Corr" / f"{corr_name}.lean"
            if not lean_file_path.exists():
                stale_binding = True
                evidence_msg = f"Proof file {lean_file_path.name} not found"
            else:
                try:
                    content = lean_file_path.read_text(encoding="utf-8")
                    # Clean comments from Lean content
                    code_no_single = re.sub(r'--.*', '', content)
                    code_clean = re.sub(r'/\-.*?\-/', '', code_no_single, flags=re.DOTALL)
                    if aeneas_module not in code_clean:
                        stale_binding = True
                        evidence_msg = f"Proof file does not import or reference the extraction module {aeneas_module}"
                except Exception as e:
                    stale_binding = True
                    evidence_msg = f"Failed to read proof file: {e}"

        if stale_binding:
            findings.append({
                "gap_class": 5,
                "severity": "BLOCKER",
                "refusal_code": "STALE_PROOF_BINDING",
                "path_or_target": corr_name,
                "evidence": f"Stale proof binding found for {corr_name}: {evidence_msg}",
                "expected": f"aeneasDecl != 'TBD' and proof file imports/references {aeneas_module}",
                "actual": f"aeneasDecl={aeneas_decl}, evidence={evidence_msg}",
                "recommended_action": "Complete the correspondence extraction and update the proof file imports.",
                "standing_status": status if status else "REFUSED"
            })

    return findings


def check_tag_ancestry(repo_root: Path) -> list[dict[str, Any]]:
    """Class 6 (Tag ancestry check) check."""
    manifest_path = repo_root / "release" / "release-manifest.json"
    run_id = ""
    if manifest_path.exists():
        try:
            with open(manifest_path, "r", encoding="utf-8") as f:
                manifest = json.load(f)
                run_id = manifest.get("runIdentifier", "")
        except Exception:
            pass

    findings = []
    res_tag = subprocess.run(
        ["git", "rev-parse", "--verify", "v26.7.7-procint-certified"],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False
    )
    if res_tag.returncode != 0:
        return findings

    tag_commit = res_tag.stdout.strip()

    res_anc_head = subprocess.run(
        ["git", "merge-base", "--is-ancestor", "v26.7.7-procint-certified", "HEAD"],
        cwd=repo_root,
        check=False
    )
    is_anc_head = (res_anc_head.returncode == 0)

    is_anc_run_id = False
    if run_id:
        res_anc_run = subprocess.run(
            ["git", "merge-base", "--is-ancestor", run_id, "v26.7.7-procint-certified"],
            cwd=repo_root,
            check=False
        )
        is_anc_run_id = (res_anc_run.returncode == 0)
    else:
        is_anc_run_id = True

    if not is_anc_head or not is_anc_run_id:
        evidence = f"Tag v26.7.7-procint-certified ({tag_commit[:8]}) is not an ancestor of HEAD or runIdentifier ({run_id[:8] if run_id else 'None'})"
        findings.append({
            "gap_class": 6,
            "severity": "BLOCKER",
            "refusal_code": "TAG_ANCESTRY_FAIL",
            "path_or_target": "v26.7.7-procint-certified",
            "evidence": evidence,
            "expected": "Tag is an ancestor of HEAD and runIdentifier",
            "actual": f"is_ancestor_head={is_anc_head}, is_ancestor_run_id={is_anc_run_id}",
            "recommended_action": "Rebase/merge HEAD onto the release tag or recreate the tag at a proper ancestor commit.",
            "standing_status": "REFUSED"
        })

    return findings


def check_untracked_ontology_fragments(repo_root: Path) -> list[dict[str, Any]]:
    """Class 7 (Untracked-fragment-feeds-ontology check) check."""
    findings = []
    packs_dir = repo_root / "packs"
    if not packs_dir.exists():
        return findings

    for ttl_path in packs_dir.glob("*/fragments/*.ttl"):
        rel_str = str(ttl_path.relative_to(repo_root))
        if is_untracked(ttl_path, repo_root):
            findings.append({
                "gap_class": 7,
                "severity": "BLOCKER",
                "refusal_code": "UNTRACKED_ONTOLOGY_FRAGMENT",
                "path_or_target": rel_str,
                "evidence": f"Ontology fragment file {rel_str} is untracked in git.",
                "expected": "Tracked in git",
                "actual": "Untracked in git",
                "recommended_action": "Commit or track the ontology fragment in git.",
                "standing_status": "REFUSED"
            })

    return findings


def check_prose_paper_consistency(repo_root: Path) -> list[dict[str, Any]]:
    """Class 8 (Prose/paper consistency check) check."""
    paper_path = repo_root / "paper" / "main.tex"
    findings = []
    if not paper_path.exists():
        return findings

    actual_proven_count = 0
    manifest_path = repo_root / "release" / "release-manifest.json"
    if manifest_path.exists():
        try:
            with open(manifest_path, "r", encoding="utf-8") as f:
                manifest = json.load(f)
                actual_proven_count = sum(1 for a in manifest.get("artifacts", []) if a.get("proven") is True)
        except Exception:
            pass

    try:
        content = paper_path.read_text(encoding="utf-8", errors="ignore")
    except Exception as e:
        findings.append({
            "gap_class": 8,
            "severity": "WARNING",
            "refusal_code": "STALE_PAPER_PROSE_COUNT",
            "path_or_target": "paper/main.tex",
            "evidence": f"Failed to read paper/main.tex: {e}",
            "expected": "Readable paper/main.tex",
            "actual": str(e),
            "recommended_action": "Check paper/main.tex file permissions",
            "standing_status": "REFUSED"
        })
        return findings

    lines = content.splitlines()

    # Rules 1 and 4 flag a self-contained bad phrase; the phrase itself is
    # the violation regardless of surrounding text, so these stay per-line.
    for line_idx, line in enumerate(lines, 1):
        if re.search(r'\b(145|318)\b', line):
            findings.append({
                "gap_class": 8,
                "severity": "WARNING",
                "refusal_code": "STALE_PAPER_PROSE_COUNT",
                "path_or_target": f"paper/main.tex:{line_idx}",
                "evidence": f"Stale proven count found in prose: '{line.strip()}'",
                "expected": f"Actual proven count ({actual_proven_count})",
                "actual": "Stale count (145 or 318)",
                "recommended_action": "Update the count to match the release manifest.",
                "standing_status": "REFUSED"
            })

        if re.search(r'Aeneas\s+(proves|verified|checked|certified)', line, re.IGNORECASE):
            findings.append({
                "gap_class": 8,
                "severity": "WARNING",
                "refusal_code": "PROSE_LINT_VIOLATION",
                "path_or_target": f"paper/main.tex:{line_idx}",
                "evidence": f"Rule 1 Violation: 'Aeneas proves/verified/checked/certified' claim: '{line.strip()}'",
                "expected": "Use 'Aeneas extracts' and 'Lean proves'",
                "actual": line.strip(),
                "recommended_action": "Change phrase to specify Aeneas extracts and Lean proves.",
                "standing_status": "REFUSED"
            })

        if re.search(r'automatically\s+(extract|verif|prove|check|generate)|without\s+(proof|verif|checking)', line, re.IGNORECASE):
            findings.append({
                "gap_class": 8,
                "severity": "WARNING",
                "refusal_code": "PROSE_LINT_VIOLATION",
                "path_or_target": f"paper/main.tex:{line_idx}",
                "evidence": f"Rule 4 Violation: totality claim 'automatically' or 'without proof': '{line.strip()}'",
                "expected": "Be specific about deterministic translation or Lean kernel check",
                "actual": line.strip(),
                "recommended_action": "Avoid 'automatically' or 'without proof'; describe mechanism precisely.",
                "standing_status": "REFUSED"
            })

    # Rules 5, 7, and 8 look for a qualifying word "nearby" a trigger word.
    # LaTeX source is hand-wrapped at ~80 columns with no relation to
    # sentence or clause boundaries, so a same-physical-line window sees a
    # trigger word and its qualifier split across two lines and misreports
    # a false positive (e.g. "...receipts prove consequence." on one line,
    # "...Lean kernel, Lake build..." naming the formal context two lines
    # later). Widen the window to the whole paragraph (lines between blank
    # lines / \section-like boundaries) so a qualifier anywhere in the same
    # paragraph as the trigger word satisfies the rule; still report the
    # specific line the trigger word occurs on.
    para_boundary = re.compile(r'^\s*$|^\s*\\(section|subsection|paragraph|begin|end)\b')
    paragraphs = []
    current = []
    for line_idx, line in enumerate(lines, 1):
        if para_boundary.match(line):
            if current:
                paragraphs.append(current)
                current = []
        else:
            current.append((line_idx, line))
    if current:
        paragraphs.append(current)

    def emit(rule_num, refusal_code, evidence_prefix, expected, recommendation, line_idx, line_text):
        findings.append({
            "gap_class": 8,
            "severity": "WARNING",
            "refusal_code": refusal_code,
            "path_or_target": f"paper/main.tex:{line_idx}",
            "evidence": f"Rule {rule_num} Violation: {evidence_prefix}: '{line_text.strip()}'",
            "expected": expected,
            "actual": line_text.strip(),
            "recommended_action": recommendation,
            "standing_status": "REFUSED"
        })

    for para in paragraphs:
        para_text = ' '.join(l for _, l in para)

        chain_hash_ok = any(q in para_text.lower() for q in [
            "receipt chain", "chain hash", "content hash", "payload hash",
            "manifest hash", "blake3", "chain linkage", "chain integrity",
            "b3sum", "supply chain"
        ])
        proof_ok = any(q in para_text.lower() for q in [
            "lean", "lake", "kernel", "formal", "theorem", "re-admit",
            "sorry", "axiom", "\\textsc{proven}", "\\textsc{stated}"
        ])
        totality_ok = any(q in para_text.lower() for q in [
            "d1", "specimen", "this work", "correspondence", "lake build",
            "in this apparatus", "does not claim", "nor does it claim",
            "inductive type", "kernel-tested", "deliberately"
        ])

        for line_idx, line in para:
            if not chain_hash_ok and re.search(r'\b(chain|hash)\b', line, re.IGNORECASE):
                emit(5, "PROSE_LINT_VIOLATION", "bare 'chain' or 'hash' detected",
                     "Specify type (receipt chain, chain hash, content hash, payload hash) "
                     "somewhere in the same paragraph",
                     "Add specific qualifiers to bare chain/hash in this paragraph.",
                     line_idx, line)

            if not proof_ok and re.search(r'\b(prove|proof|proven)\b', line, re.IGNORECASE):
                emit(7, "PROSE_LINT_VIOLATION", "'proof/prove' used without formal context",
                     "Use 'evidence', 'witness' or specify Lean/lake/kernel formal context "
                     "somewhere in the same paragraph",
                     "Reword to avoid claiming proof without formal verification context.",
                     line_idx, line)

            if not totality_ok and re.search(r'\b(entirely|completely|fully|absolutely|always|never)\b', line, re.IGNORECASE):
                emit(8, "PROSE_LINT_VIOLATION", "totality adverb without caveats",
                     "Scope totality claim with D1, specimen, etc. somewhere in the same paragraph",
                     "Qualify totality claim with appropriate scope constraints.",
                     line_idx, line)

    return findings


@mcp.tool
def scan() -> list[dict[str, Any]]:
    """Scan the repository for integrity, correctness, and guardrail gaps."""
    artifacts_toml_path = REPO_ROOT / ".mfact" / "artifacts.toml"
    ledgered_paths = set()
    data_toml = {"artifact": []}

    if artifacts_toml_path.exists():
        import tomllib
        try:
            with open(artifacts_toml_path, "rb") as f:
                data_toml = tomllib.load(f)
            for art in data_toml.get("artifact", []):
                p = art.get("path", "")
                if p:
                    ledgered_paths.add(p)
        except Exception:
            pass

    findings = []

    findings.extend(check_sorry_theorem_promotion(REPO_ROOT))
    findings.extend(check_ledger_drift(REPO_ROOT))
    findings.extend(check_orphan_artifacts(REPO_ROOT, ledgered_paths))
    findings.extend(check_regen_check_coverage_gap(REPO_ROOT, data_toml))
    findings.extend(check_correspondence_binding(REPO_ROOT))
    findings.extend(check_tag_ancestry(REPO_ROOT))
    findings.extend(check_untracked_ontology_fragments(REPO_ROOT))
    findings.extend(check_prose_paper_consistency(REPO_ROOT))

    return findings


if __name__ == "__main__":
    mcp.run()
