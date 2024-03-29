import QtQuick 2.15
import QtQuick.Controls 2.15

import "../../style"
import "../simple"

Item {
    id: item
    width: 600
    height: AppStyle.defaultHeight
    property var button_label: qsTr("Button")
    property alias button: button
    property alias field: field
    Button {
        id: button
        text: button_label
        width: item.width / 4 - AppStyle.spacing
        height: item.height
        anchors.top: parent.top
        anchors.left: parent.left 
    }
    Field {
        id: field
        width: item.width * 3 / 4 - AppStyle.spacing
        height: item.height
        anchors.top: parent.top
        anchors.left: button.right
        anchors.leftMargin: 20
    }
}
