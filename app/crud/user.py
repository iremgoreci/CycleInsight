from sqlalchemy.orm import Session
from app.core.security import hash_password
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

def create_user(db: Session, user_data: UserCreate) -> User:
    hashed_password = hash_password(user_data.password)

    new_user = User(
        first_name= user_data.first_name,
        last_name= user_data.last_name,
        email= user_data.email,
        password_hash= hashed_password,
        date_of_birth= user_data.date_of_birth
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user

def get_user(db: Session, user_id: int):
    return db.query(User).filter(
        User.id == user_id
    ).first()

def get_users(db: Session):
    return db.query(User).all()

def update_user(db: Session, user_id: int, user_data: UserUpdate):
    user = get_user(db, user_id)

    if user is None:
        return None

    if user_data.first_name is not None:
        user.first_name = user_data.first_name

    if user_data.last_name is not None:
        user.last_name = user_data.last_name

    if user_data.email is not None:
        user.email = user_data.email

    if user_data.password is not None:
        user.password_hash = hash_password(user_data.password)

    if user_data.date_of_birth is not None:
        user.date_of_birth = user_data.date_of_birth

    db.commit()
    db.refresh(user)

    return user

def delete_user(db: Session, user_id: int):
    user = get_user(db, user_id)

    if user is None:
        return None

    db.delete(user)
    db.commit()

    return user