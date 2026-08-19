from pydantic import BaseModel, Field
from datetime import date


class DailyLogCreate(BaseModel):
    log_date: date
    bleeding_level: int = Field(ge=0, le=5)
    mood_level: int = Field(ge=1, le=5)
    pain_level: int = Field(ge=0, le=5)
    sleep_quality: int = Field(ge=1, le=5)
    stress_level: int = Field(ge=0, le=5)
    notes: str | None = Field(default=None, max_length=1000)


class DailyLogUpdate(BaseModel):
    log_date: date | None = None
    bleeding_level: int | None = Field(default=None, ge=0, le=5)
    mood_level: int | None = Field(default=None, ge=1, le=5)
    pain_level: int | None = Field(default=None, ge=0, le=5)
    sleep_quality: int | None = Field(default=None, ge=1, le=5)
    stress_level: int | None = Field(default=None, ge=0, le=5)
    notes: str | None = Field(default=None, max_length=1000)


class DailyLogResponse(BaseModel):
    id: int
    log_date: date
    bleeding_level: int
    mood_level: int
    pain_level: int
    sleep_quality: int
    stress_level: int
    notes: str | None

    model_config = {
        "from_attributes": True
    }