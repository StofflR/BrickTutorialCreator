import QtQuick
import QtQuick.Controls 2.0 as T

import "../style"

T.Slider {
    id: control
    hoverEnabled: true
    stepSize: 0.5

    background: Rectangle {
        x: control.leftPadding + control.vertical ? control.availableWidth / 2 - width / 2 : 0
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: control.vertical ? 4 : 200
        implicitHeight: control.vertical ? 200 : 4
        width: control.vertical ? implicitWidth : control.width
        height: control.vertical ? control.height : implicitHeight
        radius: 2
        color: Qt.lighter(AppStyle.color.light)
    }
    handle: Rectangle {
        id: handle
        x: control.vertical ? control.availableWidth / 2 - width / 2 : control.leftPadding
                              + control.visualPosition * (control.availableWidth - width)
        y: control.vertical ? control.topPadding + control.visualPosition
                              * (control.availableHeight - height) : control.topPadding
                              + control.availableHeight / 2 - height / 2
        implicitHeight: 4 + AppStyle.spacing
        implicitWidth: 4 + AppStyle.spacing
        radius: 5
        color: control.pressed ? AppStyle.color.midlight : AppStyle.color.light
        T.ToolTip.text: control.value
        T.ToolTip.visible: control.hovered && !control.pressed
        T.ToolTip.delay: 1
    }
}
