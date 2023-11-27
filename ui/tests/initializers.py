from PySide6.QtGui import QGuiApplication
import sys

app = None


def initQt():
    global app
    if not app:
        app = QGuiApplication(sys.argv)
