import json

from PyQt5.QtGui import QDropEvent
from PyQt5.QtWidgets import QListWidgetItem, QFileDialog
import logging

from PyQt5.QtGui import QPixmap, QImage
from PyQt5.QtWidgets import QFrame, QDialogButtonBox, QGraphicsScene, QGraphicsPixmapItem
from resources.layout.tutorial_creator import Ui_Dialog
from resources.modules.InformationDialog import InformationDialog
from resources.modules.TutorialFrame import TutorialFrame
from resources.modules.App import App as Creator
from resources.modules.SVGBrick import SVGBrick, randomString
from threading import Lock
from PIL import Image
from typing import List


class Tutorial:
    def __init__(self, image, path):
        self.image = image
        self.path = path
        if self.path is None:
            self.path = randomString(10) + ".png"

    def save(self, path=None):
        if path is None:
            path = self.path
        if ".png" not in path:
            path = path + ".png"
        self.image.save(path)


class BrickInformation(QListWidgetItem):
    def __init__(self, brick: SVGBrick):
        representation = brick.contentPlain()
        if representation == "":
            representation = "(empty brick)"
        super(BrickInformation, self).__init__(representation)
        self.brick = brick
        self.content = self.brick.toJSON()
        self.png = self.brick.savePNG(self.brick.getWorkingBrick())


class TutorialCreator(Ui_Dialog, QFrame):
    def __init__(self):
        super(TutorialCreator, self).__init__()
        self.tutorial = Tutorial(None, None)
        self.update_lock = Lock()
        self.needs_update = False

        self.setupUi(self)

        # Hijacking drop event :)
        self.drop_callback = self.tutorial_list.dropEvent
        self.tutorial_list.dropEvent = self.dropEvent

        self.tutorial_viewer = TutorialFrame()
        self.tutorial_viewer.closeEvent = self.previewCallback
        self.tutorial_viewer.previous_pos = self.tutorial_viewer.pos()

        self.creator = Creator()
        self.creator_exited = self.creator.closeEvent
        self.creator.closeEvent = self.creatorCallback
        self.creator.previous_pos = self.creator.pos()

        self.creator.buttonBox.hide()
        self.creator.check_translator.hide()

        for button in buttons:
            self.buttonBox.addButton(button, QDialogButtonBox.ActionRole)

        self.show()

    def buttonPressed(self, button):
        buttons[button.text()](self)

    def update(self):
        if self.update_lock.acquire(blocking=False):
            if self.tutorial_list.count() == 0:
                self.tutorial_viewer.clearScene()
                self.update_lock.release()
                return
            bricks = []
            for index in range(self.tutorial_list.count()):
                bricks.append(self.tutorial_list.item(index).brick)
            self.updateTutorial(bricks)
        else:
            self.needs_update = True

    def closeEvent(self, event) -> None:
        self.creator.close()
        self.tutorial_viewer.close()

    def creatorCallback(self, event):
        self.checkBox.setChecked(False)
        self.creator_exited(event)

    def previewCallback(self, event):
        self.checkBox_2.setChecked(False)
        event.accept()

    def load(self):
        file, tag = QFileDialog.getOpenFileName(None, 'Load from JSON file.. ', "", "JSON Source File (*.json)")
        content = json.load(open(file, "r"))
        for brick in content:
            info = BrickInformation(SVGBrick.fromJSON(json.loads(brick)))
            self.tutorial_list.addItem(info)
        self.update()

    def about(self):
        InformationDialog.about()

    def help(self):
        InformationDialog.helpTutorial()

    def exportJSON(self):
        export = []
        for index in range(self.tutorial_list.count()):
            brick: SVGBrick
            brick = self.tutorial_list.item(index).brick
            export.append(brick.JSON())
        out_file = open(self.creator.exportFolder+"/"+self.lineEdit.text()+".json", "w")
        json.dump(export, out_file)

    def findExisting(self):
        file, tag = QFileDialog.getOpenFileName(None, 'Load from JSON file.. ', "", "JSON Source File (*.json);; SVG (*.svg)")
        if "json" in tag:
            content = json.load(open(file, "r"))
        else:
            content = SVGBrick.getJSONFromSVG(file)
        info = BrickInformation(SVGBrick.fromJSON(content))
        self.tutorial_list.insertItem(self.getIndex(), info)
        self.update()

    def delete(self):
        for item in self.tutorial_list.selectedItems():
            self.tutorial_list.takeItem(self.tutorial_list.row(item))
        self.update()
        pass

    def save(self):
        path = self.creator.text_path.text()
        path += "/" + self.lineEdit.text()
        if ".png" not in path:
            path += ".png"
        self.tutorial.save(path)
        self.exportJSON()
        pass

    def addNew(self):

        info = BrickInformation(self.creator.svg_brick)
        self.tutorial_list.insertItem(self.getIndex(), info)
        self.update()
        pass

    def updateTutorial(self, bricks: List[SVGBrick]):
        logging.debug("Updating Tutorial!")
        bricks[0].savePNG(path=bricks[0].working_brick_.replace(".svg", ".png"), width=640)
        tutorial = Image.open(bricks[0].working_brick_.replace(".svg", ".png"))

        for brick in bricks[1::]:
            brick.savePNG(path=brick.working_brick_.replace(".svg", ".png"), width=640)
            b = Image.open(brick.working_brick_.replace(".svg", ".png"))
            size = (tutorial.size[0], tutorial.size[1] + b.size[1] - 16)
            target = Image.new("RGBA", size)

            target.alpha_composite(tutorial)
            target.paste(b, (0, tutorial.size[1] - 16), b)
            tutorial = target

        self.tutorial = Tutorial(tutorial, "resources/tmp/" + randomString(10))
        self.tutorial.save()
        self.update_lock.release()
        self.displayTutorial()
        if self.needs_update:
            self.needs_update = False
            self.update()

    def dropEvent(self, a0: QDropEvent) -> None:
        self.drop_callback(a0)
        self.update()

    def toggleCreator(self):
        if self.checkBox.isChecked():
            self.creator.move(self.creator.previous_pos)
            self.creator.show()
        else:
            self.creator.hide()
            self.creator.previous_pos = self.creator.pos()

    def togglePreview(self):
        if self.checkBox_2.isChecked():
            self.tutorial_viewer.move(self.tutorial_viewer.previous_pos)
            self.tutorial_viewer.show()
        else:
            self.tutorial_viewer.hide()
            self.tutorial_viewer.previous_pos = self.tutorial_viewer.pos()

    def displayTutorial(self):
        self.tutorial_viewer.display(self.tutorial.path)

    def getIndex(self):
        index = self.tutorial_list.currentIndex().row()
        if index < 0:
            index = self.tutorial_list.count()
        return index + 1


buttons = {
    "Add New": TutorialCreator.addNew,
    "Add from existing": TutorialCreator.findExisting,
    "Save to export path": TutorialCreator.save,
    "Load from ..": TutorialCreator.load,
    "Delete": TutorialCreator.delete,
    "Help": TutorialCreator.help,
    "About": TutorialCreator.about
}
