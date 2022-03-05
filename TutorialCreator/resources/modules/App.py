import json
import logging
import os

from PyQt5.QtCore import QPoint

from resources.layout.BrickDesigner import Ui_Dialog
from PyQt5.QtWidgets import QDialogButtonBox, QFileDialog, QFrame, QMessageBox

from resources.modules.InformationDialog import InformationDialog
from resources.modules.ResourceManager import ResourceManager, DEFAULT_PATH as RESOURCE_PATH
from resources.modules.SVGFrame import SVGFrame
from threading import Lock
from resources.modules.SVGBrick import SVGBrick, DEF_TMP as DEFAULT_TMP
from resources.modules.Translator import Translator


class App(Ui_Dialog, QFrame):
    def __init__(self):
        super(App, self).__init__()
        self.bricks = []
        self.exportFolder = os.getcwd() + "/export"

        self.svg_viewer_updating = Lock()
        self.setup_finished = False

        self.loadAvailableResources()

        self.setupUi(self)
        self.displayAvailableBricks()
        self.svg_brick = self.generateBrickFromSettings()

        self.svg_frame = SVGFrame(app=self)
        self.translator = Translator(app=self)
        self.translator.setFixedSize(self.translator.size())
        self.svg_frame.preview_position = QPoint(0, self.translator.height())
        self.svg_frame.move(0, self.translator.height())

        if self.check_preview.isChecked():
            self.svg_frame.show()

        for button in buttons:
            self.buttonBox.addButton(button, QDialogButtonBox.ActionRole)

        self.setFixedSize(self.size())
        self.text_path.setText(self.exportFolder.replace("/", "\\"))
        self.setup_finished = True
        self.updateSVGFrame()
        self.show()
        pass

    def preview(self, toggle):
        if toggle:
            self.svg_frame.move(self.svg_frame.preview_position)
            self.svg_frame.show()
        else:
            self.svg_frame.preview_position = self.svg_frame.pos()
            self.svg_frame.hide()

    def showTranslator(self, toggle):
        if toggle:
            self.translator.move(self.translator.preview_position)
            self.translator.show()
        else:
            self.translator.preview_position = self.translator.pos()
            self.translator.hide()

    def closeEvent(self, event) -> None:
        self.svg_frame.close()
        self.translator.close()
        event.accept()

    def __del__(self):
        logging.debug("removing tmp files")
        if not os.path.isdir(DEFAULT_TMP):
            return
        for file in os.listdir(DEFAULT_TMP):
            os.remove(DEFAULT_TMP + file)

    def contentChanged(self):
        self.updateSVGFrame()

    @staticmethod
    def convertFolder():
        folder = QFileDialog.getExistingDirectory(None, "Select Folder to convert SVGs")

        if folder == "":
            return

        logging.info(folder + " selected")
        for file in os.listdir(folder):
            if ".svg" in file:
                SVGBrick.convertSVG(folder + "/" + file)

    def brickChanged(self):
        self.updateSVGFrame()

    def updateSVGFrame(self, generate_brick=True):
        if not self.setup_finished:
            return
        self.svg_viewer_updating.acquire()
        logging.info("Updating SVG Frame")
        if generate_brick:
            self.svg_brick = self.generateBrickFromSettings()
        self.svg_frame.displayBrick(self.svg_brick)
        self.svg_viewer_updating.release()

    def changeExportFolder(self):
        folder = QFileDialog.getExistingDirectory(None, "Select Folder to export Files")
        if folder == "":
            return
        self.exportFolder = folder
        self.text_path.setText(self.exportFolder.replace("/", "\\"))

    def sizeChanged(self):
        text = self.box_bricks.currentText()
        self.displayAvailableBricks(text)
        self.updateSVGFrame()

    def scaleChanged(self):
        self.updateSVGFrame()

    def loadAvailableResources(self):
        resource_manager = ResourceManager(file_type=".svg")
        self.bricks = resource_manager.getAvailable()

    def help(self):
        InformationDialog.helpBrick()

    def save(self, suffix=None, name=None):
        if name is None:
            name = self.svg_brick.contentPlain()
        if suffix:
            name += "_" + suffix
        if not os.path.isdir(self.exportFolder):
            os.mkdir(self.exportFolder)
        if self.check_png.isChecked():
            png_folder = self.exportFolder + "/png/"
            if not os.path.isdir(png_folder):
                os.mkdir(png_folder)
            self.svg_brick.savePNG(png_folder + name, width=640)
        if self.check_svg.isChecked():
            svg_folder = self.exportFolder + "/svg/"
            if not os.path.isdir(svg_folder):
                os.mkdir(svg_folder)
            self.svg_brick.save(svg_folder + name)
        if self.check_json.isChecked():
            json_folder = self.exportFolder + "/json/"
            if not os.path.isdir(json_folder):
                os.mkdir(json_folder)
            self.svg_brick.toJSON(json_folder + name)

    def buttonPressed(self, button):
        buttons[button.text()](self)

    def displayAvailableBricks(self, previous=None):
        size = self.box_size.value()
        self.box_bricks.clear()
        for index, element in enumerate(self.bricks):
            if str(size) + "h" in element.sizes.keys():
                self.box_bricks.addItem(element.color)

        if previous is not None:
            index = self.box_bricks.findText(previous)
            if index == -1:
                self.box_bricks.setCurrentIndex(0)
            else:
                self.box_bricks.setCurrentIndex(index)

    def about(self):
        InformationDialog.about()

    def generateBrickFromSettings(self):
        color = self.box_bricks.currentText()
        brick = [brick for i, brick in enumerate(self.bricks) if brick.color == color]
        if len(brick) == 0:
            brick = self.bricks[0]
        else:
            brick = brick[0]
        size = self.box_size.value()
        path = brick.sizes[str(size) + "h"]
        path = os.getcwd() + "/" + RESOURCE_PATH + "/" + path
        if ".ai" in path:
            path = path.replace(".ai", ".svg")
        return SVGBrick(base_type=color, content=self.text_content.toPlainText(), size=size, path=path,
                        scaling_factor=self.box_scale.value() / 100)

    def applySettingsForJSON(self, json_content):
        self.svg_brick = SVGBrick.fromJSON(json_content)
        self.box_scale.setValue(self.svg_brick.scaling_factor * 100)
        self.box_size.setValue(int(json_content["size"]))
        self.text_content.setPlainText(json_content["content"])
        self.displayAvailableBricks(json_content["base_type"])
        self.updateSVGFrame(False)

    def loadFromJSON(self):
        file, tag = QFileDialog.getOpenFileName(None, 'Load from JSON file.. ', "", "JSON Source File (*.json);; SVG (*.svg)")

        if file[0] == "":
            return

        path = os.path.dirname(file)
        parent_path = os.path.dirname(path)
        json_text = ""

        if "json" in tag:
            if "json" in path.replace(parent_path, ""):
                path = parent_path
            json_text = json.load(open(file))

        elif "svg" in tag:
            if "svg" in path.replace(parent_path, ""):
                path = parent_path
            json_text = SVGBrick.getJSONFromSVG(file)

        if json_text == "":
            logging.info("Error loading JSON from: " + file)
            QMessageBox.critical(
                self,
                "Could not load from SVG!",
                "Something went very wrong.",
                buttons=QMessageBox.Ok,
                defaultButton=QMessageBox.Ok)
            return

        logging.info("Loading JSON from: " + file)
        self.exportFolder = path
        self.applySettingsForJSON(json_text)


buttons = {
    "Convert Folder": App.convertFolder,
    "Save": App.save,
    "Help": App.help,
    "About": App.about
}
