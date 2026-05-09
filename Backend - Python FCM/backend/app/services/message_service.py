from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.models.user import User, FcmToken
from app.models.message import Message, MessageNotification

from app.schemas.message import SendMessageRequest
from app.services.firebase_service import send_push_notification


async def send_message_service(
    db: AsyncSession,
    sender_email: str,
    data: SendMessageRequest,
):
    # 1. Validar que el usuario receptor exista
    result = await db.execute(
        select(User).where(User.email == data.receiver_email)
    )

    receiver = result.scalar_one_or_none()

    if receiver is None:
        raise HTTPException(
            status_code=404,
            detail="Usuario destinatario no existe"
        )

    # 2. Evitar auto mensajes
    if sender_email == data.receiver_email:
        raise HTTPException(
            status_code=400,
            detail="No puedes enviarte mensajes a ti mismo"
        )

    # 3. Crear mensaje
    message = Message(
        title=data.title,
        body=data.body,
        sender_email=sender_email,
        receiver_email=data.receiver_email,
    )

    db.add(message)

    await db.commit()
    await db.refresh(message)

    # 4. Obtener tokens FCM del receptor
    token_result = await db.execute(
        select(FcmToken).where(
            FcmToken.user_email == data.receiver_email
        )
    )

    tokens = token_result.scalars().all()

    # 5. Enviar notificaciones push
    for item in tokens:
        try:
            response = send_push_notification(
                token=item.token,
                title=data.title,
                body=data.body,
            )

        except Exception as e:
            # Guardar error de Firebase
            response = str(e)

        notification = MessageNotification(
            message_id=message.id,
            fcm_token=item.token,
            firebase_response=response,
        )

        db.add(notification)

    await db.commit()

    return message