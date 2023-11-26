import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    image: Component {
        Image {
            source: "qrc:/help/resources/help/tutorial.png"
        }
    }
    MouseArea {
        Rectangle {
            color: "transparent"
            border.color: "yellow"
            anchors.fill: parent
        }
        anchors.right: frame.right
        y: frame.height / 3
        width: 4 * frame.width / 9
        height: frame.height / 12
        hoverEnabled: true
        ToolTip.visible: containsMouse
        ToolTip.text: "Filter bricks"
    }
}
