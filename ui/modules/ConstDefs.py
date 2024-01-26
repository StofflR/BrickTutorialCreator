from os import getcwd

DEF_RESOURCE = getcwd() + "/resources/"
DEF_TMP = DEF_RESOURCE + "tmp/"
VARIABLE = "var"
DROPDOWN = "drop"
TEXT = "text"
BOLD = "bold"
NORMAL = "normal"

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

RES_PATH = {BOLD: "/qml/font/Roboto-Bold.ttf", NORMAL: "/qml/font/Roboto-Light.ttf"}
FAMILY_NAME = {BOLD: "Roboto", NORMAL: "Roboto"}

LEN_SCALAR = {BOLD: 1.1, NORMAL: 1.1}

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
    "/": "",
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
