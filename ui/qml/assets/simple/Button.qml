import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../../style"

T.Button {
    id: control
    text: qsTr("Button")
    height: AppStyle.defaultHeight
    property bool dangerButton: false

    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing

    background.implicitWidth: parent.width
    background.implicitHeight: parent.height
}
