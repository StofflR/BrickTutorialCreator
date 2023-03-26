import QtQuick 2.0
import QtQuick.Controls 2.0

import "../assets"
import "../font"
import "../style"

Item {
    id: item
    width: 600
    height: AppStyle.defaultHeight
    property alias spinbox: spinbox
    property var label: qsTr("Label")
    property var button_label: qsTr("Button")
    property alias labelWidth: label.width
    Label {
        width: item.width / 2 - AppStyle.spacing
        height: item.height
        id: label
        text: item.label
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pointSize: AppStyle.spacing * 8 / 6
        anchors.verticalCenter: item.verticalCenter
        anchors.top: parent.top
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    DoubleSpinBox {
        id: spinbox
        width: item.width / 2 - AppStyle.spacing
        height: item.height
        anchors.top: parent.top
        anchors.left: label.right
        anchors.leftMargin: AppStyle.spacing
    }
}
