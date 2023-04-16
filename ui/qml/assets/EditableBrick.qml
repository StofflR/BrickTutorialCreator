import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import BrickManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Image {
    id: svgPreview
    property var brickImg
    property var xPos
    property var yPos
    property var contentScale
    property string brickContent: previewContent.text
    property var availableSize
    property var brickPath
    property var brickColor

    property bool savePNG
    property bool saveSVG
    property bool saveJSON

    property string status

    property alias brick: svgBrick

    signal updated
    signal dataChanged
    signal fileLoaded

    source: brickImg // overlay.visible ? "qrc:/bricks/base/" + brickPath : brickImg
    Brick {
        id: svgBrick
    }
    onDataChanged: {
        if (!brickPath || !brickColor || !availableSize) {
            return
        }
        svgBrick.updateBrick(brickColor, brickPath, availableSize,
                             brickContent, contentScale, xPos, yPos)
        brickImg = svgBrick.path()
        svgPreview.updated()
    }


    /*
    Column {
        id: overlay
        anchors.fill: previewContent
        visible: previewContent.cursorVisible
        Repeater {
            id: repeater
            property int cursorPosition: previewContent.cursorPosition
                                         - previewContent.text.substring(
                                             0,
                                             previewContent.cursorPosition).lastIndexOf(
                                             "\n") - 1
            model:
            }

            TextEdit {
                id: repeaterLine
                width: contentWidth
                height: 12 * previewContent.scale
                text: repeater.model[index]
                padding: 0
                opacity: 0.5
                textFormat: TextEdit.AutoText
                z: repeater.model.length - index
                font: previewContent.font
                cursorVisible: index === previewContent.cursorLine
                               && previewContent.cursorVisible
                Binding on cursorPosition {
                    when: onTextChanged || previewContent.text
                          || previewContent.cursorPosition
                    value: repeater.cursorPosition
                }
                onTextChanged: cursorPosition = repeater.cursorPosition
                onCursorPositionChanged: console.log(cursorPosition)
            }
        }
    }*/
    TextArea {
        id: textView
        anchors.fill: previewContent
        text: {
            var data = previewContent.getText(0, previewContent.length)

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
                data = data.replace("*", "<small>&middot;")
                data = data.replace("*", "&middot;</small>")
            }
            return "<p style=\"line-height:75%;letter-spacing:-1px;padding-left:-20px;white-space:pre;\">" + data + "</p>"
        }
        wrapMode: TextArea
        cursorPosition: previewContent.cursorPosition
        cursorVisible: previewContent.cursorVisible
        textFormat: TextEdit.RichText
        font.family: "Roboto"
        color: "red"
        font.bold: true
        font.pointSize: 12 * previewContent.scale < 0 ? 12 : 12 * previewContent.scale
    }

    TextArea {
        id: previewContent
        text: ""

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
        onScaleChanged: console.log(12 * previewContent.scale)
        property real scale: svgPreview.paintedWidth * contentScale / 35000

        cursorVisible: false
        wrapMode: TextArea
        font: textView.font
        opacity: 0
        Component.onCompleted: {
            textChanged.connect(svgPreview.dataChanged)
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
        height: enabled ? width : 0
        icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Clear current brick content!")
        onPressed: {
            previewContent.text = ""
            status = "INFO: Cleared brick content!"
        }
    }
    IconButton {
        FileDialog {
            id: brickOpenDialog
            folder: tempFolder
            nameFilters: ["SVG files (*.svg)", "JSON files (*.json)"]
            fileMode: FileDialog.OpenFiles
            onAccepted: {
                svgBrick.fromFile(currentFile)
                previewContent.text = svgBrick.content()
                svgPreview.brickImg = svgBrick.path()
                //svgPreview.xPos = svgBrick.x
                //svgPreview.yPos = svgBrick.y
                svgPreview.status = "INFO: Loaded " + currentFile
                svgPreview.fileLoaded()
                svgPreview.updated()
            }
        }
        id: loadButton
        anchors.top: clearButton.bottom
        anchors.right: svgPreview.right
        anchors.margins: enabled ? AppStyle.spacing : 0
        height: enabled ? width : 0
        enabled: false //TODO: Load brick from file
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
        height: enabled ? width : 0
        icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
        enabled: (svg_check.checked || json_check.checked || png_check.checked)
                 && brickContent.text !== ""
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Save the current brick!")
        onPressed: save()

        function save() {
            var statusText = "INFO: Saved brick(s) as: "
            var filename = svgBrick.fileName()
            console.log(filename)
            if (!filename)
                return
            if (svgPreview.saveSVG) {
                svgBrick.saveSVG(textMetrics.text)
                statusText += filename + ".svg "
            }
            if (svgPreview.saveJSON) {
                svgBrick.saveJSON(textMetrics.text)
                statusText += filename + ".json "
            }
            if (svgPreview.savePNG) {
                svgBrick.savePNG(textMetrics.text)
                statusText += filename + ".png "
            }
            statusText += " to " + textMetrics.text
            root.updateStatusMessage(statusText)
        }
    }
}
