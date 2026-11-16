"""Seed clearly marked synthetic data for the existing CycleInsight test user.

Run from the backend directory:
    python scripts/seed_test_data.py

This script never creates users or symptom types and never deletes or updates
existing records. All changes are inserted in a single transaction.
"""

from __future__ import annotations

import sys
from dataclasses import dataclass
from datetime import date, datetime, timedelta

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db.database import SessionLocal
from app.models.cycle import Cycle
from app.models.daily_log import DailyLog
from app.models.daily_log_symptom import DailyLogSymptom
from app.models.symptom_type import SymptomType
from app.models.user import User

TEST_EMAIL = "test1234@gmail.com"
SYNTHETIC_NOTE = (
    "[SYNTHETIC_TEST_DATA: CycleInsight QA seed; not real health data.]"
)
SYNTHETIC_CYCLE_TIMESTAMP = datetime(2000, 1, 1, 0, 0, 0)

HISTORICAL_CYCLE_COUNT = 6
CYCLE_LENGTH_DAYS = 28
PERIOD_DURATION_DAYS = 5
DAILY_LOG_DAYS = 60


class SeedDataError(RuntimeError):
    """Raised when seed preconditions are not met."""


@dataclass(frozen=True)
class CycleSeed:
    start_date: date
    end_date: date | None


@dataclass(frozen=True)
class DailyLogSeed:
    log_date: date
    bleeding_level: int
    mood_level: int
    pain_level: int
    sleep_quality: int
    stress_level: int


def build_cycle_seeds(reference_date: date) -> list[CycleSeed]:
    """Build six completed 28-day cycles and one current open cycle."""
    starts = [
        reference_date - timedelta(days=CYCLE_LENGTH_DAYS * offset)
        for offset in range(HISTORICAL_CYCLE_COUNT, -1, -1)
    ]
    return [
        CycleSeed(
            start_date=start,
            end_date=(
                start + timedelta(days=PERIOD_DURATION_DAYS - 1)
                if start != reference_date
                else None
            ),
        )
        for start in starts
    ]


def build_daily_log_seeds(reference_date: date) -> list[DailyLogSeed]:
    """Build deterministic values for the inclusive last 60 days."""
    first_date = reference_date - timedelta(days=DAILY_LOG_DAYS - 1)
    cycle_starts = [
        reference_date - timedelta(days=CYCLE_LENGTH_DAYS * offset)
        for offset in range(HISTORICAL_CYCLE_COUNT + 1, -1, -1)
    ]

    mood_pattern = (3, 4, 3, 4, 5, 3, 2)
    pain_pattern = (0, 1, 1, 2, 1, 0, 1)
    sleep_pattern = (3, 4, 4, 3, 5, 4, 2)
    stress_pattern = (2, 2, 3, 2, 1, 3, 4)
    bleeding_pattern = (4, 3, 2, 1, 1)

    result: list[DailyLogSeed] = []
    for index in range(DAILY_LOG_DAYS):
        log_date = first_date + timedelta(days=index)
        latest_cycle_start = max(
            start for start in cycle_starts if start <= log_date
        )
        cycle_day = (log_date - latest_cycle_start).days + 1
        bleeding = (
            bleeding_pattern[cycle_day - 1]
            if cycle_day <= PERIOD_DURATION_DAYS
            else 0
        )
        result.append(
            DailyLogSeed(
                log_date=log_date,
                bleeding_level=bleeding,
                mood_level=mood_pattern[index % len(mood_pattern)],
                pain_level=pain_pattern[index % len(pain_pattern)],
                sleep_quality=sleep_pattern[index % len(sleep_pattern)],
                stress_level=stress_pattern[index % len(stress_pattern)],
            )
        )
    return result


def get_test_user(session: Session) -> User:
    user = session.scalar(select(User).where(User.email == TEST_EMAIL))
    if user is None:
        raise SeedDataError(
            f"Test user '{TEST_EMAIL}' was not found. No user was created."
        )
    return user


def validate_cycle_seed_state(
    session: Session, user: User, seeds: list[CycleSeed]
) -> bool:
    """Validate synthetic and conflicting cycles without adding ORM objects."""
    marked = list(
        session.scalars(
            select(Cycle).where(
                Cycle.user_id == user.id,
                Cycle.created_at == SYNTHETIC_CYCLE_TIMESTAMP,
                Cycle.updated_at == SYNTHETIC_CYCLE_TIMESTAMP,
            )
        )
    )
    expected = {(seed.start_date, seed.end_date) for seed in seeds}

    if marked:
        actual = {(cycle.start_date, cycle.end_date) for cycle in marked}
        if len(marked) != len(expected) or actual != expected:
            raise SeedDataError(
                "Existing synthetic cycles do not match the expected complete "
                "date set; no records were changed."
            )
        return True

    target_starts = [seed.start_date for seed in seeds]
    conflicts = list(
        session.scalars(
            select(Cycle).where(
                Cycle.user_id == user.id,
                Cycle.start_date.in_(target_starts),
            )
        )
    )
    if conflicts:
        dates = ", ".join(sorted(c.start_date.isoformat() for c in conflicts))
        raise SeedDataError(
            f"Existing non-synthetic cycles conflict with dates ({dates}); "
            "no records were changed."
        )
    return False


