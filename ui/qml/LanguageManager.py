from PySide6.QtCore import Slot, QObject, Property, Signal, QStringListModel
from PySide6.QtQml import QmlElement
from PySide6.QtWidgets import QApplication, QDialog, QMainWindow, QPushButton, QDialogButtonBox
from modules.ResourceManager import ResourceManager
import os
import logging

QML_IMPORT_NAME = "LanguageManager"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class LanguageManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.model = []
        self._currentIndex = -1

    @Slot(str, str)
    def new(self, path, newLanguage):
        path = path.replace("file:///", "") + "/"+newLanguage
        logging.debug("Created new directory: " + path)
        os.makedirs(path, exist_ok=True)

    @Slot(str, str)
    def delete(self, path, language):
        path = path.replace("file:///", "") + "/"+language
        logging.debug("Deleting language located in: " + path)
        self._currentIndex = self._currentIndex - 1
        def delete(path):
            print(path)
            for root, dirs, files in os.walk(path):
                for name in files:
                    os.remove(os.path.join(root, name))
                for name in dirs:
                    delete(os.path.join(root, name))
                    os.rmdir(os.path.join(root, name))
                os.rmdir(root)
        delete(path)

    def _setCurrentIndex(self, value):
        self._currentIndex = value

    def _getCurrentIndex(self):
        return self._currentIndex

    @Signal
    def currentIndexChanged(self):
        pass

    currentIndex = Property(int, _getCurrentIndex,
                            _setCurrentIndex, notify=currentIndexChanged)

    @Slot(str, result=list)
    def languages(self, path):
        result = []
        path = path.replace("file:///", "")
        for root, dirs, files in os.walk(path):
            result += dirs
        result.append("New …")
        return result

    @Slot(str, result=list)
    def sourceModel(self, path):
        result = []
        path = path.replace("file:///", "")

        if not path or not os.path.isdir(path):
            return result
        for element in os.listdir(path):
            if ".svg" in element:  # or ".json" in element:
                result.append(element)
        return result

    @Slot(str, result=bool)
    def exists(self, file):
        return os.path.isfile(file.replace("file:///", ""))
