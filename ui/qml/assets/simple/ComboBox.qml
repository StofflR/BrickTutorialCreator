import QtQuick 2.12
import QtQuick.Controls 2.0 as T
import QtQml 2.12

import "../../style"

T.ComboBox {
    id: control

    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing

    indicator.x: control.width - width - control.rightPadding
    indicator.y: control.topPadding + (control.availableHeight - height) / 2
    indicator.width: 12
    indicator.height: 8

    background.implicitWidth: 120
    background.implicitHeight: AppStyle.defaultHeight

    popup.y: control.height - 1
    popup.width: control.width
    popup.implicitHeight: contentItem.implicitHeight
}
