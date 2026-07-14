"""Tests for the thermodynamics and statistical process control module.

ruff: noqa: PLR2004
"""

import math

from mpops.thermo import process_work_functional, sparse_chaos_diagnostic, western_electric_rules


def test_western_electric_rules_rule1() -> None:
    """Test rule 1: Point beyond 3-sigma limit."""
    data = [0.0] * 10
    data[5] = 4.0  # > 3 sigma if std=1 and mean=0

    violations = western_electric_rules(data, mean=0.0, std=1.0)
    assert len(violations) == 1
    assert violations[0].index == 5
    assert violations[0].rule_number == 1


def test_western_electric_rules_rule2() -> None:
    """Test rule 2: 2 of 3 consecutive points beyond 2 sigma."""
    data = [0.0] * 10
    data[4] = 2.5
    data[5] = 1.0
    data[6] = 2.1

    violations = western_electric_rules(data, mean=0.0, std=1.0)
    # We might trigger rule 1 if any point > 3, but here they are 2.5 and 2.1
    rule2_violations = [v for v in violations if v.rule_number == 2]
    assert len(rule2_violations) == 1
    assert rule2_violations[0].index == 6


def test_western_electric_rules_rule3() -> None:
    """Test rule 3: 4 of 5 consecutive points beyond 1 sigma."""
    data = [0.0] * 10
    data[2] = 1.2
    data[3] = 1.5
    data[4] = 0.5
    data[5] = 1.1
    data[6] = 1.3

    violations = western_electric_rules(data, mean=0.0, std=1.0)
    rule3_violations = [v for v in violations if v.rule_number == 3]
    assert len(rule3_violations) == 1
    assert rule3_violations[0].index == 6


def test_western_electric_rules_rule4() -> None:
    """Test rule 4: 8 consecutive points on one side of center line."""
    data = [0.0] * 10
    for i in range(1, 9):
        data[i] = 0.5

    violations = western_electric_rules(data, mean=0.0, std=1.0)
    rule4_violations = [v for v in violations if v.rule_number == 4]
    assert len(rule4_violations) == 1
    assert rule4_violations[0].index == 8


def test_sparse_chaos_diagnostic() -> None:
    """Test sparse chaos diagnostic."""
    gradients = [1.0, 2.0, 4.0, 8.0]
    diag = sparse_chaos_diagnostic(gradients)
    assert math.isclose(diag, math.log(2.0))

    # Should handle empty or small data
    assert sparse_chaos_diagnostic([]) == 0.0
    assert sparse_chaos_diagnostic([1.0]) == 0.0


def test_process_work_functional() -> None:
    """Test process work functional."""
    assert process_work_functional(2.0, -3.0) == 6.0
    assert process_work_functional(0.0, 5.0) == 0.0
    assert process_work_functional(4.0, 0.0) == 0.0
