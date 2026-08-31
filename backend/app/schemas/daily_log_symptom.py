from pydantic import BaseModel


class DailyLogSymptomCreate(BaseModel):
    daily_log_id: int
    symptom_type_id: int


class DailyLogSymptomResponse(BaseModel):
    id: int
    daily_log_id: int
    symptom_type_id: int

    model_config = {
        "from_attributes": True
    }