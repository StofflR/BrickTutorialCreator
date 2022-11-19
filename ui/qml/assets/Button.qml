import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../assets"
import "../font"
import "../style"

T.Button {
    id: control
    text: qsTr("Button")
    height: AppStyle.defaultHeight
    property bool dangerButton: false
    contentItem: Text {
        text: control.text
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: AppStyle.spacing
        opacity: enabled ? 1.0 : 0.3
        color: dangerButton ? control.down ? "lightcoral" : "red" : control.down ? "dimgray" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        opacity: enabled ? 1 : 0.3
        border.color: dangerButton ? control.down ? "lightcoral" : "red" : control.down ? "dimgray" : "black"
        border.width: 1
        radius: 2
    }
}
