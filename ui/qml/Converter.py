from PySide6.QtCore import Slot, QObject
from PySide6.QtQml import QmlElement
from modules.SVGBrick import SVGBrick
from modules.BatchBrickUpdater import BatchBrickUpdater

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

    @Slot(str, result=type([]))
    def updateExisting(self, path):
        path = path.replace("file:///", "")
        file_set = []
        for dir_, _, files in os.walk(path):
            for file_name in files:
                rel_dir = os.path.relpath(dir_, path)
                rel_file = os.path.join(rel_dir, file_name)
                file_set.append(os.path.join(path , rel_file))
        return file_set
