from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.crud.user import create_user, get_user, get_users, update_user, delete_user
from app.db.dependencies import get_db
from app.schemas.user import UserCreate, UserUpdate

router = APIRouter()


@router.post("/users")
def register_user(
    user: UserCreate,
    db: Session = Depends(get_db)
):
    return create_user(db, user)


@router.get("/users")
def read_users(
    db: Session = Depends(get_db)
):
    return get_users(db)


@router.get("/users/{user_id}")
def read_user(
    user_id: int,
    db: Session = Depends(get_db)
):
    return get_user(db, user_id)


@router.put("/users/{user_id}")
def edit_user(
    user_id: int,
    user: UserUpdate,
    db: Session = Depends(get_db)
):
    return update_user(db, user_id, user)


@router.delete("/users/{user_id}")
def remove_user(
    user_id: int,
    db: Session = Depends(get_db)
):
    return delete_user(db, user_id)