"""Tests for Standing Guard MCP Server implementation."""

from __future__ import annotations

import re
from pathlib import Path
import pytest

from mpops.standing_guard.server import scan


def test_scan_callable():
    """Verify that scan() is callable and returns structured findings."""
    findings = scan()
    assert isinstance(findings, list)
    
    # We expect some findings due to the baseline state (like TBD in verif-receipt)
    for finding in findings:
        assert isinstance(finding, dict)
        
        # Verify required keys
        assert "gap_class" in finding
        assert isinstance(finding["gap_class"], int)
        assert 1 <= finding["gap_class"] <= 8
        
        assert "severity" in finding
        assert finding["severity"] in ["BLOCKER", "WARNING", "INFO"]
        
        assert "refusal_code" in finding
        assert isinstance(finding["refusal_code"], str)
        
        assert "path_or_target" in finding
        assert isinstance(finding["path_or_target"], str)
        
        assert "evidence" in finding
        assert isinstance(finding["evidence"], str)
        
        assert "expected" in finding
        assert isinstance(finding["expected"], str)
        
        assert "actual" in finding
        assert isinstance(finding["actual"], str)
        
        assert "recommended_action" in finding
        assert isinstance(finding["recommended_action"], str)
        
        assert "standing_status" in finding
        assert finding["standing_status"] in ["PROVEN", "STATED", "DECLARED", "REFUSED"]


def test_no_mutation_capabilities():
    """Verify that the Standing Guard server contains absolutely no mutation capabilities."""
    server_path = Path(__file__).resolve().parents[1] / "src" / "mpops" / "standing_guard" / "server.py"
    assert server_path.exists(), f"Could not find server.py at {server_path}"
    
    content = server_path.read_text(encoding="utf-8")
    
    # 1. Check open modes - only allow read modes "r" and "rb"
    for line_idx, line in enumerate(content.splitlines(), 1):
        if "open(" in line:
            # Must contain read modes
            assert any(mode in line for mode in ['"r"', '"rb"', "'r'", "'rb'"]), \
                f"Line {line_idx} contains open() but not explicitly in read mode: {line.strip()}"
            # Must not contain write/append/exclusive modes
            assert not any(mode in line for mode in [
                '"w"', '"wb"', '"w+"', '"wb+"', '"a"', '"ab"', '"a+"', '"x"', '"xb"',
                "'w'", "'wb'", "'w+'", "'wb+'", "'a'", "'ab'", "'a+'", "'x'", "'xb'"
            ]), f"Line {line_idx} contains a write/append open mode: {line.strip()}"

    # 2. Check for write methods on files
    assert ".write(" not in content, "Found file.write() call in server.py"
    assert ".writelines(" not in content, "Found file.writelines() call in server.py"
    assert "write_text(" not in content, "Found Path.write_text() call in server.py"
    assert "write_bytes(" not in content, "Found Path.write_bytes() call in server.py"

    # 3. Check for copying/moving/deleting functions
    assert "shutil.copy" not in content, "Found shutil.copy in server.py"
    assert "shutil.move" not in content, "Found shutil.move in server.py"
    assert "os.remove" not in content, "Found os.remove in server.py"
    assert "os.unlink" not in content, "Found os.unlink in server.py"
    assert "os.makedirs" not in content, "Found os.makedirs in server.py"
    assert "Path.mkdir" not in content, "Found Path.mkdir in server.py"

    # 4. Check for git commands that mutate
    subprocess_calls = re.findall(r'subprocess\.(?:run|Popen|call|check_output)\((.*?)\)', content, re.DOTALL)
    for call in subprocess_calls:
        for forbidden in ["commit", "add", "checkout", "push", "tag", "rm"]:
            assert forbidden not in call, f"Found potentially mutating git command '{forbidden}' in subprocess call: {call}"
