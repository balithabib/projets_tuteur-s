from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def send_notification(server, sender, receiver, subject, message):
    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = receiver
    msg['Subject'] = subject
    msg.attach(MIMEText(message))
    server.sendmail(sender, receiver, msg.as_string())
    return True


def send_notification_with_image(server, sender, receiver, subject, message, image):
    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = receiver
    msg['Subject'] = subject
    msg.attach(MIMEText(message))

    part = MIMEBase('application', 'octet-stream')
    part.set_payload(image)
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', "piece; filename= image.png")
    msg.attach(part)

    server.sendmail(sender, receiver, msg.as_string())
    return True
