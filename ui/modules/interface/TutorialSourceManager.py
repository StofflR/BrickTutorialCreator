from PySide6.QtCore import Slot, QObject, Property, Signal
from PySide6.QtQml import QmlElement
from modules.backend.SVGBrick import SVGBrick
import logging
from modules.ConstDefs import *
from modules.Utility import removeFileStub

QML_IMPORT_NAME = "TutorialSourceManager"
QML_IMPORT_MAJOR_VERSION = 1


def addSorted(resources: list, brick: dict) -> None:
    """
    Helper function to sort bricks based on their color
    Parameters
    ----------
    resources: available resources
    brick: brick to be added based on color
    """
    base_path = os.path.join(DEF_BASE, brick["base_path"])
    for color in resources:
        if color["path"] == base_path:
            return color["elements"].append(brick)
    resources.append({"path": base_path, "elements": [brick]})


@QmlElement
class TutorialSourceManager(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.paths = {}
        self.modelVal = []
        self.allowForeignVal = False
        self.enableSorting = False
        self.typeModel = {}
        self.filter = ""

    def isBrick(self, file: str): # -> dict | bool:
        """
        Check if a given file is a brick
        Parameters
        ----------
        file: path to the file to be checked
        Returns
        -------
        False if no brick else json representation of the brick
        """
        is_brick = '<desc id="json" tag="brick">' in open(file, "r").read()
        if is_brick:
            return SVGBrick.getJSONFromSVG(file)

        if self.allowForeignVal:
            try:
                return SVGBrick.getJSONFromSVG(file)
            except Exception as _:
                logging.debug("Could not load svg: " + file)
        return False

    def findResources(self, path: str) -> (list, list):
        """
        Finds all available bricks which can be added to the tutorial
        Exclusion filters can be set in the model
        Parameters
        ----------
        path: path to be checked
        Returns
        -------
        resources, unique_resources -> all resources found, unique resources not yet in self.modelVal
        """
        resources = []
        unique_resources = []
        files = os.listdir(path)
        for file in files:
            file = os.path.join(path, file)
            if SVG_EXT in file:
                brick_data = self.isBrick(file)
                if brick_data:
                    brick = {"path": file, "is_brick": True}
                    brick_data["base_path"] = brick_data["path"]
                    brick_data.update(brick)
                    brick = brick_data

                    if self.filter == "" or (
                        "content" in brick.keys() and self.filter in brick["content"]
                    ):
                        if self.enableSorting:
                            addSorted(resources, brick)
                            unique_resources = resources.copy()
                        else:
                            resources.append(brick)
                            if file not in self.modelVal:
                                unique_resources.append(brick)
        return resources, unique_resources

    @Slot(str, result=None)
    def addPath(self, path: str) -> None:
        """
        Add a path to be included in file search
        Files are added to the resources and unique resources
        Parameters
        ----------
        path: path to be added
        """
        path = removeFileStub(path)

        if path in self.paths.keys():
            return

        resources, unique_resources = self.findResources(path)
        self.paths[path] = resources
        self._setModel(self.modelVal + unique_resources)
        self.modelChanged.emit()

    @Slot()
    def refresh(self) -> None:
        """
        Refresh the available bricks
        """
        model = []
        self.modelVal = []
        for path in self.paths.keys():
            resources, unique_resources = self.findResources(path)
            self.paths[path] = resources
            model = model + unique_resources
        self._setModel(model)

    @Slot(str, result=None)
    def removePath(self, path):
        """
        Remove path from the model. Refreshes the available bricks
        Parameters
        ----------
        path: path to be removed
        """
        path = removeFileStub(path)
        self.paths.pop(path, None)
        self.refresh()

    @Slot(str)
    def setFilter(self, text):
        """
        Set the filter for file exclusion. refreshes the model
        Parameters
        ----------
        text: the text to be searched for
        """
        self.filter = text
        self.refresh()

    """Property getters, setters and notifiers"""

    def _getModel(self):
        return self.modelVal

    def _getAllowForeign(self):
        return self.allowForeignVal

    def _getSorting(self):
        return self.enableSorting

    @Slot(list)
    def _setModel(self, model):
        self.modelVal = model
        self.modelChanged.emit()

    @Slot(bool)
    def _setAllowForeign(self, allow):
        self.allowForeignVal = allow
        self.foreignChanged.emit()

    @Slot(bool)
    def _setSorting(self, allow):
        self.enableSorting = allow
        self.refresh()

    @Signal
    def modelChanged(self):
        pass

    @Signal
    def foreignChanged(self):
        pass

    @Signal
    def sortingChanged(self):
        pass

    model = Property(list, _getModel, _setModel, notify=modelChanged)
    allowForeign = Property(
        bool, _getAllowForeign, _setAllowForeign, notify=foreignChanged
    )
    sorted = Property(bool, _getSorting, _setSorting, notify=sortingChanged)
