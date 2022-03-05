import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../assets"
import "../font"

T.CheckBox {
    text: "right"
    id: control

    indicator: Rectangle {
        implicitWidth: 26
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 3
        border.color: control.down ? "dimgray" : "black"

        Rectangle {
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 2
            color: "lightgray"
            visible: control.checked
        }
    }
}
