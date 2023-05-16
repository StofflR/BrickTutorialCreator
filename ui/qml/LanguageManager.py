from PySide6.QtCore import Slot, QObject, Property, Signal, QStringListModel
from PySide6.QtQml import QmlElement
from PySide6.QtWidgets import QApplication, QDialog, QMainWindow, QPushButton, QDialogButtonBox
from modules.ResourceManager import ResourceManager
import os
import logging
import shutil

QML_IMPORT_NAME = "LanguageManager"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class LanguageManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self._path = ""

    @Slot(str)
    def newLanguage(self, newLanguage):
        file_path =  self._path.replace("file:///", "") + "/" + newLanguage
        logging.debug("Created new directory: " + file_path)
        os.makedirs(file_path, exist_ok=True)
        self.languagesChanged.emit()

    @Slot(str)
    def delete(self, language):
        file_path =  self._path.replace("file:///", "") + "/" + language
        shutil.rmtree(file_path)
        self.languagesChanged.emit()

    @Signal
    def languagesChanged(self):
        pass

    def _getLanguages(self):
        result = []
        file_path = self._path.replace("file:///", "")
        for root, dirs, files in os.walk(file_path):
            if(dirs not in result):
                result += dirs
        return result

    languages = Property(list, _getLanguages, notify=languagesChanged)

    @Signal
    def sourceModelChanged(self):
        pass

    def _getSourceModel(self):
        result = []
        file_path =  self._path.replace("file:///", "")

        if not file_path or not os.path.isdir(file_path):
            return result

        for element in os.listdir(file_path):
            if ".svg" in element:  # or ".json" in element:
                result.append(element)
        return result

    sourceModel = Property(list, _getSourceModel, notify=sourceModelChanged)

    @Signal
    def pathChanged(self):
        pass

    def _setPath(self, value):
        self._path = value
        self.languagesChanged.emit()
        self.sourceModelChanged.emit()

    def _getPath(self):
        return self._path

    path = Property(str, _getPath,
                            _setPath, notify=pathChanged)

    @Slot(str, result=bool)
    def exists(self, file):
        return os.path.isfile(file.replace("file:///", ""))
