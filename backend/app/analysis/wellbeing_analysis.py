from statistics import median
import math


def calculate_average_level(
    levels: list[int],
) -> float | None:
    """
    Calculate the average of recorded levels.
    """

    if not levels:
        return None

    return sum(levels) / len(levels)


def calculate_median_level(
    levels: list[int],
) -> float | None:
    """
    Calculate the median of recorded levels.
    """

    if not levels:
        return None

    return median(levels)


def calculate_min_level(
    levels: list[int],
) -> int | None:
    """
    Return the lowest recorded level.
    """

    if not levels:
        return None

    return min(levels)


def calculate_max_level(
    levels: list[int],
) -> int | None:
    """
    Return the highest recorded level.
    """

    if not levels:
        return None

    return max(levels)


def calculate_level_trend(
    levels: list[int],
) -> dict | None:
    """
    Calculate the linear trend of recorded levels.
    """

    if len(levels) < 3:
        return None

    from scipy.stats import linregress

    x = list(range(1, len(levels) + 1))

    result = linregress(x, levels)

    slope = result.slope
    r_squared = result.rvalue ** 2
    p_value = result.pvalue

    if not all(
        math.isfinite(value)
        for value in [slope, r_squared, p_value]
    ):
        return None

    return {
        "slope": slope,
        "r_squared": r_squared,
        "p_value": p_value,
    }