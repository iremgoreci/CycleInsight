from typing import Any

from app.analysis.cycle_analysis import (
    calculate_cycle_lengths,
    calculate_average_cycle_length,
    calculate_median_cycle_length,
    calculate_cycle_variability,
    calculate_cycle_range,
    calculate_consecutive_cycle_differences,
    assess_cycle_regularity,
    calculate_cycle_trend,
)

from app.analysis.bleeding_analysis import (
    calculate_period_duration,
    calculate_average_bleeding_level,
    calculate_median_bleeding_level,
    calculate_peak_bleeding_level,
    calculate_bleeding_intensity_score,
)

from app.analysis.wellbeing_analysis import (
    calculate_average_level,
    calculate_median_level,
    calculate_min_level,
    calculate_max_level,
    calculate_level_trend,
)

from app.analysis.symptom_analysis import (
    calculate_symptom_frequency,
    calculate_symptom_occurrence_rate,
)

from app.analysis.data_preparation import (
    extract_cycle_start_dates,
    extract_bleeding_levels,
    extract_wellbeing_levels,
    extract_matched_daily_log_values,
    extract_symptom_dates,
)

from app.analysis.correlation_analysis import (
    calculate_spearman_correlation,
)

from app.analysis.phase_analysis import (
    calculate_current_cycle_day,
    calculate_current_phase,
)

from app.analysis.prediction_analysis import (
    estimate_cycle_length,
    estimate_next_period_date,
    estimate_ovulation_day,
    estimate_ovulation_date,
    estimate_ovulation_window,
    calculate_prediction_confidence,
)


