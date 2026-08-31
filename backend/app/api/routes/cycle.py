from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.dependencies import get_db
from app.crud.cycle import create_cycle, get_cycle, get_cycles, update_cycle, delete_cycle
from app.schemas.cycle import CycleCreate, CycleUpdate, CycleResponse
from app.core.dependencies import get_current_user
from app.models.user import User

router = APIRouter()


@router.post("/cycles", response_model=CycleResponse)
def create_new_cycle(
    cycle: CycleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    new_cycle = create_cycle(
        db=db,
        user_id=current_user.id,
        cycle_data=cycle,
    )

    if new_cycle is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A cycle with this start date already exists.",
        )

    return new_cycle


@router.get("/cycles", response_model=list[CycleResponse])
def read_cycles(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return get_cycles(
        db=db,
        user_id=current_user.id
    )


@router.get("/cycles/{cycle_id}", response_model=CycleResponse)
def read_cycle(
    cycle_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    cycle = get_cycle(
        db,
        cycle_id,
        current_user.id
    )

    if cycle is None:
        raise HTTPException(
            status_code=404,
            detail="Cycle not found"
        )

    return cycle


@router.put("/cycles/{cycle_id}", response_model=CycleResponse)
def edit_cycle(
    cycle_id: int,
    cycle: CycleUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    try:
        updated_cycle = update_cycle(
            db,
            cycle_id,
            cycle,
            current_user.id
        )

    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )

    if updated_cycle is None:
        raise HTTPException(
            status_code=404,
            detail="Cycle not found"
        )

    return updated_cycle


@router.delete("/cycles/{cycle_id}")
def remove_cycle(
    cycle_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    deleted_cycle = delete_cycle(db, cycle_id, current_user.id)

    if deleted_cycle is None:
        raise HTTPException(
            status_code=404, 
            detail="Cycle not found"
        )

    return {
        "message": "Cycle deleted successfully."
    }