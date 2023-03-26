from PySide6.QtCore import Slot, QObject
from PySide6.QtQml import QmlElement
from modules.SVGBrick import SVGBrick

import logging
import os
import json

QML_IMPORT_NAME = "Converter"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class Converter(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)

    @Slot(str, result=int)
    def fromJSONtoSVG(self, path):
        path = path.replace("file:///", "")
        count = 0
        for element in os.listdir(path):
            if ".json" in element:
                count += 1
                element = path + "/" + element
                SVGBrick.fromJSON(json.load(open(element))).save(element.replace(".json", ".svg"))
        return count

    @Slot(str, result=int)
    def fromJSONtoPNG(self, path):
        path = path.replace("file:///", "")
        count = 0
        for element in os.listdir(path):
            if ".json" in element:
                count += 1
                element = path + "/" + element
                SVGBrick.fromJSON(json.load(open(element))).savePNG(element.replace(".json", ".png"))
        return count

    @Slot(str, result=int)
    def fromSVGtoPNG(self, path):
        path = path.replace("file:///", "")
        count = 0
        for element in os.listdir(path):
            if ".svg" in element:
                count += 1
                element = path + "/" + element
                SVGBrick.fromJSON(SVGBrick.getJSONFromSVG(element)).savePNG(element.replace(".svg", ".png"))
        return count
