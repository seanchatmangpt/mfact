"""Thermodynamics and Statistical Process Control for execution bounds."""

import math
from typing import NamedTuple


class RuleViolation(NamedTuple):
    """Represents a violation of a Western Electric rule."""

    index: int
    rule_number: int
    description: str


def western_electric_rules(
    data: list[float], mean: float | None = None, std: float | None = None
) -> list[RuleViolation]:
    """
    Evaluate Western Electric rules on a sequence of process measurements.

    Rules:
    1. One point plots outside the 3-sigma control limits.
    2. Two out of three consecutive points plot beyond a 2-sigma limit (in the same direction).
    3. Four out of five consecutive points plot beyond a 1-sigma limit (in the same direction).
    4. Eight consecutive points plot on one side of the center line.

    Args:
        data: Sequence of numerical values.
        mean: Historical mean. If None, calculated from data.
        std: Historical standard deviation. If None, calculated from data.

    Returns
    -------
        List of RuleViolation objects.
    """
    if not data:
        return []

    if mean is None:
        mean = sum(data) / len(data)
    if std is None:
        if len(data) < 2:
            std = 0.0
        else:
            variance = sum((x - mean) ** 2 for x in data) / (len(data) - 1)
            std = math.sqrt(variance)

    if std == 0:
        return []

    violations = []

    for i, x in enumerate(data):
        z = (x - mean) / std

        # Rule 1: > 3 sigma
        if abs(z) > 3:
            violations.append(RuleViolation(i, 1, "Point beyond 3-sigma limit."))

        # Rule 2: 2 of 3 beyond 2 sigma (same direction)
        if i >= 2:
            window = [(data[j] - mean) / std for j in range(i - 2, i + 1)]
            if sum(1 for v in window if v > 2) >= 2:
                violations.append(RuleViolation(i, 2, "2 of 3 consecutive points > +2 sigma."))
            elif sum(1 for v in window if v < -2) >= 2:
                violations.append(RuleViolation(i, 2, "2 of 3 consecutive points < -2 sigma."))

        # Rule 3: 4 of 5 beyond 1 sigma (same direction)
        if i >= 4:
            window = [(data[j] - mean) / std for j in range(i - 4, i + 1)]
            if sum(1 for v in window if v > 1) >= 4:
                violations.append(RuleViolation(i, 3, "4 of 5 consecutive points > +1 sigma."))
            elif sum(1 for v in window if v < -1) >= 4:
                violations.append(RuleViolation(i, 3, "4 of 5 consecutive points < -1 sigma."))

        # Rule 4: 8 consecutive on one side of mean
        if i >= 7:
            window = [(data[j] - mean) / std for j in range(i - 7, i + 1)]
            if all(v > 0 for v in window):
                violations.append(RuleViolation(i, 4, "8 consecutive points > mean."))
            elif all(v < 0 for v in window):
                violations.append(RuleViolation(i, 4, "8 consecutive points < mean."))

    return violations


def sparse_chaos_diagnostic(gradients: list[float], threshold: float = 1e-6) -> float:
    """
    Compute a diagnostic for sparse chaos from capability gradients.

    This function measures process pressure based on gradient fluctuation sensitivity.
    We approximate a discrete analog of the Lyapunov exponent for the capability gradients.

    Args:
        gradients: Sequence of capability gradients or process pressures.
        threshold: Minimum gradient magnitude to consider for ratio calculation.

    Returns
    -------
        A scalar diagnostic value representing chaos/instability.
        Returns 0.0 if not enough data.
    """
    if len(gradients) < 2:
        return 0.0

    log_ratios = []
    for i in range(1, len(gradients)):
        delta_n1 = abs(gradients[i])
        delta_n = abs(gradients[i - 1])
        if delta_n > threshold and delta_n1 > threshold:
            log_ratios.append(math.log(delta_n1 / delta_n))

    if not log_ratios:
        return 0.0

    return sum(log_ratios) / len(log_ratios)


def process_work_functional(s: float, g: float) -> float:
    """
    Process-work functional F(s, g) measuring process pressure.

    Args:
        s: Process state/entropy metric (e.g., recursive depth, refusal density).
        g: Capability gradient.

    Returns
    -------
        Process work evaluation.
    """
    return s * abs(g)
