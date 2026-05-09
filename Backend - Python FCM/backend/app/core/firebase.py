import firebase_admin
from firebase_admin import credentials, messaging

cred = credentials.Certificate("app/firebase_key.json")

firebase_app = firebase_admin.initialize_app(cred)
