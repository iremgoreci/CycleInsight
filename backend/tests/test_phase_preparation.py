from datetime import date
from types import SimpleNamespace

from app.analysis.data_preparation import (
    extract_daily_log_phases,
)


def test_extract_daily_log_phases():
    cycle_start_dates = [
        date(2026, 9, 1),
    ]

    daily_logs = [
        SimpleNamespace(
            log_date=date(2026, 9, 2),
            mood_level=3,
        ),
        SimpleNamespace(
            log_date=date(2026, 9, 8),
            mood_level=4,
        ),
        SimpleNamespace(
            log_date=date(2026, 9, 14),
            mood_level=5,
        ),
        SimpleNamespace(
            log_date=date(2026, 9, 20),
            mood_level=2,
        ),
    ]

    result = extract_daily_log_phases(
        daily_logs=daily_logs,
        cycle_start_dates=cycle_start_dates,
        ovulation_day=14,
        period_duration=5,
    )

    assert len(result["menstrual"]) == 1
    assert len(result["follicular"]) == 1
    assert len(result["ovulatory"]) == 1
    assert len(result["luteal"]) == 1


def test_extract_daily_log_phases_without_logs():
    result = extract_daily_log_phases(
        daily_logs=[],
        cycle_start_dates=[
            date(2026, 9, 1)
        ],
        ovulation_day=14,
        period_duration=5,
    )

    assert result == {
        "menstrual": [],
        "follicular": [],
        "ovulatory": [],
        "luteal": [],
    }


def test_extract_daily_log_phases_without_cycles():
    daily_logs = [
        SimpleNamespace(
            log_date=date(2026, 9, 2),
        ),
    ]

    result = extract_daily_log_phases(
        daily_logs=daily_logs,
        cycle_start_dates=[],
        ovulation_day=14,
        period_duration=5,
    )

    assert result == {
        "menstrual": [],
        "follicular": [],
        "ovulatory": [],
        "luteal": [],
    }


def test_extract_daily_log_phases_without_ovulation_day():
    daily_logs = [
        SimpleNamespace(
            log_date=date(2026, 9, 2),
        ),
    ]

    result = extract_daily_log_phases(
        daily_logs=daily_logs,
        cycle_start_dates=[
            date(2026, 9, 1)
        ],
        ovulation_day=None,
        period_duration=5,
    )

    assert result == {
        "menstrual": [],
        "follicular": [],
        "ovulatory": [],
        "luteal": [],
    }