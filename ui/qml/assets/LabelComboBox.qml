import QtQuick 2.0
import QtQuick.Controls 2.0

import "../assets"
import "../font"

Item {
    id: item
    width: 600
    height: 40
    property var label: qsTr("Label")
    property alias comboBox: comboBox
    signal displayTextChanged
    Label {
        width: item.width / 2 - 10
        height: item.height
        id: label
        text: item.label
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: 10
        anchors.verticalCenter: item.verticalCenter
        anchors.top: parent.top
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    ComboBox {
        width: item.width / 2 - 10
        height: item.height
        id: comboBox
        anchors.top: parent.top
        anchors.left: label.right
        anchors.leftMargin: 10
        onDisplayTextChanged: item.displayTextChanged()
    }
}
