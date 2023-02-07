from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
from modules.ResourceManager import ResourceManager
import os

QML_IMPORT_NAME = "TutorialSourceManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class TutorialSourceManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.paths = {}
        self.modelVal = []

    def isBrick(self, file : str):
        return True

    @Slot(str, result=None)
    def addPath(self, path):
        resources = []
        unique_resources = []
        path = path.replace("file:///", "")

        if path in self.paths.keys():
            return

        files = os.listdir(path)
        for file in files:
            if ".svg" in file and self.isBrick(file):
                file = path + "/" + file
                resources.append(file)
                if file not in self.modelVal:
                    unique_resources.append(file)
        self.paths[path] = resources
        self._updateModel(self.modelVal + unique_resources)
        self.modelChanged.emit()


    @Slot(str, result=None)
    def removePath(self, path):
        path = path.replace("file:///", "")
        self.paths[path] = []
        model = []
        for path in self.paths.keys():
            model + self.paths[path]
        self._updateModel(model)


    def _getModel(self):
        return self.modelVal

    @Slot(list)
    def _updateModel(self, model):
        self.modelVal = model
        self.modelChanged.emit()

    @Signal
    def modelChanged(self):
        pass

    model = Property(list, _getModel, _updateModel, notify=modelChanged)
