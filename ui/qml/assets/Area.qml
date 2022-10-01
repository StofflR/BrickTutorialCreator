import QtQuick 2.0
import QtQuick.Controls 2.0

import "../assets"
import "../font"
import "../style"

TextArea {
    id: control
    placeholderText: qsTr("Enter description")
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pixelSize: AppStyle.spacing
    leftInset: -AppStyle.spacing
    wrapMode: TextEdit.WordWrap
    background: Rectangle {
        implicitWidth: AppStyle.defaultWidth
        implicitHeight: AppStyle.defaultHeight
        border.color: control.down ? "dimgray" : "black"
        border.width: 1
        radius: 2
    }
}
