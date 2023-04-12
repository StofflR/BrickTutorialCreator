import QtQuick 2.15
import QtQuick.Controls 2.15 as T

import "../assets"
import "../font"
import "../style"

T.TabButton {
    id: creator
    text: qsTr("Creator")
    opacity: enabled ? 1.0 : 0.3
    contentItem: Text {
        text: creator.text
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: AppStyle.spacing
        opacity: enabled ? 1.0 : 0.3
        color: AppStyle.color.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
