from typing import Optional
from pydantic import BaseModel
from datetime import date


class CycleCreate(BaseModel):
    start_date: date
    end_date: date | None = None


class CycleUpdate(BaseModel):
    start_date: date | None = None
    end_date: date | None = None


class CycleResponse(BaseModel):
    id: int
    user_id: int
    start_date: date
    end_date: date | None = None

    model_config = {
        "from_attributes": True
    }