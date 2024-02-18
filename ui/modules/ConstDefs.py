import os

DEF_RESOURCE = os.path.join(os.getcwd(), "resources")
DEF_RESOURCE_OUT = os.path.join(DEF_RESOURCE, "out")
DEF_RESOURCE_OUT_EXPORT = os.path.join(DEF_RESOURCE_OUT, "export")
DEF_TMP = os.path.join(DEF_RESOURCE, "tmp")
DEF_BASE = os.path.join(os.getcwd(), "base")

VARIABLE = "var"
DROPDOWN = "drop"
TEXT = "text"

OP_KEY_NEWLINE = "\n"
OP_KEY_END = "\0"
OP_KEY_DROPDOWN = "*"
OP_KEY_VARIABLE = "$"

LINE_ID = "var_line"
TRIANGLE_ID = "triangle"
JSON_ID = "json"

BRICK_TAG = "brick"
POLYGON_TAG = "polygon"
LINE_TAG = "line"
TEXT_TAG = "text"

FONT_SIZE = 12
LINE_OFF = 3
LINE_HEIGHT = 8

DEFAULT_WIDTH = 350
DEFAULT_X = 43
DEFAULT_Y = 33

DROPDOWN_SIZE = 10
DROPDOWN_OFFSET = 5

PNG_WIDTH = 1920
PNG_HEIGHT_0H = 72
PNG_HEIGHT_1H = 397
PNG_HEIGHT_1H_CONTROL = 397
PNG_HEIGHT_2H_CONTROL = 524
PNG_HEIGHT_2H = 530
PNG_HEIGHT_3H = 657

BOLD = "bold"
NORMAL = "normal"

STYLE_LIGHT = "Light"
STYLE_BOLD = "Bold"

RES_PATH = {BOLD: "/qml/font/Roboto-Bold.ttf", NORMAL: "/qml/font/Roboto-Light.ttf"}
FAMILY_NAME = {BOLD: "Roboto", NORMAL: "Roboto"}

LEN_SCALAR = {BOLD: 1.1, NORMAL: 1.1}

HEX_DARK_BLUE = "#274383"
HEX_WHITE = "#FFFFFF"
HEX_BLACK = "#000000"

FORBIDDEN_FILE_NAME_CHARS = {
    r" ": "_",
    r"/": "",
    r":": "",
    r"<": "_lt_",
    r">": "_gt_",
    r'"': "",
    "\\n": "",
    "\\": "",
    "//": "",
    r"|": "",
    r"?": "",
    r"*": "",
    r"$": "",
    r".": "",
    r"=": "_eq_",
    "\n": "_",
    "\t": "_",
    r"%": "_pct_",
}
