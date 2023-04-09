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

    Brick {
        id: svgBrick
    }

    id: batchDialog
    signal finished(int value)
    property int count
    property int index
    property var files
    property var converter
    property var content: []
    width: 500
    height: 400
    function convert(files) {
        count = 0
        index = -1
        batchDialog.files = files
        converter.convert(files[0])
        batchDialog.next()
        batchDialog.open()
    }
    function finish(count) {
        finished(count)
        batchDialog.close()
    }
    function previous() {
        converter.convert(files[batchDialog.index - 1])
        var color = converter.getData("base_type")
        var base = converter.getData("path")
        var size = converter.getData("size")
        var text = batchDialog.content[index - 2]
        svgBrick.updateBrick(color, base, size, text, 100, 43, 33)
        targetPreview.source = svgBrick.path()
        converter.convert(files[batchDialog.index])
        batchDialog.index = batchDialog.index - 1
    }

    function next() {

        var color = converter.getData("base_type")
        var base = converter.getData("path")
        var size = converter.getData("size")
        var text = converter.getData("content")
        if (batchDialog.content.length >= index + 1) {
            text = batchDialog.content[index]
        } else {
            batchDialog.content.push(text)
        }

        console.log(color, base, size, text, 100)
        svgBrick.updateBrick(color, base, size, text, 100, 43, 33)

        targetPreview.source = svgBrick.path()
        console.log(targetPreview.source)
        //if(index != 0)
        // TODO save
        index = batchDialog.index + 1
        if (batchDialog.index < batchDialog.files.length - 1)
            converter.convert(files[batchDialog.index + 1])
    }

    // source View Section
    // target View Section
    // target Path / name
    Rectangle {
        id: layout
        anchors.fill: parent
        Image {
            id: sourcePreview
            enabled: index >= 0
            source: "file:///" + files[index]
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 200
        }
        Image {
            //TODO make editable brick
            id: targetPreview
            enabled: index >= 0
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
            onClicked: batchDialog.previous()
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
