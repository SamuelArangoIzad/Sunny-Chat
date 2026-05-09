from pydantic import BaseModel, EmailStr


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str
    photo_url: str | None = None
    full_name: str
    phone: str
    role: str
    fcm_token: str


class LoginRequest(BaseModel):
    email: EmailStr
    password: str
    fcm_token: str


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    email: str
