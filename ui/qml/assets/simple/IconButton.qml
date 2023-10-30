import QtQuick 2.0
import QtQuick.Controls 2.0 as T

import "../../style"

T.Button {
    id: control
    implicitHeight: AppStyle.defaultHeight
    implicitWidth: AppStyle.defaultHeight
    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing
    opacity: enabled ? 1.0 : 0.3

    icon.color: control.checked
                || control.highlighted ? control.palette.brightText : control.flat
                                         && !control.down ? (control.visualFocus ? control.palette.highlight : control.palette.windowText) : control.palette.buttonText
    background.implicitHeight: AppStyle.defaultHeight
    background.implicitWidth: AppStyle.defaultHeight
}
