import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import BrickManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"

Rectangle {
    anchors.fill: parent
    anchors.margins: 10
    ButtonField {
        id: path
        button_label: qsTr("Set export to …")
        field.placeholderText: qsTr("Select export path …")
        field.width: parent.width * 3 / 4 - 10
        button.width: parent.width / 4 - 10
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
        anchors.topMargin: 10
        comboBox.model: bricks.availableBricks()
        onDisplayTextChanged: {
            bricks.sizes = bricks.availableSizes(comboBox.currentIndex)
            svgPreview.update()
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
        anchors.topMargin: 10
        anchors.leftMargin: 10
        comboBox.model: bricks.sizes
        onDisplayTextChanged: svgPreview.update()
    }

    LabelDoubleSpinBox {
        label: qsTr("Content scale")
        id: contentScale
        spinbox.from: 1
        spinbox.to: 200
        spinbox.editable: true
        width: parent.width / 2
        anchors.top: availableBricks.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        spinbox.onValueChanged: svgPreview.update()
    }
    Label {
        width: parent.width / 8
        height: 40
        id: saveLabel
        text: qsTr("Save as")
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: 10
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
        height: 40
        CheckBox {
            id: svg_check
            text: "SVG"
            font.pixelSize: 10
            anchors.fill: parent
            checked: true
        }
    }
    Rectangle {
        id: json
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: svg.right
        height: 40
        CheckBox {
            id: json_check
            text: "JSON"
            font.pixelSize: 10
            anchors.fill: parent
            checked: true
        }
    }
    Rectangle {
        id: png
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: json.right
        height: 40
        CheckBox {
            id: png_check
            text: "PNG"
            font.pixelSize: 10
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
        Area {
            id: brickContent
            font.pixelSize: 30
            anchors.left: contentLayout.left
            height: contentLayout.height
            anchors.right: saveButton.left
            anchors.margins: 10
            placeholderText: qsTr("Enter brick content …")
            verticalAlignment: TextField.AlignTop
            inputMethodHints: Qt.ImhMultiLine
            onTextChanged: svgPreview.update()
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Variables:\n$ some sample var $\nNew Line:\n\\\\\nDropdown:\n* some sample var *")
        }
        IconButton {
            id: saveButton
            anchors.top: brickContent.top
            anchors.right: parent.right
            anchors.margins: 10
            anchors.topMargin: 0
            width: height
            icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
            enabled: (svg_check.checked || json_check.checked
                      || png_check.checked) && brickContent.text !== ""
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Save the current brick!")
            onPressed: {
                if (svg_check.checked)
                    svgBrick.saveSVG(textMetrics.text)
                if (json_check.checked)
                    svgBrick.saveJSON(textMetrics.text)
                if (png_check.checked)
                    svgBrick.savePNG(textMetrics.text)
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
                    svgPreview.source = svgBrick.path()
                }
            }
            id: loadButton
            anchors.top: saveButton.bottom
            anchors.right: parent.right
            anchors.margins: 10
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
            anchors.margins: 10
            width: height
            icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Clear current brick content!")
            onPressed: brickContent.clear()
        }
    }
    Brick {
        id: svgBrick
    }

    Image {
        id: svgPreview

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: contentLayout.bottom
        onUpdate: {
            svgBrick.updateBrick(availableBricks.comboBox.displayText,
                                 bricks.brickPath(
                                     availableBricks.comboBox.currentIndex,
                                     availableSize.comboBox.displayText),
                                 availableSize.comboBox.displayText,
                                 brickContent.text, contentScale.spinbox.value)
            source = svgBrick.path()
        }
    }
    Component.onCompleted: svgPreview.update()
}
