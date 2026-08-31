from datetime import date
import app.models
from app.crud.user import create_user
from app.db.database import SessionLocal
from app.schemas.user import UserCreate

db = SessionLocal()

user = UserCreate(
    first_name="İrem",
    last_name="Göreci",
    email="deneme2@example.com",
    password="123456",
    date_of_birth=date(2000, 1, 1)
)

new_user = create_user(db, user)

print(new_user.id)
print(new_user.first_name)

db.close()