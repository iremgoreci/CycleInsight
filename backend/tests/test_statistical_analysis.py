from app.analysis.correlation_analysis import (
    calculate_spearman_correlation,
)

from app.analysis.wellbeing_analysis import (
    calculate_average_level,
    calculate_median_level,
    calculate_min_level,
    calculate_max_level,
    calculate_level_trend,
)


def test_average_level():
    result = calculate_average_level([1, 3, 5])

    assert result == 3


def test_median_level():
    result = calculate_median_level([1, 5, 3])

    assert result == 3


def test_min_level():
    result = calculate_min_level([1, 3, 5])

    assert result == 1


def test_max_level():
    result = calculate_max_level([1, 3, 5])

    assert result == 5


def test_average_level_without_data():
    result = calculate_average_level([])

    assert result is None


def test_level_trend_without_enough_data():
    result = calculate_level_trend([1, 2])

    assert result is None


def test_spearman_correlation():
    result = calculate_spearman_correlation(
        [1, 2, 3, 4],
        [1, 2, 3, 4],
    )

    assert result is not None
    assert result["correlation"] == 1.0


def test_spearman_correlation_without_enough_data():
    result = calculate_spearman_correlation(
        [1, 2],
        [1, 2],
    )

    assert result is None