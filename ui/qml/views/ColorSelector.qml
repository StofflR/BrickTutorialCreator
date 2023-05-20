import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Dialogs

import ColorManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Popup {
    id: colorSelector
    anchors.centerIn: Overlay.overlay
    width: 400
    height: 200 + header.height + addNewColor.height + 2 * AppStyle.spacing

    ColorManager {
        id: manager
    }
    signal baseChanged(string color, string baseFile, string size)
    signal selectionChanged(string base, string type, string background, string shade, string border, string size)

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

                            if (!manager.exists(file)) {
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
        color: AppStyle.color.window
        Text {
            id: backText
            text: "Back"
            width: header.width / 5
            font: Font.lightFont
            color: AppStyle.color.text
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            id: shadeText
            text: "Shade"
            anchors.left: backText.right
            width: header.width / 5
            font: Font.lightFont
            color: AppStyle.color.text
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            id: borderText
            text: "Border"
            anchors.left: shadeText.right
            width: header.width / 5
            font: Font.lightFont
            color: AppStyle.color.text
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            text: "Name"
            width: header.width * 2 / 5
            anchors.left: borderText.right
            font: Font.lightFont
            color: AppStyle.color.text
            horizontalAlignment: Text.AlignHCenter
        }
    }
    ListView {
        id: colorList
        anchors.top: header.bottom
        width: colorSelector.width * 2 / 3
        height: 200
        model: AppStyle.colorSchemes
        clip: true

        property string brickColor
        property string brickShade
        property string brickBorder
        property string brickName

        onCurrentIndexChanged: colorSelector.selectionChanged(
                                   colorList.brickName, sizeList.brickType,
                                   colorList.brickColor, colorList.brickShade,
                                   colorList.brickBorder, sizeList.brickSize)

        ScrollBar.vertical: ScrollBar {
            active: true
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
                color: selected ? Qt.lighter(
                                      AppStyle.color.window) : AppStyle.color.window
                height: delegate.height
                width: delegate.width
            }

            Rectangle {
                id: background
                width: delegate.width / 5
                height: name.height
                color: "#" + modelData.color
            }
            Rectangle {
                id: shade
                anchors.left: background.right
                width: delegate.width / 5
                height: name.height
                color: "#" + modelData.shade
            }
            Rectangle {
                id: border
                anchors.left: shade.right
                width: delegate.width / 5
                height: name.height
                color: "#" + modelData.border
            }
            Text {
                id: name
                text: modelData.name
                width: delegate.width * 2 / 5
                anchors.left: border.right
                font: Font.lightFont
                color: AppStyle.color.text
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    ListView {
        id: sizeList
        width: colorSelector.width / 3 - 2 * AppStyle.spacing
        height: colorSelector.height
        anchors.left: colorList.right
        anchors.margins: AppStyle.spacing

        interactive: false

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

        header: ItemDelegate {
            width: sizeList.width
            enabled: false
            Text {
                text: "Size"
                width: sizeList.width
                font: Font.lightFont
                color: AppStyle.color.text
                horizontalAlignment: Text.AlignHCenter
            }
        }
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
                color: selected ? Qt.lighter(
                                      AppStyle.color.window) : AppStyle.color.window
                height: sizeText.height
                width: sizeList.width
            }
            Text {
                id: sizeText
                text: modelData.text
                width: sizeList.width
                font: Font.lightFont
                color: AppStyle.color.text
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    IconButton {
        id: addNewColor
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
    }
}
