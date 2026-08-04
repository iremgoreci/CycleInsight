from app.db.database import Base
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.daily_log import DailyLog
from app.models.symptom_type import SymptomType


class DailyLogSymptom(Base):
    __tablename__ = "daily_log_symptoms"
    id: Mapped[int] = mapped_column(primary_key=True)
    daily_log_id: Mapped[int] = mapped_column(ForeignKey("daily_logs.id"), nullable=False)
    symptom_type_id: Mapped[int] = mapped_column(ForeignKey("symptom_types.id"), nullable=False)
    daily_log: Mapped["DailyLog"] = relationship(back_populates="daily_log_symptoms")
    symptom_type: Mapped["SymptomType"] = relationship(back_populates="daily_log_symptoms")