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

        anchors.right: frame.right
        y: 1.7 * frame.height / 3
        height: frame.height / 2.2
        width: frame.width
        hoverEnabled: true
        ToolTip.visible: containsMouse
        ToolTip.text: "Brick information"
    }
}
