import pytest
import sys
from os import getcwd, path

import skimage

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
from modules.ConstDefs import *

data = {}
data["sizes"] = ["1h", "2h"]
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
]


def test_bricks():
    initQt()
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            brick_path = f"brick_{brick_type}_{size}_control.svg"
            ref_path = path.join(
                getcwd(), r"tests/ref/" + f"{brick_type}_{size}_control" + PNG_EXT
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
            created_path = brick.working_brick_.replace(SVG_EXT, PNG_EXT)
            brick.savePNG(path=created_path)
            assert compareImages(ref_path, created_path) > 0.995


if __name__ == "__main__":
    test_bricks()
