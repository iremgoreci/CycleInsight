from datetime import date

from app.analysis.cycle_analysis import (
    calculate_cycle_lengths,
    calculate_average_cycle_length,
    calculate_median_cycle_length,
    calculate_cycle_range,
    calculate_consecutive_cycle_differences,
    assess_cycle_regularity,
)


def test_calculate_cycle_lengths():
    dates = [
        date(2026, 1, 1),
        date(2026, 1, 25),
        date(2026, 2, 14),
    ]

    result = calculate_cycle_lengths(dates)

    assert result == [24, 20]


def test_calculate_cycle_lengths_with_insufficient_data():
    dates = [date(2026, 1, 1)]

    result = calculate_cycle_lengths(dates)

    assert result == []


def test_calculate_average_cycle_length():
    result = calculate_average_cycle_length([24, 20])

    assert result == 22


def test_calculate_median_cycle_length():
    result = calculate_median_cycle_length([24, 20, 22])

    assert result == 22


def test_calculate_cycle_range():
    result = calculate_cycle_range([24, 20, 22])

    assert result == 4


def test_calculate_consecutive_cycle_differences():
    result = calculate_consecutive_cycle_differences(
        [24, 20, 23]
    )

    assert result == [4, 3]


def test_assess_cycle_regularity():
    result = assess_cycle_regularity(
        [24, 20, 22],
        20,
    )

    assert result == "regular"


def test_assess_cycle_regularity_without_age():
    result = assess_cycle_regularity(
        [24, 20, 22],
        None,
    )

    assert result == "not_assessed"