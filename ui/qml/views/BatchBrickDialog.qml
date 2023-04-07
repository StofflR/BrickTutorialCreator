import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import BrickManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Popup {
    id: batchDialog
    signal finished
    property int count
    property int index
    property var files
    width: 300
    height: 400
    function convert(files) {
        count = 0
        index = 0
        batchDialog.files = files
        batchDialog.open()
    }
    function finish() {
        finished(files.length)
        batchDialog.close()
    }

    // source View Section
    // target View Section
    // target Path / name
    Rectangle {
        width: parent.width
        height: prev.height

        Button {
            id: prev
            anchors.left: parent.left
            width: paretn.width / 4
            anchors.margins: AppStyle.spacing
            enabled: batchDialog.index > 0
            onClicked: batchDialog.index = batchDialog.index - 1
        }
        Button {
            anchors.left: prev.left
            width: paretn.width / 4
            anchors.margins: AppStyle.spacing
            onClicked: batchDialog.index
                       < batchDialog.files.length ? batchDialog.index = batchDialog.index
                                                    + 1 : batchDialog.finish()
        }
    }
}
