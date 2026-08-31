from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base

class SymptomType(Base):
    __tablename__ = "symptom_types"
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    daily_log_symptoms: Mapped[list["DailyLogSymptom"]] = relationship(back_populates="symptom_type")
