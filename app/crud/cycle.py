from sqlalchemy.orm import Session
from app.models.cycle import Cycle
from app.schemas.cycle import CycleCreate, CycleUpdate



def create_cycle(db: Session, user_id: int, cycle_data: CycleCreate):
    new_cycle = Cycle(
        user_id=user_id,
        start_date= cycle_data.start_date,
        end_date= cycle_data.end_date,
    )

    db.add(new_cycle)
    db.commit()
    db.refresh(new_cycle)

    return new_cycle

def get_cycle(db: Session, cycle_id: int):
    return db.query(Cycle).filter(
        Cycle.id == cycle_id
    ).first()

def get_cycles(db: Session):
    return db.query(Cycle).all()

def update_cycle(db: Session, cycle_id: int, cycle_data: CycleUpdate):
    cycle = get_cycle(db, cycle_id)

    if cycle is None:
        return None

    if cycle_data.start_date is not None:
        cycle.start_date = cycle_data.start_date

    if cycle_data.end_date is not None:
        cycle.end_date = cycle_data.end_date

    db.commit()
    db.refresh(cycle)

    return cycle

def delete_cycle(db: Session, cycle_id: int):
    cycle = get_cycle(db, cycle_id)

    if cycle is None:
        return None

    db.delete(cycle)
    db.commit()

    return cycle