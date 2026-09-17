from datetime import date
from types import SimpleNamespace

from app.analysis.analysis_service import analyze_user_data


def test_phase_wellbeing_analysis():
    cycles = [
        SimpleNamespace(
            start_date=date(2026, 8, 10),
            end_date=date(2026, 8, 14),
        ),
        SimpleNamespace(
            start_date=date(2026, 9, 1),
            end_date=date(2026, 9, 5),
        ),
    ]

    daily_logs = [
        SimpleNamespace(
            id=1,
            log_date=date(2026, 9, 2),
            bleeding_level=3,
            mood_level=2,
            pain_level=4,
            sleep_quality=2,
            stress_level=3,
        ),
        SimpleNamespace(
            id=2,
            log_date=date(2026, 9, 6),
            bleeding_level=0,
            mood_level=4,
            pain_level=2,
            sleep_quality=4,
            stress_level=2,
        ),
        SimpleNamespace(
            id=3,
            log_date=date(2026, 9, 8),
            bleeding_level=0,
            mood_level=5,
            pain_level=1,
            sleep_quality=5,
            stress_level=1,
        ),
        SimpleNamespace(
            id=4,
            log_date=date(2026, 9, 14),
            bleeding_level=0,
            mood_level=3,
            pain_level=3,
            sleep_quality=3,
            stress_level=4,
        ),
    ]

    result = analyze_user_data(
        cycles=cycles,
        daily_logs=daily_logs,
        daily_log_symptoms=[],
        symptom_types=[],
        age=20,
    )

    phase_wellbeing = result["phase"]["wellbeing"]

    assert phase_wellbeing["menstrual"]["mood"] == 2
    assert phase_wellbeing["follicular"]["mood"] == 4
    assert phase_wellbeing["ovulatory"]["mood"] == 5
    assert phase_wellbeing["luteal"]["mood"] == 3

    assert phase_wellbeing["menstrual"]["pain"] == 4
    assert phase_wellbeing["ovulatory"]["sleep"] == 5
    assert phase_wellbeing["luteal"]["stress"] == 4