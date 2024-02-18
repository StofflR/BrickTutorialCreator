from PySide6.QtCore import Slot, QObject
from PySide6.QtQml import QmlElement
from modules.ConstDefs import *
import os

QML_IMPORT_NAME = "ColorManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class ColorManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)

    @Slot(str, result=bool)
    def exists(self, file):
        """
        Check if file exists
        Parameters
        ----------
        file: file to be checked
        """
        return os.path.isfile(os.path.join(DEF_BASE, file))

    @Slot(str, str, str, str, str)
    def addBaseType(self, path, background, shade, border, base):
        """
        Create base brick for color if it is not present
        Parameters
        ----------
        path: base brick file to be stored
        background: background color
        shade: shade color
        border: border color
        base: reference base brick path
        """
        with open(os.path.join(DEF_RESOURCE, base), "r") as file:
            filedata = file.read()
            filedata = (
                filedata.replace("BACKGROUND", background)
                .replace("SHADE", shade)
                .replace("BORDER", border)
            )
        with open(os.path.join(DEF_BASE, path), "w") as file:
            file.write(filedata)
