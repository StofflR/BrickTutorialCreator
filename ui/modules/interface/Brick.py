from PySide6.QtCore import Slot, QObject, QUrl
from PySide6.QtQml import QmlElement
from modules.backend.SVGBrick import SVGBrick, FORBIDDEN_FILE_NAME_CHARS
import logging
import os
import json

from sys import platform
import modules.OSDefs as OSDefs

QML_IMPORT_NAME = "Brick"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class Brick(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.brick = None

    @Slot(None, result=str)
    def brickContent(self):
        return self.brick.content

    @Slot(None, result=int)
    def posX(self):
        return self.brick.x

    @Slot(None, result=int)
    def posY(self):
        return self.brick.y

    @Slot(None, result=str)
    def basePath(self):
        baseBrick = self.brick.base_type
        control = ""
        if "(control)" in baseBrick:
            baseBrick = baseBrick.replace(" (control)", "")
            control = "_control"
        return "brick_" + baseBrick + "_" + str(self.brick.size) + control + ".svg"

    @Slot(None, result=str)
    def brickColor(self):
        return self.brick.base_type

    @Slot(str, str, str, str, int, int, int)
    def updateBrick(self, color, path, size, content, scale, x=43, y=33):
        if color and path and size and scale:
            self.brick = SVGBrick(
                base_type=color,
                content=content,
                size=size,
                path=path,
                scaling_factor=scale / 100,
                x=x,
                y=y,
            )

    @Slot(str)
    def fromJSON(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        self.brick = SVGBrick.fromJSON(json.load(open(path)))

    @Slot(str)
    def fromSVG(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        self.brick = SVGBrick.fromJSON(SVGBrick.getJSONFromSVG(path))

    @Slot(str)
    def fromFile(self, path):
        if ".json" in path:
            self.fromJSON(path)
        elif ".svg" in path:
            self.fromSVG(path)

    @Slot(str)
    def updateBrickContent(self, content):
        color = self.brick.base_type
        path = self.brick.path
        size = self.brick.size
        scale = self.brick.scaling_factor
        if color and path and size and scale:
            self.brick = SVGBrick(
                base_type=color,
                content=content,
                size=size,
                path=path,
                scaling_factor=scale,
            )

    @Slot(None, result=str)
    def path(self):
        if self.brick:
            workingBrick = self.brick.getWorkingBrick()
            return QUrl.fromLocalFile(workingBrick).toString()
        return ""

    @Slot(result=str)
    def fileName(self):
        # clean multi, leading/tailing whitespaces
        return " ".join(self.brick.contentPlain().split()).strip().replace(" ", "_")

    @Slot(str, result=str)
    @Slot(str, str, result=str)
    def saveSVG(self, path, filename=None):
        path = path.replace(OSDefs.FILE_STUB, "")
        if not filename:
            filename = self.fileName()
        print(path)
        filename = self.cleanFileName(filename)
        os.makedirs(path, exist_ok=True)
        target = path + "/" + filename + ".svg"
        self.brick.save(target)
        return target

    @Slot(str)
    @Slot(str, str)
    def savePNG(self, path, filename=None):
        path = path.replace(OSDefs.FILE_STUB, "")
        if not filename:
            filename = self.fileName()
        filename = cleanFileName(filename)
        os.makedirs(path, exist_ok=True)
        self.brick.savePNG(path + "/" + filename + ".png")

    @Slot(str, result=bool)
    def exists(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        return os.path.exists(path)

    @Slot(str)
    @Slot(str, str)
    def saveJSON(self, path, filename=None):
        path = path.replace(OSDefs.FILE_STUB, "")
        if not filename:
            filename = self.fileName()
        filename = cleanFileName(filename)
        os.makedirs(path, exist_ok=True)
        self.brick.toJSON(path + "/" + filename + ".json")

    @Slot(str, result=str)
    def cleanFileName(self, filename):
        return cleanFileName(filename)


def cleanFileName(filename):
    name = filename.replace(".svg", "").replace(".png", "").replace(".json", "")
    for key, value in FORBIDDEN_FILE_NAME_CHARS.items():
        name = name.replace(key, value)
    return name