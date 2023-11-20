import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    image: Component {
        Image {
            anchors.fill: parent
            source: "qrc:/help/resources/help/brick_creator.png"
        }
    }
    MouseArea {
        Rectangle {
            color: "transparent"
            border.color: "yellow"
            anchors.fill: parent
        }
        y: frame.height / 20
        x: frame.width / 1.82
        width: frame.width / 3
        height: frame.height / 12
        hoverEnabled: true
        ToolTip.visible: containsMouse
        ToolTip.text: "Save options"
    }
    MouseArea {
        Rectangle {
            color: "transparent"
            border.color: "yellow"
            anchors.fill: parent
        }
        anchors.right: frame.right
        y: 4 * frame.height / 7
        height: frame.height / 12
        width: frame.width / 4
        hoverEnabled: true
        ToolTip.visible: containsMouse
        ToolTip.text: "Auto save"
    }
}
