from datetime import date

from app.analysis.prediction_analysis import (
    estimate_cycle_length,
    estimate_next_period_date,
    estimate_ovulation_day,
    estimate_ovulation_date,
    estimate_ovulation_window,
    calculate_prediction_confidence,
)


def test_estimate_cycle_length():
    result = estimate_cycle_length([24, 20, 22])

    assert result == 22


def test_estimate_cycle_length_without_data():
    result = estimate_cycle_length([])

    assert result is None


def test_estimate_next_period_date():
    result = estimate_next_period_date(
        date(2026, 9, 1),
        22,
    )

    assert result == date(2026, 9, 23)


def test_estimate_next_period_date_without_cycle_length():
    result = estimate_next_period_date(
        date(2026, 9, 1),
        None,
    )

    assert result is None


def test_estimate_ovulation_day():
    result = estimate_ovulation_day(28)

    assert result == 14


def test_estimate_ovulation_date():
    result = estimate_ovulation_date(
        date(2026, 9, 1),
        14,
    )

    assert result == date(2026, 9, 14)


def test_estimate_ovulation_window():
    result = estimate_ovulation_window(14)

    assert result == {
        "start_day": 11,
        "end_day": 17,
    }


def test_prediction_confidence_without_data():
    result = calculate_prediction_confidence([])

    assert result == {
        "score": 0.0,
        "tier": "low",
    }