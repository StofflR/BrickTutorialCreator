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
    signal finished(int value)
    property int count
    property int index
    property var files
    property var converter
    width: 500
    height: 400
    function convert(files) {
        count = 0
        index = 0
        batchDialog.files = files
        targetPreview.source = converter.convert(files[index])
        batchDialog.open()
    }
    function finish(count) {
        finished(count)
        batchDialog.close()
    }
    function next() {
        //TODO save
        targetPreview.source = converter.convert(files[index + 1])
        index = batchDialog.index + 1
    }

    // source View Section
    // target View Section
    // target Path / name
    Rectangle {
        id: layout
        anchors.fill: parent
        Image {
            id: sourcePreview
            source: "file:///" + files[index]
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 200
        }
        Image {
            //TODO make editable brick
            id: targetPreview
            source: "file:///" + files[index]
            anchors.bottom: prev.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: sourcePreview.bottom
            height: 200
        }
        Button {
            id: prev
            text: "Previous"
            anchors.left: parent.left
            anchors.bottom: layout.bottom
            width: parent.width / 4
            anchors.margins: AppStyle.spacing
            enabled: batchDialog.index > 0
            onClicked: batchDialog.index = batchDialog.index - 1
        }
        Button {
            anchors.left: prev.right
            width: parent.width / 4
            anchors.bottom: layout.bottom
            anchors.margins: AppStyle.spacing
            onClicked: batchDialog.index < batchDialog.files.length
                       - 1 ? batchDialog.next() : batchDialog.finish(
                                 batchDialog.index)
            text: batchDialog.index < batchDialog.files.length - 1 ? "Next" : "Finish"
        }
    }
}
