import json
from typing import Dict
from modules.backend.SVGBrickModifier import *
from PySide6.QtGui import QImage, QPainter
from PySide6.QtSvg import QSvgRenderer
from PySide6.QtCore import Qt


class SVGBrick(SVGBrickModifier):
    def __init__(
        self,
        base_type: str,
        content: str,
        size: int,
        path: str,
        scaling_factor=1,
        x=DEFAULT_X,
        y=DEFAULT_Y,
    ):
        SVGBrickModifier.__init__(
            self, base_type, content, size, path, scaling_factor, x, y
        )
        self.addContent()

    def getWorkingBrick(self):
        return self.working_brick_

    @staticmethod
    def getJSONFromSVG(path):
        svg = Tree.parse(open(path, "r"))
        json_text = ""
        for element in svg.getroot():
            if (
                hasattr(element, "attrib")
                and "id" in element.attrib.keys()
                and element.attrib["id"] == "json"
            ):
                json_text = element.text
        if json_text == "":
            return json_text
        return json.loads(json_text)

    @classmethod
    def fromJSON(cls, json_text: Dict):
        try:
            x = DEFAULT_X if "x" not in json_text.keys() else json_text["x"]
            y = DEFAULT_Y if "y" not in json_text.keys() else json_text["y"]
            return cls(
                json_text["base_type"],
                json_text["content"],
                json_text["size"],
                json_text["path"],
                json_text["scaling_factor"],
                x,
                y,
            )
        except Exception as e:
            logging.warning(e)
            logging.info("created empty brick")
            return cls("", "", 1, "", 1)

    def toJSON(self, path=""):
        json_text = self.JSON()
        if path != "":
            if ".json" not in path:
                path += ".json"
            logging.debug("Dumping JSON to: " + path)
            file = open(path, "w")
            file.write(json_text)
            file.close()
        return json_text

    def addContent(self):
        if not os.path.isdir(DEF_TMP):
            os.makedirs(DEF_TMP)
        self.working_brick_ = DEF_TMP + randomString(10) + ".svg"

        self.parse(self.content, self.x, self.y)
        self.save()

    def contentPlain(self, for_system=False):
        content = self.content
        if "collapsed" in self.base_type:
            content += self.base_type
        for key in self.operations.keys():
            content = content.replace(key, "")
        if for_system:
            for key, value in FORBIDDEN_FILE_NAME_CHARS.items():
                content = content.replace(key, value)
        return content

    def save(self, path=""):
        if path == "":
            path = self.working_brick_
        if ".svg" not in path:
            path += ".svg"

        logging.debug("Brick saved to: " + path)
        self.tree_.write(path)

        # TODO find better solution
        with open(path, "r") as file:
            filedata = file.read()
            filedata = filedata.replace("ns0:", "").replace(":ns0", "")
        with open(path, "w") as file:
            file.write(filedata)

    def savePNG(self, path="", width=1920, height=None):
        renderer = QSvgRenderer(path.replace(".png", ".svg"))
        image = None
        if height == None:
            image = QImage(path.replace(".png", ".svg")).scaledToWidth(
                width, Qt.SmoothTransformation
            )
        else:
            image = QImage(path.replace(".png", ".svg")).scaled(
                width, height, mode=Qt.SmoothTransformation
            )
        painter = QPainter(image)
        renderer.render(painter)
        del painter  # painter doesn't get deleted properly
        image.save(path, quality=100)
        logging.debug("Brick saved to: " + path)

    def parse(self, content: str, x=DEFAULT_X, y=DEFAULT_Y):
        if content is None:
            return

        for index, _ in enumerate(content):
            if content[index] in self.operations.keys():
                line, x, y = self.operations[content[index]](content, x, y)
                return self.parse(line, x, y)

        if content is not None:
            self.addString(content, x, y)
        self.addDescription()

    def JSON(self):
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
