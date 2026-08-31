from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.dependencies import get_db
from app.crud.symptom_type import get_symptom_type, get_symptom_types
from app.schemas.symptom_type import SymptomTypeResponse

router = APIRouter()


@router.get("/symptom_types", response_model=list[SymptomTypeResponse])
def read_symptom_types(
    db: Session = Depends(get_db)
):
    return get_symptom_types(db)


@router.get("/symptom_types/{symptom_type_id}", response_model=SymptomTypeResponse)
def read_symptom_type(
    symptom_type_id: int,
    db: Session = Depends(get_db)
):
    symptom_type = get_symptom_type(db, symptom_type_id)

    if symptom_type is None: 
        raise HTTPException(
            status_code=404,
            detail="Symptom type not found"
        )
    
    return symptom_type
