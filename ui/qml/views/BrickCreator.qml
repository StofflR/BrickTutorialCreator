import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import BrickManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Rectangle {
    id: root
    signal updateStatusMessage(string text)
    anchors.fill: parent
    anchors.margins: AppStyle.spacing
    color: AppStyle.color.window
    ButtonField {
        id: path
        button_label: qsTr("Set export to …")
        field.placeholderText: qsTr("Select export path …")
        field.width: parent.width * 3 / 4 - AppStyle.spacing
        button.width: parent.width / 4 - AppStyle.spacing
        field.text: textMetrics.elidedText
        field.readOnly: true
        button.onPressed: folderDialog.open()
    }
    FolderDialog {
        id: folderDialog
        folder: tempFolder
        TextMetrics {
            id: textMetrics
            font.family: Font.boldFont ? Font.boldFont : -1
            elide: Text.ElideLeft
            elideWidth: path.field.width
            text: folderDialog.folder
        }
        onAccepted: {
            textMetrics.text = folder
        }
    }

    LabelComboBox {
        label: qsTr("Available bricks")
        id: availableBricks
        width: parent.width / 2
        anchors.top: path.bottom
        anchors.left: parent.left
        anchors.topMargin: AppStyle.spacing
        comboBox.model: bricks.availableBricks()
        onDisplayTextChanged: {
            bricks.sizes = bricks.availableSizes(comboBox.currentIndex)
            svgPreview.update(true)
        }
    }
    BrickManager {
        id: bricks
        Component.onCompleted: {
            bricks.reset()
        }
        property var sizes
    }

    LabelComboBox {
        label: qsTr("Available sizes")
        id: availableSize
        width: parent.width / 2
        anchors.top: path.bottom
        anchors.left: availableBricks.right
        anchors.topMargin: AppStyle.spacing
        anchors.leftMargin: AppStyle.spacing
        comboBox.model: bricks.sizes
        onDisplayTextChanged: svgPreview.update(true)
    }

    LabelDoubleSpinBox {
        label: qsTr("Content scale")
        id: contentScale
        spinbox.from: 1
        spinbox.to: 300
        spinbox.editable: true
        width: parent.width / 2
        anchors.top: availableBricks.bottom
        anchors.left: parent.left
        anchors.topMargin: AppStyle.spacing
        spinbox.onValueChanged: svgPreview.update(true)
    }
    LabelDoubleSpinBox {
        label: qsTr("X")
        id: xPos
        labelWidth: width / 4
        spinbox.from: 1
        spinbox.value: 43
        spinbox.to: 300
        spinbox.editable: true
        width: parent.width / 4
        anchors.top: availableBricks.bottom
        anchors.left: contentScale.right
        anchors.topMargin: AppStyle.spacing
        spinbox.onValueChanged: svgPreview.update(true)
    }
    LabelDoubleSpinBox {
        label: qsTr("Y")
        id: yPos
        labelWidth: width / 4
        spinbox.from: 1
        spinbox.value: 33
        spinbox.to: 200
        spinbox.editable: true
        width: parent.width / 4
        anchors.top: availableBricks.bottom
        anchors.left: xPos.right
        anchors.topMargin: AppStyle.spacing
        spinbox.onValueChanged: svgPreview.update(true)
    }
    Label {
        width: parent.width / 8
        height: AppStyle.defaultHeight
        id: saveLabel
        text: qsTr("Save as")
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pointSize: AppStyle.spacing * 8 / 6
        anchors.top: contentScale.bottom
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    Rectangle {
        id: svg
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: saveLabel.right
        height: AppStyle.defaultHeight
        color: AppStyle.color.window
        CheckBox {
            id: svg_check
            text: "SVG"
            font.pointSize: AppStyle.spacing * 8 / 6
            anchors.fill: parent
            checked: true
        }
    }
    Rectangle {
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.right: parent.right
        height: AppStyle.defaultHeight
        color: AppStyle.color.window
        CheckBox {
            id: autoSave
            text: "Auto-Save"
            font.pointSize: AppStyle.spacing * 8 / 6
            anchors.fill: parent
            checked: false
        }
    }
    Rectangle {
        id: json
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: svg.right
        height: AppStyle.defaultHeight
        color: AppStyle.color.window
        CheckBox {
            id: json_check
            text: "JSON"
            font.pointSize: AppStyle.spacing * 8 / 6
            anchors.fill: parent
            checked: true
        }
    }
    Rectangle {
        id: png
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: json.right
        height: AppStyle.defaultHeight
        color: AppStyle.color.window
        CheckBox {
            id: png_check
            text: "PNG"
            font.pointSize: AppStyle.spacing * 8 / 6
            anchors.fill: parent
            checked: true
        }
    }
    Rectangle {
        id: contentLayout
        anchors.top: saveLabel.bottom
        height: saveButton.height + loadButton.height + clearButton.height + 20
        anchors.left: parent.left
        anchors.right: parent.right
        color: AppStyle.color.window
        Area {
            id: brickContent
            text: previewContent.text
            font.pointSize: 30 * 8 / 6
            anchors.left: contentLayout.left
            height: contentLayout.height
            anchors.right: saveButton.left
            anchors.margins: AppStyle.spacing
            placeholderText: qsTr("Enter brick content …")
            verticalAlignment: TextField.AlignTop
            inputMethodHints: Qt.ImhMultiLine
            onTextChanged: svgPreview.update(false)
            onEditingFinished: if (autoSave.checked)
                                   saveButton.save()
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Variables:\n$ some sample var $\nNew Line:\n\\\\\nDropdown:\n* some sample var *")
        }
        IconButton {
            id: saveButton
            anchors.top: brickContent.top
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            anchors.topMargin: 0
            width: height
            icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
            enabled: (svg_check.checked || json_check.checked
                      || png_check.checked) && brickContent.text !== ""
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Save the current brick!")
            onPressed: save()

            function save() {
                var statusText = "INFO: Saved brick(s) as: "
                var filename = svgBrick.fileName()
                if (!filename)
                    return
                if (svg_check.checked) {
                    svgBrick.saveSVG(textMetrics.text)
                    statusText += filename + ".svg "
                }
                if (json_check.checked) {
                    svgBrick.saveJSON(textMetrics.text)
                    statusText += filename + ".json "
                }
                if (png_check.checked) {
                    svgBrick.savePNG(textMetrics.text)
                    statusText += filename + ".png "
                }
                statusText += " to " + textMetrics.text
                root.updateStatusMessage(statusText)
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
                    brickContent.text = svgBrick.content()
                    svgPreview.brickImg = svgBrick.path()
                    xPos.spinbox.value = svgBrick.x()
                    yPos.spinbox.value = svgBrick.y()
                    root.updateStatusMessage("INFO: Loaded " + currentFile)
                }
            }
            id: loadButton
            anchors.top: saveButton.bottom
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            width: height
            icon.source: "qrc:/bricks/resources/file_open_black_24dp.svg"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Load existring brick from SVG or JSON!")
            onPressed: brickOpenDialog.open()
        }
        IconButton {
            id: clearButton
            anchors.top: loadButton.bottom
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            width: height
            icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Clear current brick content!")
            onPressed: {
                brickContent.clear()
                root.updateStatusMessage("INFO: Cleared brick content!")
            }
        }
    }
    Brick {
        id: svgBrick
    }

    Image {
        id: svgPreview
        property var brickImg
        source: overlay.visible ? "qrc:/bricks/base/" + bricks.brickPath(
                                      availableBricks.comboBox.currentIndex,
                                      availableSize.comboBox.displayText) : brickImg

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: contentLayout.bottom
        onUpdate: autosave => {
                      svgBrick.updateBrick(
                          availableBricks.comboBox.displayText,
                          bricks.brickPath(
                              availableBricks.comboBox.currentIndex,
                              availableSize.comboBox.displayText),
                          availableSize.comboBox.displayText,
                          brickContent.text, contentScale.spinbox.value,
                          xPos.spinbox.value, yPos.spinbox.value)
                      brickImg = svgBrick.path()
                      if (autoSave.checked && autosave)
                      saveButton.save()
                  }
        Column {
            id: overlay
            anchors.fill: previewContent
            visible: false // previewContent.cursorVisible ? 1 : 0 // TODO: enable on component completion

            Repeater {
                id: repeater
                property int cursorPosition: previewContent.cursorPosition
                                             - previewContent.text.substring(
                                                 0,
                                                 previewContent.cursorPosition).lastIndexOf(
                                                 "\n") - 1
                model: {
                    var data = previewContent.getText(0, previewContent.length)
                    while (data.indexOf("\n") !== -1) {
                        data = data.replace("\n", "&nbsp;\r")
                    }

                    while (data.indexOf("$") !== -1) {
                        data = data.replace(
                                    "$",
                                    "<u style=\"white-space:pre;\">&middot;")
                        data = data.replace("$", "&middot;</u>")
                    }
                    while (data.indexOf("*") !== -1) {
                        data = data.replace(
                                    "*",
                                    "<span style=\"text-indent:25px;white-space:pre;\"><small>&middot;")
                        data = data.replace("*", "&middot;</small></span>")
                    }
                    return data.split("\r")
                }

                TextEdit {
                    id: repeaterLine
                    width: contentWidth
                    height: 12 * previewContent.scale
                    text: repeater.model[index]
                    padding: 0
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
        }
        TextEdit {
            id: previewContent
            visible: false // TODO: enable on component completion
            property int cursorLine: previewContent.text.substring(
                                         0,
                                         previewContent.cursorPosition).split(
                                         /\n/).length - 1

            property real scale: svgPreview.paintedWidth / 350
            anchors.left: svgPreview.left
            anchors.top: svgPreview.top
            anchors.leftMargin: (xPos.spinbox.value - 2) * scale
                                + (svgPreview.width - svgPreview.paintedWidth) / 2
            anchors.topMargin: (yPos.spinbox.value - 15) * scale
                               + (svgPreview.height - svgPreview.paintedHeight) / 2

            width: svgPreview.width - anchors.leftMargin
            height: svgPreview.height - anchors.topMargin
            cursorDelegate: Item {}

            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            cursorVisible: false
            wrapMode: TextArea.WordWrap
            font.bold: true
            font.pointSize: 12 * scale < 0 ? 12 : 12 * scale
            opacity: 0
        }
    }
    Component.onCompleted: svgPreview.update(true)
}
