import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Dialogs

import BrickManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Popup {
    id: colorSelector
    anchors.centerIn: Overlay.overlay
    width: 400
    height: colorList.contentHeight + 2 * AppStyle.spacing
    ListView {
        id: colorList
        width: colorSelector.width / 2
        height: colorSelector.height
        model: AppStyle.colorSchemes
        interactive: false
        header: ItemDelegate {
            id: header
            width: colorSelector.width / 2
            enabled: false
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
        delegate: ItemDelegate {
            id: delegate
            width: colorSelector.width / 2
            height: name.height
            onClicked: colorList.currentIndex = index
            background: Rectangle {
                color: index == colorList.currentIndex ? Qt.lighter(
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
        width: colorSelector.width / 3
        height: colorSelector.height
        anchors.left: colorList.right
        anchors.margins: AppStyle.spacing
        model: [{
                "text": "1h"
            }, {
                "text": "2h"
            }, {
                "text": "3h"
            }, {
                "text": "1h (control)"
            }, {
                "text": "2h (control)"
            }]
        header: ItemDelegate {
            width: colorSelector.width / 3
            enabled: false
            Text {
                text: "Size"
                width: colorSelector.width / 3
                font: Font.lightFont
                color: AppStyle.color.text
                horizontalAlignment: Text.AlignHCenter
            }
        }
        delegate: ItemDelegate {
            height: sizeText.height
            width: colorSelector.width / 3
            onClicked: sizeList.currentIndex = index
            background: Rectangle {
                color: index
                       == sizeList.currentIndex ? Qt.lighter(
                                                      AppStyle.color.window) : AppStyle.color.window
                height: sizeText.height
                width: colorSelector.width / 3
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
    ColorDialog {
        id: borderDialog
    }
    ColorDialog {
        id: contentDialog
    }
    ColorDialog {
        id: shadeDialog
    }
}
