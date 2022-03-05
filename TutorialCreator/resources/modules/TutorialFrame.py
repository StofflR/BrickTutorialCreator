import logging

from PyQt5.QtWidgets import QFrame, QGraphicsScene, QGraphicsPixmapItem
from PyQt5.QtGui import QPixmap, QImage
from resources.layout.tutorial_viewer import Ui_Frame


class TutorialFrame(Ui_Frame, QFrame):
    def __init__(self):
        super(TutorialFrame, self).__init__()
        self.setupUi(self)
        self.show()
        self.scene = QGraphicsScene(self)
        self.graphicsView.setScene(self.scene)
        pass

    def clearScene(self):
        self.scene.clear()
        self.graphicsView.viewport().update()

    def display(self, image_path):
        self.scene.clear()
        logging.info("Displaying: " + str(image_path))
        item = QGraphicsPixmapItem(QPixmap.fromImage(QImage(image_path)))
        self.scene.addItem(item)
        self.graphicsView.viewport().update()