def validate_daily_log_seed_state(
    session: Session, user: User, seeds: list[DailyLogSeed]
) -> dict[date, DailyLog]:
    """Validate all target dates before any new ORM objects are added."""
    target_dates = [seed.log_date for seed in seeds]
    existing = list(
        session.scalars(
            select(DailyLog).where(
                DailyLog.user_id == user.id,
                DailyLog.log_date.in_(target_dates),
            )
        )
    )
    conflicts = sorted(
        log.log_date.isoformat()
        for log in existing
        if log.notes != SYNTHETIC_NOTE
    )
    if conflicts:
        raise SeedDataError(
            "Existing non-synthetic daily logs conflict with dates "
            f"({', '.join(conflicts)}); no records were changed."
        )
    return {log.log_date: log for log in existing}


def add_cycles(
    session: Session, user: User, seeds: list[CycleSeed], already_seeded: bool
) -> int:
    if already_seeded:
        return 0
    session.add_all(
        [
            Cycle(
                user_id=user.id,
                start_date=seed.start_date,
                end_date=seed.end_date,
                created_at=SYNTHETIC_CYCLE_TIMESTAMP,
                updated_at=SYNTHETIC_CYCLE_TIMESTAMP,
            )
            for seed in seeds
        ]
    )
    return len(seeds)


def add_daily_logs(
    session: Session,
    user: User,
    seeds: list[DailyLogSeed],
    logs_by_date: dict[date, DailyLog],
) -> tuple[int, dict[date, DailyLog]]:
    created = 0
    for seed in seeds:
        log = logs_by_date.get(seed.log_date)
        if log is None:
            log = DailyLog(
                user_id=user.id,
                log_date=seed.log_date,
                bleeding_level=seed.bleeding_level,
                mood_level=seed.mood_level,
                pain_level=seed.pain_level,
                sleep_quality=seed.sleep_quality,
                stress_level=seed.stress_level,
                notes=SYNTHETIC_NOTE,
            )
            session.add(log)
            logs_by_date[seed.log_date] = log
            created += 1
    return created, logs_by_date


def add_daily_log_symptoms(
    session: Session,
    logs_by_date: dict[date, DailyLog],
    symptom_types: list[SymptomType],
) -> int:
    """Add deterministic symptom links, without duplicating existing links."""
    if not symptom_types:
        raise SeedDataError(
            "No symptom_types records exist. No records were created."
        )

    # Flush newly added logs so their primary keys are available. This is
    # inside the transaction, after all preflight checks have succeeded.
    session.flush()

    existing_pairs = set(
        session.execute(
            select(
                DailyLogSymptom.daily_log_id,
                DailyLogSymptom.symptom_type_id,
            ).where(
                DailyLogSymptom.daily_log_id.in_(
                    [log.id for log in logs_by_date.values()]
                )
            )
        ).all()
    )

    created = 0
    ordered_logs = sorted(logs_by_date.values(), key=lambda log: log.log_date)
    for index, log in enumerate(ordered_logs):
        # Vary the synthetic symptom links deterministically.
        selected_type = symptom_types[index % len(symptom_types)]
        pair = (log.id, selected_type.id)
        if pair not in existing_pairs:
            session.add(
                DailyLogSymptom(
                    daily_log_id=log.id,
                    symptom_type_id=selected_type.id,
                )
            )
            existing_pairs.add(pair)
            created += 1
    return created


def seed() -> tuple[int, int, int]:
    reference_date = date.today()
    cycle_seeds = build_cycle_seeds(reference_date)
    daily_log_seeds = build_daily_log_seeds(reference_date)

    with SessionLocal() as session:
        try:
            with session.begin():
                user = get_test_user(session)
                symptom_types = list(
                    session.scalars(select(SymptomType).order_by(SymptomType.id))
                )
                if not symptom_types:
                    raise SeedDataError(
                        "No symptom_types records exist. No records were created."
                    )

                # Complete every read-only preflight before adding ORM objects.
                cycles_already_seeded = validate_cycle_seed_state(
                    session, user, cycle_seeds
                )
                existing_logs_by_date = validate_daily_log_seed_state(
                    session, user, daily_log_seeds
                )

                created_cycles = add_cycles(
                    session, user, cycle_seeds, cycles_already_seeded
                )
                created_logs, logs_by_date = add_daily_logs(
                    session, user, daily_log_seeds, existing_logs_by_date
                )
                created_relationships = add_daily_log_symptoms(
                    session, logs_by_date, symptom_types
                )
        except Exception:
            session.rollback()
            raise

    return created_cycles, created_logs, created_relationships


def main() -> int:
    try:
        cycles, daily_logs, relationships = seed()
    except SeedDataError as error:
        print(f"Seed aborted safely: {error}", file=sys.stderr)
        return 1
    except Exception as error:
        print(
            f"Seed failed; transaction was rolled back: {error}",
            file=sys.stderr,
        )
        return 1

    print("Synthetic CycleInsight QA data seeded successfully.")
    print("This data is synthetic and is not real health information.")
    print(
        f"Created {cycles} cycles, {daily_logs} daily logs, "
        f"and {relationships} daily-log symptom relationships."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
