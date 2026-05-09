from sqlalchemy import String, ForeignKey, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime

from app.db.session import Base


class User(Base):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(String(120), primary_key=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    photo_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    full_name: Mapped[str] = mapped_column(String(150), nullable=False)
    phone: Mapped[str] = mapped_column(String(30), nullable=False)
    role: Mapped[str] = mapped_column(String(80), nullable=False)

    tokens = relationship("FcmToken", back_populates="user")


class FcmToken(Base):
    __tablename__ = "fcm_tokens"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_email: Mapped[str] = mapped_column(ForeignKey("users.email"), nullable=False)
    token: Mapped[str] = mapped_column(String(500), nullable=False, unique=True)

    user = relationship("User", back_populates="tokens")


