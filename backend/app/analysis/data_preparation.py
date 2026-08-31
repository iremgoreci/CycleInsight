from datetime import date
from collections import defaultdict
from typing import Any


def extract_cycle_start_dates(cycles: list[Any]) -> list[date]:
    """
    Extract and sort cycle start dates.
    """

    return sorted(cycle.start_date for cycle in cycles)


def extract_bleeding_levels(daily_logs: list[Any]) -> list[int]:
    """
    Extract bleeding levels from daily logs sorted by date.
    """

    sorted_logs = sorted(daily_logs, key=lambda log: log.log_date)

    return [log.bleeding_level for log in sorted_logs]


def extract_wellbeing_levels(daily_logs: list[Any], field_name: str) -> list[int]:
    """
    Extract a wellbeing field from daily logs sorted by date.
    """

    supported_fields = {
        "mood_level",
        "pain_level",
        "sleep_quality",
        "stress_level"
    }

    if field_name not in supported_fields:
        raise ValueError(f"Unsupported wellbeing field: {field_name}")

    sorted_logs = sorted(daily_logs, key=lambda log: log.log_date)

    return [getattr(log, field_name) for log in sorted_logs]


def extract_matched_daily_log_values(daily_logs: list[Any], first_field: str, second_field: str) -> tuple[list[int], list[int]]:
    """
    Extract two matched wellbeing variables from the same
    daily logs, sorted by date.
    """

    supported_fields = {
        "mood_level",
        "pain_level",
        "sleep_quality",
        "stress_level"
    }

    if first_field not in supported_fields:
        raise ValueError(f"Unsupported wellbeing field: {first_field}")

    if second_field not in supported_fields:
        raise ValueError(f"Unsupported wellbeing field: {second_field}")

    sorted_logs = sorted(daily_logs, key=lambda log: log.log_date)

    first_values = [getattr(log, first_field) for log in sorted_logs]

    second_values = [getattr(log, second_field) for log in sorted_logs]

    return first_values, second_values


def extract_symptom_dates(
    daily_log_symptoms: list[Any],
    daily_logs: list[Any]
) -> dict[int, list]:
    """
    Group symptom occurrence dates by symptom type ID.
    """

    daily_log_dates = {
        daily_log.id: daily_log.log_date
        for daily_log in daily_logs
    }

    symptom_dates = defaultdict(list)

    for daily_log_symptom in daily_log_symptoms:
        log_date = daily_log_dates.get(
            daily_log_symptom.daily_log_id
        )

        if log_date is not None:
            symptom_dates[
                daily_log_symptom.symptom_type_id
            ].append(log_date)

    return {
        symptom_type_id: sorted(dates)
        for symptom_type_id, dates
        in symptom_dates.items()
    }