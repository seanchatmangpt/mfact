"""Test Math Factory PyLab reporting CLI with comprehensive command and subprocess verification.

This module tests:
1. All 5 required commands (help and functional tests)
2. Verification that "tactic" is not a registered command
3. Assertion that subprocess is never called with 'just' in any test
4. Assertion that scripts/build_*.py are never invoked
"""

import json
from unittest import mock

import pytest
from typer.testing import CliRunner

from mpops.cli import app

runner = CliRunner()

# Exit code indicating command not found in Typer
COMMAND_NOT_FOUND_EXIT_CODE = 2


class TestReportingCliCommands:
    """Test suite for all reporting CLI commands."""

    def test_help_command_exits_zero(self) -> None:
        """Test that 'mpops --help' exits with code 0."""
        result = runner.invoke(app, ["--help"])
        assert result.exit_code == 0
        assert "Usage:" in result.stdout or "Commands:" in result.stdout

    def test_report_help_command_exits_zero(self) -> None:
        """Test that 'mpops report --help' exits with code 0."""
        result = runner.invoke(app, ["report", "--help"])
        assert result.exit_code == 0
        assert "Usage:" in result.stdout or "Commands:" in result.stdout

    def test_report_status_command_exits_zero(self) -> None:
        """Test that 'mpops report status' exits with code 0 and outputs valid JSON."""
        with mock.patch("subprocess.run") as mock_run:
            # Mock git commands used by cockpit.status()
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            result = runner.invoke(app, ["report", "status"])
            assert result.exit_code == 0, f"Exit code {result.exit_code}: {result.stdout}"

            # Verify output is valid JSON and contains repo info
            try:
                output_json = json.loads(result.stdout)
                assert isinstance(output_json, dict)
                assert "git" in output_json
            except json.JSONDecodeError:
                pytest.fail(f"Status output is not valid JSON: {result.stdout}")

            # Verify no 'just' calls were made
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, list):
                    assert "just" not in args, f"Unexpected 'just' call: {args}"

    def test_report_doctor_command_exits_zero(self) -> None:
        """Test that 'mpops report doctor' exits with code 0 and lists tools."""
        with mock.patch("subprocess.run") as mock_run:
            # Mock tool version checks
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "1.2.3"
            mock_run.return_value = mock_result

            result = runner.invoke(app, ["report", "doctor"])
            assert result.exit_code == 0, f"Exit code {result.exit_code}: {result.stdout}"

            # Verify output is valid JSON and contains tool list
            try:
                output_json = json.loads(result.stdout)
                assert isinstance(output_json, list)
                # Should contain tool objects with 'name' and 'status' fields
                if output_json:
                    assert "name" in output_json[0]
                    assert "status" in output_json[0]
            except json.JSONDecodeError:
                pytest.fail(f"Doctor output is not valid JSON: {result.stdout}")

            # Verify no 'just' calls were made
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, list):
                    assert "just" not in args, f"Unexpected 'just' call: {args}"

    def test_report_next_command_exits_zero(self) -> None:
        """Test that 'mpops report next' exits with code 0 and outputs a string."""
        with mock.patch("subprocess.run") as mock_run:
            # Mock git commands used by cockpit.status()
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            result = runner.invoke(app, ["report", "next"])
            assert result.exit_code == 0, f"Exit code {result.exit_code}: {result.stdout}"

            # Verify output is valid JSON (list of NextAction items)
            try:
                output_json = json.loads(result.stdout)
                assert isinstance(output_json, list)
                # Should contain action objects with 'description' and 'reason'
                if output_json:
                    assert "description" in output_json[0]
                    assert "reason" in output_json[0]
            except json.JSONDecodeError:
                pytest.fail(f"Next output is not valid JSON: {result.stdout}")

            # Verify no 'just' calls were made
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, list):
                    assert "just" not in args, f"Unexpected 'just' call: {args}"


