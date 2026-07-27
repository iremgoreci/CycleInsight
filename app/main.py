from fastapi import FastAPI
from app.schemas.user import UserCreate

app = FastAPI()


@app.get("/")
def root():
    return {"message": "Welcome to CycleInsight API"}


@app.post("/auth/register")
def register(user: UserCreate):
    print(user)
    print(type(user))
    print(user.first_name)

    print(user.model_dump())
    print(type(user.model_dump()))
    
    return {
        "message": "User received"
    }