import pytest
import sys
from os import getcwd, path

import skimage

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt

data = {}
data["sizes"] = ["1h"]
data["colors"] = ["cyan"]
data["content"] = ["basic brick", "basic *dropdown*", "basic $variable$"]


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
    for size in data["sizes"]:
        for brick_type in data["colors"]:
            for content in data["content"]:
                brick_path = f"brick_{brick_type}_{size}.svg"
                ref_path = path.join(
                    getcwd(),
                    r"tests\\ref\\"
                    + f"{brick_type}_{size}_{content.replace('*', '').replace('$', '').replace(' ','_')}"
                    + ".png",
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
                created_path = brick.working_brick_.replace(".svg", ".png")
                brick.savePNG(path=created_path)
                assert compare_images(ref_path, created_path) > 0.995


if __name__ == "__main__":
    test_bricks()
