import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Image {
    id: svgPreview
    property string brickImg: "qrc:/bricks/base/brick_blue_1h.svg"
    property int xPos: 43
    property int yPos: 33
    property int contentScale: 100
    readonly property string brickContent: previewContent.text
    property string availableSize: "1h"
    property string brickPath: "brick_blue_1h.svg"
    property string brickColor: "blue"

    property bool modified: false
    property bool disable: false

    property string status

    property alias brick: modifyableBrick
    property alias saveButton: saveButton
    property alias loadButton: loadButton
    property alias clearButton: clearButton
    property alias colorButton: colorButton

    property alias content: previewContent

    signal dataChanged
    signal save
    asynchronous: true
    property bool loading: false

    function loadFromFile(currentFile) {
        {
            if (!currentFile)
                return
            modifyableBrick.fromFile(currentFile)
            svgPreview.loading = true
            previewContent.text = modifyableBrick.brickContent()
            svgPreview.brickImg = modifyableBrick.path()
            svgPreview.brickPath = modifyableBrick.basePath()
            svgPreview.xPos = modifyableBrick.posX()
            svgPreview.yPos = modifyableBrick.posY()
            svgPreview.brickColor = modifyableBrick.brickColor()
            svgPreview.loading = false
            svgPreview.status = "INFO: Loaded " + currentFile
        }
    }
    fillMode: Image.PreserveAspectFit
    source: previewContent.cursorVisible ? baseFolder + "/" + brickPath : brickImg
    Brick {
        id: modifyableBrick
    }
    onDataChanged: {
        if (!brickPath || !brickColor || !availableSize || !xPos || !yPos
                || !contentScale || loading) {
            return
        }
        modifyableBrick.updateBrick(brickColor, brickPath, availableSize,
                                    brickContent, contentScale, xPos, yPos)
        brickImg = modifyableBrick.path()
    }
    TextArea {
        id: textView
        Binding on cursorPosition {
            when: previewContent.cursorPosition
            value: previewContent.cursorPosition
        }
        visible: previewContent.cursorVisible
        anchors.fill: previewContent
        text: {
            var data = previewContent.getText(0, previewContent.length)
            while (data.indexOf("<") !== -1) {
                data = data.replace("<", "&lt;")
            }
            while (data.indexOf("\n") !== -1) {
                data = data.replace("\n", "<br>")
            }
            while (data.indexOf("$") !== -1) {
                data = data.replace(
                            "$",
                            "<u style=\"letter-spacing:0px\"><small>&middot;")
                data = data.replace("$", "&middot;</small></u>")
            }
            while (data.indexOf("*") !== -1) {
                data = data.replace("*", "<small>&#9662;")
                data = data.replace("*", "&#9662;</small>")
            }
            return "<p style=\"line-height:75%;letter-spacing:-1px;padding-left:-20px;white-space:pre;\">" + data + "</p>"
        }
        onTextChanged: cursorPosition = previewContent.cursorPosition
        wrapMode: TextArea

        cursorVisible: previewContent.cursorVisible
        textFormat: TextEdit.RichText
        font.family: "Roboto"
        font.letterSpacing: -1
        font.bold: true
        color: brickColor.lastIndexOf(
                   "white") == -1 ? "white" : brickColor.lastIndexOf(
                                        "transparent") == -1 ? "blue" : "black"
        font.pointSize: 12 * previewContent.scale <= 0 ? 12 : 12 * previewContent.scale
    }

    TextArea {
        id: previewContent
        text: ""
        placeholderText: "<b>Click to modify content!<\b>"
        anchors.left: svgPreview.left
        anchors.top: svgPreview.top
        width: svgPreview.width - svgPreview.xPos
        height: svgPreview.height - svgPreview.yPos
        anchors.leftMargin: (svgPreview.xPos - 4) * svgPreview.paintedWidth / 350
        anchors.topMargin: (svgPreview.yPos - 4) * svgPreview.paintedWidth / 350
                           - 13 * previewContent.scale
        property int cursorLine: previewContent.text.substring(
                                     0, previewContent.cursorPosition).split(
                                     /\n/).length - 1
        property real scale: svgPreview.paintedWidth * contentScale / 35000
        wrapMode: TextArea
        font: textView.font
        opacity: text ? 0 : 1
        cursorVisible: false
        onCursorVisibleChanged: dataChanged()
        Component.onCompleted: {
            textChanged.connect(svgPreview.dataChanged)
        }
    }
    MouseArea {
        anchors.fill: previewContent
        onReleased: mouseEvent => {
                        previewContent.cursorPosition = textView.positionAt(
                            mouseEvent.x, mouseEvent.y)
                        previewContent.forceActiveFocus()
                    }
        onClicked: {
            modified = true
        }
    }

    Component.onCompleted: {
        availableSizeChanged.connect(svgPreview.dataChanged)
        xPosChanged.connect(svgPreview.dataChanged)
        yPosChanged.connect(svgPreview.dataChanged)
        contentScaleChanged.connect(svgPreview.dataChanged)
        availableSizeChanged.connect(svgPreview.dataChanged)
        brickPathChanged.connect(svgPreview.dataChanged)
        brickColorChanged.connect(svgPreview.dataChanged)
    }

    IconButton {
        id: clearButton
        anchors.top: svgPreview.top
        anchors.right: svgPreview.right
        anchors.margins: enabled ? AppStyle.spacing : 0
        visible: enabled
        opacity: enabled ? 0.7 : 0.3
        width: visible ? AppStyle.defaultHeight / 2 : 0
        height: visible ? width : 0
        icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Clear current brick content!")
        onPressed: {
            previewContent.text = ""
            dataChanged()
            status = "INFO: Cleared brick content!"
        }
    }
    IconButton {
        FileDialog {
            id: brickOpenDialog
            folder: tempFolder
            nameFilters: ["Any (*.svg *.json)", "SVG files (*.svg)", "JSON files (*.json)"]
            fileMode: FileDialog.OpenFiles
            onAccepted: loadFromFile(currentFile)
            options: FileDialog.HideNameFilterDetails
        }
        id: loadButton
        anchors.top: clearButton.bottom
        anchors.right: svgPreview.right
        anchors.margins: enabled ? AppStyle.spacing : 0
        visible: enabled
        opacity: enabled ? 0.7 : 0.3
        width: visible ? AppStyle.defaultHeight / 2 : 0
        height: visible ? width : 0
        icon.source: "qrc:/bricks/resources/file_open_black_24dp.svg"
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Load existring brick from SVG or JSON!")
        onPressed: brickOpenDialog.open()
    }
    IconButton {
        id: saveButton
        anchors.top: loadButton.bottom
        anchors.right: svgPreview.right
        anchors.margins: enabled ? AppStyle.spacing : 0
        visible: enabled
        opacity: enabled ? 0.7 : 0.3
        width: visible ? AppStyle.defaultHeight / 2 : 0
        height: visible ? width : 0
        icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
        enabled: (svg_check.checked || json_check.checked || png_check.checked)
                 && brickContent.text !== ""
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Save the current brick!")
        onPressed: {
            saveButton.forceActiveFocus()
            save()
        }
    }
    IconButton {
        ColorSelector {
            id: selector
            onBaseChanged: (selectedColor, selectedPath, selectedSize) => {
                               if (!selectedColor || !selectedPath
                                   || !selectedSize) {
                                   return
                               }
                               svgPreview.loading = true
                               brickColor = selectedColor
                               brickPath = selectedPath
                               availableSize = selectedSize
                               svgPreview.loading = false
                               svgPreview.dataChanged()
                           }
        }
        id: colorButton
        anchors.top: svgPreview.top
        anchors.right: clearButton.left
        anchors.margins: enabled ? AppStyle.spacing : 0
        visible: enabled
        opacity: enabled ? 0.7 : 0.3
        width: visible ? AppStyle.defaultHeight / 2 : 0
        height: visible ? width : 0
        icon.source: "qrc:/bricks/resources/create_black_24dp.svg"
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Edit visuals of current brick!")
        onPressed: selector.open()
    }
}
