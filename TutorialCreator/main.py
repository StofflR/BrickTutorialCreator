import os

# TODO: sometimes it might be necessary to link the specific dll path for cairosvg
# might only be necessary on specific python / windows versions .. Thanks windows .. :^)
if os.name == 'nt':
    os.add_dll_directory(r"C:/GTK2-Runtime/bin/")

from resources.modules.App import App
from resources.modules.TutorialCreator import TutorialCreator
from PyQt5 import QtWidgets
from PIL import Image

applications = {
    "1": ("Create Tutorial", TutorialCreator),
    "2": ("Create / Translate Bricks", App),
}
application_args = {
    "--tutorial": "1",
    "--brick": "2"
}


def getUserSelection(arg):
    if arg in application_args.keys():
        return applications[application_args[arg]][1]

    print("What do you want to do?:")
    for key in applications.keys():
        print("\t" + key + ": " + applications[key][0])
    selection = input("Which application (number)? ")
    if selection not in applications.keys():
        print("Invalid selection!")
        return getUserSelection("")
    return applications[selection][1]


if __name__ == "__main__":
    import sys

    arg = ""
    if len(sys.argv) > 1:
        arg = sys.argv[1]

    app = QtWidgets.QApplication(sys.argv)
    ui = getUserSelection(arg)()
    sys.exit(app.exec_())
