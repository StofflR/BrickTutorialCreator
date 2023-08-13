import QtQuick 2.0
import QtQml 2.0
import Qt.labs.platform 1.1
import Converter 1.0

import "views"

Item {
    id: root
    signal converted(var count)
    Converter {
        id: converter
    }

    BatchBrickDialog {
        id: batchBrickDialog
        onFinished: count => root.converted(count)
        onConverted: target => root.converted(target)

        modal: true
        converter: converter
    }

    FolderDialog {
        id: folderDialog
        property string mode
        onAccepted: {
            if (mode === "SP")
                converted(converter.fromSVGtoPNG(folder))
            if (mode === "JP")
                converted(converter.fromJSONtoPNG(folder))
            if (mode === "JS")
                converted(cwonverter.fromJSONtoSVG(folder))
            if (mode === "UP") {
                batchBrickDialog.targetPath = folder
                batchBrickDialog.convert(converter.updateExisting(folder))
            }
        }
    }
    function fromSVGtoPNG() {
        folderDialog.mode = "SP"
        folderDialog.open()
    }
    function fromJSONtoPNG() {
        folderDialog.mode = "JP"
        folderDialog.open()
    }
    function fromJSONtoSVG() {
        folderDialog.mode = "JS"
        folderDialog.open()
    }
    function updateExisting() {
        folderDialog.mode = "UP"
        folderDialog.open()
    }
}
