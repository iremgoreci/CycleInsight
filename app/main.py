from fastapi import FastAPI

from app.api.routes.user import router as user_router
from app.api.routes.cycle import router as cycle_router


app = FastAPI()


@app.get("/")
def root():
    return {
        "message": "Welcome to CycleInsight API"
    }


app.include_router(user_router)
app.include_router(cycle_router)