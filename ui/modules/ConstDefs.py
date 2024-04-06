import os

DEF_RESOURCE = os.path.join(os.getcwd(), "resources")
DEF_RESOURCE_OUT = os.path.join(DEF_RESOURCE, "out")
DEF_RESOURCE_OUT_EXPORT = os.path.join(DEF_RESOURCE_OUT, "export")
DEF_TMP = os.path.join(DEF_RESOURCE, "tmp")

DEF_BASE = os.path.join(os.getcwd(), "base")
DEF_BASE_CUSTOM = os.path.join(os.getcwd(), "custom")
DEF_BASE_BRICK = os.path.join(DEF_BASE, "brick_blue_1h.svg")

VARIABLE = "var"
DROPDOWN = "drop"
TEXT = "text"

SVG_EXT = ".svg"
PNG_EXT = ".png"
JSON_EXT = ".json"

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
PNG_WIDTH_TUTORIAL = 640

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

blue = "408ac5"
blue_shade = "27567c"

cyan = "26a6ae"
cyan_shade = "2e7078"

dark_blue = "395cab"
dark_blue_shade = "889dcd"

gold = "95750c"
gold_shade = "57452c"

dark_green = "305716"
dark_green_shade = "173718"

green = "6b9c49"
green_shade = "486822"

light_orange = "f99761"
light_orange_shade = "a86d45"

olive = "aea626"
olive_shade = "7e7a30"

orange = "cf5717"
orange_shade = "7a3a18"

yellow = "fccb41"
yellow_shade = "aa8832"

violet = "8f4cba"
violet_shade = "5d2d7c"

pink = "cf7aa6"
pink_shade = "935e7b"

red = "f24e50"
red_shade = "ae2f2f"

white = "ffffff"
white_shade = "a9b4cd"
white_border = "274383"

default_border = "383838"

colorSchemes = [
    {"name": "blue", "color": blue, "shade": blue_shade, "border": default_border},
    {"name": "cyan", "color": cyan, "shade": cyan_shade, "border": default_border},
    {
        "name": "dark_blue",
        "color": dark_blue,
        "shade": dark_blue_shade,
        "border": default_border,
    },
    {"name": "gold", "color": gold, "shade": gold_shade, "border": default_border},
    {
        "name": "dark_green",
        "color": dark_green,
        "shade": dark_green_shade,
        "border": default_border,
    },
    {"name": "green", "color": green, "shade": green_shade, "border": default_border},
    {
        "name": "light_orange",
        "color": light_orange,
        "shade": light_orange_shade,
        "border": default_border,
    },
    {"name": "olive", "color": olive, "shade": olive_shade, "border": default_border},
    {
        "name": "orange",
        "color": orange,
        "shade": orange_shade,
        "border": default_border,
    },
    {
        "name": "yellow",
        "color": yellow,
        "shade": yellow_shade,
        "border": default_border,
    },
    {
        "name": "violet",
        "color": violet,
        "shade": violet_shade,
        "border": default_border,
    },
    {"name": "pink", "color": pink, "shade": pink_shade, "border": default_border},
    {"name": "red", "color": red, "shade": red_shade, "border": default_border},
    {"name": "white", "color": white, "shade": white_shade, "border": white_border},
    {
        "name": "transparent_white",
        "color": "ffffffff",
        "shade": "ffffffff",
        "border": "ffffffff",
    },
    {
        "name": "transparent_black",
        "color": "000000ff",
        "shade": "000000ff",
        "border": "000000ff",
    },
]
