"""Math Factory PyLab CLI."""

import typer
from . import reporting

app = typer.Typer()

# Mount reporting commands under "report" noun
app.add_typer(reporting.cli.app, name="report")
