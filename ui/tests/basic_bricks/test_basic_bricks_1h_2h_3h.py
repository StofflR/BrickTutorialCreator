import pytest
import sys
from os import getcwd, path

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
import modules.ConstDefs as Const
from modules.ConstDefs import *

data = {}
data["sizes"] = ["1h", "2h", "3h"]
data["colors"] = [
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


def test_bricks():
    initQt()
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            brick_path = f"brick_{brick_type}_{size}.svg"
            ref_path = path.join(
                getcwd(), r"tests/ref/" + f"{brick_type}_{size}" + PNG_EXT
            )
            brick = SVGBrick(
                base_type=brick_type,
                content="",
                size=size,
                path=brick_path,
                scaling_factor=1.0,
                x=43,
                y=33,
            )

            height = Const.PNG_HEIGHT_1H

            if "2h" in size and "control" in size:
                height = Const.PNG_HEIGHT_2H_CONTROL
            elif "2h" in size:
                height = Const.PNG_HEIGHT_2H
            elif "3h" in size:
                height = Const.PNG_HEIGHT_3H
            created_path = brick.working_brick_.replace(SVG_EXT, PNG_EXT)
            brick.savePNG(path=created_path, width=Const.PNG_WIDTH, height=height)
            assert compareImages(ref_path, created_path) > 0.995


if __name__ == "__main__":
    test_bricks()
