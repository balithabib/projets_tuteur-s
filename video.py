import cv2


class Video:
    def __init__(self, name_file=None):
        if name_file is None:
            self.cap = cv2.VideoCapture(0)
        else:
            self.cap = cv2.VideoCapture(name_file, 0)

    def get_frame(self):
        _, frame = self.cap.read()
        return frame
