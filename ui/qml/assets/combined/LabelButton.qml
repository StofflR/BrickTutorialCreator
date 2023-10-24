import QtQuick 2.0
import QtQuick.Controls 2.0

import "../../style"
import "../simple"

Item {
    id: item
    width: 600
    height: AppStyle.defaultHeight
    property var label: qsTr("Label")
    property var button_label: qsTr("Button")
    Label {
        width: item.width / 2 - AppStyle.spacing
        height: item.height
        id: label
        text: item.label
        font.family: "Roboto"
        font.pointSize: AppStyle.pointsizeSpacing
        anchors.verticalCenter: item.verticalCenter
        anchors.top: parent.top
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    Button {
        width: item.width / 2 - AppStyle.spacing
        height: item.height
        id: button
        anchors.top: parent.top
        anchors.left: label.right
        anchors.leftMargin: 20
        text: "Button"
    }
}
