import QtQuick 2.15
import QtQuick.Controls 2.15 as T

import "../assets"
import "../font"

T.TabButton {
    id: creator
    text: qsTr("Creator")
    opacity: enabled ? 1.0 : 0.3
    contentItem: Text {
        text: creator.text
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: 10
        opacity: enabled ? 1.0 : 0.3
        color: creator.down ? "dimgray" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
