from PySide6.QtGui import QGuiApplication, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
import os
import sys

def initQt():
    app = QGuiApplication(sys.argv)
    assert (
        QFontDatabase.addApplicationFont(
            os.getcwd() + "/resources/fonts/Roboto-Bold.ttf"
        )
        != -1
    )
    assert (
        QFontDatabase.addApplicationFont(
            os.getcwd() + "/resources/fonts/Roboto-Light.ttf"
        )
        != -1
    )

    engine = QQmlApplicationEngine()

    fontStyles = QFontDatabase.styles("Roboto")
    assert "Light" in fontStyles
    assert "Bold" in fontStyles

    for style in fontStyles:
        font = QFontDatabase.font("Roboto", style, 12)
        assert font
        engine.rootContext().setContextProperty(style.lower() + "Roboto", font)
