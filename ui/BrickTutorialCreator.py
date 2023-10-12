import sys
import os
from PySide6.QtCore import QUrl, Qt
from PySide6.QtQuick import QQuickWindow, QSGRendererInterface
from PySide6.QtGui import QGuiApplication, QFontDatabase, QIcon, QFont
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, QQmlDebuggingEnabler
from qml import Brick
from qml import TutorialManager
from qml import TutorialSourceManager
from qml import LanguageManager
from qml import Converter
from qml import ColorManager

import resources_rc
import logging
import shutil
import OSDefs

if __name__ == "__main__":
    os.environ["QT_FONT_DPI"] = "96"
    folder = os.path.join(os.getcwd() + r"/resources/tmp")
    logging.debug("Leftover tmp files form: " + folder)
    os.makedirs(folder, exist_ok=True)
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print("Failed to delete %s. Reason: %s" % (file_path, e))

    sys.argv += ["--style", "Fusion"]
    QGuiApplication.setAttribute(Qt.AA_ShareOpenGLContexts, True)
    QQuickWindow.setGraphicsApi(QSGRendererInterface.OpenGLRhi)
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("./resources/icon.svg"))

    # sapp.applicationDisplayName("Brick Designer")
    qmlRegisterType(Brick.Brick, "Brick", 1, 0, "Brick")
    qmlRegisterType(
        TutorialManager.TutorialManager, "TutorialManager", 1, 0, "TutorialManager"
    )
    qmlRegisterType(
        LanguageManager.LanguageManager, "LanguageManager", 1, 0, "LanguageManager"
    )
    qmlRegisterType(
        TutorialSourceManager.TutorialSourceManager,
        "TutorialSourceManager",
        1,
        0,
        "TutorialSourceManager",
    )
    qmlRegisterType(Converter.Converter, "Converter", 1, 0, "Converter")
    qmlRegisterType(ColorManager.ColorManager, "ColorManager", 1, 0, "ColorManager")

    assert (
        QFontDatabase.addApplicationFont(os.getcwd() + "/qml/font/Roboto-Bold.ttf")
        != -1
    )
    assert (
        QFontDatabase.addApplicationFont(os.getcwd() + "/qml/font/Roboto-Light.ttf")
        != -1
    )

    engine = QQmlApplicationEngine()
    engine.load("./qml/main.qml")
    fontStyles = QFontDatabase.styles("Roboto")
    assert "Light" in fontStyles
    assert "Bold" in fontStyles

    for style in fontStyles:
        font = QFontDatabase.font("Roboto", style, 12)
        assert font
        engine.rootContext().setContextProperty(style.lower() + "Roboto", font)

    engine.rootContext().setContextProperty(
        "tempFolder", QUrl.fromLocalFile(os.getcwd()).toString() + r"/resources/out"
    )
    engine.rootContext().setContextProperty(
        "fileStub", OSDefs.FILE_STUB
    )
    engine.rootContext().setContextProperty(
        "baseFolder", QUrl.fromLocalFile(os.getcwd()).toString() + r"/base"
    )
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
