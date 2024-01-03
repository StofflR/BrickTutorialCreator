import pytest
import sys
import os
from os import getcwd, walk
import json
import skimage

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt

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

def test_all_bricks():
    ref_brick_path = "tests/ref_all_bricks"
    for root, dirs, folder in walk(ref_brick_path):
        for file_name in folder:
            file_path = os.path.join(root, file_name)
            if ".json" in file_path:
                print("opening", file_path)
                file = open(file_path, 'r')
                content = json.load(file)
                brick: SVGBrick = SVGBrick.fromJSON(content)
                file.close()
                path=brick.working_brick_.replace(".json", ".png")
                brick.savePNG(path=path) 
                assert compare_images(path, file_path) > 0.995

if __name__ == "__main__":
    test_all_bricks()