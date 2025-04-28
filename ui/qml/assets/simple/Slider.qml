import QtQuick
import QtQuick.Controls 2.0 as T

import "../../style"

T.Slider {
    id: control
    hoverEnabled: true
    stepSize: 0.5

    background.x: control.leftPadding + control.vertical ? control.availableWidth
                                                           / 2 - width / 2 : 0
    background.y: control.topPadding + control.availableHeight / 2 - height / 2
    background.implicitWidth: control.vertical ? 4 : 200
    background.implicitHeight: control.vertical ? 200 : 4

    handle.x: control.vertical ? control.availableWidth / 2 - width / 2 : control.leftPadding
                                 + control.visualPosition * (control.availableWidth - width)
    handle.y: control.vertical ? control.topPadding + control.visualPosition
                                 * (control.availableHeight - height) : control.topPadding
                                 + control.availableHeight / 2 - height / 2
    handle.implicitHeight: 4 + AppStyle.spacing
    handle.implicitWidth: 4 + AppStyle.spacing
    T.ToolTip.text: control.value
    T.ToolTip.visible: control.hovered && !control.pressed
    T.ToolTip.delay: 1
}
