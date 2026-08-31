from datetime import date
from statistics import mean, median, stdev
from scipy.stats import linregress

def calculate_cycle_lengths(start_dates: list[date]) -> list[int]:
    """
    Calculate cycle lengths from consecutive cycle start dates.

    Example:
        [May 1, May 29, June 27]
        -> [28, 29]
    """
    sorted_dates = sorted(start_dates)

    if len(sorted_dates) < 2:
        return []

    cycle_lengths = []

    for i in range(1, len(sorted_dates)):
        cycle_length = (sorted_dates[i] - sorted_dates[i - 1]).days
        cycle_lengths.append(cycle_length)

    return cycle_lengths


def calculate_average_cycle_length(cycle_lengths: list[int]) -> float | None:
    """
    Calculate the average cycle length.
    """
    if not cycle_lengths:
        return None

    return mean(cycle_lengths)


def calculate_median_cycle_length(cycle_lengths: list[int]) -> float | None:
    """
    Calculate the median cycle length.
    """
    if not cycle_lengths:
        return None

    return median(cycle_lengths)


def calculate_cycle_variability(cycle_lengths: list[int]) -> float | None:
    """
    Calculate cycle length variability using standard deviation.
    """
    if len(cycle_lengths) < 2:
        return None

    return stdev(cycle_lengths)


def calculate_cycle_range(cycle_lengths: list[int]) -> int | None:
    """
    Calculate the difference between the longest and shortest cycle.
    """
    if not cycle_lengths:
        return None

    return max(cycle_lengths) - min(cycle_lengths)


def calculate_consecutive_cycle_differences(cycle_lengths: list[int]) -> list[int] | None:
    if len(cycle_lengths) < 2:
        return None

    cycle_length_differences = []
    
    for i in range(1, len(cycle_lengths)):
        cycle_length_difference = abs(cycle_lengths[i] - cycle_lengths[i - 1])
        cycle_length_differences.append(cycle_length_difference)
    
    return cycle_length_differences


def assess_cycle_regularity(cycle_lengths: list[int], age: int) -> str:
    """
    Assess menstrual cycle regularity based on age-specific
    FIGO cycle-length variation criteria.
    """

    if len(cycle_lengths) < 2:
        return "insufficient_data"

    cycle_range = max(cycle_lengths) - min(cycle_lengths)

    if 18 <= age <= 25:
        threshold = 9
    elif 26 <= age <= 41:
        threshold = 7
    elif 42 <= age <= 45:
        threshold = 9
    else:
        return "not_assessed"

    if cycle_range <= threshold:
        return "regular"

    return "irregular"


def calculate_cycle_trend(cycle_lengths: list[int]) -> dict | None:
    if len(cycle_lengths) < 3:
        return None

    x = list(range(1, len(cycle_lengths) + 1))
    y = cycle_lengths

    result = linregress(x, y)

    return {
        "slope": result.slope,
        "r_squared": result.rvalue ** 2,
        "p_value": result.pvalue
    }