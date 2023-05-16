from PySide6.QtCore import Slot, QObject
from PySide6.QtQml import QmlElement
import os

QML_IMPORT_NAME = "ColorManager"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class ColorManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)

    @Slot(str, result=bool)
    def exists(self ,file):
        return os.path.isfile(os.getcwd() + "/base/" +file)

    @Slot(str, str, str, str, str)
    def addBaseType(self, path, background, shade, border, base):
        with open(os.getcwd() + "/resources/" + base, 'r') as file:
            filedata = file.read()
            filedata = filedata.replace('BACKGROUND', background).replace('SHADE', shade).replace('BORDER', border).replace('ns0:', '').replace(':ns0', '')
        with open(os.getcwd() + "/base/" +path, 'w') as file:
            file.write(filedata)
