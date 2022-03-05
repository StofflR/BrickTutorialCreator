from PyQt5.QtWidgets import QMessageBox


class InformationDialog(QMessageBox):
    def __init__(self):
        super(InformationDialog, self).__init__()
    
    @classmethod
    def about(cls):
        box = cls()
        box.setIcon(QMessageBox.Information)
        box.setText("about information")
        box.setWindowTitle("About")
        box.setStandardButtons(QMessageBox.Ok)
        box.exec()

    @classmethod
    def helpTutorial(cls):
        box = cls()
        box.setIcon(QMessageBox.Information)
        box.setText("help tutorial")
        box.setWindowTitle("Help")
        box.setStandardButtons(QMessageBox.Ok)
        box.exec()

    @classmethod
    def helpBrick(cls):
        box = cls()
        box.setIcon(QMessageBox.Information)
        box.setText("Variables:\n\t$ some sample var $\t\nNew Line:\n\t\\\\\t\nDropdown:\n\t* some sample var \\\\\t")
        box.setWindowTitle("Help")
        box.setStandardButtons(QMessageBox.Ok)
        box.exec()