import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

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

    MouseArea {
        anchors.fill: root
        onClicked: root.forceActiveFocus()
    }
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
            font.family: "Roboto"
            elide: Text.ElideLeft
            elideWidth: path.field.width
            text: folderDialog.folder
        }
        onAccepted: {
            textMetrics.text = folder
        }
    }

    LabelDoubleSpinBox {
        label: qsTr("Content scale")
        id: contentScale
        spinbox.from: 25
        spinbox.to: 300
        spinbox.value: 100
        width: parent.width / 2
        anchors.top: path.bottom
        anchors.left: parent.left
        anchors.topMargin: AppStyle.spacing
        spinbox.onValueChanged: edtiableBrick.update(true)
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
            font.pointSize: AppStyle.pointsizeSpacing
            anchors.fill: parent
            checked: true
        }
    }
    Rectangle {
        width: parent.width / 6
        anchors.top: contentScale.bottom
        anchors.left: root.left
        height: AppStyle.defaultHeight
        color: AppStyle.color.window
        CheckBox {
            id: autoSave
            text: "Auto-Save"
            font.pointSize: AppStyle.pointsizeSpacing
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
            font.pointSize: AppStyle.pointsizeSpacing
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
            font.pointSize: AppStyle.pointsizeSpacing
            anchors.fill: parent
            checked: true
        }
    }

    Rectangle {
        anchors.fill: edtiableBrick
        color: AppStyle.color.midlight
        radius: 5
    }

    Button {
        text: qsTr("Reset Default")
        id: defaultButton
        width: parent.width / 4
        anchors.top: path.bottom
        anchors.left: contentScale.right
        anchors.topMargin: AppStyle.spacing
        onClicked: {
            xSlider.value = xSlider.defaultValue
            ySlider.value = ySlider.defaultValue
            contentScale.spinbox.value = 100
        }
    }
    EditableBrick {
        id: edtiableBrick
        asynchronous: false
        onAvailableSizeChanged: {
            if (availableSize == "0h") {
                ySlider.from = 0
                ySlider.to = 0
            }
            if (availableSize == "1h") {
                ySlider.from = 60
                ySlider.to = 15
            }
            if (availableSize == "2h") {
                ySlider.from = 85
                ySlider.to = 15
            }
            if (availableSize == "3h") {
                ySlider.from = 110
                ySlider.to = 15
            }
        }
        Binding on contentScale {
            when: contentScale.spinbox.value
            value: contentScale.spinbox.value
        }
        Binding on xPos {
            when: xSlider.value
            value: xSlider.value
        }
        Binding on yPos {
            when: ySlider.value
            value: ySlider.value
        }

        anchors.right: parent.right
        anchors.left: ySlider.right
        anchors.leftMargin: AppStyle.spacing / 2
        anchors.bottom: bottomPadding.top
        onStatusChanged: root.updateStatusMessage(edtiableBrick.status)
        modified: true
        onSave: saveBrick()

        function saveBrick() {
            var statusText = "INFO: Saved brick(s) as: "
            var filename = edtiableBrick.brick.fileName()
            if (!filename || !modified && edtiableBrick.brickColor.search(
                        "collapsed") < 0)
                return
            if (svg_check.checked) {
                edtiableBrick.brick.saveSVG(textMetrics.text)
                statusText += filename + ".svg "
            }
            if (json_check.checked) {
                edtiableBrick.brick.saveJSON(textMetrics.text)
                statusText += filename + ".json "
            }
            if (png_check.checked) {
                edtiableBrick.brick.savePNG(textMetrics.text)
                statusText += filename + ".png "
            }
            modified = false
            statusText += " to " + textMetrics.text
            root.updateStatusMessage(statusText)
        }
    }
    Slider {
        id: xSlider
        width: root.width
        anchors.bottom: edtiableBrick.top
        anchors.left: edtiableBrick.left
        anchors.right: edtiableBrick.right
        anchors.margins: AppStyle.spacing / 2
        from: 1
        to: 345
        property int defaultValue: 43
        value: defaultValue
    }
    Slider {
        id: ySlider
        anchors.left: root.left
        anchors.bottom: edtiableBrick.bottom
        anchors.top: edtiableBrick.top
        anchors.margins: AppStyle.spacing / 2
        from: 60
        to: 15
        orientation: Qt.Vertical
        property int defaultValue: 33
        value: defaultValue
    }

    Rectangle {
        id: bottomPadding
        height: edtiableBrick.brickColor.search(
                    "collapsed") > -1 ? AppStyle.defaultHeight * 2 : 0
        anchors.bottom: parent.bottom
    }
}
