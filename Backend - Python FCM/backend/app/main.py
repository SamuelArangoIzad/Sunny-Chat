from fastapi import FastAPI
import os
import app.core.firebase

from fastapi.staticfiles import StaticFiles

from app.db.session import engine, Base
from app.models import User, FcmToken, Message, MessageNotification

from app.api.auth import router as auth_router
from app.api.users import router as users_router
from app.api.messages import router as messages_router
from app.api.profile import router as profile_router


app = FastAPI(title="Backend Examen 2 - Mensajería FCM")

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

app.include_router(auth_router)
app.include_router(users_router)
app.include_router(messages_router)
app.include_router(profile_router)


@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


@app.get("/")
async def root():
    return {"status": "ok"}