import math

from scipy.stats import spearmanr


def calculate_spearman_correlation(
    first_values: list[int],
    second_values: list[int],
) -> dict | None:
    """
    Calculate the Spearman rank correlation
    between two variables.
    """

    if len(first_values) < 3:
        return None

    if len(second_values) < 3:
        return None

    if len(first_values) != len(second_values):
        return None

    result = spearmanr(
        first_values,
        second_values,
    )

    correlation = result.statistic
    p_value = result.pvalue

    if not math.isfinite(correlation):
        return None

    if not math.isfinite(p_value):
        return None

    return {
        "correlation": correlation,
        "p_value": p_value,
    }