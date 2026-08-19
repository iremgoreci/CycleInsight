from pydantic import BaseModel


class SymptomTypeResponse(BaseModel):
    id: int
    name: str

    model_config = {
        "from_attributes": True
    }