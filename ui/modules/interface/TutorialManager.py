import os

from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
from PySide6.QtGui import QImage, QPainter, QColor
from modules.backend.SVGBrick import SVGBrick
from typing import Dict, List
import logging
import json
import modules.OSDefs as OSDefs

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

    enableCCBY = Property(bool, _getCCBY, _setCCBY, notify=ccByChanged)

    @Slot(str)
    @Slot(str, int)
    def addBrick(self, path, index=None):
        if ".json" not in path:
            json_text = SVGBrick.getJSONFromSVG(path.replace(OSDefs.FILE_STUB, ""))
        else:
            json_text = json.load(open(path.replace(OSDefs.FILE_STUB, "")))
        brick = SVGBrick.fromJSON(json_text)
        if ".json" in path:
            path = OSDefs.FILE_STUB + brick.getWorkingBrick()

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
            self.addBrick(OSDefs.FILE_STUB + os.getcwd() + "/resources/ccbysa.svg")

        for brick in self.modelVal:
            content.append(self.bricks[brick].toJSON())

        if self.ccby:
            self.removeBrick(len(self.bricks) - 1)

        pre, _ = os.path.splitext(path.replace(OSDefs.FILE_STUB, ""))
        f = open(pre + ".json", "w")
        f.write(json.dumps(content))
        f.close()

    @Slot(str)
    def toPNG(self, path):
        pre, _ = os.path.splitext(path.replace(OSDefs.FILE_STUB, ""))
        self.generateTutorial()
        self.tutorial.save(pre + ".png")

    @Slot()
    def clear(self):
        self.modelVal.clear()
        self.bricks.clear()
        self.modelChanged.emit()

    @Slot(str, result=str)
    def fromJSON(self, path):
        self.modelVal.clear()
        self.bricks.clear()
        content = json.load(open(path.replace(OSDefs.FILE_STUB, "")))
        for element in content:
            svg_brick = SVGBrick.fromJSON(json.loads(element))
            brick_path = OSDefs.FILE_STUB + svg_brick.getWorkingBrick()
            self.modelVal.append(brick_path)
            self.bricks[brick_path] = svg_brick

        json_text = SVGBrick.getJSONFromSVG(os.getcwd() + "/resources/ccbysa.svg")
        brick = SVGBrick.fromJSON(json_text)
        if brick.contentPlain() == svg_brick.contentPlain():
            self._setCCBY(True)
            self.modelVal.pop()
            self.bricks.pop(brick_path)
        else:
            self._setCCBY(False)

        self.ccByChanged.emit()
        self.modelChanged.emit()

        filename_w_ext = os.path.basename(path.replace(OSDefs.FILE_STUB, ""))
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
        pre, ext = os.path.splitext(path.replace(OSDefs.FILE_STUB, ""))
        _, error = os.path.splitext(pre)
        if error:
            return None
        print(pre, ext)
        if "png" in ext:
            logging.debug("Saving Tutorial to: " + pre + ".png")
            self.toPNG(pre)
        elif "json" in ext:
            logging.debug("Saving Tutorial to: " + pre + ".json")
            self.toJSON(pre)
        filename_w_ext = os.path.basename(pre)
        filename, file_extension = os.path.splitext(filename_w_ext)
        return filename

    def generateTutorial(self):
        del self.tutorial
        self.tutorial = None
        if self.ccby:
            self.addBrick(OSDefs.FILE_STUB + os.getcwd() + "/resources/ccbysa.svg")
        self.bricks[self.modelVal[0]].savePNG(
            path=self.bricks[self.modelVal[0]].working_brick_.replace(".svg", ".png"),
            width=640,
        )
        tutorial = QImage(
            self.bricks[self.modelVal[0]].working_brick_.replace(".svg", ".png")
        )

        for brick in self.modelVal[1::]:
            self.bricks[brick].savePNG(
                path=self.bricks[brick].working_brick_.replace(".svg", ".png"),
                width=640,
            )
            b = QImage(self.bricks[brick].working_brick_.replace(".svg", ".png"))
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

    model = Property(list, _getModel, _updateModel, notify=modelChanged)