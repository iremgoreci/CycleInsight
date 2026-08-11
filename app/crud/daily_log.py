from sqlalchemy.orm import Session
from app.models.daily_log import DailyLog
from app.schemas.daily_log import DailyLogCreate, DailyLogUpdate



def create_daily_log(db: Session, user_id: int, daily_log_data: DailyLogCreate):
    new_daily_log = DailyLog(
        user_id=user_id,
        log_date= daily_log_data.log_date,
        bleeding_level= daily_log_data.bleeding_level,
        mood_level= daily_log_data.mood_level,
        pain_level= daily_log_data.pain_level,
        sleep_quality= daily_log_data.sleep_quality,
        stress_level= daily_log_data.stress_level,
        notes= daily_log_data.notes
    )
    db.add(new_daily_log)
    db.commit()
    db.refresh(new_daily_log)

    return new_daily_log


def get_daily_log(db: Session, daily_log_id: int):
    return db.query(DailyLog).filter(
        DailyLog.id == daily_log_id
    ).first()

def get_daily_logs(db: Session):
    return db.query(DailyLog).all()

def update_daily_log(db: Session, daily_log_id: int, daily_log_data: DailyLogUpdate):
    daily_log = get_daily_log(db, daily_log_id)
    
    if daily_log is None:
        return None

    if daily_log_data.log_date is not None:
        daily_log.log_date = daily_log_data.log_date

    if daily_log_data.bleeding_level is not None:
        daily_log.bleeding_level = daily_log_data.bleeding_level

    if daily_log_data.mood_level is not None:
        daily_log.mood_level = daily_log_data.mood_level

    if daily_log_data.pain_level is not None:
        daily_log.pain_level = daily_log_data.pain_level

    if daily_log_data.sleep_quality is not None:
        daily_log.sleep_quality = daily_log_data.sleep_quality

    if daily_log_data.stress_level is not None:
        daily_log.stress_level = daily_log_data.stress_level

    if daily_log_data.notes is not None:
        daily_log.notes = daily_log_data.notes

    db.commit()
    db.refresh(daily_log)

    return daily_log

def delete_daily_log(db: Session, daily_log_id: int):
    daily_log = get_daily_log(db, daily_log_id)

    if daily_log is None:
        return None

    db.delete(daily_log)
    db.commit()

    return daily_log