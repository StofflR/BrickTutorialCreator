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
        y: frame.height / 7
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
                text: "New brick import paths can be added by clicking 'Add path' and following the instructions!<br>Remove path removed the highlighted path in the selection below!"
                color: palette.windowText
            }
            Text {
                text: "Legacy bricks: Tries to load older brick versions. This might not work properly!"
                color: palette.windowText
            }
            Text {
                text: "Sort bricks: Sorts the bricks by color and size!"
                color: palette.windowText
            }
            Text {
                text: "Ad CC-BY-SA: Adds a transparent CC-BY-SA 4.0 Tag at the end of the tutorial!"
                color: palette.windowText
            }
        }
    }
}
