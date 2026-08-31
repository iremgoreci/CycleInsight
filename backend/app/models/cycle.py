from sqlalchemy import ForeignKey, DateTime, Date
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import date, datetime

from app.db.database import Base
from app.models.user import User


class Cycle(Base):
    __tablename__ = "cycles"
    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    start_date: Mapped[date] = mapped_column(Date, nullable=False)
    end_date: Mapped[date] = mapped_column(Date, nullable=True)
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
    user: Mapped["User"] = relationship(back_populates="cycles")
