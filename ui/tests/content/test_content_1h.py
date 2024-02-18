import pytest
import sys
from os import getcwd, path

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
from modules.ConstDefs import *

data = {}
data["sizes"] = ["1h"]
data["colors"] = ["cyan"]
data["content"] = ["basic brick", "basic *dropdown*", "basic $variable$"]


def test_bricks():
    initQt()
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            for content in data["content"]:
                brick_path = f"brick_{brick_type}_{size}.svg"
                ref_path = path.join(
                    getcwd(),
                    r"tests/ref/"
                    + f"{brick_type}_{size}_{content.replace('*', '').replace('$', '').replace(' ','_')}"
                    + PNG_EXT,
                )
                brick = SVGBrick(
                    base_type=brick_type,
                    content=content,
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
