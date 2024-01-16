import pytest
import sys
import os
from os import getcwd, walk
import json
from PIL import Image
import skimage
import warnings
import numpy as np

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt


def compare_images(img1, img2):
    # Convert images to grayscale if needed
    image1 = Image.open(img1)
    image2 = Image.open(img2)

    # Resize the image
    image2 = image2.resize(image1.size)
    assert image1.size == image2.size
    # Calculate SSIM
    ssim_value, _ = skimage.metrics.structural_similarity(
        np.array(image1), np.array(image2), full=True, data_range=1.0, win_size=3
    )
    image1.close()
    image2.close()
    print("comparing: ", img1, img2, ssim_value)
    return ssim_value


def test_all_bricks():
    initQt()
    ref_brick_path = "tests/ref_all_bricks"
    for root, dirs, folder in walk(ref_brick_path):
        for file_name in folder:
            file_path = os.path.join(root, file_name)
            if ".json" in file_path:
                print("opening", file_path)
                file = open(file_path, "r")
                content = json.load(file)
                brick: SVGBrick = SVGBrick.fromJSON(content)
                file.close()
                created_path = brick.working_brick_.replace(".svg", ".png")
                brick.savePNG(path=created_path)
                reference_path = file_path.replace(".json", ".png")
                assert compare_images(created_path, reference_path) > 0.995
                del brick


if __name__ == "__main__":
    test_all_bricks()
