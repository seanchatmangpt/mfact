"""Test Math Factory PyLab CLI."""

from typer.testing import CliRunner

from mpops.cli import app

runner = CliRunner()


def test_mpops_help() -> None:
    """Test that mpops --help works."""
    result = runner.invoke(app, ["--help"])
    assert result.exit_code == 0
    assert "report" in result.stdout


def test_mpops_report_help() -> None:
    """Test that mpops report --help works."""
    result = runner.invoke(app, ["report", "--help"])
    assert result.exit_code == 0
    assert "status" in result.stdout or "Commands" in result.stdout
