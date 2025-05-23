import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import Brick 1.0

import "../interface"
import "../../assets/simple"
import "../../style"

Popup {
    id: batchDialog
    signal finished(int value)
    signal converted(var target)
    property int count: 0
    property int index: 0
    property var files: []
    property var converter
    property string targetPath: ""
    property var content: []
    property alias svgBrick: targetPreview.brick
    anchors.centerIn: Overlay.overlay
    width: 500
    height: 400
    onClosed: {
        content = []
        files = []
        count = 0
        index = 0
        targetPath = ""
    }

    function convert(newFiles) {
        files = newFiles
        loadBrick()
        batchDialog.open()
    }
    function loadBrick() {
        if (index < 0 || files.length === 0)
            return

        converter.removeNS0(files[index])
        sourcePreview.source = fileStub + files[index]

        converter.convert(files[index])
        if (converter.isBrick(files[index])) {
            targetPreview.loadFromFile(files[index])
        } else {
            console.debug("Trying to convert Legacy brick!")
            targetPreview.loading = true
            targetPreview.content.text = converter.getData("content")
            targetPreview.brickImg = fileStub + files[index]
            targetPreview.brickPath = converter.getData("path")
            //targetPreview.xPos = converter.getData["content"]
            //targetPreview.yPos = converter.getData["content"]
            targetPreview.loading = false
            targetPreview.dataChanged()
        }
        if (content.length > index)
            targetPreview.content.text = content[index]
    }

    function acceptCurrentBrick() {
        if (content.length > index)
            content[index] = targetPreview.brickContent
        else
            content.push(targetPreview.brickContent)

        console.log("updating file: " + batchDialog.brickPath)
        var target = targetPreview.brick.saveSVG(converter.getOutputPath(
                                                     files[index]))
        converted(index + "/" + files.length + " : " + target)
    }
    function finish(count) {
        finished(count)
        batchDialog.close()
    }
    function previous() {
        acceptCurrentBrick()
        index = index - 1
        loadBrick()
    }

    function next() {
        acceptCurrentBrick()
        index = index + 1
        loadBrick()
    }

    // source View Section
    // target View Section
    // target Path / name
    Rectangle {
        id: layout
        anchors.fill: parent
        Image {
            id: sourcePreview
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 200
        }

        MouseArea {
            anchors.fill: layout
            onClicked: batchDialog.forceActiveFocus()
        }
        EditableBrick {
            id: targetPreview
            anchors.bottom: prev.top
            anchors.left: layout.left
            width: sourcePreview.paintedWidth
            height: sourcePreview.paintedHeight
            loadButton.enabled: false
            saveButton.enabled: false

            IconButton {
                id: customButton
                anchors.top: targetPreview.clearButton.bottom
                anchors.right: targetPreview.right
                anchors.margins: enabled ? AppStyle.spacing : 0
                height: enabled ? width : 0
                icon.source: "qrc:/bricks/resources/done_black_24dp.svg"
                ToolTip.visible: hovered
                ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                ToolTip.text: qsTr("Accept!")
                onClicked: acceptCurrentBrick()
            }
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
            onClicked: batchDialog.index <= batchDialog.files.length
                       - 1 ? batchDialog.next() : batchDialog.finish(
                                 batchDialog.index)
            text: batchDialog.index <= batchDialog.files.length - 1 ? "Next" : "Finish"
        }
    }
}
