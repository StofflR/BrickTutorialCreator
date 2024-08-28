from PySide6.QtCore import Slot, QObject, QUrl, Property, Signal
from PySide6.QtQml import QmlElement

from modules.backend.SVGBrick import SVGBrick
import json
from modules.Utility import *
from modules.ConstDefs import *

QML_IMPORT_NAME = "Brick"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class Brick(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self.brick = SVGBrick()

    @Signal
    def _updateBrick(self):
        return

    @Signal
    def _contentChanged(self):
        return

    def _getBaseType(self):
        return self.brick.base_type

    def _setBaseType(self, base_type):
        self.brick.base_type = base_type
        self.resetSVG()
        self._updateBrick.emit()

    def _getContent(self):
        return self.brick.content

    def _setContent(self, value):
        self.brick.content = value
        self.resetSVG()
        self._updateBrick.emit()

    def _getSize(self):
        return self.brick.size

    def _setSize(self, value):
        self.size = value
        self.resetSVG()
        self._updateBrick.emit()

    def _getPath(self):
        return self.brick.path

    def _setPath(self, value):
        self.brick.path = value
        self.resetSVG()
        self._updateBrick.emit()

    def _getScalingFactor(self):
        return self.brick.scaling_factor

    def _setScalingFactor(self, value):
        self.brick.scaling_factor = value
        self.resetSVG()
        self._updateBrick.emit()

    def _getXPos(self):
        return self.brick.x

    def _setXPos(self, value):
        self.brick.x = value
        self.resetSVG()
        self._updateBrick.emit()

    def _getYPos(self):
        return self.brick.y

    def _setYPos(self, value):
        self.brick.y = value
        self.resetSVG()
        self._updateBrick.emit()

    baseType = Property(str, fget=_getBaseType, fset=_setBaseType, notify=_updateBrick)
    brickContent = Property(
        str, fget=_getContent, fset=_setContent, notify=_contentChanged
    )
    brickSize = Property(str, fget=_getSize, fset=_setSize, notify=_updateBrick)
    brickPath = Property(str, fget=_getPath, fset=_setPath, notify=_updateBrick)
    scalingFactor = Property(
        float, fget=_getScalingFactor, fset=_setScalingFactor, notify=_updateBrick
    )
    xPos = Property(float, fget=_getXPos, fset=_setXPos, notify=_updateBrick)
    yPos = Property(float, fget=_getYPos, fset=_setYPos, notify=_updateBrick)

    contentChanged = Signal()

    @Slot(None, result=str)
    def basePath(self):
        """
        Returns
        -------
        The SVG Brick base brick path
        """
        base_brick = self.brick.base_type
        control = ""
        if "(control)" in base_brick:
            base_brick = base_brick.replace(" (control)", "")
            control = "_control"
        return "brick_" + base_brick + "_" + str(self.brick.size) + control + SVG_EXT

    def _getFullBasePath(self) -> str:
        return addFileStub(os.path.join(DEF_BASE, self.basePath()))

    fullBasePath = Property(str, fget=_getFullBasePath, notify=_updateBrick)

    def resetSVG(self) -> None:
        self.brick.reset()
        self.brick.addContent()

    def updateFromJSON(self, json_text):
        """
        Updates the brick from a JSON text
        Parameters
        ----------
        json_text: the json text to update the brick with
        """
        self.brick.base_type = getAttr(json_text, "base_type", "")
        self.brick.content = getAttr(json_text, "content", "")
        self.brick.size = getAttr(json_text, "size", "1h")
        self.brick.path = getAttr(json_text, "path", DEF_BASE_BRICK)
        self.brick.scaling_factor = float(getAttr(json_text, "scaling_factor", 1))
        self.brick.x = float(getAttr(json_text, "x", DEFAULT_X))
        self.brick.y = float(getAttr(json_text, "y", DEFAULT_Y))

    @Slot(str)
    def fromJSON(self, path):
        """
        Load an SVG Brick from json
        Parameters
        ----------
        path: to the json file
        """
        path = removeFileStub(path)
        self.updateFromJSON(SVGBrick.fromJSON(json.load(open(path))))
        self.resetSVG()
        self.contentChanged.emit()
        self._updateBrick.emit()

    @Slot(str)
    def fromSVG(self, path):
        """
        Load an SVG Brick from an SVG
        Parameters
        ----------
        path: to the svg file
        """
        path = removeFileStub(path)
        self.updateFromJSON(SVGBrick.getJSONFromSVG(path))
        self.resetSVG()
        self.contentChanged.emit()
        self._updateBrick.emit()


    @Slot(SVGBrick)
    def fromSVGBrick(self, brick):
        """
        Load an SVG Brick from an SVG
        Parameters
        ----------
        path: to the svg file
        """
        self.brick = brick
        self.resetSVG()
        self.contentChanged.emit()
        self._updateBrick.emit()

    @Slot(str)
    def fromFile(self, path):
        """
        Load the brick from an SVG or JSON file
        Parameters
        ----------
        path: to the file to load
        """
        if JSON_EXT in path:
            self.fromJSON(path)
        elif SVG_EXT in path:
            self.fromSVG(path)

    @Slot(str)
    def updateBrickContent(self, content):
        """
        Update the SVG brick content
        Parameters
        ----------
        content: the content for the SVG brick
        """
        if content != self.brick.content:
            self.brick.content = content
            self.resetSVG()

    def _workingPath(self):
        """
        Returns the QML path to the working brick
        Returns
        -------
        string of path to the current working brick
        """
        return QUrl.fromLocalFile(self.brick.getWorkingBrick()).toString()

    workingPath = Property(str, fget=_workingPath, notify=_updateBrick)

    @Slot(result=str)
    def fileName(self):
        """
        Returns the current filename of the SVG Brick
        Returns
        -------
        string of the current SVG Brick
        """
        # clean multi, leading/tailing whitespaces
        return " ".join(self.brick.contentPlain().split()).strip().replace(" ", "_")

    @Slot(str, result=str)
    @Slot(str, str, result=str)
    def saveSVG(self, path, filename=None) -> str:
        """
        Saves the current SVG Brick to the provided path and filename as SVG
        Parameters
        ----------
        path: the path to store the SVG
        filename: the filename to use (if none is provided it is generated from the content)
        Returns
        -------
        string of the target path and filename
        """
        path = removeFileStub(path)
        os.makedirs(path, exist_ok=True)
        target = os.path.join(path, self._getFileName(filename, SVG_EXT))
        self.brick.save(target)
        return target

    @Slot(str)
    @Slot(str, str)
    def savePNG(self, path, filename=None):
        """
        Saves the current SVG Brick to the provided path and filename as PNG
        Parameters
        ----------
        path: the path to store the SVG
        filename: the filename to use (if none is provided it is generated from the content)
        """
        path = removeFileStub(path)
        os.makedirs(path, exist_ok=True)
        SVGBrick.savePNG(self, os.path.join(path, self._getFileName(filename, PNG_EXT)))

    @Slot(str, result=bool)
    def exists(self, path):
        """
        Check if a given path exists
        Parameters
        ----------
        path: path to check
        Returns
        -------
        boolean if path exists
        """
        path = removeFileStub(path)
        return os.path.exists(path)

    @Slot(str)
    @Slot(str, str)
    def saveJSON(self, path, filename=None):
        """
        Saves the current SVG Brick to the provided path and filename as JSON
        Parameters
        ----------
        path: the path to store the SVG
        filename: the filename to use (if none is provided it is generated from the content)
        Returns
        -------
        string of the target path and filename
        """
        path = removeFileStub(path)
        os.makedirs(path, exist_ok=True)
        self.brick.toJSON(os.path.join(path, self._getFileName(filename, JSON_EXT)))

    @Slot(str, result=str)
    def cleanFileName(self, filename):
        """
        Get a clean filename which is allowed to be used in OS
        Parameters
        ----------
        filename: filename containing special characters
        Returns
        -------
        string of the filename without special characters
        """
        return cleanFileName(filename)

    def _getFileName(self, filename, extension):
        """
        Retrieve the filename with a given file extension
        Parameters
        ----------
        filename: the filename to be cleaned
        extension: the extension to be added if not present
        Returns
        -------
        string of the filename without special characters and with the file extension
        """
        if not filename:
            filename = self.fileName()
        filename = cleanFileName(filename)
        filename = filename if PNG_EXT in filename else filename + extension
        return filename
