import QtQuick
import QtQuick.Controls

import app

Item {
    id: root
    property alias value: textField.text
    signal dataChanged(string newValue)

    Label {
        id: label
        text: settingName
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        font: FontStyle.bold.font
        anchors.margins: AppStyle.spacing
        elide: Label.ElideRight
        height: parent.height
    }
    TextField {
        id: textField
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: AppStyle.spacing
        anchors.left: label.right
        height: parent.height
        font: FontStyle.light.font
    }
}
