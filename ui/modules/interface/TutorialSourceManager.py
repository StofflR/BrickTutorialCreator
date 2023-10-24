import os

from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
from modules.backend.SVGBrick import SVGBrick
import logging

from sys import platform

import modules.OSDefs as OSDefs


QML_IMPORT_NAME = "TutorialSourceManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class TutorialSourceManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.paths = {}
        self.modelVal = []
        self.allowForeignVal = False
        self.enableSorting = False
        self.typeModel = {}
        self.filter = ""

    def isBrick(self, file: str):
        is_brick = '<desc id="json" tag="brick">' in open(file, "r").read()
        if is_brick:
            return SVGBrick.getJSONFromSVG(file)

        if self.allowForeignVal:
            try:
                return SVGBrick.getJSONFromSVG(file)
            except Exception as e:
                logging.debug("Cloud not load svg: " + file)
        return False

    def findResources(self, path):
        resources = []
        unique_resources = []
        files = os.listdir(path)
        for file in files:
            file = path + "/" + file
            if ".svg" in file:
                brick_data = self.isBrick(file)
                if brick_data:
                    brick = {"path": file, "is_brick": True}
                    brick_data["base_path"] = brick_data["path"]
                    brick_data.update(brick)
                    brick = brick_data

                    if self.filter == "" or (
                        "content" in brick.keys() and self.filter in brick["content"]
                    ):
                        if self.enableSorting:
                            self.addSorted(resources, brick)
                            unique_resources = resources.copy()
                        else:
                            resources.append(brick)
                            if file not in self.modelVal:
                                unique_resources.append(brick)
        return resources, unique_resources

    def addSorted(self, resources, brick):
        for color in resources:
            if color["path"] == brick["base_path"]:
                return color["elements"].append(brick)
        resources.append({"path": brick["base_path"], "elements": [brick]})

    @Slot(str, result=None)
    def addPath(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")

        if path in self.paths.keys():
            return

        resources, unique_resources = self.findResources(path)
        self.paths[path] = resources
        self._updateModel(self.modelVal + unique_resources)
        self.modelChanged.emit()

    @Slot()
    def refresh(self):
        model = []
        self.modelVal = []
        for path in self.paths.keys():
            resources, unique_resources = self.findResources(path)
            self.paths[path] = resources
            model = model + unique_resources
        self._updateModel(model)

    @Slot(str, result=None)
    def removePath(self, path):
        path = path.replace(OSDefs.FILE_STUB, "")
        self.paths.pop(path, None)
        self.refresh()

    def _getModel(self):
        return self.modelVal

    @Slot(str)
    def setFilter(self, text):
        self.filter = text
        self.refresh()

    @Slot(list)
    def _updateModel(self, model):
        self.modelVal = model
        self.modelChanged.emit()

    @Signal
    def modelChanged(self):
        pass

    def _getAllowForeign(self):
        return self.allowForeignVal

    @Slot(bool)
    def _setAllowForeign(self, allow):
        self.allowForeignVal = allow
        self.foreignChanged.emit()

    @Signal
    def foreignChanged(self):
        pass

    def _getSorting(self):
        return self.enableSorting

    @Slot(bool)
    def _setSorting(self, allow):
        self.enableSorting = allow
        self.refresh()

    @Signal
    def sortingChanged(self):
        pass

    model = Property(list, _getModel, _updateModel, notify=modelChanged)
    allowForeign = Property(
        bool, _getAllowForeign, _setAllowForeign, notify=foreignChanged
    )
    sorted = Property(bool, _getSorting, _setSorting, notify=sortingChanged)
