import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    property bool displayInfo: element.containsMouse || textarea.containsMouse
    onDisplayInfoChanged: if (displayInfo)
                              infotext.open()
                          else
                              infotext.close()
    image: Component {
        Image {
            source: "qrc:/help/resources/help/tutorial.png"
        }
    }
    MouseArea {
        id: element
        Rectangle {
            color: "transparent"
            border.color: "yellow"
            anchors.fill: parent
        }
        y: frame.height / 20
        width: 3 * frame.width / 4
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: name.containsMouse
    }
    Popup {
        id: infotext
        MouseArea {
            id: textarea
            anchors.fill: parent
            hoverEnabled: true
        }
        anchors.centerIn: frame
        opacity: 0.8
        width: frame.width * 0.8
        height: frame.height * 0.8
        ColumnLayout {
            Text {
                text: "Set the name of the tutorial. This name will be used when saving and loading the tutorial!"
                color: palette.windowText
            }
        }
    }
}
