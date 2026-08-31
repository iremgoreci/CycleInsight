from datetime import date


def calculate_current_cycle_day(
    cycle_start_date: date,
    current_date: date | None = None,
) -> int:
    if current_date is None:
        current_date = date.today()

    return (current_date - cycle_start_date).days + 1


def calculate_current_phase(cycle_day: int, ovulation_day: int, period_duration: int | None = None) -> str:
    if period_duration is not None and cycle_day <= period_duration:
        return "menstrual"

    if cycle_day < ovulation_day:
        return "follicular"

    if cycle_day == ovulation_day:
        return "ovulatory"

    return "luteal"