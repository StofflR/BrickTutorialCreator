from PySide6.QtCore import Slot, QObject, QUrl
from PySide6.QtQml import QmlElement
from modules.backend.SVGBrick import SVGBrick
import json
from modules.Utility import *
from modules.ConstDefs import *
import modules.OSDefs as OSDefs
from math import isclose

QML_IMPORT_NAME = "Brick"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class Brick(SVGBrick, QObject):
    def __init__(self, parent=None):
        SVGBrick.__init__(self)
        QObject.__init__(self, parent)

    @Slot(None, result=str)
    def brickContent(self):
        """
        Returns
        -------
        The SVG Brick content to be displayed (contains modifier)
        """
        return self.content

    @Slot(None, result=int)
    def posX(self):
        """
        Returns
        -------
        The SVG Brick content x position
        """
        return self.x

    @Slot(None, result=int)
    def posY(self):
        """
        Returns
        -------
        The SVG Brick content y position
        """
        return self.y

    @Slot(None, result=str)
    def basePath(self):
        """
        Returns
        -------
        The SVG Brick base brick path
        """
        base_brick = self.base_type
        control = ""
        if "(control)" in base_brick:
            base_brick = base_brick.replace(" (control)", "")
            control = "_control"
        return "brick_" + base_brick + "_" + str(self.size) + control + SVG_EXT

    @Slot(None, result=str)
    def brickColor(self):
        """
        Returns
        -------
        The SVG Brick color scheme
        """
        return self.base_type

    @Slot(str, str, str, str, int, int, int)
    def updateBrick(
        self,
        base_type,
        content,
        size,
        path,
        scaling_factor=1.0,
        x=DEFAULT_X,
        y=DEFAULT_Y,
    ):
        """
        Update the SVG Brick and its contents
        Parameters
        ----------
        base_type: base color scheme
        content: content to be displayed (contains special characters)
        size: brick size e.g. 1h
        path: path of the base brick
        scaling_factor: the content scaling factor
        x: x position
        y: y position
        """
        modified = False

        modified |= self.base_type != base_type or self.content != content
        self.content = content
        self.base_type = base_type

        modified |= not isclose(self.scaling_factor, scaling_factor / 100)
        self.scaling_factor = scaling_factor / 100

        path = path if SVG_EXT in path else DEF_BASE_BRICK
        modified |= self.path != path
        self.path = path

        modified |= self.y != y or self.x != x or self.size != size
        self.size = size
        self.x = x
        self.y = y

        if modified:
            self.resetSVG()
            self.addContent()

    def updateFromJSON(self, json_text):
        """
        Updates the brick from a JSON text
        Parameters
        ----------
        json_text: the json text to update the brick with
        """
        self.updateBrick(
            getAttr(json_text, "base_type", ""),
            getAttr(json_text, "content", ""),
            getAttr(json_text, "size", "1h"),
            getAttr(json_text, "path", DEF_BASE_BRICK),
            float(getAttr(json_text, "scaling_factor", 1)),
            float(getAttr(json_text, "x", DEFAULT_X)),
            float(getAttr(json_text, "y", DEFAULT_Y)),
        )

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
        if content != self.content:
            self.content = content
            self.resetSVG()
            self.addContent()

    @Slot(None, result=str)
    def workingPath(self):
        """
        Returns the QML path to the working brick
        Returns
        -------

        """
        return QUrl.fromLocalFile(self.getWorkingBrick()).toString()

    @Slot(result=str)
    def fileName(self):
        """
        Returns the current filename of the SVG Brick
        Returns
        -------
        string of the current SVG Brick
        """
        # clean multi, leading/tailing whitespaces
        return " ".join(self.contentPlain().split()).strip().replace(" ", "_")

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
        self.save(target)
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
        self.toJSON(os.path.join(path, self._getFileName(filename, JSON_EXT)))

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
