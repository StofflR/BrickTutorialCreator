import QtQuick
import QtQuick.Controls

import app

Item {
    id: root
    anchors.fill: parent

    property alias value: checkBox.checked

    Label {
        id: label
        text: settingName
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        font: FontStyle.bold.font
        anchors.margins: AppStyle.spacing
        elide: Label.ElideRight
        anchors.right: checkBox.left
        height: parent.height
    }
    CheckBox {
        id: checkBox
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: AppStyle.spacing
        font: FontStyle.light.font
        height: parent.height
    }
}
