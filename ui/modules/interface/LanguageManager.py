import json

from PySide6.QtCore import Slot, QObject, Property, Signal, QUrl
from PySide6.QtQml import QmlElement
from modules.ConstDefs import *
from modules.backend.SVGBrick import SVGBrick
from modules.Utility import removeFileStub, addFileStub

QML_IMPORT_NAME = "LanguageManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class LanguageManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self._path = ""
        self._target = ""
        self._model = []
        self._recursive = False
        self._loadSVG = True
        self._loadJSON = False
        self._JSONBricks = []
    @Slot()
    def refreshModel(self):
        """
        Refresh the model
        """
        self._setSourceFolder(self._path)

    def _setSourceFolder(self, folder):
        """
        Set the source folder of the model. Resets all the available bricks.
        Parameters
        ----------
        folder: folder of the model to be loaded
        """
        self._path = removeFileStub(folder)
        self._model.clear()
        self._JSONBricks.clear()
        for root, dirs, files in os.walk(self._path):
            if root in self._path or self._recursive:
                for file_name in files:
                    file_path = os.path.join(root, file_name)
                    if (SVG_EXT in file_path and self._loadSVG) or (JSON_EXT in file_path and self._loadJSON):
                        targetPath = os.path.join(self._target, file_name)
                        if not os.path.isfile(targetPath):
                            targetPath = ""
                        source_path = os.path.join(root, file_name)
                        if JSON_EXT in file_name and self._loadJSON:
                            brick = SVGBrick.fromJSON(json.load(open(os.path.join(root, file_name))))
                            self._JSONBricks.append(brick)
                            source_path = brick.getWorkingBrick()
                        self.model.append(
                            {
                                "sourcePath": addFileStub(source_path),
                                "sourceFile": file_name,
                                "targetPath": targetPath,
                            }
                        )
        self.modelChanged.emit()

    """Property getters, setters and notifiers"""

    def _setTargetFolder(self, folder):
        self._target = removeFileStub(folder)
        self._setSourceFolder(self._path)
        self.targetFolderChanged.emit()

    def _setRecursive(self, recursive):
        self._recursive = recursive
        self._setSourceFolder(self._path)
        self.loadRecursiveChanged.emit()
    def _setLoadSVG(self, value):
        self._loadSVG = value
        self.refreshModel()
    def _setLoadJSON(self, value):
        self._loadJSON = value
        self.refreshModel()

    def _getModel(self):
        return self._model

    def _getRecursive(self):
        return self._recursive

    def _getTargetFolder(self):
        return self._target

    @Signal
    def loadRecursiveChanged(self):
        pass

    @Signal
    def modelChanged(self):
        pass

    @Signal
    def sourceFolderChanged(self):
        pass

    @Signal
    def targetFolderChanged(self):
        pass

    loadRecursive = Property(
        bool, fget=_getRecursive, fset=_setRecursive, notify=loadRecursiveChanged
    )
    sourceFolder = Property(str, fset=_setSourceFolder, notify=sourceFolderChanged)
    model = Property(list, fget=_getModel, notify=modelChanged)
    loadSVG = Property(bool, fset=_setLoadSVG)
    loadJSON = Property(bool, fset=_setLoadJSON)
    targetFolder = Property(
        str, fget=_getTargetFolder, fset=_setTargetFolder, notify=targetFolderChanged
    )
