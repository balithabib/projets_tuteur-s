import argparse

import cv2
import requests

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

if __name__ == '__main__':
    while True:
        encoded_image = encode_image(video.get_frame())

        result = requests.post(URL, encoded_image, stream=True).json()

        image = decode_image(result['data'])

        cv2.imshow('object detection', image)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break
