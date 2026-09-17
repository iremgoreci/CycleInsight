from datetime import date

from app.analysis.bleeding_analysis import (
    calculate_period_duration,
    calculate_average_bleeding_level,
    calculate_median_bleeding_level,
    calculate_peak_bleeding_level,
    calculate_bleeding_intensity_score,
)

from app.analysis.symptom_analysis import (
    calculate_symptom_frequency,
    calculate_symptom_occurrence_rate,
)


def test_period_duration():
    result = calculate_period_duration([1, 2, 3])

    assert result == 3


def test_period_duration_without_data():
    result = calculate_period_duration([])

    assert result == 0


def test_average_bleeding_level():
    result = calculate_average_bleeding_level([1, 3, 5])

    assert result == 3


def test_median_bleeding_level():
    result = calculate_median_bleeding_level([1, 5, 3])

    assert result == 3


def test_peak_bleeding_level():
    result = calculate_peak_bleeding_level([1, 4, 2])

    assert result == 4


def test_bleeding_intensity_score():
    result = calculate_bleeding_intensity_score([1, 2, 3])

    assert result == 6


def test_symptom_frequency():
    dates = [
        date(2026, 9, 1),
        date(2026, 9, 3),
        date(2026, 9, 5),
    ]

    result = calculate_symptom_frequency(dates)

    assert result == 3


def test_symptom_occurrence_rate():
    dates = [
        date(2026, 9, 1),
        date(2026, 9, 3),
    ]

    result = calculate_symptom_occurrence_rate(
        dates,
        10,
    )

    assert result == 0.2