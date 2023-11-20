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
        y: frame.height / 8
        width: frame.width / 2
        height: frame.height / 2
        hoverEnabled: true
        ToolTip.visible: containsMouse
        ToolTip.text: "Filter bricks"
    }
}
