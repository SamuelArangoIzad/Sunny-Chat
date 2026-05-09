from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession

from sqlalchemy import (
    select,
    desc,
    and_,
    or_,
)

from app.db.session import get_db

from app.models.user import User

from app.models.message import Message

from app.schemas.message import (
    SendMessageRequest,
    MessageResponse,
)

from app.api.dependencies import (
    get_current_user,
)

from app.services.message_service import (
    send_message_service,
)


router = APIRouter(
    prefix="/messages",
    tags=["Messages"]
)


@router.post(
    "",
    response_model=MessageResponse
)
async def send_message(

    data: SendMessageRequest,

    db: AsyncSession = Depends(get_db),

    current_user: User = Depends(
        get_current_user
    ),
):

    return await send_message_service(
        db,
        current_user.email,
        data,
    )


@router.get(
    "/received",
    response_model=list[MessageResponse]
)
async def get_received_messages(

    db: AsyncSession = Depends(get_db),

    current_user: User = Depends(
        get_current_user
    ),
):

    result = await db.execute(

        select(Message)

        .where(
            Message.receiver_email
            == current_user.email
        )

        .order_by(
            desc(Message.created_at)
        )
    )

    return result.scalars().all()


@router.get(
    "/sent",
    response_model=list[MessageResponse]
)
async def get_sent_messages(

    db: AsyncSession = Depends(get_db),

    current_user: User = Depends(
        get_current_user
    ),
):

    result = await db.execute(

        select(Message)

        .where(
            Message.sender_email
            == current_user.email
        )

        .order_by(
            desc(Message.created_at)
        )
    )

    return result.scalars().all()


@router.get(
    "/conversation/{email}",
    response_model=list[MessageResponse]
)
async def get_conversation(

    email: str,

    db: AsyncSession = Depends(get_db),

    current_user: User = Depends(
        get_current_user
    ),
):

    result = await db.execute(

        select(Message)

        .where(

            or_(

                and_(
                    Message.sender_email
                    == current_user.email,

                    Message.receiver_email
                    == email,
                ),

                and_(
                    Message.sender_email
                    == email,

                    Message.receiver_email
                    == current_user.email,
                ),
            )
        )

        .order_by(
            Message.created_at.asc()
        )
    )

    return result.scalars().all()