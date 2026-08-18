from fastapi import FastAPI

from app.api.routes.user import router as user_router
from app.api.routes.cycle import router as cycle_router
from app.api.routes.daily_log import router as daily_log_router
from app.api.routes.symptom_type import router as symptom_type_router
from app.api.routes.daily_log_symptom import router as daily_log_symptom_router
from app.api.routes.auth import router as auth_router

app = FastAPI()


@app.get("/")
def root():
    return {
        "message": "Welcome to CycleInsight API"
    }


app.include_router(user_router)
app.include_router(cycle_router)
app.include_router(daily_log_router)
app.include_router(symptom_type_router)
app.include_router(daily_log_symptom_router)
app.include_router(auth_router)