import QtQuick 2.15
import QtQuick.Controls 2.15

import "../assets"
import "../font"

TextField {
    id: control
    placeholderText: qsTr("Enter description")
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pixelSize: 10
    leftInset: -10
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        border.color: control.down ? "dimgray" : "black"
        border.width: 1
        radius: 2
    }
}
