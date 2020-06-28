import argparse
import random
import string

from flask import Flask, request, jsonify

from backend.detection import ObjectDetector
from backend.utils import decode_image, encode_image

parser = argparse.ArgumentParser()
parser.add_argument("--host", default=None, help="the host of the backend")
parser.add_argument('--port', default="6666", help='the port of the backend')
args = vars(parser.parse_args())

app = Flask(__name__)
client_detector = ObjectDetector()

# Config options - Make sure you created a 'config.py' file.
# Generate a new secret key :
SECRET_KEY = "".join([random.choice(string.printable) for _ in range(24)])
app.config.update(SECRET_KEY=SECRET_KEY, FB_APP_ID=1200420960103822)
HOST = args['host']
PORT = args['port']


@app.route('/web_cam', methods=['POST'])
def post():
    decoded_image = decode_image(request.data)

    image_with_detection = client_detector.detect(decoded_image)

    encoded_image = encode_image(image_with_detection)

    return jsonify({"data": encoded_image})


if __name__ == '__main__':
    print(HOST, PORT)
    app.run(host=HOST, port=PORT)
