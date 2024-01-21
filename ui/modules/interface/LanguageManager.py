from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
import os
import logging
import shutil

from sys import platform

import modules.OSDefs as OSDefs

QML_IMPORT_NAME = "LanguageManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class LanguageManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self._path = ""
        self._target = ""
        self._model = []

    @Signal
    def modelChanged(self):
        pass

    def _getModel(self):
        return self._model

    @Signal
    def sourceFolderChanged(self):
        pass

    @Signal
    def targetFolderChanged(self):
        pass

    def _setTargetFolder(self, folder):
        self._target = folder.replace(OSDefs.FILE_STUB, "")
        self._setSourceFolder(self._path)
        self.targetFolderChanged.emit()

    def _getTargetFolder(self):
        return self._target

    @Slot()
    def refreshModel(self):
        self._setSourceFolder(self._path)

    def _setSourceFolder(self, folder):
        self._path = folder.replace(OSDefs.FILE_STUB, "")
        self._model.clear()
        for root, dirs, files in os.walk(self._path):
            if root in self._path:
                for file_name in files:
                    file_path = os.path.join(root, file_name)
                    if ".svg" in file_path:
                        targetPath = os.path.join(self._target, file_name)
                        if not os.path.isfile(targetPath):
                            targetPath = ""
                        self.model.append(
                            {
                                "sourcePath": OSDefs.FILE_STUB
                                + os.path.join(root, file_name),
                                "sourceFile": file_name,
                                "targetPath": targetPath,
                            }
                        )
        self.modelChanged.emit()

    sourceFolder = Property(str, fset=_setSourceFolder, notify=sourceFolderChanged)
    model = Property(list, fget=_getModel, notify=modelChanged)
    targetFolder = Property(
        str, fget=_getTargetFolder, fset=_setTargetFolder, notify=targetFolderChanged
    )
