import QtQuick 2.15
import QtQuick.Controls 2.15

import "../../style"

TextField {
    id: control
    placeholderText: qsTr("Enter description")
    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing
    leftInset: -AppStyle.spacing
    background.implicitWidth: AppStyle.defaultWidth
    background.implicitHeight: AppStyle.defaultHeight
}
