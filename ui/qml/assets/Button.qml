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
        font.pointSize: AppStyle.spacing * 8 / 6
        opacity: enabled ? 1.0 : 0.3
        color: dangerButton ? control.down ? "lightcoral" : "red" : AppStyle.color.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        opacity: enabled ? 1 : 0.3
        border.color: dangerButton ? "red" :  Qt.darker(AppStyle.color.window)
        border.width: 1
        radius: 2
        color: AppStyle.color.light
    }
}
