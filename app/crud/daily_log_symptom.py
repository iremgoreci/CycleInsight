from sqlalchemy.orm import Session

from app.models.daily_log_symptom import DailyLogSymptom
from app.models.daily_log import DailyLog
from app.schemas.daily_log_symptom import DailyLogSymptomCreate


def create_daily_log_symptom(
    db: Session,
    daily_log_symptom_data: DailyLogSymptomCreate,
    user_id: int
):
    daily_log = db.query(DailyLog).filter(
        DailyLog.id == daily_log_symptom_data.daily_log_id,
        DailyLog.user_id == user_id
    ).first()

    if daily_log is None:
        return None

    new_daily_log_symptom = DailyLogSymptom(
        daily_log_id=daily_log_symptom_data.daily_log_id,
        symptom_type_id=daily_log_symptom_data.symptom_type_id
    )

    db.add(new_daily_log_symptom)
    db.commit()
    db.refresh(new_daily_log_symptom)

    return new_daily_log_symptom


def get_daily_log_symptom(
    db: Session,
    daily_log_symptom_id: int,
    user_id: int
):
    return db.query(DailyLogSymptom).join(
        DailyLog,
        DailyLog.id == DailyLogSymptom.daily_log_id
    ).filter(
        DailyLogSymptom.id == daily_log_symptom_id,
        DailyLog.user_id == user_id
    ).first()


def get_daily_log_symptoms(db: Session, user_id: int):
    return db.query(DailyLogSymptom).join(
        DailyLog,
        DailyLog.id == DailyLogSymptom.daily_log_id
    ).filter(
        DailyLog.user_id == user_id
    ).all()


def delete_daily_log_symptom(
    db: Session,
    daily_log_symptom_id: int,
    user_id: int
):
    deleted_daily_log_symptom = get_daily_log_symptom(
        db,
        daily_log_symptom_id,
        user_id
    )

    if deleted_daily_log_symptom is None:
        return None

    db.delete(deleted_daily_log_symptom)
    db.commit()

    return deleted_daily_log_symptom