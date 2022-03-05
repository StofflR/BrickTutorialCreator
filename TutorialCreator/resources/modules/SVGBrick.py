import json
import logging
import os
import random
import string
import sys
import xml.etree.ElementTree as Tree
from typing import Dict

from PIL import ImageFont
from cairosvg import svg2png

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

DEF_RESOURCE = "resources/"
DEF_TMP = DEF_RESOURCE + "tmp/"
VARIABLE = "var"
DROPDOWN = "drop"
TEXT = "text"
BOLD = "bold"
NORMAL = "normal"

FONT_SIZE = 12
LINE_OFF = 3
LINE_HEIGHT = 7

DEFAULT_WIDTH = 350
DEFAULT_X = 43
DEFAULT_Y = 33

DROPDOWN_SIZE = 10
DROPDOWN_OFFSET = 10

RES_PATH = {
    BOLD: "font/Roboto-Bold.ttf",
    NORMAL: "font/Roboto-Light.ttf"
}
LEN_SCALAR = {
    BOLD: 1.1,
    NORMAL: 1.1
}


def randomString(digits):
    return ''.join(random.SystemRandom().choice(string.ascii_letters + string.digits) for _ in range(digits))


class SVGBrick:
    def __init__(self, base_type: str, content: str, size: int, path: str, scaling_factor=1):
        self.base_type = base_type
        self.working_brick_ = ""
        self.scaling_factor = scaling_factor
        self.content = content.replace("\t", "")
        self.path = path
        self.size = size
        self.tree_ = Tree.parse(open(self.path, 'r'))
        self.operations = {
            "\\": self.addLineBreak,
            '\n': self.addLineBreakNewLine,
            "\0": self.addString,
            "*": self.addDropdown,
            "$": self.addVariable
        }
        self.addContent()
        pass

    def getWorkingBrick(self):
        return self.working_brick_

    def __del__(self):
        logging.debug("Deleting: " + self.working_brick_)
        if os.path.exists(self.working_brick_):
            os.remove(self.working_brick_)
            logging.debug("Working brick: " + self.contentPlain() + " deleted")

    @staticmethod
    def getJSONFromSVG(path):
        svg = Tree.parse(open(path, 'r'))
        json_text = ""
        for element in svg.getroot():
            if hasattr(element, "attrib") and "id" in element.attrib.keys() and element.attrib["id"] == "json":
                json_text = element.text
        if json_text == "":
            return json_text
        return json.loads(json_text)

    @classmethod
    def fromJSON(cls, json_text: Dict):
        try:
            return cls(json_text["base_type"], json_text["content"], json_text["size"], json_text["path"],
                       json_text["scaling_factor"])
        except Exception as e:
            logging.warning(e)
            logging.info("created empty brick")
            return cls("", "", 1, "", 1)

    @classmethod
    def convertSVG(cls, path: str, width: int = DEFAULT_WIDTH):
        logging.info("converting: " + path)
        if ".svg" in path:
            svg2png(url=path, write_to=path.replace(".svg", ".png"), output_width=width)
        else:
            logging.warning("Path: " + path + " is no svg!")

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


    def addLineBreakNewLine(self, line: str, x: int, y: int):
        return self.addLineBreak(line,x,y,"\n")

    def addLineBreak(self, line: str, x: int, y: int, delim="\\"):
        segments = line.split(delim, 1)
        self.addString(segments[0], x, y)
        return segments[1], DEFAULT_X, y + (LINE_HEIGHT + LINE_OFF) * self.scaling_factor

    def addContent(self):
        if not os.path.isdir(DEF_TMP):
            os.mkdir(DEF_TMP)
        self.working_brick_ = DEF_TMP + randomString(10) + ".svg"

        self.parse(self.content)
        self.save()

    def contentPlain(self):
        content = self.content
        for key in self.operations.keys():
            content = content.replace(key, "")
        return content

    def save(self, path=""):
        if path == "":
            path = self.working_brick_
        if ".svg" not in path:
            path += ".svg"

        logging.debug("Brick saved to: " + path)
        self.tree_.write(path)

    def savePNG(self, path="", width=DEFAULT_WIDTH):
        logging.debug("Saving PNG to: " + path)
        if path == "":
            path = self.working_brick_
        path = path.replace(".svg", ".png")
        if ".png" not in path:
            path += ".png"
        logging.debug("Saving PNG to: " + path)
        svg2png(url=self.working_brick_, write_to=path, output_width=width)

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

    def addString(self, line: str, x: int, y: int, svg_id=TEXT, font_weight=BOLD, size=FONT_SIZE):
        size = size * self.scaling_factor
        font_type = "font-family: 'Roboto Light', sans-serif;font-size:" + \
                    str(size) + "pt;"

        sub_element = Tree.SubElement(self.tree_.getroot(), 'ns0:text', {'id': svg_id,
                                                                         'x': str(x) + "px",
                                                                         'y': str(y) + "px",
                                                                         'fill': '#ffffff',
                                                                         'fill-opacity': "1",
                                                                         "font-weight": font_weight,
                                                                         'xml:space': 'preserve',
                                                                         'style': font_type})
        sub_element.text = line
        return self.stringLength(line, size=FONT_SIZE * self.scaling_factor)

    def addLine(self, line, x, y):
        length = self.stringLength(
            line, size=FONT_SIZE * self.scaling_factor, font=NORMAL)
        Tree.SubElement(self.tree_.getroot(), 'ns0:line', {"id": "var_line",
                                                           "x1": str(x),
                                                           "y1": str(y),
                                                           "x2": str(x + length),
                                                           "y2": str(y),
                                                           "stroke": "#ffffff",
                                                           "fill": "#ffffff",
                                                           "stroke-width": "1"})

        return x + length

    # TODO: might need some more love :/
    @staticmethod
    def stringLength(line: str, size=12, font=BOLD):
        # logging.debug(os.getcwd() + DEF_RESOURCE + RES_PATH[font])
        font_type = ImageFont.truetype(
            DEF_RESOURCE + RES_PATH[font], int(size))
        return font_type.getsize(line)[0] * LEN_SCALAR[font]  # 1.344
        # draw_text = ImageDraw.Draw(Image.new("RGB",(100,100)))
        # widht, height = draw_text.textsize(line, font_type)
        # return widht

    def addVariable(self, line: str, x: int, y: int):
        segments = line.split("$", 2)

        x += self.addString(segments[0], x, y)

        segments[1] = " " + segments[1] + " "
        _ = self.addString(segments[1], x, y, font_weight=NORMAL)
        x = self.addLine(segments[1], x, y + LINE_OFF)

        if len(segments) > 2:
            return segments[2], x, y
        return None, x, y

    def addDropdown(self, line: str, x: int, y: int):
        segments = line.split("*", 2)
        _ = self.addString(segments[0], x, y)
        self.addTriangle(DEFAULT_WIDTH, y)
        x = DEFAULT_X
        y += (LINE_HEIGHT + LINE_OFF) * self.scaling_factor
        self.addString(segments[1], x + DROPDOWN_OFFSET,
                       y, DROPDOWN, NORMAL, DROPDOWN_SIZE)
        if len(segments) > 2:
            return segments[2], x, y
        return None, x, y

    def addTriangle(self, x0: int, y0: int):
        x = x0 - 2 * FONT_SIZE
        y = y0 - FONT_SIZE
        Tree.SubElement(self.tree_.getroot(), 'ns0:polygon',
                        {"points": str(x) + "," + str(y) + " " + str(x + FONT_SIZE) + "," + str(y) + " " + str(
                            x + (FONT_SIZE / 2)) + "," + str(y + FONT_SIZE),
                         "id": "triangle",
                         "stroke": "white",
                         "fill": "white",
                         "stroke-width": "1"})

    def addDescription(self):
        sub_element= Tree.SubElement(self.tree_.getroot(), 'ns0:desc', {'id': "json"})
        sub_element.text = self.JSON()

    def JSON(self):
        return json.dumps({"base_type": self.base_type,
                                "content": self.content,
                                "size": self.size,
                                "path": self.path,
                                "scaling_factor": self.scaling_factor})

if __name__ == "__main__":
    brick = SVGBrick("blue", "Hellllllllllllo $Hellllllllllllo$ does it work?!*DROP",
                     "/mnt/c/Users/Stoffl/Documents/GIT/BrickTutorialCreator/BrickCreator/base/brick_blue_1h.svg")
    brick.addContent()
