import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Dialogs

import ColorManager 1.0
import Brick 1.0

import "../../assets/simple"
import "../../style"

Item {
    id: colorSelector
    implicitWidth: 400
    implicitHeight: 200 + header.height + addNewColor.height + 2 * AppStyle.spacing
    property double listViewHeight: colorSelector.height - header.height
    ColorManager {
        id: manager
        property int channel: 0
        property int index: 0
    }
    signal baseChanged(string color, string baseFile, string size)
    signal selectionChanged(string base, string type, string background, string shade, string border, string size)

    property alias ok_button: ok

    onSelectionChanged: (base, type, background, shade, border, size) => {
                            if (!base || !background || !shade || !border
                                || !size) {
                                return
                            }
                            var control = type ? (type.search(
                                                      "control") > -1 ? "_control" : "")
                                                 + (type.search(
                                                        "collapsed") > -1 ? "_collapsed" : "") : ""
                            var file = "brick_" + base + "_" + size + control + ".svg"
                            var baseFile = "base_" + size + control + ".svg"

                            if (!manager.exists(file)
                                || colorList.currentIndex >= manager.customIndex) {
                                manager.addBaseType(file, background, shade,
                                                    border, baseFile)
                            }
                            control = type ? (type.search(
                                                  "control") > -1 ? " (control)" : "")
                                             + (type.search(
                                                    "collapsed") > -1 ? " (collapsed)" : "") : ""
                            baseChanged(base + control, file, size)
                        }

    Rectangle {
        id: header
        width: colorSelector.width * 2 / 3
        height: backText.height
        color: palette.base
        Label {
            id: backText
            text: "Back"
            width: header.width / 5
            font: lightRoboto
            horizontalAlignment: Text.AlignHCenter
        }
        Label {
            id: shadeText
            text: "Shade"
            anchors.left: backText.right
            width: header.width / 5
            font: lightRoboto
            horizontalAlignment: Text.AlignHCenter
        }
        Label {
            id: borderText
            text: "Border"
            anchors.left: shadeText.right
            width: header.width / 5
            font: lightRoboto
            horizontalAlignment: Text.AlignHCenter
        }
        Label {
            text: "Name"
            width: header.width * 2 / 5
            anchors.left: borderText.right
            font: lightRoboto
            horizontalAlignment: Text.AlignHCenter
        }
    }
    ListView {
        id: colorList
        anchors.top: header.bottom
        width: colorSelector.width * 2 / 3
        height: colorSelector.listViewHeight
        model: manager.model
        clip: true
        property string brickColor
        property string brickShade
        property string brickBorder
        property string brickName

        onCurrentIndexChanged: {
            colorSelector.selectionChanged(colorList.brickName,
                                           sizeList.brickType,
                                           colorList.brickColor,
                                           colorList.brickShade,
                                           colorList.brickBorder,
                                           sizeList.brickSize)
        }

        ScrollBar.vertical: ScrollBar {
            active: true
        }

        footer: Item {
            width: colorList.width
            height: addCustomColorButton.height
            IconButton {
                id: addCustomColorButton
                height: 15
                anchors.centerIn: parent
                icon.source: "qrc:/bricks/resources/add_black_24dp.svg"
                onClicked: {
                    manager.addCustomColor()
                    colorList.currentIndex = colorList.count - 1
                }
            }
        }
        delegate: ItemDelegate {
            id: delegate
            width: colorSelector.width * 2 / 3
            height: name.height
            onClicked: colorList.currentIndex = index
            property bool selected: index == colorList.currentIndex
            onSelectedChanged: if (selected) {
                                   colorList.brickColor = modelData.color
                                   colorList.brickShade = modelData.shade
                                   colorList.brickBorder = modelData.border
                                   colorList.brickName = modelData.name
                                   colorSelector.selectionChanged(
                                               colorList.brickName,
                                               sizeList.brickType,
                                               colorList.brickColor,
                                               colorList.brickShade,
                                               colorList.brickBorder,
                                               sizeList.brickSize)
                               }
            background: Rectangle {
                height: delegate.height
                width: delegate.width
                color: selected ? palette.midlight : palette.window
            }

            Rectangle {
                id: background
                width: delegate.width / 5
                height: name.height
                color: "#" + (modelData.color.length == 8 ? modelData.color.slice(
                                                                0,
                                                                6) : modelData.color)
                IconButton {
                    height: 15
                    visible: index >= manager.customIndex
                    anchors.right: parent.right
                    icon.source: "qrc:/bricks/resources/build_black_24dp.svg"
                    onClicked: {
                        manager.channel = 0
                        manager.index = index
                        colorDialog.open()
                    }
                }
            }
            Rectangle {
                id: shade
                anchors.left: background.right
                width: delegate.width / 5
                height: name.height
                color: "#" + (modelData.shade.length == 8 ? modelData.shade.slice(
                                                                0,
                                                                6) : modelData.shade)
                IconButton {
                    height: 15
                    visible: index >= manager.customIndex
                    anchors.right: parent.right
                    icon.source: "qrc:/bricks/resources/build_black_24dp.svg"
                    onClicked: {
                        manager.channel = 1
                        manager.index = index
                        colorDialog.open()
                    }
                }
            }
            Rectangle {
                id: border
                anchors.left: shade.right
                width: delegate.width / 5
                height: name.height
                color: "#" + (modelData.border.length == 8 ? modelData.border.slice(
                                                                 0,
                                                                 6) : modelData.border)
                IconButton {
                    height: 15
                    visible: index >= manager.customIndex
                    anchors.right: parent.right
                    icon.source: "qrc:/bricks/resources/build_black_24dp.svg"
                    onClicked: {
                        manager.channel = 2
                        manager.index = index
                        colorDialog.open()
                    }
                }
            }
            TextEdit {
                id: name
                text: modelData.name
                width: delegate.width * 2 / 5
                anchors.left: border.right
                font: lightRoboto
                color: name.palette.windowText
                enabled: index >= manager.customIndex
                horizontalAlignment: Text.AlignHCenter
                onEditingFinished: {
                    if (manager.setName(index, name.text))
                        colorList.currentIndex = index
                }
                selectByMouse: true
                onFocusChanged: if (activeFocus)
                                    colorList.currentIndex = index
            }
        }
    }
    Rectangle {
        id: headerSize
        anchors.left: sizeList.left
        height: backText.height
        width: sizeList.width
        color: palette.base
        Label {
            text: "Size"
            width: headerSize.width
            anchors.fill: headerSize
            font: lightRoboto
            horizontalAlignment: Text.AlignHCenter
        }
    }
    ListView {
        id: sizeList
        width: colorSelector.width / 3 - 2 * AppStyle.spacing
        height: colorSelector.listViewHeight
        anchors.left: colorList.right
        anchors.top: headerSize.bottom
        anchors.leftMargin: AppStyle.spacing
        clip: true

        ScrollBar.vertical: ScrollBar {
            active: true
        }

        model: [{
                "text": "1h",
                "type": "",
                "size": "1h"
            }, {
                "text": "2h",
                "type": "",
                "size": "2h"
            }, {
                "text": "3h",
                "type": "",
                "size": "3h"
            }, {
                "text": "1h (control)",
                "type": "control",
                "size": "1h"
            }, {
                "text": "2h (control)",
                "type": "control",
                "size": "2h"
            }, {
                "text": "0h (collapsed)",
                "type": "collapsed",
                "size": "0h"
            }]
        property string brickType
        property string brickSize
        delegate: ItemDelegate {
            id: sizeDelegate
            height: sizeText.height
            width: sizeList.width
            onClicked: sizeList.currentIndex = index
            property bool selected: index == sizeList.currentIndex

            onSelectedChanged: if (selected) {
                                   sizeList.brickType = modelData.type
                                   sizeList.brickSize = modelData.size
                                   colorSelector.selectionChanged(
                                               colorList.brickName,
                                               sizeList.brickType,
                                               colorList.brickColor,
                                               colorList.brickShade,
                                               colorList.brickBorder,
                                               sizeList.brickSize)
                               }

            background: Rectangle {
                height: sizeText.height
                width: sizeList.width
                color: selected ? palette.midlight : palette.window
            }
            Label {
                id: sizeText
                text: modelData.text
                width: sizeList.width
                font: lightRoboto
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    IconButton {
        id: addNewColor
        visible: false
        anchors.margins: AppStyle.spacing
        anchors.top: colorList.bottom
        icon.source: "qrc:/bricks/resources/add_circle_black_24dp.svg"
    }
    IconButton {
        id: ok
        anchors.margins: AppStyle.spacing
        anchors.top: colorList.bottom
        icon.source: "qrc:/bricks/resources/done_black_24dp.svg"
    }
    ColorDialog {
        id: colorDialog
        onSelectedColorChanged: {
            manager.setColor(manager.index, manager.channel,
                             colorDialog.selectedColor.toString().replace("#",
                                                                          ""))
            colorList.currentIndex = manager.index
        }
    }
}
