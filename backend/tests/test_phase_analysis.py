from datetime import date

from app.analysis.phase_analysis import (
    calculate_current_cycle_day,
    calculate_current_phase,
    calculate_phase_for_cycle_day,
)


def test_calculate_current_cycle_day():
    result = calculate_current_cycle_day(
        date(2026, 9, 1),
        date(2026, 9, 8),
    )

    assert result == 8


def test_calculate_current_cycle_day_without_current_date():
    result = calculate_current_cycle_day(
        date.today()
    )

    assert result == 1


def test_menstrual_phase():
    result = calculate_phase_for_cycle_day(
        cycle_day=2,
        ovulation_day=14,
        period_duration=5,
    )

    assert result == "menstrual"


def test_follicular_phase():
    result = calculate_phase_for_cycle_day(
        cycle_day=8,
        ovulation_day=14,
        period_duration=5,
    )

    assert result == "follicular"


def test_ovulatory_phase():
    result = calculate_phase_for_cycle_day(
        cycle_day=14,
        ovulation_day=14,
        period_duration=5,
    )

    assert result == "ovulatory"


def test_luteal_phase():
    result = calculate_phase_for_cycle_day(
        cycle_day=20,
        ovulation_day=14,
        period_duration=5,
    )

    assert result == "luteal"


def test_current_phase_menstrual():
    result = calculate_current_phase(
        cycle_day=3,
        ovulation_day=14,
        period_duration=5,
    )

    assert result == "menstrual"


def test_current_phase_luteal():
    result = calculate_current_phase(
        cycle_day=20,
        ovulation_day=14,
        period_duration=5,
    )

    assert result == "luteal"