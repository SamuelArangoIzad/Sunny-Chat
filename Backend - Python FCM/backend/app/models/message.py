from datetime import datetime

from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    DateTime,
    ForeignKey,
)

from app.db.session import Base


class Message(Base):

    __tablename__ = "messages"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    title = Column(
        String(150),
        nullable=False
    )

    body = Column(
        Text,
        nullable=False
    )

    sender_email = Column(
        String(120),
        ForeignKey("users.email"),
        nullable=False,
    )

    receiver_email = Column(
        String(120),
        ForeignKey("users.email"),
        nullable=False,
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
        nullable=False,
    )


class MessageNotification(Base):

    __tablename__ = "message_notifications"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    message_id = Column(
        Integer,
        ForeignKey("messages.id"),
        nullable=False,
    )

    fcm_token = Column(
        String(500),
        nullable=False
    )

    firebase_response = Column(
        Text,
        nullable=True
    )