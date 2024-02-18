import logging
import os
import sys
import xml.etree.ElementTree as Tree

Tree.register_namespace("", "http://www.w3.org/2000/svg")
from PySide6.QtGui import QFontMetrics, QFont, QFontDatabase
import math

from modules.Utility import *

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)


class SVGBrickModifier:
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
        self.base_type = base_type
        self.working_brick_ = DEF_TMP + randomString(10) + ".svg"
        self.scaling_factor = scaling_factor
        self.content = content.replace("\t", "")
        self.path = path
        self.size = size
        self.x = x
        self.y = y
        self.tree_ = Tree.parse(open(os.getcwd() + "/base/" + self.path, "r"))
        self.operations = {
            "\n": self.addLineBreak,
            "\0": self.addString,
            "*": self.addDropdown,
            "$": self.addVariable,
        }

    def textColor(self):
        if "transparent" in self.base_type:
            if "white" in self.base_type:
                return "#FFFFFF"
            return "#000000"

        if "white" in self.base_type:
            return "#274383"
        return "#FFFFFF"

    def __del__(self):
        logging.debug("Deleting: " + self.working_brick_)
        if os.path.exists(self.working_brick_):
            os.remove(self.working_brick_)
            logging.debug("Working brick: " + self.contentPlain() + " deleted")

    def addLineBreakNewLine(self, line: str, x: int, y: int):
        return self.addLineBreak(line, x, y, "\n")

    def addLineBreak(self, line: str, x: int, y: int, delim="\n"):
        segments = line.split(delim, 1)
        self.addString(segments[0], x, y)
        return (
            segments[1],
            self.x,
            y + (LINE_HEIGHT + 2 * LINE_OFF) * self.scaling_factor,
        )

    def addString(
        self, line: str, x: int, y: int, svg_id=TEXT, font_weight=BOLD, size=FONT_SIZE
    ):
        size = size * self.scaling_factor
        font_type = "font-family: Roboto;font-size:" + str(size) + "pt;"

        sub_element = Tree.SubElement(
            self.tree_.getroot(),
            "text",
            {
                "id": svg_id,
                "x": str(x) + "px",
                "y": str(y) + "px",
                "fill": self.textColor(),
                "fill-opacity": "1",
                "font-weight": font_weight,
                "xml:space": "preserve",
                "style": font_type,
            },
        )
        sub_element.text = line
        return self.stringLength(line, size=FONT_SIZE * self.scaling_factor)

    def addLine(self, line, x, y):
        length = self.stringLength(
            line, size=FONT_SIZE * self.scaling_factor, font=NORMAL
        )
        Tree.SubElement(
            self.tree_.getroot(),
            "line",
            {
                "id": "var_line",
                "x1": str(x),
                "y1": str(y),
                "x2": str(x + length),
                "y2": str(y),
                "stroke": "#ffffff",
                "fill": "#ffffff",
                "stroke-width": "1",
            },
        )

        return x + length

    @staticmethod
    def stringLength(line: str, size=12, font=BOLD):
        if font == NORMAL:
            weight = QFont.Thin
            style = "Light"
        else:
            weight = QFont.DemiBold + 20
            style = "Bold"
        size = size - 1
        metric = QFontMetrics(
            QFontDatabase.font("Roboto", style, math.ceil(size)),
            pointSize=math.ceil(size),
            weight=weight,
        )
        return (
            metric.horizontalAdvance(line) / metric.fontDpi() * 96
        )  # mhh small mac dpi

    def addVariable(self, line: str, x: int, y: int):
        segments = line.split("$", 2)

        x += self.addString(segments[0], x, y)

        segments[1] = " " + segments[1] + " "
        _ = self.addString(segments[1], x, y, font_weight=NORMAL)
        x = self.addLine(segments[1], math.ceil(x), y + LINE_OFF)

        if len(segments) > 2:
            return segments[2], x, y
        return None, x, y

    def addDropdown(self, line: str, x: int, y: int):
        segments = line.split("*", 2)
        x += self.addString(segments[0], x, y)
        self.addTriangle(DEFAULT_WIDTH, y)
        x += (
            self.addString(
                segments[1], x + DROPDOWN_OFFSET, y, DROPDOWN, NORMAL, DROPDOWN_SIZE
            )
            + DROPDOWN_OFFSET
        )

        y += LINE_OFF * self.scaling_factor
        if len(segments) > 2:
            return segments[2], x, y
        return None, x, y

    def addTriangle(self, x0: int, y0: int):
        x = x0 - 2 * FONT_SIZE
        y = y0 - FONT_SIZE
        Tree.SubElement(
            self.tree_.getroot(),
            "polygon",
            {
                "points": str(x)
                + ","
                + str(y)
                + " "
                + str(x + FONT_SIZE / 4)
                + ","
                + str(y)
                + " "
                + str(x + (FONT_SIZE / 8))
                + ","
                + str(y + FONT_SIZE / 4),
                "id": "triangle",
                "stroke": "white",
                "fill": "white",
                "stroke-width": "0.5",
            },
        )

    def addDescription(self):
        sub_element = Tree.SubElement(
            self.tree_.getroot(), "desc", {"id": "json", "tag": "brick"}
        )
        sub_element.text = self.JSON()


def randomString(digits):
    return "".join(
        random.SystemRandom().choice(string.ascii_letters + string.digits)
        for _ in range(digits)
    )
