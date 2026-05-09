from pydantic import BaseModel, EmailStr


class UserResponse(BaseModel):
    email: EmailStr
    photo_url: str | None
    full_name: str
    phone: str
    role: str

    model_config = {
        "from_attributes": True
    }
