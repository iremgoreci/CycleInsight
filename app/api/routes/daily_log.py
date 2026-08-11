from fastapi import APIRouter, Depends, HTTPException
from app.db.dependencies import get_db
from app.crud.daily_log import create_daily_log, get_daily_log, get_daily_logs, update_daily_log, delete_daily_log
from app.schemas.daily_log import DailyLogCreate, DailyLogUpdate, DailyLogResponse
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError

router = APIRouter()

@router.post("/daily_logs", response_model=DailyLogResponse)
def create_new_daily_log(
    daily_log: DailyLogCreate,
    db: Session = Depends(get_db)
):
    try:
        return create_daily_log(
            db=db,
            user_id=4,
            daily_log_data=daily_log
        )

    except IntegrityError:
        db.rollback()

        raise HTTPException(
            status_code=409,
            detail="A daily log already exists for this date."
        )


@router.get("/daily_logs", response_model=list[DailyLogResponse])
def read_daily_logs(
    db: Session = Depends(get_db)
):
    return get_daily_logs(db)


@router.get("/daily_logs/{daily_log_id}", response_model=DailyLogResponse)
def read_daily_log(
    daily_log_id: int,
    db: Session = Depends(get_db)
):
    daily_log = get_daily_log(db, daily_log_id)

    if daily_log is None: 
        raise HTTPException(
            status_code=404,
            detail="Daily log not found"
        )
    
    return daily_log


@router.put("/daily_logs/{daily_log_id}", response_model=DailyLogResponse)
def edit_daily_log(
    daily_log_id: int,
    daily_log: DailyLogUpdate,
    db: Session = Depends(get_db)
):
    updated_daily_log = update_daily_log(db, daily_log_id, daily_log)

    if updated_daily_log is None:
        raise HTTPException(
            status_code=404,
            detail="Daily log not found"
        )

    return updated_daily_log


@router.delete("/daily_logs/{daily_log_id}")
def remove_daily_log(
    daily_log_id: int,
    db: Session = Depends(get_db)
):
    deleted_daily_log = delete_daily_log(db, daily_log_id)

    if deleted_daily_log is None:
        raise HTTPException(
            status_code=404,
            detail="Daily log not found"
        )

    return {
        "message": "Daily log deleted successfully"
    }