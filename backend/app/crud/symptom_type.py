from sqlalchemy.orm import Session

from app.models.symptom_type import SymptomType


def get_symptom_type(db: Session, symptom_type_id: int):
    return db.query(SymptomType).filter(
        SymptomType.id  == symptom_type_id
    ).first()


def get_symptom_types(db: Session):
    return db.query(SymptomType).all()