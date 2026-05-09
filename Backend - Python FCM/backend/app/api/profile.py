from fastapi import (
    APIRouter,
    UploadFile,
    File,
    Depends,
)

from sqlalchemy.ext.asyncio import AsyncSession

from sqlalchemy import (
    update,
    delete,
)

import shutil
import uuid

from app.db.session import get_db

from app.models import User

from app.models.user import FcmToken


router = APIRouter(
    prefix="/profile",
    tags=["Profile"]
)


@router.post("/upload-photo/{email}")
async def upload_photo(

    email: str,

    file: UploadFile = File(...),

    db: AsyncSession = Depends(get_db),
):

    extension = file.filename.split(".")[-1]

    filename = f"{uuid.uuid4()}.{extension}"

    path = f"uploads/{filename}"

    with open(path, "wb") as buffer:

        shutil.copyfileobj(
            file.file,
            buffer,
        )

    photo_url = (
        f"http://192.168.10.13:8000/uploads/{filename}"
    )

    await db.execute(

        update(User)

        .where(User.email == email)

        .values(photo_url=photo_url)
    )

    await db.commit()

    return {
        "photo_url": photo_url
    }


@router.delete("/logout/{email}")
async def logout_user(

    email: str,

    db: AsyncSession = Depends(get_db),
):

    await db.execute(

        delete(FcmToken)

        .where(
            FcmToken.user_email == email
        )
    )

    await db.commit()

    return {
        "message": "logout ok"
    }