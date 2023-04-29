import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../assets"
import "../font"
import "../style"

T.Button {
    id: control
    implicitHeight: AppStyle.defaultHeight
    implicitWidth: AppStyle.defaultHeight
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pointSize: AppStyle.pointsizeSpacing
    opacity: enabled ? 1.0 : 0.3
    icon.color: AppStyle.color.text
    background: Rectangle {
        implicitHeight: AppStyle.defaultHeight
        implicitWidth: AppStyle.defaultHeight
        opacity: enabled ? 1 : 0.3
        border.color: Qt.darker(AppStyle.color.window)
        color: AppStyle.color.light
        border.width: 1
        radius: 2
    }
}