class TestUnregisteredCommands:
    """Test that unregistered commands are properly rejected."""

    def test_tactic_command_not_registered(self) -> None:
        """Test that 'tactic' is not a registered command (should exit 2)."""
        result = runner.invoke(app, ["tactic", "evolve", "--help"])
        assert result.exit_code == COMMAND_NOT_FOUND_EXIT_CODE
        # Error message appears in output (which captures both stdout and stderr)
        assert "No such command" in result.output or "tactic" in result.output.lower()


class TestSubprocessIntegration:
    """Test that subprocess calls are properly scoped and never invoke restricted commands."""

    def test_no_just_calls_in_status(self) -> None:
        """Verify status() never calls 'just' commands."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            runner.invoke(app, ["report", "status"])

            # Check all subprocess.run calls
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, (list, str)):
                    assert "just" not in args

    def test_no_just_calls_in_doctor(self) -> None:
        """Verify doctor() never calls 'just' commands."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "1.2.3"
            mock_run.return_value = mock_result

            runner.invoke(app, ["report", "doctor"])

            # Check all subprocess.run calls
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, (list, str)):
                    assert "just" not in args

    def test_no_just_calls_in_next(self) -> None:
        """Verify next() never calls 'just' commands."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            runner.invoke(app, ["report", "next"])

            # Check all subprocess.run calls
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, (list, str)):
                    assert "just" not in args

    def test_no_build_scripts_invoked_in_status(self) -> None:
        """Verify status() never invokes scripts/build_*.py."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            runner.invoke(app, ["report", "status"])

            # Check all subprocess.run calls
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, list):
                    combined = " ".join(args)
                    assert "scripts/build_" not in combined
                elif isinstance(args, str):
                    assert "scripts/build_" not in args

    def test_no_build_scripts_invoked_in_doctor(self) -> None:
        """Verify doctor() never invokes scripts/build_*.py."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "1.2.3"
            mock_run.return_value = mock_result

            runner.invoke(app, ["report", "doctor"])

            # Check all subprocess.run calls
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, list):
                    combined = " ".join(args)
                    assert "scripts/build_" not in combined
                elif isinstance(args, str):
                    assert "scripts/build_" not in args

    def test_no_build_scripts_invoked_in_next(self) -> None:
        """Verify next() never invokes scripts/build_*.py."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            runner.invoke(app, ["report", "next"])

            # Check all subprocess.run calls
            for call in mock_run.call_args_list:
                args = call[0][0] if call[0] else []
                if isinstance(args, list):
                    combined = " ".join(args)
                    assert "scripts/build_" not in combined
                elif isinstance(args, str):
                    assert "scripts/build_" not in args


class TestCommandOutputStructure:
    """Test the structure and content of command outputs."""

    def test_status_output_contains_git_info(self) -> None:
        """Verify status output contains git information."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            result = runner.invoke(app, ["report", "status"])
            assert result.exit_code == 0

            output_json = json.loads(result.stdout)
            assert "git" in output_json
            assert isinstance(output_json["git"], dict)

    def test_doctor_output_is_list_of_tools(self) -> None:
        """Verify doctor output is a list with tool information."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "1.2.3"
            mock_run.return_value = mock_result

            result = runner.invoke(app, ["report", "doctor"])
            assert result.exit_code == 0

            output_json = json.loads(result.stdout)
            assert isinstance(output_json, list)
            # Each tool should have name and status
            for tool in output_json:
                assert "name" in tool
                assert "status" in tool

    def test_next_output_is_list_of_actions(self) -> None:
        """Verify next output is a list of action items."""
        with mock.patch("subprocess.run") as mock_run:
            mock_result = mock.Mock()
            mock_result.returncode = 0
            mock_result.stdout = "main"
            mock_run.return_value = mock_result

            result = runner.invoke(app, ["report", "next"])
            assert result.exit_code == 0

            output_json = json.loads(result.stdout)
            assert isinstance(output_json, list)
            # Each action should have required fields
            for action in output_json:
                assert "priority" in action
                assert "description" in action
                assert "reason" in action
                assert "status" in action
