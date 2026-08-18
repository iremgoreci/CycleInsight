from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.crud.daily_log_symptom import (
    create_daily_log_symptom,
    get_daily_log_symptom,
    get_daily_log_symptoms,
    delete_daily_log_symptom
)
from app.db.dependencies import get_db
from app.schemas.daily_log_symptom import (
    DailyLogSymptomCreate,
    DailyLogSymptomResponse
)
from app.core.dependencies import get_current_user
from app.models.user import User


router = APIRouter()


@router.post(
    "/daily_log_symptoms",
    response_model=DailyLogSymptomResponse
)
def create_new_daily_log_symptom(
    daily_log_symptom: DailyLogSymptomCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    new_daily_log_symptom = create_daily_log_symptom(
        db,
        daily_log_symptom,
        current_user.id
    )

    if new_daily_log_symptom is None:
        raise HTTPException(
            status_code=404,
            detail="Daily log not found"
        )

    return new_daily_log_symptom


@router.get(
    "/daily_log_symptoms",
    response_model=list[DailyLogSymptomResponse]
)
def read_daily_log_symptoms(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return get_daily_log_symptoms(
        db,
        current_user.id
    )


@router.get(
    "/daily_log_symptoms/{daily_log_symptom_id}",
    response_model=DailyLogSymptomResponse
)
def read_daily_log_symptom(
    daily_log_symptom_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    daily_log_symptom = get_daily_log_symptom(
        db,
        daily_log_symptom_id,
        current_user.id
    )

    if daily_log_symptom is None:
        raise HTTPException(
            status_code=404,
            detail="Daily log symptom not found"
        )

    return daily_log_symptom


@router.delete("/daily_log_symptoms/{daily_log_symptom_id}")
def remove_daily_log_symptom(
    daily_log_symptom_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    deleted_daily_log_symptom = delete_daily_log_symptom(
        db,
        daily_log_symptom_id,
        current_user.id
    )

    if deleted_daily_log_symptom is None:
        raise HTTPException(
            status_code=404,
            detail="Daily log symptom not found"
        )

    return {
        "message": "Daily log symptom deleted successfully"
    }