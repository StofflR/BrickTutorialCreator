import QtQuick 2.15
import QtQuick.Controls 2.15

import "../../style"

TextField {
    id: control
    placeholderText: qsTr("Enter description")
    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing
    leftInset: -AppStyle.spacing
    background: Rectangle {
        implicitWidth: AppStyle.defaultWidth
        implicitHeight: AppStyle.defaultHeight
        border.color: Qt.darker(AppStyle.color.window)
        border.width: 1
        radius: 2
        color: AppStyle.color.light
    }
}
