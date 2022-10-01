import QtQuick 2.15
import QtQuick.Controls 2.15

import "../assets"
import "../font"
import "../style"

TextField {
    id: control
    placeholderText: qsTr("Enter description")
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pixelSize: AppStyle.spacing
    leftInset: -AppStyle.spacing
    background: Rectangle {
        implicitWidth: AppStyle.defaultWidth
        implicitHeight: AppStyle.defaultHeight
        border.color: control.down ? "dimgray" : "black"
        border.width: 1
        radius: 2
    }
}
