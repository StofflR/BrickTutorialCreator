from PySide6.QtGui import QGuiApplication, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
import os
import sys
app = None
def initQt():
    global app
    if not app:
        app = QGuiApplication()
    QFontDatabase.addApplicationFont(
        os.getcwd() + "/resources/fonts/Roboto-Bold.ttf"
    )
    QFontDatabase.addApplicationFont(
        os.getcwd() + "/resources/fonts/Roboto-Light.ttf"
    )
    engine = QQmlApplicationEngine()
    fontStyles = QFontDatabase.styles("Roboto")

    for style in fontStyles:
        font = QFontDatabase.font("Roboto", style, 12)
        engine.rootContext().setContextProperty(style.lower() + "Roboto", font)
