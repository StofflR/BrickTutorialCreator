import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

import app

Item {
    id: root

    property string extendedInfo: ""

    Item {
        id: brickArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: brickView.height + horizontalSlider.height

        Slider {
            id: horizontalSlider
            height: AppStyle.defaultHeight
            width: brickView.width
            anchors.right: quickSettings.left
            anchors.top: parent.top
            to: brickView.width
            value: 1 / 8 * brickView.width
            onPressedChanged: extendedInfo = Qt.binding(function () {
                return pressed ? "Position x: " + (100 * value / to).toFixed(1) + "%" : "";
            })
        }
        Slider {
            id: verticalSlider
            orientation: Qt.Vertical
            width: AppStyle.defaultHeight
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: brickView.height
            value: brickView.yStartPosition
            to: 0
            from: brickView.height
            onPressedChanged: extendedInfo = Qt.binding(function () {
                return pressed ? "Position y: " + (100 * value / from).toFixed(1) + "%" : "";
            })
        }
        Brick {
            id: brickView
            anchors.top: horizontalSlider.bottom
            anchors.left: verticalSlider.right
            anchors.right: quickSettings.left

            color: colorSelection.color
            colorShade: colorSelection.colorShade
            colorBorder: colorSelection.colorBorder
            colorText: colorSelection.colorText

            baseType: typeSelection.brickType
            brickSize: typeSelection.brickSize

            xPos: horizontalSlider.value
            yPos: verticalSlider.value

            content: brickContent.text

            autoSave: settingsModel.autoSave
            toSVG: settingsModel.exportSVG
            toPNG: settingsModel.exportPNG
            toJSON: settingsModel.exportJSON

            brickName: settingsModel.name
            brickPath: settingsModel.exportPath
            brickWidth: settingsModel.brickWidth

            font: FontStyle.bold.font

            BrickLoader {
                id: brickLoader
                onFileLoaded: (content, type, size, color, shade, border, text) => {
                    brickContent.text = content;
                    typeSelection.setTypeAndSize(type, size);
                    colorSelection.setColors(color, shade, border, text);
                }
                onPositionLoaded: (xPos, yPos) => {
                    horizontalSlider.value = xPos;
                    verticalSlider.value = yPos;
                }
                onWidthLoaded: width => {
                    settingsModel.loadWidth(width);
                }
            }
        }
        ColumnLayout {
            id: quickSettings
            width: AppStyle.defaultHeight + AppStyle.spacing
            anchors.right: parent.right
            anchors.top: horizontalSlider.bottom
            uniformCellSizes: true
            spacing: AppStyle.spacing
            Layout.fillHeight: true
            Button {
                id: resetButton
                implicitWidth: AppStyle.propertyHeight
                implicitHeight: AppStyle.propertyHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                icon.source: AppStyle.icons.refresh_black_24dp
                onClicked: {
                    horizontalSlider.value = brickView.width / 8;
                    verticalSlider.value = brickView.yStartPosition;
                    brickContent.text = "";
                    typeSelection.currentIndex = 1;
                    colorSelection.currentIndex = 0;
                    StatusHandler.statusMessage = "Reset brick to default values.";
                }
            }

            Button {
                id: saveButton
                implicitWidth: AppStyle.propertyHeight
                implicitHeight: AppStyle.propertyHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                icon.source: AppStyle.icons.save_black_24dp
                onClicked: {
                    StatusHandler.statusMessage = "Brick saved.";
                    brickView.saveBrick();
                }
            }

            Button {
                id: fileLoadButton
                implicitWidth: AppStyle.propertyHeight
                implicitHeight: AppStyle.propertyHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                icon.source: AppStyle.icons.file_open_black_24dp
                onClicked: fileDialog.open()
                FileDialog {
                    id: fileDialog
                    title: "Select Brick File"
                    nameFilters: ["JSON files (*.json)", "PNG files (*.png)", "SVG files (*.svg)"]
                    currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
                    onAccepted: brickLoader.loadFile(selectedFile)
                }
            }
            Button {
                id: addColorButton
                implicitWidth: AppStyle.propertyHeight
                implicitHeight: AppStyle.propertyHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                icon.source: AppStyle.icons.color_palette_24dp
                onClicked: colorSelection.model.addCustomColor()
            }
        }
    }
    Item {
        id: settings
        anchors.top: brickArea.bottom
        anchors.topMargin: AppStyle.spacing
        anchors.bottom: parent.bottom
        width: parent.width

        Label {
            id: settingsLabel
            anchors.left: parent.left
            anchors.leftMargin: AppStyle.spacing
            text: "Settings"
            font: FontStyle.bold.font
        }
        Rectangle {
            anchors.left: settingsLabel.right
            anchors.right: parent.right
            anchors.verticalCenter: settingsLabel.verticalCenter
            anchors.leftMargin: AppStyle.spacing
            anchors.rightMargin: AppStyle.spacing
            height: 1
            color: "#1E000000"
        }

        RowLayout {
            id: controlArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: settingsLabel.bottom
            anchors.bottom: parent.bottom
            anchors.margins: AppStyle.spacing

            ColumnLayout {
                id: controlView
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextArea {
                    id: brickContent
                    Layout.fillWidth: true
                    implicitHeight: controlArea.height / 3
                    placeholderText: "Enter brick content here..."
                    placeholderTextColor: AppStyle.color.shadow
                    font: FontStyle.light.font
                }
                RowLayout {
                    id: brickSettings
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Settings {
                        id: settingsSelection
                        model: SettingsModel {
                            id: settingsModel
                        }
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    TypeSelector {
                        id: typeSelection
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        property var brickSize: currentItem?.size ?? "H1"
                        property var brickType: currentItem?.type ?? "Base"
                    }
                }
            }

            ColorSelector {
                id: colorSelection
                Layout.fillHeight: true
                implicitWidth: root.width / 2

                property var color: currentItem?.fillColor ?? "#FFFFFF"
                property var colorBorder: currentItem?.borderColor ?? "#FFFFFF"
                property var colorShade: currentItem?.shadeColor ?? "#FFFFFF"
                property var colorText: currentItem?.textColor ?? "#FFFFFF"
            }
        }
    }
}
