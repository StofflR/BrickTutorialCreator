import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../assets"
import "../font"

T.Button {
    id: control
    text: qsTr("Button")
    height: 40

    contentItem: Text {
        text: control.text
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: 10
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "dimgray" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "dimgray" : "black"
        border.width: 1
        radius: 2
    }
}
