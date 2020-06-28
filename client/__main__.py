import argparse
import asyncio

import aiohttp
import cv2

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

"""
def detection_reel_times():
    while True:
        encoded_image = encode_image(video.get_frame())

        result = client_http.post(URL, encoded_image, stream=True).json()

        image = decode_image(result['data'])

        cv2.imshow('object detection', image)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break


def detection_with_order_version_1():
    while True:
        frame = video.get_frame()
        cv2.imshow('web_cam', frame)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break

        if cv2.waitKey(25) & 0xFF == ord('c'):
            encoded_image = encode_image(frame)

            result = client_http.post(URL, encoded_image, stream=True).json()

            image = decode_image(result['data'])

            cv2.imshow('object detection', image)


async def detection(frame):
    encoded_image = encode_image(frame)

    result = await client_http.post(URL, encoded_image, stream=True).json()

    return decode_image(result['data'])


def detection_with_order_version_2():
    start = time.time()
    step = 0
    while True:
        frame = video.get_frame()

        cv2.imshow('web_cam', frame)

        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break

        end = time.time() - start
        if time.time() - start > step:
            step += 2
            print(end, type(detection(frame)))
            cv2.imshow('web_cam', frame)

"""


def stream():
    return encode_image(video.get_frame())


async def get_detection_in_backend(client):
    async with client.post(URL, data=stream()) as response:
        return await response.json()


async def detection_1(client):
    data = await get_detection_in_backend(client)
    return decode_image(data['data'])


async def detection_with_order_version_3():
    client = aiohttp.ClientSession()
    while True:
        image_with_detection = await detection_1(client)
        cv2.imshow('web_cam', image_with_detection)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break


if __name__ == '__main__':
    # detection_reel_times()
    # detection_with_order_version_1()
    # detection_with_order_version_2()
    asyncio.run(detection_with_order_version_3())
