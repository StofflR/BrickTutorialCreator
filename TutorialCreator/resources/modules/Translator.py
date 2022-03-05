import copy
import json
import os
import logging

from PyQt5.QtWidgets import QFrame, QFileDialog, QTableWidgetItem, QHeaderView
from PyQt5 import QtCore
from resources.layout.translation import Ui_Dialog
from resources.modules.SVGBrick import SVGBrick


class TranslationUnit:
    def __init__(self, json_content):
        self.source_brick = copy.deepcopy(json_content)
        self.translation_brick = copy.deepcopy(json_content)


class Translator(Ui_Dialog, QFrame):
    def __init__(self, app):
        super(Translator, self).__init__()
        self.bricks = []
        self.app = app
        self.setupUi(self)
        self.preview_position = self.pos()
        self.updating = False
        self.export_folder = self.app.exportFolder
        self.text_path.setText(self.app.exportFolder.replace("/", "\\"))
        header = self.tableWidget.horizontalHeader()
        header.setSectionResizeMode(0, QHeaderView.Stretch)
        header.setSectionResizeMode(1, QHeaderView.Stretch)
        self.hide()
        pass

    def contentSelected(self, row, column):
        unit = self.bricks[row]
        self.app.applySettingsForJSON(unit.translation_brick)

    def exportLanguageChanged(self, language: str):
        export = self.export_folder + "/" + language
        self.app.text_path.setText(export)
        self.app.exportFolder = export

    def contentChanged(self, row, column):
        if self.updating:
            return

        self.tableWidget.resizeRowToContents(row)
        item = self.tableWidget.item(row, column)
        unit = self.bricks[row]
        logging.info("Content of cell " + str(row) + ":" + str(column) + " changed to " + item.text() + " from " + unit.translation_brick["content"])
        unit.translation_brick["content"] = item.text()
        plain_name = SVGBrick.fromJSON(unit.source_brick).contentPlain()
        print(plain_name)
        self.app.applySettingsForJSON(unit.translation_brick)
        self.app.save(self.text_language.text(), plain_name)

    def closeEvent(self, event) -> None:
        logging.debug("Translator closed!")
        self.app.check_translator.setCheckState(False)
        self.hide()
        event.accept()

    def getTranslationFolder(self):
        self.export_folder = QFileDialog.getExistingDirectory(None, "Select Folder to translate JSON Files")
        logging.info(self.export_folder + " selected")
        if self.export_folder == "":
            return

        self.exportLanguageChanged(self.text_language.text())

        self.bricks.clear()
        self.text_path.setText(self.export_folder)
        for file in os.listdir(self.export_folder):
            if ".json" in file:
                self.bricks.append(TranslationUnit(json.load(open(self.export_folder + "/" + file))))
        self.tableWidget.setRowCount(len(self.bricks))
        self.updating = True
        self.updateTable()
        self.updating = False

    def updateTable(self):
        for index, unit in enumerate(self.bricks):
            content = unit.source_brick["content"]
            source = QTableWidgetItem(content)
            source.setFlags(QtCore.Qt.ItemIsEnabled)
            self.tableWidget.setItem(index, 0, source)
            self.tableWidget.setItem(index, 1, QTableWidgetItem(content))
