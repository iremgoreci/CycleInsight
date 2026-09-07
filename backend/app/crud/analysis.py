from sqlalchemy.orm import Session

from app.models.cycle import Cycle
from app.models.daily_log import DailyLog
from app.models.daily_log_symptom import DailyLogSymptom
from app.models.symptom_type import SymptomType


def get_user_analysis_data(
    db: Session,
    user_id: int
):
    cycles = db.query(Cycle).filter(
        Cycle.user_id == user_id
    ).order_by(
        Cycle.start_date
    ).all()

    daily_logs = db.query(DailyLog).filter(
        DailyLog.user_id == user_id
    ).order_by(
        DailyLog.log_date
    ).all()

    daily_log_ids = [
        daily_log.id
        for daily_log in daily_logs
    ]

    daily_log_symptoms = []

    if daily_log_ids:
        daily_log_symptoms = db.query(
            DailyLogSymptom
        ).filter(
            DailyLogSymptom.daily_log_id.in_(
                daily_log_ids
            )
        ).all()

    symptom_types = db.query(
        SymptomType
    ).order_by(
        SymptomType.id
    ).all()

    return {
        "cycles": cycles,
        "daily_logs": daily_logs,
        "daily_log_symptoms": daily_log_symptoms,
        "symptom_types": symptom_types,
    }