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
        id: name
        y: frame.height / 20
        width: 3 * frame.width / 4
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: name.containsMouse
        ToolTip.text: "Naming Tutorial"
        onClicked: frame.clicked(5)
    }
}
