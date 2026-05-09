from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.models.user import User, FcmToken
from app.schemas.auth import RegisterRequest, LoginRequest
from app.core.security import hash_password, verify_password, create_access_token


async def save_fcm_token(db: AsyncSession, user_email: str, token: str):
    result = await db.execute(select(FcmToken).where(FcmToken.token == token))
    existing_token = result.scalar_one_or_none()

    if existing_token is None:
        db.add(FcmToken(user_email=user_email, token=token))
        await db.commit()


async def register_user(db: AsyncSession, data: RegisterRequest):
    result = await db.execute(select(User).where(User.email == data.email))
    existing_user = result.scalar_one_or_none()

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El usuario ya existe",
        )

    user = User(
        email=data.email,
        password_hash=hash_password(data.password),
        photo_url=data.photo_url,
        full_name=data.full_name,
        phone=data.phone,
        role=data.role,
    )

    db.add(user)
    await db.commit()

    await save_fcm_token(db, data.email, data.fcm_token)

    token = create_access_token(subject=data.email)

    return {
        "access_token": token,
        "token_type": "bearer",
        "email": data.email,
    }


async def login_user(db: AsyncSession, data: LoginRequest):
    result = await db.execute(select(User).where(User.email == data.email))
    user = result.scalar_one_or_none()

    if user is None or not verify_password(data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas",
        )

    await save_fcm_token(db, data.email, data.fcm_token)

    token = create_access_token(subject=data.email)

    return {
        "access_token": token,
        "token_type": "bearer",
        "email": data.email,
    }
