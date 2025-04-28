import json
from typing import Dict

from modules import ConstDefs
from modules.backend.SVGBrickModifier import *
from PySide6.QtGui import QImage, QPainter, QColor
from PySide6.QtSvg import QSvgRenderer
from PySide6.QtCore import Qt
from modules.Utility import *
from modules.ConstDefs import *


class SVGBrick(SVGBrickModifier):
    def __init__(
        self,
        base_type="",
        content="",
        size="1h",
        path=DEF_BASE_BRICK,
        scaling_factor=1,
        x=DEFAULT_X,
        y=DEFAULT_Y,
    ):
        SVGBrickModifier.__init__(
            self, base_type, content, size, path, scaling_factor, x, y
        )
        self.addContent()

    def __del__(self):
        """
        Delete the temporary file created on object destruction!
        """
        logging.debug("Deleting: " + self.working_brick_)
        self.cleanup()
        if os.path.exists(self.working_brick_):
            os.remove(self.working_brick_)
            logging.debug("Working brick: " + self.contentPlain() + " deleted")

    def getWorkingBrick(self) -> str:
        """
        The current temp working directory of the brick
        Returns
        -------
        the current working directory string
        """
        return self.working_brick_

    @staticmethod
    def getJSONFromSVG(path: str) -> dict:
        """
        Get the JSON representation of a SVGBrick svg
        Parameters
        ----------
        path: the path containing the svg file
        Returns
        -------
        the json representation of the brick
        """

        svg = Tree.parse(open(path, "r"))
        json_text = ""
        for element in svg.getroot():
            if (
                hasattr(element, "attrib")
                and "id" in element.attrib.keys()
                and element.attrib["id"] == "json"
            ):
                json_text = element.text

        return json_text if json_text == "" else json.loads(json_text)

    @classmethod
    def fromJSON(cls, json_text: Dict):
        """
        Create a SVGBrick from a given json
        Parameters
        ----------
        json_text: the json representation of the SVG Brick to be created
        Returns
        -------
        An SVG Brick from the given json representation
        """
        return cls(
            getAttr(json_text, "base_type", ""),
            getAttr(json_text, "content", ""),
            getAttr(json_text, "size", "1h"),
            getAttr(json_text, "path", DEF_BASE_BRICK),
            getAttr(json_text, "scaling_factor", 1),
            getAttr(json_text, "x", DEFAULT_X),
            getAttr(json_text, "y", DEFAULT_Y),
        )

    def toJSON(self, path="") -> str:
        """
        Create a json string from the current brick settings
        Parameters
        ----------
        path: if a path is provided, the JSON is stored in the given file
        Returns
        -------
        the JSON representation of the SVG Brick
        """
        if path != "":
            path = extendFileExtension(path, JSON_EXT)
            logging.debug("Dumping JSON to: " + path)
            file = open(path, "w")
            file.write(self.JSON())
            file.close()
        return self.JSON()

    def addContent(self, save=True) -> None:
        """
        Adds the given content to the svg file and saves it
        """
        self.parse(self.content, self.x, self.y)
        if save:
            self.save()

    def contentPlain(self, for_system=False) -> str:
        """
        Get a plain text representation of the current SVG Brick
        Parameters
        ----------
        for_system: boolean toggle, if true removes forbidden characters of the operating file system
        Returns
        -------
        the plain text representation of the content with special characters removed
        """
        content = self.content
        if "collapsed" in self.base_type:
            content += self.base_type
        for key in self.operations.keys():
            content = content.replace(key, "")
        if for_system:
            for key, value in FORBIDDEN_FILE_NAME_CHARS.items():
                content = content.replace(key, value)
        return content

    def save(self, path="") -> None:
        """
        Store the current brick ath the given path. If no path is specified, the working_brick_ path is used.
        Parameters
        ----------
        path: The path where the file should be saved to
        """
        self.cleanup()
        if path == "":
            path = self.working_brick_
            self.toBeRemoved_.append(path)
        path = extendFileExtension(path, SVG_EXT)
        logging.debug("Brick saved to: " + path)
        self.tree_.write(path)

    def cleanup(self):
        failed = []
        for path in self.toBeRemoved_:
            if os.path.exists(path):
                try:
                    os.remove(path)
                except Exception as e:
                    failed.append(path)
        self.toBeRemoved_.clear()
        self.toBeRemoved_.extend(failed)

    def savePNG(self, path, width=ConstDefs.PNG_WIDTH, height=None) -> None:
        """
        Create a PNG of the current brick
        Parameters
        ----------
        path : str target where the brick should be stored
        width : width of the image (default=1920)
        height : height of the image (default=None) image is scaled according to default brick height
        """
        assert path != ""
        path = extendFileExtension(path, PNG_EXT)
        renderer = QSvgRenderer(self.working_brick_)
        if height is None:
            scale = width / PNG_WIDTH
            height = getHeight(self.size, self.base_type) * scale
        image = QImage(width, height, QImage.Format_ARGB32)
        image.fill(QColor(0, 0, 0, 0))
        painter = QPainter(image)
        renderer.render(painter)
        image.save(path, quality=100)
        del renderer
        del painter  # painter doesn't get deleted properly
        del image
        logging.debug("Brick saved to: " + path)

    def parse(self, content: str, x=DEFAULT_X, y=DEFAULT_Y) -> None:
        """
        Parses the content of the brick to format the svg
        Parameters
        ----------
        content : content to be parsed
        x : starting x coordinate
        y : starting y coordinate
        """
        if content is None or content == "":
            return self.addDescription()

        for index, letter in enumerate(content):
            if letter in self.operations.keys():
                line, x, y = self.operations[letter](content, x, y)
                return self.parse(line, x, y)

        if content is not None:
            self.addString(content, x, y)
        self.addDescription()

    def addDescription(self) -> None:
        """
        Add JSON representation of the current brick to the svg
        """
        sub_element = Tree.SubElement(
            self.tree_.getroot(), "desc", {"id": JSON_ID, "tag": BRICK_TAG}
        )
        sub_element.text = self.JSON()

    def JSON(self) -> str:
        """
        Create a json representation of the curren brick
        Returns
        -------
        string of JSON representation
        """
        return json.dumps(
            {
                "base_type": self.base_type,
                "content": self.content,
                "size": self.size,
                "path": self.path,
                "scaling_factor": self.scaling_factor,
                "x": self.x,
                "y": self.y,
            }
        )
