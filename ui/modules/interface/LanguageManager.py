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
        self._model = []

    @Signal
    def modelChanged(self):
        pass

    def _getModel(self):
        return self._model

    @Signal
    def sourceFolderChanged(self):
        pass

    @Slot()
    def refreshModel(self):
        self._setSourceFolder(self._path)

    def _setSourceFolder(self, folder):
        self._path = "".join(folder)
        self._model.clear()
        for root, dirs, files in os.walk(self._path):
            for file_name in files:
                file_path = os.path.join(root, file_name)
                if ".svg" in file_path:
                    self.model.append(
                        {
                            "sourcePath": OSDefs.FILE_STUB
                            + os.path.join(root, file_name),
                            "sourceFile": file_name,
                        }
                    )
        self.modelChanged.emit()

    sourceFolder = Property(list, fset=_setSourceFolder, notify=sourceFolderChanged)
    model = Property(list, fget=_getModel, notify=modelChanged)
