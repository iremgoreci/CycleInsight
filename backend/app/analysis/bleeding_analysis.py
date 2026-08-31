from statistics import median


def calculate_period_duration(bleeding_levels: list[int]) -> int:
    return sum(1 for level in bleeding_levels if level > 0)


def calculate_average_bleeding_level(bleeding_levels: list[int]) -> float | None:
    positive_levels = sum(level for level in bleeding_levels if level > 0)
    positive_level_count = sum(1 for level in bleeding_levels if level > 0)

    if positive_level_count == 0:
        return None
    
    return positive_levels / positive_level_count


def calculate_median_bleeding_level(bleeding_levels: list[int]) -> float | None:
    positive_levels = [level for level in bleeding_levels if level > 0]

    if not positive_levels:
        return None

    return median(positive_levels)


def calculate_peak_bleeding_level(bleeding_levels: list[int]) -> int | None:
    positive_bleeding_levels = [level for level in bleeding_levels if level > 0]
    if not positive_bleeding_levels:
        return None
    return max(positive_bleeding_levels)


def calculate_bleeding_intensity_score(bleeding_levels: list[int]) -> int:
    return sum(level for level in bleeding_levels if level > 0)
