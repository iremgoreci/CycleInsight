from datetime import date

from app.analysis.data_preparation import (
    find_cycle_start_for_log,
)


def test_find_cycle_start_for_log():
    cycle_start_dates = [
        date(2026, 8, 1),
        date(2026, 8, 25),
        date(2026, 9, 15),
    ]

    result = find_cycle_start_for_log(
        date(2026, 9, 5),
        cycle_start_dates,
    )

    assert result == date(2026, 8, 25)


def test_find_cycle_start_on_cycle_start_date():
    cycle_start_dates = [
        date(2026, 8, 1),
        date(2026, 8, 25),
    ]

    result = find_cycle_start_for_log(
        date(2026, 8, 25),
        cycle_start_dates,
    )

    assert result == date(2026, 8, 25)


def test_find_cycle_start_before_first_cycle():
    cycle_start_dates = [
        date(2026, 8, 1),
        date(2026, 8, 25),
    ]

    result = find_cycle_start_for_log(
        date(2026, 7, 20),
        cycle_start_dates,
    )

    assert result is None


def test_find_cycle_start_without_cycles():
    result = find_cycle_start_for_log(
        date(2026, 9, 5),
        [],
    )

    assert result is None