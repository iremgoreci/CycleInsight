from datetime import date


def calculate_symptom_frequency(
    symptom_dates: list[date]
) -> int:
    """
    Calculate how many times a symptom was recorded.
    """

    return len(symptom_dates)


def calculate_symptom_occurrence_rate(
    symptom_dates: list[date],
    total_logged_days: int
) -> float | None:
    """
    Calculate the percentage of logged days on which
    a symptom was recorded.
    """

    if total_logged_days <= 0:
        return None

    return len(symptom_dates) / total_logged_days


def calculate_symptom_dates(
    symptom_dates: list[date]
) -> list[date]:
    """
    Return the dates on which a symptom was recorded.
    """

    return sorted(symptom_dates)