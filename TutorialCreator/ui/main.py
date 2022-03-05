# This Python file uses the following encoding: utf-8
import sys
import os
from PySide6.QtCore import  QUrl
from PySide6.QtGui import QGuiApplication, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
from qml import BrickManager
from qml import Brick
from qml import TutorialManager
from qml import LanguageManager
import resources_rc

if __name__ == "__main__":
    sys.argv += ['--style', 'Fusion']
    app = QGuiApplication(sys.argv)
    QFontDatabase.addApplicationFont(QUrl.fromLocalFile(os.getcwd()).toString()+ "/qml/font/Roboto-Bold.ttf")
    QFontDatabase.addApplicationFont(QUrl.fromLocalFile(os.getcwd()).toString()+ "/qml/font/Roboto-Light.ttf")
    engine = QQmlApplicationEngine()
    engine.load("./qml/main.qml")
    engine.rootContext().setContextProperty("tempFolder", QUrl.fromLocalFile(os.getcwd()).toString() + "/resources/out")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
