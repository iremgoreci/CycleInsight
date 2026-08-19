from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError

from app.crud.user import create_user
from app.db.dependencies import get_db
from app.schemas.user import UserCreate, UserResponse

router = APIRouter()


@router.post("/users", response_model=UserResponse)
def register_user(
    user: UserCreate,
    db: Session = Depends(get_db)
):
    try:
        return create_user(db, user)

    except IntegrityError:
        db.rollback()

        raise HTTPException(
            status_code=400,
            detail="Email already exists."
        )