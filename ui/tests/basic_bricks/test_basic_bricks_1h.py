import pytest
import sys
from os import getcwd, path

import scipy
import numpy
import cv2

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt

initQt()

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


def difference(img_a, img_b):
    img1 = cv2.imread(img_a, cv2.IMREAD_GRAYSCALE)
    img2 = cv2.imread(img_b, cv2.IMREAD_GRAYSCALE)
    norm1, norm2 = compare_images(img1, img2)
    print(norm1, norm2)
    return 0

def compare_images(img1, img2):
    # normalize to compensate for exposure difference, this may be unnecessary
    # consider disabling it
    img1 = numpy.normalize(img1)
    img2 = numpy.normalize(img2)
    # calculate the difference and its norms
    diff = img1 - img2  # elementwise for scipy arrays
    m_norm = scipy.sum(scipy.abs(diff))  # Manhattan norm
    z_norm = scipy.linalg.norm(diff.ravel(), 0)  # Zero norm
    return (m_norm, z_norm)

def test_bricks():
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            brick_path = f"brick_{brick_type}_{size}.svg"
            ref_path = path.join(
                getcwd(), r"tests\\ref\\" + f"{brick_type}_{size}" + ".png"
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
            created_path = brick.working_brick_.replace(".svg", ".png")
            brick.savePNG(path=created_path)
            assert difference(ref_path, created_path) < 0.1


if __name__ == "__main__":
    test_bricks()
