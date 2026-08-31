from pydantic import BaseModel, model_validator
from datetime import date


class CycleCreate(BaseModel):
    start_date: date
    end_date: date | None = None

    @model_validator(mode="after")
    def validate_dates(self):
        if self.end_date is not None and self.end_date < self.start_date:
            raise ValueError("End date cannot be before start date.")

        return self


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