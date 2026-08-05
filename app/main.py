from fastapi import FastAPI

from app.api.routes.user import router as user_router

app = FastAPI()


@app.get("/")
def root():
    return {
        "message": "Welcome to CycleInsight API"
    }


app.include_router(user_router)