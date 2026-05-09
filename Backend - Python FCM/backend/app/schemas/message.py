from datetime import datetime

from pydantic import BaseModel


class SendMessageRequest(BaseModel):

    receiver_email: str

    title: str

    body: str


class MessageResponse(BaseModel):

    id: int

    title: str

    body: str

    sender_email: str

    receiver_email: str

    created_at: datetime

    class Config:
        from_attributes = True