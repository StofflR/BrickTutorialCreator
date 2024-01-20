import QtQuick 2.0
import QtQml 2.0
import Qt.labs.platform 1.1
import Converter 1.0

import "../dialogs"
import "../../style"

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
        property var mode
        onAccepted: converted(folderDialog.mode(folderDialog.folder))
    }
    function fromSVGtoPNG() {
        folderDialog.mode = converter.fromSVGtoPNG
        folderDialog.open()
    }
    function fromJSONtoPNG() {
        folderDialog.mode = converter.fromJSONtoPNG
        folderDialog.open()
    }
    function fromTutorialtoPNG() {
        folderDialog.mode = converter.fromTutorialtoPNG
        folderDialog.open()
    }
    function fromJSONtoSVG() {
        folderDialog.mode = converter.fromJSONtoSVG
        folderDialog.open()
    }
}
