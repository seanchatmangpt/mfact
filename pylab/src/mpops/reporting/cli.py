"""CLI reporting module for mpops.

This module provides a Typer sub-app for reporting on repository status,
tool diagnostics, and next actions from the mfact manufacturing system.
"""

import json
import typer
from dataclasses import asdict

# Import cockpit functions from local module
from .cockpit import (
    status as cockpit_status,
    doctor as cockpit_doctor,
    next as cockpit_next,
)

# Create the sub-app with name "report"
app = typer.Typer(help="Repository status and diagnostics reporting")


@app.command()
def status() -> None:
    """Display current repository status."""
    try:
        result = cockpit_status()
        result_dict = asdict(result)
        typer.echo(json.dumps(result_dict, indent=2, default=str))
    except Exception as e:
        typer.echo(f"ERROR: {e}", err=True)
        raise typer.Exit(1)


@app.command()
def doctor() -> None:
    """Run tool health checks and diagnostics."""
    try:
        result = cockpit_doctor()
        result_list = [asdict(item) for item in result]
        typer.echo(json.dumps(result_list, indent=2, default=str))
    except Exception as e:
        typer.echo(f"ERROR: {e}", err=True)
        raise typer.Exit(1)


@app.command()
def next() -> None:
    """Display the next recommended action."""
    try:
        result = cockpit_next()
        result_list = [asdict(item) for item in result]
        typer.echo(json.dumps(result_list, indent=2, default=str))
    except Exception as e:
        typer.echo(f"ERROR: {e}", err=True)
        raise typer.Exit(1)
