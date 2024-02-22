import sys
from PySide6.QtCore import Qt
from PySide6.QtQuick import QQuickWindow, QSGRendererInterface
from PySide6.QtGui import QGuiApplication, QFontDatabase, QIcon, QFont
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, QQmlDebuggingEnabler
from modules.interface.TutorialManager import TutorialManager
from modules.interface.TutorialSourceManager import TutorialSourceManager
from modules.interface.LanguageManager import LanguageManager
from modules.interface.Converter import Converter
from modules.interface.ColorManager import ColorManager
from modules.interface.Brick import Brick

import resources_rc
import logging
import modules.OSDefs as OSDefs
from modules.ConstDefs import *
from modules.Utility import generateRequiredFolders, clearFolder, addFileStub

if __name__ == "__main__":
    os.environ["QT_FONT_DPI"] = "96"
    generateRequiredFolders()
    logging.debug("Leftover tmp files form: " + DEF_TMP)
    clearFolder(DEF_TMP)

    sys.argv += ["--style", "Fusion"]
    QGuiApplication.setAttribute(Qt.AA_ShareOpenGLContexts, True)
    QQuickWindow.setGraphicsApi(QSGRendererInterface.OpenGLRhi)
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("./resources/icon.svg"))

    # register custom Python classes for use in QML
    qmlRegisterType(Brick, "Brick", 1, 0, "Brick")
    qmlRegisterType(TutorialManager, "TutorialManager", 1, 0, "TutorialManager")
    qmlRegisterType(LanguageManager, "LanguageManager", 1, 0, "LanguageManager")
    qmlRegisterType(
        TutorialSourceManager,
        "TutorialSourceManager",
        1,
        0,
        "TutorialSourceManager",
    )
    qmlRegisterType(Converter, "Converter", 1, 0, "Converter")
    qmlRegisterType(Converter, "Converter", 1, 0, "Converter")
    qmlRegisterType(ColorManager, "ColorManager", 1, 0, "ColorManager")

    # load fonts
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

    # register constant paths as variables for use in qml
    engine.rootContext().setContextProperty(
        "resourcesOutFolder", addFileStub(DEF_RESOURCE_OUT)
    )
    engine.rootContext().setContextProperty(
        "exportFolder", addFileStub(DEF_RESOURCE_OUT_EXPORT)
    )
    engine.rootContext().setContextProperty("baseFolder", addFileStub(DEF_BASE))
    engine.rootContext().setContextProperty("fileStub", OSDefs.FILE_STUB)
    engine.load("./qml/main.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
