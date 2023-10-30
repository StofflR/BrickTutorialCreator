import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../../style"

T.CheckBox {
    text: "right"
    id: control

    indicator.implicitWidth: 26
    indicator.implicitHeight: 26
    indicator.x: control.leftPadding
    indicator.y: parent.height / 2 - height / 2
}
