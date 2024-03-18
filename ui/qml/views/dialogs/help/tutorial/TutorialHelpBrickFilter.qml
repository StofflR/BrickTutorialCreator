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
        anchors.right: frame.right
        y: frame.height / 3
        width: 4 * frame.width / 9
        height: frame.height / 6
        hoverEnabled: true
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
                text: "The added available paths are displayed here!<br>By enterin a description in the field below<br>the content of the available bricks is checking and only bricks containing the content are displayed!"
                color: palette.windowText
            }
        }
    }
}
