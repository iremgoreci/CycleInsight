from sqlalchemy.orm import Session
from app.models.daily_log_symptom import DailyLogSymptom
from app.schemas.daily_log_symptom import DailyLogSymptomCreate


def create_daily_log_symptom(
    db: Session,
    daily_log_symptom_data: DailyLogSymptomCreate
):
    new_daily_log_symptom = DailyLogSymptom(
        daily_log_id=daily_log_symptom_data.daily_log_id,
        symptom_type_id=daily_log_symptom_data.symptom_type_id
    )

    db.add(new_daily_log_symptom)
    db.commit()
    db.refresh(new_daily_log_symptom)

    return new_daily_log_symptom


def get_daily_log_symptom(db: Session, daily_log_symptom_id: int):
    return db.query(DailyLogSymptom).filter(
        DailyLogSymptom.id  == daily_log_symptom_id
    ).first()


def get_daily_log_symptoms(db: Session):
    return db.query(DailyLogSymptom).all()


def delete_daily_log_symptom(db: Session, daily_log_symptom_id: int):
    deleted_daily_log_symptom = get_daily_log_symptom(db, daily_log_symptom_id)

    if deleted_daily_log_symptom is None:
        return None

    db.delete(deleted_daily_log_symptom)
    db.commit()

    return deleted_daily_log_symptom

