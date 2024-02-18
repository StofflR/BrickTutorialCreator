import json
import logging
from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QmlElement
from modules.backend.SVGBrick import SVGBrick
from modules.ConstDefs import *
from modules.Utility import removeFileStub, addFileStub
from modules.interface.BatchBrickUpdater import BatchBrickUpdater
from modules.interface.TutorialManager import TutorialManager

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
        path = removeFileStub(path)
        count = 0
        for element in os.listdir(path):
            if JSON_EXT in element:
                count += 1
                element = os.path.join(path, element)
                SVGBrick.fromJSON(json.load(open(element))).save(
                    element.replace(JSON_EXT, SVG_EXT)
                )
        return count

    @Slot(str, result=int)
    def fromJSONtoPNG(self, path):
        path = removeFileStub(path)
        count = 0
        for element in os.listdir(path):
            if JSON_EXT in element:
                count += 1
                element = os.path.join(path, element)
                SVGBrick.fromJSON(json.load(open(element))).savePNG(
                    element.replace(JSON_EXT, PNG_EXT)
                )
        return count

    @Slot(str, result=int)
    def fromTutorialToPNG(self, path):
        path = removeFileStub(path)
        count = 0
        for element in os.listdir(path):
            if JSON_EXT in element:
                element = os.path.join(path, element)
                try:
                    tutorialManager = TutorialManager()
                    tutorialManager.fromJSON(element)
                    tutorialManager.saveTutorial(element.replace(JSON_EXT, PNG_EXT))
                    count += 1
                    logging.debug(f"Converted: {element}")
                except Exception as _:
                    logging.warning(f"Could not convert: {element}")
        return count

    @Slot(str, result=int)
    def fromSVGtoPNG(self, path):
        path = removeFileStub(path)
        count = 0
        for element in os.listdir(path):
            if SVG_EXT in element:
                count += 1
                element = os.path.join(path, element)
                SVGBrick.fromJSON(SVGBrick.getJSONFromSVG(element)).savePNG(
                    element.replace(SVG_EXT, PNG_EXT)
                )
        return count

    @Slot(str, result=type([]))
    def updateExisting(self, path):
        path = removeFileStub(path)
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
        """
        Check if the given file is a brick
        Parameters
        ----------
        file: file to be checked
        Returns
        -------
        boolean whether the file is a brick or not
        """
        if not file:
            return False
        file = removeFileStub(file)
        doc = open(file, "r")
        result = '<desc id="json" tag="brick">' in doc.read()
        doc.close()
        return result

    @Slot(str, result=str)
    def getData(self, data_type):
        """
        retrieve the selected datatype from the converter
        Parameters
        ----------
        data_type: the data type to be returned
        Returns
        -------
        the requested data data type data
        """
        result = ""
        if data_type == "base_type":
            result = self.data[data_type]
        if data_type == "content":
            result = self.content
        if data_type == "size":
            result = self.data["size"].replace("h", "")
        if data_type == "path":
            result = (
                "brick_" + self.data["base_type"] + "_" + self.data["size"] + SVG_EXT
            )
        return result

    @Slot(str, result=str)
    def getOutputPath(self, file):
        """
        Get path for converted file output
        Parameters
        ----------
        file: filepath of the current file
        Returns
        -------
        string of the folder for converted file output
        """
        return os.path.join(addFileStub(os.path.dirname(file)), "/converted")
