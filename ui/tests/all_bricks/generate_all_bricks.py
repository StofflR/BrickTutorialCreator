import pytest
import sys
from os import getcwd, path, walk

import skimage

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt
import json

def iterate_files(folder_path):
    for root, dirs, files in walk(folder_path):
        for file_name in files:
            file_path = path.join(root, file_name)
            if ".json" in file_path:
                print("opening", file_path)
                file = open(file_path, 'r')
                content = json.load(file)
                brick = SVGBrick.fromJSON(content)
                file.close()
                brick.savePNG(path=file_path.replace(".json", ".png"))
                brick.save(path=file_path.replace(".json", ".svg"))

if __name__ == "__main__":
    ref_brick_path = "tests/ref_all_bricks"
    initQt()
    iterate_files(ref_brick_path)
