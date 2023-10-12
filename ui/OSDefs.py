
from sys import platform

if platform == "linux" or platform == "linux2" or platform == "darwin":
    FILE_STUB = "file://"
else:
    FILE_STUB = "file:///"