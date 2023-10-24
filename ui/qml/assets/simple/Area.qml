import QtQuick 2.0
import QtQuick.Controls 2.0

import "../../style"

TextArea {
    id: control
    placeholderText: qsTr("Enter description")
    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing
    leftInset: -AppStyle.spacing
    wrapMode: TextEdit.WordWrap
    background: Rectangle {
        implicitWidth: AppStyle.defaultWidth
        implicitHeight: AppStyle.defaultHeight
        color: AppStyle.color.light
        border.color: Qt.darker(AppStyle.color.window)
        border.width: 1
        radius: 2
    }
}
