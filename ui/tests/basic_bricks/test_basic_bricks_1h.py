import pytest
from modules.backend.SVGBrick import SVGBrick
from os import getcwd, path


def difference(img_a, img_b):
    pass


def test_bricks():
    brick_type = "dark_green"
    created_path = path.join(getcwd(), brick_type + ".png")
    ref_path = path.join(getcwd(), "ref/" + brick_type + ".png")
    brick = SVGBrick(
        base_type=brick_type,
        content="",
        size="1h",
        path="brick_dark_green_1h.svg",
        scaling_factor=1.0,
        x=43,
        y=33,
    )
    brick.savePNG(path=created_path)
    assert difference(created_path, ref_path) < 0.1
