from fastapi import APIRouter, Depends, HTTPException
from app.db.dependencies import get_db
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from app.crud.cycle import create_cycle, get_cycle, get_cycles, update_cycle, delete_cycle
from app.schemas.cycle import CycleCreate, CycleUpdate, CycleResponse

router = APIRouter()


@router.post("/cycles", response_model=CycleResponse)
def create_new_cycle(
    cycle: CycleCreate,
    db: Session = Depends(get_db)
):
    return create_cycle(
        db=db,
        user_id=4,
        cycle_data=cycle
    )


@router.get("/cycles", response_model=list[CycleResponse])
def read_cycles(
    db: Session = Depends(get_db)
):
    return get_cycles(db)

@router.get("/cycles/{cycle_id}", response_model=CycleResponse)
def read_cycle(
    cycle_id: int,
    db: Session = Depends(get_db)    
):
    cycle = get_cycle(db, cycle_id)

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
    db: Session = Depends(get_db)
):
    updated_cycle = update_cycle(db, cycle_id, cycle)

    if updated_cycle is None:
        raise HTTPException(
            status_code=404,
            detail="Cycle not found"
        )

    return updated_cycle


@router.delete("/cycles/{cycle_id}")
def remove_cycle(
    cycle_id: int, 
    db: Session = Depends(get_db)
):
    deleted_cycle = delete_cycle(db, cycle_id)

    if deleted_cycle is None:
        raise HTTPException(
            status_code=404, 
            detail="Cycle not found"
        )

    return {
        "message": "Cycle deleted successfully."
    }