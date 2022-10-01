import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import "../font"
import "../views"
import "../style"

ItemDelegate {
    id: root
    signal editPressed
    signal resetPressed
    signal savePressed
    signal advancedPressed

    property string sourcePath
    property string targetPath

    property double editWidth: targetImage.width + reset.width

    width: parent.width
    height: source.height
    Rectangle {
        id: source
        width: parent.width / 2 - 20
        height: sourceImage.height
        Image {
            id: sourceImage
            width: source.width
            source: sourcePath
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: sourcePath
        }
    }
    Rectangle {
        anchors.left: source.right
        id: control
        width: parent.width - source.width - target.width
        height: parent.height
        IconButton {
            id: edit
            width: AppStyle.defaultHeight
            height: root.height / 2
            anchors.top: parent.top
            icon.source: "qrc:/bricks/resources/build_black_24dp.svg"
            icon.color: down ? "dimgray" : "black"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Edit translation")
            onPressed: editPressed()
        }
        IconButton {
            id: reset
            anchors.bottom: parent.bottom
            width: AppStyle.defaultHeight
            height: root.height / 2
            icon.source: "qrc:/bricks/resources/restore_black_24dp.svg"
            icon.color: down ? "dimgray" : "black"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Reset translation")
            onPressed: resetPressed()
        }
    }
    Rectangle {
        anchors.left: control.right
        id: target
        width: parent.width / 2 - 20
        height: targetImage.height
        Image {
            id: targetImage
            width: target.width
            source: targetPath
        }
    }
}
