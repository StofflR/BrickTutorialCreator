import pytest
import sys
from os import getcwd, path, walk

import skimage

sys.path.insert(0, getcwd())
from modules.backend.SVGBrick import SVGBrick
from tests.initializers import initQt
import json
import modules.ConstDefs as Const


def iterate_files(folder_path) -> None:
    for root, dirs, files in walk(folder_path):
        for file_name in files:
            file_path = path.join(root, file_name)
            if ".json" in file_path:
                print("opening", file_path)
                file = open(file_path, "r")
                content = json.load(file)
                brick: SVGBrick = SVGBrick.fromJSON(content)
                file.close()
                height = Const.PNG_HEIGHT_1H
                if "2h" in content["path"] and "control" in content["path"]:
                    height = Const.PNG_HEIGHT_2H_CONTROL
                elif "2h" in content["path"]:
                    height = Const.PNG_HEIGHT_2H
                elif "3h" in content["path"]:
                    height = Const.PNG_HEIGHT_3H
                brick.savePNG(
                    path=file_path.replace(".json", ".png"),
                    width=Const.PNG_WIDTH,
                    height=height,
                )
                brick.save(path=file_path.replace(".json", ".svg"))


if __name__ == "__main__":
    ref_brick_path = "tests/ref_all_bricks"
    initQt()
    iterate_files(ref_brick_path)
