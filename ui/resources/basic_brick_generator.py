import os
from os import getcwd, path
import sys

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
import modules.ConstDefs as Const
from modules.ConstDefs import *
from PIL import Image

output_folder = os.path.join(os.getcwd(), "drawable")

drawable_dpis = {}
drawable_dpis["mdpi"] = {"width": 56, "1h": 46, "2h": 73, "3h": 96}
drawable_dpis["hdpi"] = {"width": 83, "1h": 66, "2h": 109, "3h": 143}
drawable_dpis["xhdpi"] = {"width": 111, "1h": 90, "2h": 144, "3h": 190}
drawable_dpis["ldpi"] = {"width": 43, "1h": 35, "2h": 55, "3h": 73}
drawable_dpis["xxhdpi"] = {"width": 164, "1h": 134, "2h": 216, "3h": 284}

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

            # height = Const.PNG_HEIGHT_1H
            dpi = drawable_dpis["hdpi"]
            height = dpi["1h"]
            width = dpi["width"]
            export_width = Const.PNG_WIDTH / Const.PNG_HEIGHT_1H * height
            if "2h" in size:
                height = dpi["2h"]
            #    height = Const.PNG_HEIGHT_2H
            elif "3h" in size:
                height = dpi["3h"]
            #    height = Const.PNG_HEIGHT_3H
            export_path = os.path.join(
                output_folder, brick_path.replace(SVG_EXT, PNG_EXT)
            )
            brick.savePNG(export_path, width=export_width, height=height)
            crop_width(export_path, width, export_path.replace(".png", "9.png"))


def generate_control_bricks(data):
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            brick_path = f"brick_{brick_type}_{size}_ctrol.svg"
            brick = SVGBrick(
                base_type=brick_type,
                content="",
                size=size,
                path=brick_path,
                scaling_factor=1.0,
                x=43,
                y=33,
            )
            # height = Const.PNG_HEIGHT_1H

            height = 95
            width = 311
            export_width = Const.PNG_WIDTH / Const.PNG_HEIGHT_1H * height
            if "2h" in size:
                height = 134
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
    "winered"
    # "transparent_white",
    # "transparent_black",
]
data["colors"] = ["winered"]
initQt()
generate_bricks(data)
data["sizes"] = ["1h", "2h"]
generate_control_bricks(data)

for filename in os.listdir(output_folder):
    file_path = os.path.join(output_folder, filename)
