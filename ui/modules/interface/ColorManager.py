import logging

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
import re

QML_IMPORT_NAME = "ColorManager"
QML_IMPORT_MAJOR_VERSION = 1

CHANNELS = ["color", "shade", "border"]


@QmlElement
class ColorManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.customColors = 0
        self._model = colorSchemes.copy()
        self.customColorList = []
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
        """
        Create a default custom color based on blue brick.
        Returns
        -------
        a dict containing the color name, background color, shade color and border color
        """
        return {
            "name": f"new_color_{self.customColors}",
            "color": blue,
            "shade": blue_shade,
            "border": default_border,
        }

    @Slot()
    def addCustomColor(self):
        """
        Interface function for adding a default custom color to the base bricks.
        Returns
        -------
        None
        """
        self._model.append(self.newColor())
        self.customColors = self.customColors + 1
        self.customIndexChanged.emit()
        self.modelChanged.emit()

    def addCustomColor_(self, color):
        """
        Intern function for adding a custom color defined in a color dict.
        Parameters
        ----------
        color : color dict containing name, color, border and shade information

        Returns
        -------
        None
        """
        self._model.append(color)
        self.customColors = self.customColors + 1
        self.customIndexChanged.emit()
        self.modelChanged.emit()

    @Slot()
    def loadCustomBrick(self, path):
        """
        Function for loading custom colors from the specified folder.
        Parameters
        ----------
        path : path containing the custom colors

        Returns
        -------
        None
        """
        path = removeFileStub(path)
        for file in os.listdir(path):
            brick_name = (
                file.replace("_0h", "")
                .replace("_1h", "")
                .replace("_2h", "")
                .replace("_3h", "")
                .replace(".svg", "")
                .replace("_control", "")
                .replace("_collapsed", "")
                .replace("brick_", "")
            )
            colors = []
            for color in colorSchemes:
                colors.append(color["name"])
            if brick_name not in colors and brick_name not in self.customColorList:
                self.loadColor(os.path.join(path, file), brick_name)
                self.customColorList.append(brick_name)

    def loadColor(self, path, name):
        """
        Function for getting the color information of an svg and loading it into the custom color model.
        Parameters
        ----------
        path : path to the custom color fole
        name : name of the custom color

        Returns
        -------
        None
        """
        color = self.newColor()
        color["name"] = name
        content = open(path, "r").read()
        regex = re.compile(r"border(\W|\D|)*fill: #\w+;")
        border = regex.search(content).group(0).split("#")[1].replace(";", "")
        regex = re.compile(r"shade(\W|\D|)*stop-color: #\w+;")
        shade = regex.search(content).group(0).split("#")[1].replace(";", "")
        regex = re.compile(r"background(\W|\D|)*fill: #\w+;")
        background = regex.search(content).group(0).split("#")[1].replace(";", "")
        color[CHANNELS[0]] = background
        color[CHANNELS[1]] = shade
        color[CHANNELS[2]] = border
        self.addCustomColor_(color)
        logging.debug(f"Loaded custom color {name} from: {path}")

    def loadCustomBricks(self):
        """
        Load custom bricks from the base brick folder.
        Returns
        -------
        None
        """
        self.loadCustomBrick(DEF_BASE)

    @Slot(int, int, str)
    def setColor(self, index, channel, color):
        """
        Function for setting the color in the specified channel of a custom brick.
        Parameters
        ----------
        index : index of the custom color in the model
        channel : channel to apply the color to
        color : color to be set

        Returns
        -------
        None
        """
        self._model[index][CHANNELS[channel]] = color
        self.modelChanged.emit()

    @Slot(int, str, result=bool)
    def setName(self, index, name):
        """
        Setting the name of a custom color at the specified index.
        Parameters
        ----------
        index : index of the color name to be set in the model
        name : name to be set for te custom color

        Returns
        -------
        None
        """
        name = cleanFileName(name)
        if self._model[index]["name"] != name:
            self._model[index]["name"] = name
            self.modelChanged.emit()
            return True
        return False

    def getModel(self):
        return self._model

    modelChanged = Signal()
    model = Property(list, fget=getModel, notify=modelChanged)

    def getCustomIndex(self):
        return len(colorSchemes)

    customIndexChanged = Signal()
    customIndex = Property(int, fget=getCustomIndex, notify=customIndexChanged)
