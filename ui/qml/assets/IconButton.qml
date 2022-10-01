import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../assets"
import "../font"
import "../style"

T.Button {
    id: control
    implicitHeight: AppStyle.defaultHeight
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pixelSize: AppStyle.spacing
    opacity: enabled ? 1.0 : 0.3
    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "dimgray" : "black"
        border.width: 1
        radius: 2
    }
}
