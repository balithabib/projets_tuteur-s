# Generate a new secret key :
import random
import string

SECRET_KEY = "".join([random.choice(string.printable) for _ in range(24)])

FB_APP_ID = 1200420960103822
