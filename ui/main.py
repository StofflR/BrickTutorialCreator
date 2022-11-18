import sys
import os
from PySide6.QtCore import QUrl, Qt
from PySide6.QtQuick import QQuickWindow, QSGRendererInterface
from PySide6.QtWebEngineQuick import QtWebEngineQuick
from PySide6.QtGui import QGuiApplication, QFontDatabase, QIcon
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from qml import BrickManager
from qml import Brick
from qml import TutorialManager
from qml import LanguageManager
from qml import Converter
import resources_rc

if __name__ == "__main__":
    sys.argv += ['--style', 'Fusion']
    QGuiApplication.setAttribute(Qt.AA_ShareOpenGLContexts, True)
    QQuickWindow.setGraphicsApi(QSGRendererInterface.OpenGLRhi)
    QtWebEngineQuick.initialize()
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("./resources/icon.svg"))

    #sapp.applicationDisplayName("Brick Designer")
    qmlRegisterType(BrickManager.BrickManager, 'BrickManager', 1, 0, 'BrickManager')
    qmlRegisterType(Brick.Brick, 'Brick', 1, 0, 'Brick')
    qmlRegisterType(TutorialManager.TutorialManager, 'TutorialManager', 1, 0, 'TutorialManager')
    qmlRegisterType(LanguageManager.LanguageManager, 'LanguageManager', 1, 0, 'LanguageManager')
    qmlRegisterType(Converter.Converter, 'Converter', 1, 0, 'Converter')

    QFontDatabase.addApplicationFont(QUrl.fromLocalFile(
        os.getcwd()).toString() + "/qml/font/Roboto-Bold.ttf")
    QFontDatabase.addApplicationFont(QUrl.fromLocalFile(
        os.getcwd()).toString() + "/qml/font/Roboto-Light.ttf")
    engine = QQmlApplicationEngine()
    engine.load("./qml/main.qml")
    engine.rootContext().setContextProperty(
        "tempFolder", QUrl.fromLocalFile(os.getcwd()).toString() + "/resources/out")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
