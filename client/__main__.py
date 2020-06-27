import cv2
import requests

from client.video import Video
from client.utils import encode_image, decode_image

video = Video()

if __name__ == '__main__':
    while True:
        encoded_image = encode_image(video.get_frame())

        result = requests.post('http://127.0.0.1:5000/web_cam', encoded_image, stream=True).json()

        image = decode_image(result["data"])

        cv2.imshow('object detection', image)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            break
