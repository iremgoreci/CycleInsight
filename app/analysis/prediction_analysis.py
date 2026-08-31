from datetime import date, timedelta
from statistics import median


def estimate_cycle_length(cycle_lengths: list[int]) -> int | None:
    """
    Estimate the user's cycle length using the median
    of previous cycle lengths.
    """
    if not cycle_lengths:
        return None

    return round(median(cycle_lengths))


def estimate_next_period_date(last_cycle_start_date: date, estimated_cycle_length: int | None) -> date | None:
    """
    Estimate the next period start date.
    """
    if estimated_cycle_length is None:
        return None

    return last_cycle_start_date + timedelta(days=estimated_cycle_length)


def estimate_ovulation_day(
    estimated_cycle_length: int | None,
    luteal_phase_length: int = 14,
) -> int | None:
    """
    Estimate ovulation cycle day based on estimated
    cycle length and assumed luteal phase length.
    """
    if estimated_cycle_length is None:
        return None

    return estimated_cycle_length - luteal_phase_length


def estimate_ovulation_date(last_cycle_start_date: date, ovulation_day: int | None) -> date | None:
    """
    Estimate the calendar date of ovulation.
    """
    if ovulation_day is None:
        return None

    return last_cycle_start_date + timedelta(
        days=ovulation_day - 1
    )


def estimate_ovulation_window(ovulation_day: int | None, window_size: int = 3) -> dict | None:
    """
    Return an estimated ovulation window around the
    estimated ovulation day.
    """
    if ovulation_day is None:
        return None

    return {
        "start_day": ovulation_day - window_size,
        "end_day": ovulation_day + window_size,
    }


def calculate_prediction_confidence(
    cycle_lengths: list[int],
) -> dict:
    """
    Calculate prediction confidence based on the amount
    and consistency of available cycle data.
    """
    if len(cycle_lengths) < 3:
        return {
            "score": 0.0,
            "tier": "low",
        }

    cycle_count = len(cycle_lengths)

    cycle_range = max(cycle_lengths) - min(cycle_lengths)

    if cycle_count >= 6 and cycle_range <= 3:
        return {
            "score": 0.9,
            "tier": "high",
        }

    if cycle_count >= 3 and cycle_range <= 7:
        return {
            "score": 0.6,
            "tier": "medium",
        }

    return {
        "score": 0.3,
        "tier": "low",
    }