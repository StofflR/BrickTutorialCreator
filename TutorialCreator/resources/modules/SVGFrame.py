from resources.layout.brick_viewer import Ui_Frame
from PyQt5.QtWidgets import QFrame, QGraphicsScene
from PyQt5.QtSvg import QGraphicsSvgItem
from resources.modules.SVGBrick import SVGBrick
import logging


class SVGFrame(Ui_Frame, QFrame):
    def __init__(self, app):
        self.setup_finished = False
        self.app = app
        super(SVGFrame, self).__init__()
        self.setupUi(self)
        self.setFixedSize(self.size())
        self.preview_position = self.pos()
        self.setup_finished = True

    def closeEvent(self, event) -> None:
        logging.debug("Preview closed!")
        self.app.check_preview.setCheckState(False)
        self.hide()
        event.accept()

    def displayBrick(self, brick: SVGBrick):
        if not self.setup_finished:
            return

        scene = QGraphicsScene(self)
        path = brick.getWorkingBrick()
        logging.info("Displaying: " + str(path))
        item = QGraphicsSvgItem(path)
        scene.addItem(item)
        self.graphicsView.setScene(scene)
        pass


