from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
from PySide6.QtGui import QImage, QPainter
from modules.SVGBrick import SVGBrick
from typing import Dict, List
import logging
import json

QML_IMPORT_NAME = "TutorialManager"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class TutorialManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.bricks : Dict(str, SVGBrick)
        self.bricks = {}
        self.modelVal : List(str)
        self.modelVal = []
        self.tutorial: QImage
        self.tutorial = None

    @Slot(str)
    @Slot(str, int)
    def addBrick(self, path, index=None):
        if not ".json" in path:
            jsonText = SVGBrick.getJSONFromSVG(path.replace("file:///",""))
        else:
            jsonText = json.load(open(path.replace("file:///","")))
        brick = SVGBrick.fromJSON(jsonText)
        if ".json" in path:
            path = "file:///" + brick.getWorkingBrick()

        if not index:
            self.modelVal.append(path)
        else:
            self.modelVal.insert(index, path)

        self.bricks[path] = brick
        self.modelChanged.emit()

    @Slot( int)
    def removeBrick(self, index):
        path = self.modelVal.pop(index)
        if path not in self.model:
            self.bricks.pop(path)
        self.modelChanged.emit()

    @Slot(list)
    def _updateModel(self, model):
        self.modelVal = model

    @Slot(str)
    def saveTutorial(self, path):
        self.generateTutorial()
        logging.debug("Saving Tutorial to: " +path)
        self.tutorial.save(path.replace("file:///",""))

    def generateTutorial(self):
        self.bricks[self.modelVal[0]].savePNG(path=self.bricks[self.modelVal[0]].working_brick_.replace(".svg", ".png"), width=640)
        tutorial = QImage(self.bricks[self.modelVal[0]].working_brick_.replace(".svg", ".png"))

        for brick in self.modelVal[1::]:
            self.bricks[brick].savePNG(path=self.bricks[brick].working_brick_.replace(".svg", ".png"), width=640)
            b = QImage(self.bricks[brick].working_brick_.replace(".svg", ".png"))
            target = QImage(tutorial.width(),tutorial.height() + b.height() - int(tutorial.width()/55), QImage.Format_RGBA32FPx4)
            painter = QPainter(target)
            painter.drawImage(0,0,tutorial)
            painter.drawImage(0, tutorial.height() - int(tutorial.width()/55), b)
            tutorial = target
        self.tutorial = tutorial

    def _getModel(self):
        return self.modelVal

    @Signal
    def modelChanged(self):
        pass

    model = Property(list, _getModel,_updateModel, notify=modelChanged)

