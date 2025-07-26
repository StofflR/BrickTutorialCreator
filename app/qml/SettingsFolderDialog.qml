import QtQuick
import QtQuick.Controls

import Qt.labs.platform

import app

Item {
    id: root
    anchors.fill: parent

    property alias value: folderDialog.folder

    Label {
        id: label
        text: settingName
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.margins: AppStyle.spacing
        font: FontStyle.bold.font
        elide: Label.ElideRight
        height: parent.height
    }
    Rectangle {
        id: folderButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: AppStyle.spacing
        anchors.leftMargin: AppStyle.spacing
        anchors.left: label.right
        height: parent.height
        border.color: "grey"
        color: AppStyle.color.button
        radius: AppStyle.borderRadius

        Label {
            id: dataLabel
            anchors.leftMargin: AppStyle.spacing
            anchors.rightMargin: AppStyle.spacing
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font: FontStyle.light.font
            elide: Text.ElideLeft
            text: folderDialog.folder
            ToolTip {
                text: folderDialog.folder
                font: FontStyle.light.font
                delay: 500
                visible: hover.hovered
                parent: folderButton
            }
            HoverHandler {
                id: hover
            }
            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: folderDialog.open()
            }
        }
    }
    FolderDialog {
        id: folderDialog
        title: "Select Folder"
    }
}
