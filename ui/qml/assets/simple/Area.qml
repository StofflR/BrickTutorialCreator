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
    background.implicitWidth: AppStyle.defaultWidth
    background.implicitHeight: AppStyle.defaultHeight
}
