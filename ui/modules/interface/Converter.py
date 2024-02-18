from PySide6.QtCore import Slot, QObject, QUrl
from PySide6.QtQml import QmlElement
from modules.backend.SVGBrick import SVGBrick
from modules.interface.BatchBrickUpdater import BatchBrickUpdater
from modules.interface.TutorialManager import TutorialManager
from modules.ConstDefs import *

import logging
import os
import json

from sys import platform

import modules.OSDefs as OSDefs


QML_IMPORT_NAME = "Converter"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class Converter(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.data = {}
        self.content = ""

    @Slot(str, result=int)
    def fromJSONtoSVG(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        count = 0
        for element in os.listdir(path):
            if JSON_EXT in element:
                count += 1
                element = path + "/" + element
                SVGBrick.fromJSON(json.load(open(element))).save(
                    element.replace(JSON_EXT, SVG_EXT)
                )
        return count

    @Slot(str, result=int)
    def fromJSONtoPNG(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        count = 0
        for element in os.listdir(path):
            if JSON_EXT in element:
                count += 1
                element = path + "/" + element
                SVGBrick.fromJSON(json.load(open(element))).savePNG(
                    element.replace(JSON_EXT, PNG_EXT)
                )
        return count

    @Slot(str, result=int)
    def fromTutorialtoPNG(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        count = 0
        for element in os.listdir(path):
            if JSON_EXT in element:
                element = path + "/" + element
                try:
                    tutorialManager = TutorialManager()
                    tutorialManager.fromJSON(element)
                    tutorialManager.saveTutorial(element.replace(JSON_EXT, PNG_EXT))
                    count += 1
                    logging.debug(f"Converted: {element}")
                except Exception as e:
                    logging.warning(f"Couldn't convert: {element}")
        return count

    @Slot(str, result=int)
    def fromSVGtoPNG(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        count = 0
        for element in os.listdir(path):
            if SVG_EXT in element:
                count += 1
                element = path + "/" + element
                SVGBrick.fromJSON(SVGBrick.getJSONFromSVG(element)).savePNG(
                    element.replace(SVG_EXT, PNG_EXT)
                )
        return count

    @Slot(str, result=type([]))
    def updateExisting(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        file_set = []
        for dir_, _, files in os.walk(path):
            for file_name in files:
                if SVG_EXT in file_name:
                    rel_dir = os.path.relpath(dir_, path)
                    rel_file = os.path.join(rel_dir, file_name)
                    file_set.append(os.path.join(path, rel_file))
        return file_set

    @Slot(str)
    def convert(self, file):
        doc = open(file, "r")
        is_brick = '<desc id="json" tag="brick">' in doc.read()
        doc.close()
        if is_brick:
            self.data = SVGBrick.getJSONFromSVG(file)
            self.content = self.data["content"]
        else:
            self.data, self.content = BatchBrickUpdater(file).resolveBrick()
            self.data["base_type"] = self.data["color"]
            self.data["content"] = self.content
            self.data["size"] = self.data["height"]
            self.data["path"] = (
                "brick_" + self.data["color"] + "_" + self.data["height"] + SVG_EXT
            )

    @Slot(str, result=bool)
    def isBrick(self, file):
        if not file:
            return False
        file = file.replace(OSDefs.FILE_STUB, "")
        doc = open(file, "r")
        result = '<desc id="json" tag="brick">' in doc.read()
        doc.close()
        return result

    @Slot(str, result=str)
    def getData(self, type):
        result = ""
        if type == "base_type":
            result = self.data[type]
        if type == "content":
            result = self.content
        if type == "size":
            result = self.data["size"].replace("h", "")
        if type == "path":
            result = (
                "brick_" + self.data["base_type"] + "_" + self.data["size"] + SVG_EXT
            )
        return result

    @Slot(str, result=str)
    def getOutputPath(self, file):
        print("File is:", os.path.dirname(file) + "/converted")
        return os.path.join(
            os.path.join(OSDefs.FILE_STUB, os.path.dirname(file)), "/converted"
        )
