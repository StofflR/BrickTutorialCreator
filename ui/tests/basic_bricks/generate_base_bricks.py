import os
from os import getcwd, path
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
import modules.ConstDefs as Const
from modules.ConstDefs import *
from PIL import Image

output_folder = os.path.join(os.getcwd(), "tests/ref")
if not os.path.isdir(output_folder):
    os.mkdir(output_folder)

def generate_bricks(data):
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            brick_path = f"brick_{brick_type}_{size}.svg"
            brick = SVGBrick(
                base_type=brick_type,
                content="",
                size=size,
                path=brick_path,
                scaling_factor=1.0,
                x=43,
                y=33,
            )
            export_path = os.path.join(
                output_folder, brick_path.replace(SVG_EXT, PNG_EXT).replace("brick_","")
            )
            brick.savePNG(export_path)

def generate_control_bricks(data):
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            brick_path = f"brick_{brick_type}_{size}_control.svg"
            brick = SVGBrick(
                base_type=brick_type,
                content="",
                size=size,
                path=brick_path,
                scaling_factor=1.0,
                x=43,
                y=33,
            )
            export_path = os.path.join(
                output_folder, brick_path.replace(SVG_EXT, PNG_EXT).replace("brick_","")
            )
            brick.savePNG(export_path)

def generate_collapsed_bricks(data):
    for brick_type in data["colors"]:
        brick_path = f"brick_{brick_type}_0h_collapsed.svg"
        brick = SVGBrick(
            base_type=brick_type,
            content="",
            size="0h",
            path=brick_path,
            scaling_factor=1.0,
            x=43,
            y=33,
        )
        export_path = os.path.join(
            output_folder, brick_path.replace(SVG_EXT, PNG_EXT).replace("brick_","")
        )
        brick.savePNG(export_path)

data = {}
data["colors"] = [
    "blue",
    "cyan",
    "dark_blue",
    "gold",
    "dark_green",
    "green",
    "light_orange",
    "olive",
    "orange",
    "yellow",
    "violet",
    "pink",
    "red",
    "white",
    "transparent_white",
    "transparent_black",
]
initQt()
generate_collapsed_bricks(data)
data["sizes"] = ["1h", "2h", "3h"]
generate_bricks(data)
data["sizes"] = ["1h", "2h"]
generate_control_bricks(data)

for filename in os.listdir(output_folder):
    file_path = os.path.join(output_folder, filename)