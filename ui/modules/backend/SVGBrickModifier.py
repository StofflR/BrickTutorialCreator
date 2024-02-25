import logging
import os
import sys
import xml.etree.ElementTree as Tree
from PySide6.QtGui import QFontMetrics, QFont, QFontDatabase
import math
from modules.Utility import *
from modules.ConstDefs import *

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
Tree.register_namespace(
    "", "http://www.w3.org/2000/svg"
)  # removes default ns0 namespace

DEFAULT = "default"
TRANSPARENT = "transparent"
WHITE = "white"

TEXT_COLOR = {
    TRANSPARENT: {DEFAULT: HEX_BLACK, WHITE: HEX_WHITE},
    WHITE: HEX_DARK_BLUE,
    DEFAULT: HEX_WHITE,
}

TEXT_STYLE = {
    NORMAL: {"weight": QFont.Thin, "style": STYLE_LIGHT},
    BOLD: {"weight": QFont.DemiBold + 20, "style": STYLE_BOLD},
}


class SVGBrickModifier:
    def __init__(
        self,
        base_type: str,
        content: str,
        size: str,
        path: str,
        scaling_factor=1.0,
        x=DEFAULT_X,
        y=DEFAULT_Y,
    ):
        self.base_type = base_type
        self.scaling_factor = scaling_factor
        self.content = content
        self.path = path if SVG_EXT in path else DEF_BASE_BRICK
        self.size = size
        self.x = x
        self.y = y

        self.working_brick_ = os.path.join(DEF_TMP, randomString(10) + SVG_EXT)
        self.tree_: Tree
        self.tree_ = None
        self.toBeRemoved_ = []
        self.reset()
        self.operations = {
            OP_KEY_NEWLINE: self.addLineBreak,
            OP_KEY_END: self.addString,
            OP_KEY_DROPDOWN: self.addDropdown,
            OP_KEY_VARIABLE: self.addVariable,
        }

    def reset(self) -> None:
        """
        Reset the current SVG Brick and change the working brick path
        Note: QMLImage buffers images, therefore a different path is needed!
        """
        if self.working_brick_ and os.path.exists(self.working_brick_):
            self.toBeRemoved_.append(self.working_brick_)
            logging.debug("To be removed working brick: " + self.working_brick_)
        self.working_brick_ = os.path.join(DEF_TMP, randomString(10) + SVG_EXT)
        logging.debug("New working brick: " + self.working_brick_)
        self.tree_ = Tree.parse(open(os.path.join(DEF_BASE, self.path), "r"))

    def textColor(self) -> str:
        """
        The text color of the SVG Brick
        Returns
        -------
        The HEX color to be displayed on the SVG Brick
        """
        modifier = WHITE if WHITE in self.base_type else DEFAULT
        return (
            TEXT_COLOR[TRANSPARENT][modifier]
            if TRANSPARENT in self.base_type
            else TEXT_COLOR[modifier]
        )

    def addLineBreak(
        self, line: str, x: int, y: int, delim="\n"
    ) -> (str, float, float):
        """
        Add a line break to the SVG.
        Parameters
        ----------
        line: content to be parsed
        x: current x position of the parsing
        y: current y position of the parsing
        delim: line break delimiter to split the line
        Returns
        -------
        line, x, y: remaining content to be parsed, advanced x, advanced y
        """
        segments = line.split(delim, 1)
        self.addString(segments[0], x, y)
        return (
            segments[1],
            self.x,
            y + (LINE_HEIGHT + 2 * LINE_OFF) * self.scaling_factor,
        )

    def addString(
        self, line: str, x: int, y: int, svg_id=TEXT, font_weight=BOLD, size=FONT_SIZE
    ) -> (str, float, float):
        """
        Add a string to the SVG.
        Parameters
        ----------
        line: content to be parsed
        x: current x position of the parsing
        y: current y position of the parsing
        svg_id: svg id if the string added
        font_weight: font weight of the displayed string
        size: size of the displayed string
        Returns
        -------
        the length of the text advance
        """
        font_type = (
            "font-family: Roboto;font-size:" + str(size * self.scaling_factor) + "pt;"
        )

        sub_element = Tree.SubElement(
            self.tree_.getroot(),
            TEXT_TAG,
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
        return self.stringLength(line, size=size * self.scaling_factor)

    def addLine(self, line, x, y) -> float:
        """
        Add a line to the SVG.
        Parameters
        ----------
        line: content to be parsed
        x: current x position of the parsing
        y: current y position of the parsing
        Returns
        -------
        float advance in x direction
        """
        length = self.stringLength(
            line, size=FONT_SIZE * self.scaling_factor, font=NORMAL
        )
        Tree.SubElement(
            self.tree_.getroot(),
            LINE_TAG,
            {
                "id": LINE_ID,
                "x1": str(x),
                "y1": str(y),
                "x2": str(x + length),
                "y2": str(y),
                "stroke": HEX_WHITE,
                "fill": HEX_WHITE,
                "stroke-width": "1",
            },
        )

        return x + length

    @staticmethod
    def stringLength(line: str, size=12, font=BOLD, targetDPI=96) -> float:
        """
        Calculate the x advance of a given string on the svg
        Parameters
        ----------
        line: the content of the line
        size: size of the string
        font: font of the string
        targetDPI: dpi resolution to be used
        Returns
        -------
        float advance in x direction
        """
        metric = QFontMetrics(
            QFontDatabase.font(
                FAMILY_NAME[font],
                TEXT_STYLE[font]["style"],
                math.ceil(size - 1),
            ),
            pointSize=math.ceil(size - 1),
            weight=TEXT_STYLE[font]["weight"],
        )
        return metric.horizontalAdvance(line) / metric.fontDpi() * targetDPI

    def addVariable(self, line: str, x: int, y: int) -> (str, float, float):
        """
        Add a variable string to the SVG.
        Parameters
        ----------
        line: content to be parsed
        x: current x position of the parsing
        y: current y position of the parsing
        Returns
        -------
        float advance in x direction
        """
        segments = line.split(OP_KEY_VARIABLE, 2)

        x += self.addString(segments[0], x, y)

        segments[1] = " " + segments[1] + " "
        _ = self.addString(segments[1], x, y, font_weight=NORMAL)
        x = self.addLine(segments[1], math.ceil(x), y + LINE_OFF)

        if len(segments) > 2:
            return segments[2], x, y
        return "", x, y

    def addDropdown(self, line: str, x: int, y: int):
        """
        Add a dropdown string to the SVG.
        Parameters
        ----------
        line: content to be parsed
        x: current x position of the parsing
        y: current y position of the parsing
        Returns
        -------
        float advance in x direction
        """
        segments = line.split(OP_KEY_DROPDOWN, 2)
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
        return "", x, y

    def addTriangle(self, x0: int, y0: int):
        """
        Add a dropdown triangle to the SVG.
        Parameters
        ----------
        x0: current x position of the parsing
        y0: current y position of the parsing
        Returns
        -------
        float advance in x direction
        """
        x = x0 - 2 * FONT_SIZE
        y = y0 - FONT_SIZE
        Tree.SubElement(
            self.tree_.getroot(),
            POLYGON_TAG,
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
                "id": TRIANGLE_ID,
                "stroke": HEX_WHITE,
                "fill": HEX_WHITE,
                "stroke-width": "0.5",
            },
        )
