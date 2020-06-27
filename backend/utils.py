import base64

import cv2
import numpy as np


def encode_image(image):
    bts = image_to_bts(image)
    return base64.b64encode(bts).decode('utf-8')


def decode_image(image):
    bts = base64.b64decode(image)
    return bts_to_img(bts)


def image_to_bts(frame):
    _, bts = cv2.imencode('.jpg', frame)
    return bts.tobytes()


def bts_to_img(bts):
    buff = np.fromstring(bts, np.uint8)
    buff = buff.reshape(1, -1)
    return cv2.imdecode(buff, cv2.IMREAD_COLOR)
