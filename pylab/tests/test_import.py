"""Test Math Factory PyLab."""

import math_factory_pylab


def test_import() -> None:
    """Test that the app can be imported."""
    assert isinstance(math_factory_pylab.__name__, str)
