import app.core.firebase

from firebase_admin import messaging


# TOKEN DEL RECEPTOR
# test1@mail.com
TOKEN = "dTCIhwj8T7qv7IcwRaFOWD:APA91bGQNuOgnlVh3z7XdDPXu7BWlkbab6mcgf5hC47Tinn3ORjD54blbEIlTlROir-j7aJRWq_hOkVF8CV_w_fjwG4EIonoNKGlFejCnTLHiZW1CMU6IUo"


def send_test_notification():

    message = messaging.Message(

        notification=messaging.Notification(

            title="Nuevo mensaje",

            body="Hola test1, soy test2 🚀",
        ),

        data={

            "sender": "test2@mail.com",

            "receiver": "test1@mail.com",

            "type": "chat",

            "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },

        token=TOKEN,
    )

    response = messaging.send(message)

    print("MENSAJE ENVIADO:")
    print(response)


if __name__ == "__main__":
    send_test_notification()