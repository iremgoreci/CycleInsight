from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from datetime import date

from app.db.dependencies import get_db
from app.core.dependencies import get_current_user
from app.models.user import User

from app.crud.analysis import (
    get_user_analysis_data,
)

from app.analysis.analysis_service import (
    analyze_user_data,
)

def calculate_age(date_of_birth: date) -> int:
    today = date.today()

    age = today.year - date_of_birth.year

    if (today.month, today.day) < (
        date_of_birth.month,
        date_of_birth.day
    ):
        age -= 1

    return age

router = APIRouter()


@router.get("/analysis")
def read_analysis(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    age = calculate_age(
        current_user.date_of_birth
    )

    analysis_data = get_user_analysis_data(
        db,
        current_user.id,
    )

    result = analyze_user_data(
        cycles=analysis_data["cycles"],
        daily_logs=analysis_data["daily_logs"],
        daily_log_symptoms=analysis_data[
            "daily_log_symptoms"
        ],
        age=age,
    )

    return result