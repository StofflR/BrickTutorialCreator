import pytest
import sys
import os
from os import getcwd, walk
import json

from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt, compareImages
import modules.ConstDefs as Const
from modules.ConstDefs import *

sys.path.insert(0, getcwd())


def test_all_bricks():
    initQt()
    ref_brick_path = "tests/ref_all_bricks"
    for root, dirs, folder in walk(ref_brick_path):
        for file_name in folder:
            file_path = os.path.join(root, file_name)
            if JSON_EXT in file_path:
                print("opening", file_path)
                file = open(file_path, "r")
                content = json.load(file)
                brick: SVGBrick = SVGBrick.fromJSON(content)
                file.close()
                created_path = brick.working_brick_.replace(SVG_EXT, PNG_EXT)

                height = Const.PNG_HEIGHT_1H

                if "2h" in content["path"] and "control" in content["path"]:
                    height = Const.PNG_HEIGHT_2H_CONTROL
                elif "2h" in content["path"]:
                    height = Const.PNG_HEIGHT_2H
                elif "3h" in content["path"]:
                    height = Const.PNG_HEIGHT_3H

                brick.savePNG(path=created_path, width=Const.PNG_WIDTH, height=height)
                reference_path = file_path.replace(JSON_EXT, PNG_EXT)
                assert compareImages(created_path, reference_path) > 0.995
                del brick


if __name__ == "__main__":
    test_all_bricks()
