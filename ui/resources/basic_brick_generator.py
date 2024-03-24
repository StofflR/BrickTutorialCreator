import os
from os import getcwd, path
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
import modules.ConstDefs as Const
from modules.ConstDefs import *
from PIL import Image

output_folder = os.path.join(os.getcwd(), "drawable")
if not os.path.isdir(output_folder):
    os.mkdir(output_folder)


def crop_width(image_path, new_width, output):
    # Open the image file
    img = Image.open(image_path)
    _, height = img.size
    img_area = (0, 0, new_width, height)

    img_crop = img.crop(img_area)
    img_crop.save(output)

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

            #height = Const.PNG_HEIGHT_1H
            height=66
            width=81
            export_width = Const.PNG_WIDTH/Const.PNG_HEIGHT_1H*height
            if "2h" in size:
                height=108
            #    height = Const.PNG_HEIGHT_2H
            elif "3h" in size:
                height=142
            #    height = Const.PNG_HEIGHT_3H
            export_path = os.path.join(
                output_folder, brick_path.replace(SVG_EXT, PNG_EXT)
            )
            brick.savePNG(export_path, width=export_width, height=height)
            crop_width(export_path, width, export_path.replace("png", "9.png"))

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
            #height = Const.PNG_HEIGHT_1H

            height=95
            width=311
            export_width = Const.PNG_WIDTH/Const.PNG_HEIGHT_1H*height
            if "2h" in size:
                height=134
            export_path = os.path.join(
                output_folder, brick_path.replace(SVG_EXT, PNG_EXT)
            )
            brick.savePNG(export_path, width=export_width, height=height)
            crop_width(export_path, width, export_path.replace("png", "9.png"))


data = {}
data["sizes"] = ["1h", "2h", "3h"]
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
    #"transparent_white",
    #"transparent_black",
]
initQt()
generate_bricks(data)
data["sizes"] = ["1h", "2h"]
generate_control_bricks(data)

for filename in os.listdir(output_folder):
    file_path = os.path.join(output_folder, filename)