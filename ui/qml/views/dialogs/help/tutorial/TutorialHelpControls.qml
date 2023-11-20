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
        x: frame.width / 2
        y: frame.height / 7
        width: frame.width / 15
        height: frame.height / 2
        hoverEnabled: true
        ToolTip.visible: containsMouse
        ToolTip.text: "Filter bricks"
    }
}
