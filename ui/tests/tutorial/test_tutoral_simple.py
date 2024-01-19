import pytest
import sys
from os import getcwd, path

import skimage

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt
from modules.interface.TutorialManager import TutorialManager

data = {}
data["sizes"] = ["0h", "1h", "2h", "3h"]
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


def compare_images(img1, img2):
    # Convert images to grayscale if needed
    image1 = skimage.io.imread(img1)
    image2 = skimage.io.imread(img2)
    # Calculate SSIM
    ssim_value, _ = skimage.metrics.structural_similarity(
        image1, image2, full=True, data_range=1.0, win_size=3
    )
    print("comparing: ", img1, img2, ssim_value)
    return ssim_value


def test_bricks():
    initQt()
    tutorialManager = TutorialManager()
    for size in data["sizes"]:
        tutorialManager.clear()
        for brick_type in data["colors"]:
            if "0h" in size:
                brick_path = f"brick_{brick_type}_{size}_collapsed.svg"
            else:
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
            tutorialManager.addBrick(brick.working_brick_)
        tutorialManager.toPNG(f"resources/tmp/tutorial_simple_{size}.png")
        assert (
            compare_images(
                f"resources/tmp/tutorial_simple_{size}.png",
                f"tests/ref/ref_tutorial_simple_{size}.png",
            )
            > 0.995
        )


if __name__ == "__main__":
    test_bricks()
