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


def calculate_symptom_phase_distribution(
    phases: list[str],
) -> dict[str, int]:
    """
    Count how many times a symptom was recorded
    in each cycle phase.
    """

    distribution = {
        "menstrual": 0,
        "follicular": 0,
        "ovulatory": 0,
        "luteal": 0,
    }

    for phase in phases:
        if phase in distribution:
            distribution[phase] += 1

    return distribution


def calculate_most_common_symptom_phase(
    phase_distribution: dict[str, int],
) -> str | None:
    """
    Find the cycle phase in which a symptom
    was recorded most frequently.
    """

    if not phase_distribution:
        return None

    total_occurrences = sum(
        phase_distribution.values()
    )

    if total_occurrences == 0:
        return None

    return max(
        phase_distribution,
        key=phase_distribution.get,
    )