import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import QtQuick.Layouts

import Brick 1.0

import "../assets/simple"
import "../assets/combined"
import "../views/interface"
import "../style"

Item {
    id: root
    signal updateStatusMessage(string text)
    anchors.fill: parent
    anchors.margins: AppStyle.spacing
    property int minimumHeight: path.height + 50 + svg_check.height + edtiableBrick.height
                                + xSlider.height + bottomPadding.height
                                + contentScale.height + 6 * AppStyle.spacing
    MouseArea {
        anchors.fill: root
        onClicked: root.forceActiveFocus()
    }
    Keys.onPressed: event => {
                        if (event.matches(StandardKey.Save)) {
                            edtiableBrick.saveBrick()
                        } else if (event.matches(StandardKey.SelectAll)) {
                            edtiableBrick.selectAll()
                        }
                    }
    LabelTextField {
        id: brickName
        anchors.top: root.top
        property string folderPath: tempFolder.replace(fileStub, "")
        width: root.width / 2
        label: "Name:"
        field.text: "new_brick"
        field.enabled: autoSave.checked
        field.validator: RegularExpressionValidator {
            regularExpression: /\w+/
        }
        field.hoverEnabled: true
        field.ToolTip.delay: 1000
        field.ToolTip.timeout: 5000
        field.ToolTip.visible: brickName.field.hovered
        field.ToolTip.text: brickName.folderPath
    }
    FolderDialog {
        id: folderDialog
        folder: tempFolder.replace(fileStub, "")
        onAccepted: brickName.folderPath = folder
    }
    IconButton {
        id: path
        icon.source: "qrc:/bricks/resources/folder_open_black_24dp.svg"
        anchors.left: brickName.right
        anchors.top: root.top
        onPressed: folderDialog.open()
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: path.hovered
        ToolTip.text: "Set export path …"
    }

    CheckBox {
        id: svg_check
        text: "SVG"
        anchors.bottom: path.bottom
        anchors.left: path.right
        anchors.leftMargin: AppStyle.spacing
        checked: true
    }

    CheckBox {
        id: json_check
        text: "JSON"
        anchors.bottom: svg_check.bottom
        anchors.left: svg_check.right
        height: AppStyle.defaultHeight
        checked: true
    }

    CheckBox {
        id: png_check
        text: "PNG"
        anchors.left: json_check.right
        anchors.bottom: svg_check.bottom
        checked: true
    }

    Rectangle {
        anchors.fill: edtiableBrick
        color: palette.midlight
        radius: 5
    }
    LabelSlider {
        label: qsTr("Content scale")
        id: contentScale
        slider.from: 25
        slider.to: 300
        slider.value: 100
        width: parent.width / 2
        anchors.bottom: xSlider.top
        anchors.left: parent.left
        anchors.topMargin: AppStyle.spacing
        slider.onValueChanged: edtiableBrick.dataChanged()
    }

    Button {
        text: qsTr("Reset Default")
        id: defaultButton
        width: parent.width / 4
        anchors.bottom: xSlider.top
        anchors.left: contentScale.right
        anchors.topMargin: AppStyle.spacing
        onClicked: {
            xSlider.value = xSlider.defaultValue
            ySlider.value = ySlider.defaultValue
            contentScale.slider.value = 100
            edtiableBrick.update(true)
        }
    }
    CheckBox {
        id: autoSave
        text: "Auto-Save"
        font.pointSize: AppStyle.pointsizeSpacing
        anchors.leftMargin: AppStyle.spacing
        anchors.bottom: xSlider.top
        anchors.left: defaultButton.right
        height: AppStyle.defaultHeight
        checked: false
        onCheckedChanged: {
            if (!autoSave.checked) {
                brickName.field.text = edtiableBrick.brick.cleanFileName(
                            edtiableBrick.content.text)
            }
            if (!brickName.field.text)
                brickName.field.text = "new_brick"
        }
    }
    Loader {
        id: editor
        anchors.bottom: defaultButton.top
        anchors.left: root.left
        anchors.top: path.bottom
        anchors.right: root.right
        anchors.margins: AppStyle.spacing
        sourceComponent: edtiableBrick.editor
        Component.onCompleted: {
            item.ok_button.visible = false
        }
    }

    EditableBrick {
        id: edtiableBrick
        DropArea {
            anchors.fill: parent
            onDropped: function (drop) {
                for (const url of drop.urls) {
                    edtiableBrick.loadFromFile(url)
                }
            }
        }
        asynchronous: false
        colorButton.visible: false
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
            when: contentScale.slider.value
            value: contentScale.slider.value
        }
        Binding on xPos {
            when: xSlider.value
            value: xSlider.value
        }
        Binding on yPos {
            when: ySlider.value
            value: ySlider.value
        }
        Timer {
            id: autoSaveTimeout
            interval: 500
            onTriggered: {
                edtiableBrick.dataChanged()
                edtiableBrick.save()
            }
        }
        content.onTextChanged: {
            if (!autoSave.checked) {
                brickName.field.text = edtiableBrick.brick.cleanFileName(
                            content.text)
            } else {
                dataChanged()
                save()
                autoSaveTimeout.running = true
            }
        }
        content.onEditingFinished: {
            dataChanged()
        }
        Keys.onPressed: event => {
                            if (event.matches(StandardKey.Save)) {
                                root.forceActiveFocus()
                                saveBrick()
                            } else if (event.matches(StandardKey.Cancel)) {
                                root.forceActiveFocus()
                            }
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
            var filename = brickName.field.text
            if (!filename || !brickName.folderPath)
                return
            if (svg_check.checked) {
                edtiableBrick.brick.saveSVG(brickName.folderPath, filename)
                statusText += filename + ".svg "
            }
            if (json_check.checked) {
                edtiableBrick.brick.saveJSON(brickName.folderPath, filename)
                statusText += filename + ".json "
            }
            if (png_check.checked) {
                edtiableBrick.brick.savePNG(brickName.folderPath, filename)
                statusText += filename + ".png "
            }
            modified = false
            statusText += " to " + brickName.folderPath
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
        onValueChanged: edtiableBrick.dataChanged()
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
        onValueChanged: edtiableBrick.dataChanged()
    }

    Rectangle {
        id: bottomPadding
        color: AppStyle.color.base

        height: edtiableBrick.brickColor.search(
                    "collapsed") > -1 ? AppStyle.defaultHeight * 2 : 0
        anchors.bottom: parent.bottom
    }
}
