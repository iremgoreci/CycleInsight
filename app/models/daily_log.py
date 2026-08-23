from sqlalchemy import ForeignKey, UniqueConstraint, Date, Text, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import date, datetime

from app.db.database import Base
from app.models.user import User


class DailyLog(Base):
    __tablename__ = "daily_logs"
    __table_args__ = (
        UniqueConstraint(
            "user_id",
            "log_date"
        ),
    )
    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    log_date: Mapped[date] = mapped_column(Date, nullable=False)
    bleeding_level: Mapped[int] = mapped_column()
    mood_level: Mapped[int] = mapped_column()
    pain_level: Mapped[int] = mapped_column()
    sleep_quality: Mapped[int] = mapped_column()
    stress_level: Mapped[int] = mapped_column()
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow, 
        nullable=False
        )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, 
        default=datetime.utcnow, 
        onupdate=datetime.utcnow, 
        nullable=False
        )
    user: Mapped["User"] = relationship(back_populates="daily_logs")
    daily_log_symptoms: Mapped[list["DailyLogSymptom"]] = relationship(
        back_populates="daily_log",
        cascade="all, delete-orphan"
    )
