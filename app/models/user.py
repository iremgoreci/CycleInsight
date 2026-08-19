from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import date, datetime
from sqlalchemy import String, DateTime, Date

from app.db.database import Base


class User(Base):
    __tablename__ = "users"
    id: Mapped[int] = mapped_column(primary_key=True)
    first_name: Mapped[str] = mapped_column(String(100), nullable=False)
    last_name: Mapped[str] = mapped_column(String(100), nullable=False)
    email: Mapped[str] = mapped_column(String(255), nullable=False, unique=True)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    date_of_birth: Mapped[date] = mapped_column(Date, nullable=False)
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
    cycles: Mapped[list["Cycle"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan"
    )
    daily_logs: Mapped[list["DailyLog"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan"
    )
