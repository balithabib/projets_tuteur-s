import argparse
import asyncio
import base64
import datetime
import os
import smtplib

import aiohttp
import cv2
import requests

from client.notification import send_notification_with_image
from client.utils import encode_image, decode_image
from client.video import Video

parser = argparse.ArgumentParser()
parser.add_argument('--host', default=None, help='the host of the backend')
parser.add_argument('--port', default=None, help='the port of the backend')
args = vars(parser.parse_args())
HOST = args['host']
PORT = args['port']
URL = 'http://' + HOST + ':' + PORT + '/web_cam'

video = Video()

sender = 'balithabib94@gmail.com'
receiver = sender
subject = 'ALERT !'
server = smtplib.SMTP('smtp.gmail.com', 587)
server.starttls()
server.login(sender, os.environ.get('LOGIN_EMAIL', ''))
status_send = True


def detection_with_order_version_1():
    while True:
        frame = video.get_frame()
        cv2.imshow('web_cam', frame)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break
        if cv2.waitKey(25) & 0xFF == ord('c'):
            encoded_image = encode_image(frame)
            result = requests.post(URL, encoded_image, stream=True).json()
            image = decode_image(result['data'])
            cv2.imshow('object detection', image)


def send_notification(data):
    global status_send
    for value in data['info'].values():
        if value['name'] == 'person' and status_send:
            date = datetime.datetime.now()
            message = "Hello,\n\n" \
                      "A person is detected around the premises :\n" \
                      "date : {}\n" \
                      "hour : {}\n\n" \
                      "The person's images are attached to this email.\n\n" \
                      "Cordially".format(date.date(), date.time())
            send_notification_with_image(server, sender, receiver, subject, message, base64.b64decode(data['data']))
            status_send = False


def stream():
    return encode_image(video.get_frame())


async def get_detection_in_backend(client):
    async with client.post(URL, data=stream()) as response:
        return await response.json()


async def get_detection(client):
    data = await get_detection_in_backend(client)
    send_notification(data)
    return decode_image(data['data'])


async def detection_async():
    client = aiohttp.ClientSession()
    while True:
        image_with_detection = await get_detection(client)
        cv2.imshow('web_cam', image_with_detection)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break


if __name__ == '__main__':
    asyncio.run(detection_async())
    server.quit()
