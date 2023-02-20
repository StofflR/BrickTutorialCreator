from PySide6.QtCore import Slot, QObject
from PySide6.QtQml import QmlElement
from modules.ResourceManager import ResourceManager

QML_IMPORT_NAME = "BrickManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class BrickManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.resources = ResourceManager(file_type=".svg").getAvailable()

    @Slot(int, result=list)
    def at(self, index):
        if not self.resources:
            ret = None
        else:
            ret = self.resources[index].color
        return ret

    @Slot(int, result=list)
    def availableSizes(self, index):
        if not self.resources:
            elements = ""
        else:
            elements = self.resources[index].sizes.keys()
        elements = list(elements)
        elements.sort()
        return elements

    @Slot(result=list)
    def availableBricks(self):
        ret = []
        for element in self.resources:
            ret.append(element.color)
        return ret

    @Slot(int, str, result=str)
    def brickPath(self, index, size):
        if size in self.resources[index].sizes.keys():
            return self.resources[index].sizes[size]
        return ""

    @Slot()
    def reset(self):
        self.resources = ResourceManager(file_type=".svg").getAvailable()
