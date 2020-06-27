from flask import Flask, request, jsonify

from detection import ObjectDetector
from utils import decode_image, encode_image

app = Flask(__name__)
client_detector = ObjectDetector()
# Config options - Make sure you created a 'config.py' file.
app.config.from_object('config')


@app.route('/web_cam', methods=['POST'])
def post():
    decoded_image = decode_image(request.data)

    image_with_detection = client_detector.detect(decoded_image)

    encoded_image = encode_image(image_with_detection)

    return jsonify({"data": encoded_image})


if __name__ == '__main__':
    app.run()
