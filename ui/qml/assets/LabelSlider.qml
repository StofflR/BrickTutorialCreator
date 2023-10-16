import QtQuick 2.0
import QtQuick.Controls 2.0

import "../assets"
import "../font"
import "../style"

Item {
    id: item
    width: 600
    height: AppStyle.defaultHeight
    property alias slider: slider
    property var label: qsTr("Label")
    property alias labelWidth: label.width
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
    Slider {
        id: slider
        width: item.width / 2 - AppStyle.spacing
        height: item.height
        anchors.top: parent.top
        anchors.left: label.right
        anchors.leftMargin: AppStyle.spacing
    }
}
