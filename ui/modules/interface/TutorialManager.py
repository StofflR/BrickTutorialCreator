import os

from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
from PySide6.QtGui import QImage, QPainter, QColor
from modules.backend.SVGBrick import SVGBrick
from typing import Dict, List
import logging
import json
import modules.OSDefs as OSDefs
from modules.ConstDefs import *
from modules.Utility import addFileStub, removeFileStub

QML_IMPORT_NAME = "TutorialManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class TutorialManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.modelVal: List[SVGBrick]
        self.modelVal = []
        self.tutorial: QImage
        self.tutorial = None
        self.ccby = False

    @Slot(str)
    @Slot(str, int)
    def addBrick(self, path, index=-1):
        """
        Slot to add bricks to the tutorial. If no index is given, the brick is appended.
        Parameters
        ----------
        path: path of the brick to be added
        index: index of where to insert the brick
        """
        input_path = removeFileStub(path)
        if JSON_EXT not in path:
            json_text = SVGBrick.getJSONFromSVG(input_path)
        else:
            json_text = json.load(open(input_path))
        brick = SVGBrick.fromJSON(json_text)
        if JSON_EXT in path:
            path = addFileStub(brick.getWorkingBrick())

        if index == -1:
            self.modelVal.append(brick)
        else:
            self.modelVal.insert(index, brick)

        self.modelChanged.emit()

    @Slot(str)
    def toJSON(self, path):
        """
        Save the tutorial as a JSON file.
        Parameters
        ----------
        path: path where to store the JSON file
        """
        content = []

        if self.ccby:
            self.addBrick(os.path.join(addFileStub(DEF_RESOURCE), "ccbysa.svg"))

        for brick in self.modelVal:
            content.append(brick.toJSON())

        if self.ccby:
            self.removeBrick(len(self.modelVal) - 1)

        pre, _ = os.path.splitext(removeFileStub(path))
        f = open(pre + JSON_EXT, "w")
        f.write(json.dumps(content))
        f.close()

    @Slot(str)
    def toPNG(self, path):
        """
        Save the tutorial as a PNG file.
        Parameters
        ----------
        path: path where to store the PNG file
        """
        pre, _ = os.path.splitext(removeFileStub(path))
        self.generateTutorial()
        self.tutorial.save(pre + PNG_EXT)

    @Slot()
    def clear(self):
        """
        Resetting and clearing the tutorial.
        """
        self.modelVal.clear()
        self.modelChanged.emit()

    @Slot(str, result=str)
    def fromJSON(self, path):
        """
        Load a tutorial from a JSON file.
        Parameters
        ----------
        path: file from where to load the tutorial
        """
        self.modelVal.clear()

        content = json.load(open(removeFileStub(path)))
        for element in content:
            svg_brick = SVGBrick.fromJSON(json.loads(element))
            self.modelVal.append(brick_path)

        # restore ccby status
        json_text = SVGBrick.getJSONFromSVG(os.path.join(DEF_RESOURCE, "ccbysa.svg"))
        brick = SVGBrick.fromJSON(json_text)
        if brick.contentPlain() == svg_brick.contentPlain():
            self._setCCBY(True)
            self.modelVal.pop()
        else:
            self._setCCBY(False)

        self.ccByChanged.emit()
        self.modelChanged.emit()

        filename_w_ext = os.path.basename(removeFileStub(path))
        filename, file_extension = os.path.splitext(filename_w_ext)
        return filename

    @Slot(int)
    def removeBrick(self, index):
        """
        Remove brick from the tutorial at the given index.
        Parameters
        ----------
        index: index of the brick to be removed
        """
        self.modelVal.pop(index)
        self.modelChanged.emit()

    @Slot(str, result=str)
    def saveTutorial(self, path):
        """
        Store the tutorial to the given path.
        Parameters
        ----------
        path: path to save the tutorial to
        """
        path = removeFileStub(path)
        pre, _ = os.path.splitext(path)
        _, error = os.path.splitext(pre)
        if error:
            return None
        if PNG_EXT in path:
            self.toPNG(pre)
        elif JSON_EXT in path:
            self.toJSON(pre)
        else:
            return logging.debug("Could not save Tutorial to: " + path)
        logging.debug("Saving Tutorial to: " + path)
        filename_w_ext = os.path.basename(pre)
        filename, file_extension = os.path.splitext(filename_w_ext)
        return filename

    def generateTutorial(self):
        """
        Create tutorial from all bricks added
        """
        del self.tutorial
        self.tutorial = None
        if self.ccby:
            self.addBrick(os.path.join(addFileStub(DEF_RESOURCE), "ccbysa.svg"))
        self.modelVal[0].savePNG(
            path=self.modelVal[0].working_brick_.replace(SVG_EXT, PNG_EXT),
            width=PNG_WIDTH_TUTORIAL,
        )
        tutorial = QImage(self.modelVal[0].working_brick_.replace(SVG_EXT, PNG_EXT))

        for brick in self.modelVal[1::]:
            brick.savePNG(
                path=brick.working_brick_.replace(SVG_EXT, PNG_EXT),
                width=PNG_WIDTH_TUTORIAL,
            )
            b = QImage(brick.working_brick_.replace(SVG_EXT, PNG_EXT))
            target = QImage(
                tutorial.width(),
                tutorial.height() + b.height() - int(tutorial.width() / 55),
                QImage.Format_RGBA32FPx4,
            )
            target.fill(QColor(0, 0, 0, 0))
            painter = QPainter(target)
            painter.drawImage(0, 0, tutorial)
            painter.drawImage(0, tutorial.height() - int(tutorial.width() / 55), b)
            tutorial = target
        if self.ccby:
            self.removeBrick(len(self.modelVal) - 1)
        self.tutorial = tutorial

    """Property getters, setters and notifiers"""

    def _getModel(self):
        return self.modelVal

    def _getCCBY(self):
        return self.ccby

    @Slot(list)
    def _setModel(self, model):
        self.modelVal = model

    def _setCCBY(self, value):
        self.ccby = value

    @Signal
    def modelChanged(self):
        pass

    @Signal
    def ccByChanged(self):
        pass

    enableCCBY = Property(bool, _getCCBY, _setCCBY, notify=ccByChanged)
    model = Property(list, _getModel, _setModel, notify=modelChanged)
