import json
import os
from typing import Dict, List

DEFAULT_PATH = "resources/base"


class Brick:
    def __init__(self, color: str, sizes: Dict):
        self.color = color
        self.sizes = sizes


class ResourceManager:
    def __init__(self, path=DEFAULT_PATH, file_type=""):
        self.path = path
        self.base_bricks = []
        if file_type != "":
            self.loadAvailable(DEFAULT_PATH, file_type)

    def brick_op(self, file, colors, file_type):
        if file_type in file:
            color = file.split("_", 2)[1]
            size = file.replace("brick_", "").replace(color + "_", "").replace(file_type, "")
            if "control" in file:
                color = color + " (control)"
                size = size.replace("_control", "")
            if color in colors:
                for index, brick in enumerate(self.base_bricks):
                    if brick.color == color:
                        self.base_bricks[index].sizes[size] = file
            else:
                colors.append(color)
                self.base_bricks.append(Brick(color, {size: file}))

    def loadAvailable(self, path, file_type=".svg", file_op=None):
        if file_op is None:
            file_op = self.brick_op
        self.base_bricks.clear()
        colors = []
        files = os.listdir(path)
        for file in files:
            file_op(file, colors, file_type)

    def getAvailable(self, update=False, update_path=DEFAULT_PATH) -> List:
        if update:
            self.path = update_path
            self.loadAvailable(self.path, update_path)
        return self.base_bricks


if __name__ == '__main__':
    brick_manager = ResourceManager(file_type=".ai")
    for element in brick_manager.getAvailable():
        print(element.color, json.dumps(element.sizes, indent=2))
