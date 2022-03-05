import QtQuick 2.15
import QtQuick.Controls 2.15

import "../assets"
import "../font"

Item {
    id: item
    width: 600
    height: 40
    property var button_label: qsTr("Button")
    property alias button: button
    property alias field: field
    Button {
        id: button
        text: button_label
        width: item.width / 4 - 10
        height: item.height
        anchors.top: parent.top
        anchors.left: parent.left
    }
    Field {
        id: field
        width: item.width * 3 / 4 - 10
        height: item.height
        anchors.top: parent.top
        anchors.left: button.right
        anchors.leftMargin: 20
    }
}
