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
        self.bricks: Dict[str, SVGBrick]
        self.bricks = {}
        self.modelVal: List[str]
        self.modelVal = []
        self.tutorial: QImage
        self.tutorial = None
        self.ccby = False

    def _getCCBY(self):
        return self.ccby

    def _setCCBY(self, value):
        self.ccby = value

    @Signal
    def ccByChanged(self):
        pass

    @Slot(str)
    @Slot(str, int)
    def addBrick(self, path, index=None):
        if JSON_EXT not in path:
            json_text = SVGBrick.getJSONFromSVG(removeFileStub(path))
        else:
            json_text = json.load(open(removeFileStub(path)))
        brick = SVGBrick.fromJSON(json_text)
        if JSON_EXT in path:
            path = addFileStub(brick.getWorkingBrick())

        if not index:
            self.modelVal.append(path)
        else:
            self.modelVal.insert(index, path)

        self.bricks[path] = brick
        self.modelChanged.emit()

    @Slot(str)
    def toJSON(self, path):
        content = []

        if self.ccby:
            self.addBrick(os.path.join(addFileStub(DEF_RESOURCE), "ccbysa.svg"))

        for brick in self.modelVal:
            content.append(self.bricks[brick].toJSON())

        if self.ccby:
            self.removeBrick(len(self.bricks) - 1)

        pre, _ = os.path.splitext(removeFileStub(path))
        f = open(pre + JSON_EXT, "w")
        f.write(json.dumps(content))
        f.close()

    @Slot(str)
    def toPNG(self, path):
        pre, _ = os.path.splitext(removeFileStub(path))
        self.generateTutorial()
        self.tutorial.save(pre + PNG_EXT)

    @Slot()
    def clear(self):
        self.modelVal.clear()
        self.bricks.clear()
        self.modelChanged.emit()

    @Slot(str, result=str)
    def fromJSON(self, path):
        self.modelVal.clear()
        self.bricks.clear()
        content = json.load(open(removeFileStub(path)))
        for element in content:
            svg_brick = SVGBrick.fromJSON(json.loads(element))
            brick_path = addFileStub(svg_brick.getWorkingBrick())
            self.modelVal.append(brick_path)
            self.bricks[brick_path] = svg_brick

        json_text = SVGBrick.getJSONFromSVG(os.path.join(DEF_RESOURCE, "ccbysa.svg"))
        brick = SVGBrick.fromJSON(json_text)
        if brick.contentPlain() == svg_brick.contentPlain():
            self._setCCBY(True)
            self.modelVal.pop()
            self.bricks.pop(brick_path)
        else:
            self._setCCBY(False)

        self.ccByChanged.emit()
        self.modelChanged.emit()

        filename_w_ext = os.path.basename(removeFileStub(path))
        filename, file_extension = os.path.splitext(filename_w_ext)
        return filename

    @Slot(int)
    def removeBrick(self, index):
        path = self.modelVal.pop(index)
        if path not in self.model:
            self.bricks.pop(path)
        self.modelChanged.emit()

    @Slot(list)
    def _updateModel(self, model):
        self.modelVal = model

    @Slot(str, result=str)
    def saveTutorial(self, path):
        pre, ext = os.path.splitext(removeFileStub(path))
        _, error = os.path.splitext(pre)
        if error:
            return None
        print(pre, ext)
        if "png" in ext:
            logging.debug("Saving Tutorial to: " + pre + PNG_EXT)
            self.toPNG(pre)
        elif "json" in ext:
            logging.debug("Saving Tutorial to: " + pre + JSON_EXT)
            self.toJSON(pre)
        filename_w_ext = os.path.basename(pre)
        filename, file_extension = os.path.splitext(filename_w_ext)
        return filename

    def generateTutorial(self):
        del self.tutorial
        self.tutorial = None
        if self.ccby:
            self.addBrick(os.path.join(addFileStub(DEF_RESOURCE), "ccbysa.svg"))
        self.bricks[self.modelVal[0]].savePNG(
            path=self.bricks[self.modelVal[0]].working_brick_.replace(SVG_EXT, PNG_EXT),
            width=PNG_WIDTH_TUTORIAL,
        )
        tutorial = QImage(
            self.bricks[self.modelVal[0]].working_brick_.replace(SVG_EXT, PNG_EXT)
        )

        for brick in self.modelVal[1::]:
            self.bricks[brick].savePNG(
                path=self.bricks[brick].working_brick_.replace(SVG_EXT, PNG_EXT),
                width=PNG_WIDTH_TUTORIAL,
            )
            b = QImage(self.bricks[brick].working_brick_.replace(SVG_EXT, PNG_EXT))
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
            self.removeBrick(len(self.bricks) - 1)
        self.tutorial = tutorial

    def _getModel(self):
        return self.modelVal

    @Signal
    def modelChanged(self):
        pass

    enableCCBY = Property(bool, _getCCBY, _setCCBY, notify=ccByChanged)
    model = Property(list, _getModel, _updateModel, notify=modelChanged)
