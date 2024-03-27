from PySide6.QtQml import QmlElement
from PySide6.QtCore import (
    Slot,
    QObject,
    QUrl,
    Property,
    Signal,
    QAbstractListModel,
    QModelIndex,
    Qt,
)

from modules.ConstDefs import *
from modules.Utility import *
import os

QML_IMPORT_NAME = "ColorManager"
QML_IMPORT_MAJOR_VERSION = 1

CHANNELS = ["color", "shade", "border"]


@QmlElement
class ColorManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.customColors = 0
        self._model = colorSchemes.copy()
        self.loadCustomBricks()

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

    def newColor(self):
        return {
            "name": f"new_color_{self.customColors}",
            "color": blue,
            "shade": blue_shade,
            "border": default_border,
        }

    @Slot()
    def addCustomColor(self):
        self._model.append(self.newColor())
        self.customColors = self.customColors + 1
        self.customIndexChanged.emit()
        self.modelChanged.emit()

    @Slot()
    def loadCustomBrick(self, path):
        path = removeFileStub(path)
        # TODO

    def loadCustomBricks(self):
        for filename in os.listdir(DEF_BASE):
            file_path = os.path.join(DEF_BASE, filename)
            self.loadCustomBrick(file_path)

    @Slot(int, int, str)
    def setColor(self, index, channel, color):
        print(color)
        self._model[index][CHANNELS[channel]] = color
        self.modelChanged.emit()

    @Slot(int, str, result=bool)
    def setName(self, index, name):
        name = cleanFileName(name)
        if self._model[index]["name"] != name:
            self._model[index]["name"] = name
            self.modelChanged.emit()
            return true
        return false

    def getModel(self):
        return self._model

    modelChanged = Signal()
    model = Property(list, fget=getModel, notify=modelChanged)

    @staticmethod
    def getCustomIndex(self):
        return len(colorSchemes)

    customIndexChanged = Signal()
    customIndex = Property(int, fget=getCustomIndex, notify=customIndexChanged)
