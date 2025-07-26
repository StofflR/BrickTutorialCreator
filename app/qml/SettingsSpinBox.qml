import QtQuick
import QtQuick.Controls

import app

Item {
    id: root

    property alias value: spinBox.value

    Label {
        id: label
        text: settingName
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        font: FontStyle.bold.font
        anchors.margins: AppStyle.spacing
        elide: Label.ElideRight
        height: parent.height
    }
    SpinBox {
        id: spinBox
        editable: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: AppStyle.spacing
        anchors.left: label.right
        font: FontStyle.light.font
        height: parent.height

        from: 100
        to: Math.pow(2, 31) - 1

        WheelHandler {
            id: fastWheel
            acceptedModifiers: Qt.ControlModifier
            onWheel: event => {
                if (event.angleDelta.y > 0) {
                    spinBox.value += 100;
                } else if (event.angleDelta.y < 0) {
                    spinBox.value -= 100;
                }
                event.accepted = true;
            }
        }
        WheelHandler {
            acceptedModifiers: Qt.NoModifier
            onWheel: event => {
                if (event.angleDelta.y > 0) {
                    spinBox.value += 10;
                } else if (event.angleDelta.y < 0) {
                    spinBox.value -= 10;
                }
                event.accepted = true;
            }
        }
        WheelHandler {
            acceptedModifiers: Qt.ShiftModifier
            onWheel: event => {
                if (event.angleDelta.y > 0) {
                    spinBox.value += 1;
                } else if (event.angleDelta.y < 0) {
                    spinBox.value -= 1;
                }
                event.accepted = true;
            }
        }
    }
}
