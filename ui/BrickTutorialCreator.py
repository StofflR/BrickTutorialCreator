import sys
import os
from PySide6.QtCore import QUrl, Qt
from PySide6.QtQuick import QQuickWindow, QSGRendererInterface
from PySide6.QtWebEngineQuick import QtWebEngineQuick
from PySide6.QtGui import QGuiApplication, QFontDatabase, QIcon
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType , QQmlDebuggingEnabler
from qml import Brick
from qml import TutorialManager
from qml import TutorialSourceManager
from qml import LanguageManager
from qml import Converter
from qml import ColorManager
import resources_rc
import logging
import shutil

if __name__ == "__main__":

    folder = os.path.join(os.getcwd() + r"/resources/tmp")
    logging.debug("Leftover tmp files form: "+folder)
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print('Failed to delete %s. Reason: %s' % (file_path, e))


    sys.argv += ['--style', 'Fusion']
    QGuiApplication.setAttribute(Qt.AA_ShareOpenGLContexts, True)
    QQuickWindow.setGraphicsApi(QSGRendererInterface.OpenGLRhi)
    QtWebEngineQuick.initialize()
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("./resources/icon.svg"))

    #sapp.applicationDisplayName("Brick Designer")
    qmlRegisterType(Brick.Brick, 'Brick', 1, 0, 'Brick')
    qmlRegisterType(TutorialManager.TutorialManager, 'TutorialManager', 1, 0, 'TutorialManager')
    qmlRegisterType(LanguageManager.LanguageManager, 'LanguageManager', 1, 0, 'LanguageManager')
    qmlRegisterType(TutorialSourceManager.TutorialSourceManager, 'TutorialSourceManager', 1, 0, 'TutorialSourceManager')
    qmlRegisterType(Converter.Converter, 'Converter', 1, 0, 'Converter')
    qmlRegisterType(ColorManager.ColorManager, 'ColorManager', 1, 0, 'ColorManager')

    QFontDatabase.addApplicationFont(QUrl.fromLocalFile(
        os.getcwd()).toString() + "/qml/font/Roboto-Bold.ttf")
    QFontDatabase.addApplicationFont(QUrl.fromLocalFile(
        os.getcwd()).toString() + "/qml/font/Roboto-Light.ttf")
    engine = QQmlApplicationEngine()
    engine.load("./qml/main.qml")

    engine.rootContext().setContextProperty(
        "tempFolder", QUrl.fromLocalFile(os.getcwd()).toString() + r"/resources/out")
    engine.rootContext().setContextProperty(
        "baseFolder", QUrl.fromLocalFile(os.getcwd()).toString() + r"/base")
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())

