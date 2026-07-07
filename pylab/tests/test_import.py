"""Test Math Factory PyLab."""

import mpops


def test_import() -> None:
    """Test that the app can be imported."""
    assert isinstance(mpops.__name__, str)
