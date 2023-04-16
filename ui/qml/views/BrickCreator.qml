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
            edtiableBrick.update(true)
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
        onDisplayTextChanged: edtiableBrick.update(true)
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
        spinbox.onValueChanged: edtiableBrick.update(true)
    }
    LabelDoubleSpinBox {
        label: qsTr("X")
        id: xPos
        labelWidth: width / 6
        spinbox.from: 1
        spinbox.value: 43
        spinbox.to: 300
        spinbox.editable: true
        width: parent.width / 4
        anchors.top: availableBricks.bottom
        anchors.left: contentScale.right
        anchors.topMargin: AppStyle.spacing
        spinbox.onValueChanged: edtiableBrick.update(true)
    }
    LabelDoubleSpinBox {
        label: qsTr("Y")
        id: yPos
        labelWidth: width / 6
        spinbox.from: 1
        spinbox.value: 33
        spinbox.to: 200
        spinbox.editable: true
        width: parent.width / 4
        anchors.top: availableBricks.bottom
        anchors.left: xPos.right
        anchors.topMargin: AppStyle.spacing
        spinbox.onValueChanged: edtiableBrick.update(true)
    }
    Label {
        width: parent.width / 8
        height: AppStyle.defaultHeight
        id: saveLabel
        text: qsTr("Save as")
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pointSize: AppStyle.spacing * 8 / 6
        anchors.top: yPos.top
        anchors.left: yPos.right
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    Rectangle {
        id: svg
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: parent.left
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
        anchors.left: yPos.left
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

    EditableBrick {
        id: edtiableBrick

        Binding on contentScale {
            when: contentScale.spinbox.value
            value: contentScale.spinbox.value
        }
        Binding on availableSize {
            when: availableSize.comboBox.displayText
            value: availableSize.comboBox.displayText
        }
        Binding on brickPath {
            when: availableBricks.comboBox.currentIndex
                  || availableSize.comboBox.displayText
            value: bricks.brickPath(availableBricks.comboBox.currentIndex,
                                    availableSize.comboBox.displayText)
        }
        Binding on brickColor {
            when: availableBricks.comboBox.displayText
            value: availableBricks.comboBox.displayText
        }
        Binding on xPos {
            when: xPos.spinbox.value
            value: xPos.spinbox.value
        }
        Binding on yPos {
            when: yPos.spinbox.value
            value: yPos.spinbox.value
        }

        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        onStatusChanged: root.updateStatusMessage(edtiableBrick.status)

        savePNG: png_check.checked
        saveJSON: json_check.checked
        saveSVG: svg_check.checked


        /*onFileLoaded: {
            //console.log(edtiableBrick.brickColor,
                        availableBricks.comboBox.model.indexOf(
                            edtiableBrick.brick.brickColor))
           // availableBricks.comboBox.currentIndex = availableBricks.comboBox.model.indexOf(
                        edtiableBrick.brick.brickColor)
            //xPos.spinbox.value = edtiableBrick.brick.x
            //yPos.spinbox.value = edtiableBrick.brick.y
        }*/
    }
}
