#!/bin/python3
import argparse
import smtplib

from email.mime.text import MIMEText

EMAIL_DATA = {
    "host": "uwuwhatsthis.de",
    "smtp": "mx.uwuwhatsthis.de",
    "port": 587,  # StartTLS 587
    "receiver_email": "ole@uwuwhatsthis.de",
    "user": "scripts@uwuwhatsthis.de",
    "password": "H<;-2C9K7<JUSOU>1s.ADi^8H8054Akt{h%=Qz@6"
}

def send_mail(subject: str, content: str) -> int:
    if type(content) == list:
        content = " ".join(content)
    try:
        with smtplib.SMTP(EMAIL_DATA["smtp"], EMAIL_DATA["port"], timeout=30) as server:
            server.starttls()
            server.login(EMAIL_DATA["user"], EMAIL_DATA["password"])

            msg = MIMEText(content)

            msg["Subject"] = subject
            msg["From"] = EMAIL_DATA["user"]
            msg["To"] = EMAIL_DATA["receiver_email"]

            server.sendmail(EMAIL_DATA["user"],
                            EMAIL_DATA["receiver_email"], msg.as_string())
            server.quit()
            print("Successfully sent email!")
            return 0
    except (TimeoutError and OSError) as e:
        print(f"Could not send email: {e}")
        return 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send emails as scripts@uwuwhatsthis.de")
    parser.add_argument("--subject", required=True, help="The subject to set", type=str)
    parser.add_argument("--content", required=True, help="The content", nargs="+", type=str)
    parsed = parser.parse_args()

    send_mail(parsed.subject, parsed.content)