def analyze_user_data(
    cycles: list[Any],
    daily_logs: list[Any],
    daily_log_symptoms: list[Any],
    age: int | None = None,
) -> dict:
    """
    Run all available analyses on a user's cycle and daily log data.
    """

    # Data preparation

    cycle_start_dates = extract_cycle_start_dates(cycles)

    cycle_lengths = calculate_cycle_lengths(cycle_start_dates)

    bleeding_levels = extract_bleeding_levels(daily_logs)

    mood_levels = extract_wellbeing_levels(
        daily_logs,
        "mood_level",
    )

    pain_levels = extract_wellbeing_levels(
        daily_logs,
        "pain_level",
    )

    sleep_levels = extract_wellbeing_levels(
        daily_logs,
        "sleep_quality",
    )

    stress_levels = extract_wellbeing_levels(
        daily_logs,
        "stress_level",
    )

    sleep_mood = extract_matched_daily_log_values(
        daily_logs,
        "sleep_quality",
        "mood_level",
    )

    stress_pain = extract_matched_daily_log_values(
        daily_logs,
        "stress_level",
        "pain_level",
    )

    symptom_dates = extract_symptom_dates(
        daily_log_symptoms,
        daily_logs,
    )

    # Cycle calculations

    estimated_cycle_length = estimate_cycle_length(
        cycle_lengths
    )

    latest_cycle = (
        max(cycles, key=lambda cycle: cycle.start_date)
        if cycles
        else None
    )

    last_cycle_start_date = (
        latest_cycle.start_date
        if latest_cycle is not None
        else None
    )

    if (
        latest_cycle is not None
        and latest_cycle.end_date is not None
    ):
        current_period_duration = (
            latest_cycle.end_date
            - latest_cycle.start_date
        ).days + 1
    else:
        current_period_duration = None

    if last_cycle_start_date is not None:
        current_cycle_day = calculate_current_cycle_day(
            last_cycle_start_date
        )
    else:
        current_cycle_day = None

    ovulation_day = estimate_ovulation_day(
        estimated_cycle_length
    )

    if (
        current_cycle_day is not None
        and ovulation_day is not None
    ):
        current_phase = calculate_current_phase(
            cycle_day=current_cycle_day,
            ovulation_day=ovulation_day,
            period_duration=current_period_duration,
        )
    else:
        current_phase = None

    if last_cycle_start_date is not None:
        next_period_date = estimate_next_period_date(
            last_cycle_start_date,
            estimated_cycle_length,
        )

        ovulation_date = estimate_ovulation_date(
            last_cycle_start_date,
            ovulation_day,
        )
    else:
        next_period_date = None
        ovulation_date = None


    ovulation_window = estimate_ovulation_window(
        ovulation_day
    )


    prediction_confidence = calculate_prediction_confidence(
        cycle_lengths
    )

    # Symptom analysis

    symptom_analysis = {}

    for symptom_type_id, dates in symptom_dates.items():

        symptom_analysis[symptom_type_id] = {
            "dates": dates,
            "frequency": calculate_symptom_frequency(
                dates
            ),
            "occurrence_rate":
                calculate_symptom_occurrence_rate(
                    dates,
                    len(daily_logs),
                ),
        }

    # Return analysis

    return {
        "cycle": {
            "cycle_lengths": cycle_lengths,
            "average_length": calculate_average_cycle_length(
                cycle_lengths
            ),
            "median_length": calculate_median_cycle_length(
                cycle_lengths
            ),
            "variability": calculate_cycle_variability(
                cycle_lengths
            ),
            "range": calculate_cycle_range(
                cycle_lengths
            ),
            "consecutive_differences":
                calculate_consecutive_cycle_differences(
                    cycle_lengths
                ),
            "regularity": assess_cycle_regularity(
                cycle_lengths,
                age,
            ),
            "trend": calculate_cycle_trend(
                cycle_lengths
            ),
        },

        "bleeding": {
            "period_duration": calculate_period_duration(
                bleeding_levels
            ),
            "average_level": calculate_average_bleeding_level(
                bleeding_levels
            ),
            "median_level": calculate_median_bleeding_level(
                bleeding_levels
            ),
            "peak_level": calculate_peak_bleeding_level(
                bleeding_levels
            ),
            "intensity_score": calculate_bleeding_intensity_score(
                bleeding_levels
            ),
        },

        "phase": {
            "cycle_day": current_cycle_day,
            "current_phase": current_phase,
        },

        "predictions": {
            "estimated_cycle_length": estimated_cycle_length,
            "next_period_date": next_period_date,
            "ovulation_day": ovulation_day,
            "ovulation_date": ovulation_date,
            "ovulation_window": ovulation_window,
            "confidence": prediction_confidence,
        },

        "wellbeing": {
            "mood": {
                "average": calculate_average_level(mood_levels),
                "median": calculate_median_level(mood_levels),
                "minimum": calculate_min_level(mood_levels),
                "maximum": calculate_max_level(mood_levels),
                "trend": calculate_level_trend(mood_levels),
            },

            "pain": {
                "average": calculate_average_level(pain_levels),
                "median": calculate_median_level(pain_levels),
                "minimum": calculate_min_level(pain_levels),
                "maximum": calculate_max_level(pain_levels),
                "trend": calculate_level_trend(pain_levels),
            },

            "sleep": {
                "average": calculate_average_level(sleep_levels),
                "median": calculate_median_level(sleep_levels),
                "minimum": calculate_min_level(sleep_levels),
                "maximum": calculate_max_level(sleep_levels),
                "trend": calculate_level_trend(sleep_levels),
            },

            "stress": {
                "average": calculate_average_level(stress_levels),
                "median": calculate_median_level(stress_levels),
                "minimum": calculate_min_level(stress_levels),
                "maximum": calculate_max_level(stress_levels),
                "trend": calculate_level_trend(stress_levels),
            },
        },

        "symptoms": symptom_analysis,

        "correlations": {
            "sleep_mood": calculate_spearman_correlation(
                sleep_mood[0],
                sleep_mood[1],
            ),

            "stress_pain": calculate_spearman_correlation(
                stress_pain[0],
                stress_pain[1],
            ),
        },
    }