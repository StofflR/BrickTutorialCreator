import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import Brick 1.0

import "../../assets/simple"
import "../../font"
import "../../style"

Image {
    id: svgPreview

    readonly property string brickContent: previewContent.text

    property bool disable: false
    property string statusText
    property alias brick: modifyableBrick
    property alias saveButton: saveButton
    property alias loadButton: loadButton
    property alias clearButton: clearButton
    property alias colorButton: colorButton

    property alias editor: selectorComponent
    property alias content: previewContent

    property alias mouseArea: mouseArea

    signal save
    brick.onContentChanged: previewContent.text = modifyableBrick.brickContent
    source: decodeURIComponent(
                previewContent?.cursorVisible ? modifyableBrick?.fullBasePath : modifyableBrick?.workingPath)

    asynchronous: true
    smooth: true
    cache: true

    Brick {
        id: modifyableBrick
        brickContent: previewContent.text
    }

    function selectAll() {
        textView.selectAll()
        previewContent.forceActiveFocus()
    }

    function loadFromFile(currentFile) {
        modifyableBrick.fromFile(currentFile)
    }
    fillMode: Image.PreserveAspectFit

    TextArea {
        id: textView
        persistentSelection: true
        Binding on cursorPosition {
            when: previewContent.cursorPosition
            value: previewContent.cursorPosition
        }
        visible: previewContent.cursorVisible
        anchors.fill: previewContent
        onSelectedTextChanged: previewContent.select(textView.selectionStart,
                                                     textView.selectionEnd)
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
        wrapMode: TextEdit.WordWrap

        cursorVisible: previewContent.cursorVisible
        textFormat: TextEdit.RichText
        font.family: "Roboto"
        font.letterSpacing: -1
        font.bold: true
        color: modifyableBrick?.baseType?.lastIndexOf(
                   "white") == -1 ? "white" : modifyableBrick?.baseType?.lastIndexOf(
                                        "transparent") == -1 ? "blue" : "black"

        font.pointSize: 12 * previewContent.scale <= 0 ? 12 : 12 * previewContent.scale
    }

    TextArea {
        id: previewContent
        property bool contentAddable: modifyableBrick?.brickSize != "0h"
        property string textBuffer: ""
        onContentAddableChanged: {
            if (contentAddable)
                text = textBuffer
            else
                textBuffer = text
        }

        persistentSelection: true
        text: ""
        placeholderText: contentAddable ? "<b>Click to modify content!<\b>" : ""
        enabled: contentAddable
        anchors.left: svgPreview.left
        anchors.top: svgPreview.top
        width: svgPreview.width - modifyableBrick?.xPos
        height: svgPreview.height - modifyableBrick?.yPos
        anchors.leftMargin: (modifyableBrick?.xPos - 4) * svgPreview.paintedWidth / 350
        anchors.topMargin: (modifyableBrick?.yPos - 4) * svgPreview.paintedWidth
                           / 350 - 13 * previewContent.scale

        property real scale: svgPreview.paintedWidth * modifyableBrick?.scalingFactor / 350
        wrapMode: TextEdit.WordWrap
        font: textView.font
        color: textView.color
        placeholderTextColor: textView.color
        opacity: text ? 0 : 1
        cursorVisible: false
    }
    Repeater {
        id: repeaterModel
        model: previewContent.lineCount
        property var lines: previewContent.text.split("\n")
        Rectangle {
            id: selection
            color: "darkgrey"
            opacity: 0.25
            property int textViewSelection: textView.selectionEnd - textView.selectionStart
            property int previewContentSelection: previewContent.selectionEnd
                                                  - previewContent.selectionStart

            visible: textViewSelection != 0 || previewContentSelection != 0
            onPreviewContentSelectionChanged: updateBox()
            onTextViewSelectionChanged: updateBox()
            function select(start, end) {
                selection.visible = true
                selection.x = start.x + previewContent.x
                selection.y = start.y + previewContent.y
                selection.height = start.height
                selection.width = end.x - start.x
            }

            function updateBox() {
                var startPosition = 0
                for (var i = 0; i < index; i++)
                    startPosition += repeaterModel.lines[i].length + 1

                var lineStart = textView.positionToRectangle(startPosition)
                var lineEnd = textView.positionToRectangle(
                            startPosition + repeaterModel.lines[index].length)

                var startRectView = textView.positionToRectangle(
                            previewContent.selectionStart)

                var endRectView = textView.positionToRectangle(
                            previewContent.selectionEnd)
                selection.visible = false

                if (lineStart.y < startRectView.y
                        || lineStart.y > endRectView.y) {
                    return
                }

                if (startRectView.y == endRectView.y) {
                    select(startRectView, endRectView)
                } else if (startRectView.y == lineStart.y) {
                    select(startRectView, lineEnd)
                } else if (endRectView.y == lineEnd.y) {
                    select(lineStart, endRectView)
                } else {
                    select(lineStart, lineEnd)
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: previewContent
        property int pressedAt

        onPressed: function (mouseEvent) {
            pressedAt = textView.positionAt(mouseEvent.x, mouseEvent.y)
            previewContent.cursorPosition = pressedAt
            previewContent.forceActiveFocus()
        }
        onDoubleClicked: {
            textView.selectWord()
        }
        onReleased: function (mouseEvent) {
            var position = textView.positionAt(mouseEvent.x, mouseEvent.y)
            if (position != pressedAt) {
                textView.select(Math.min(position, pressedAt),
                                Math.max(position, pressedAt))
            }
        }
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
            statusText = "INFO: Cleared brick content!"
        }
    }
    IconButton {
        FileDialog {
            id: brickOpenDialog
            folder: resourcesOutFolder
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
        onReleased: {
            saveButton.forceActiveFocus()
            save()
        }
    }
    IconButton {
        Popup {
            id: popup
            anchors.centerIn: Overlay.overlay
            Loader {
                id: selector
                sourceComponent: selectorComponent
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
        onPressed: popup.open()
    }
    Component {
        id: selectorComponent
        ColorSelector {
            onBaseChanged: (selectedColor, selectedPath, selectedSize) => {
                               if (!selectedColor || !selectedPath
                                   || !selectedSize) {
                                   return
                               }
                               modifyableBrick.baseType = selectedColor
                               modifyableBrick.brickPath = selectedPath
                               modifyableBrick.brickSize = selectedSize
                           }
        }
    }
}
