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
        x: frame.width / 2
        y: frame.height / 7
        width: frame.width / 15
        height: frame.height / 2
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
                text: "Save tutorial as PNG or JSON File!"
                color: palette.windowText
            }
            Text {
                text: "Add an existing brick to the tutorial!"
                color: palette.windowText
            }
            Text {
                text: "Save tutorial as JSON file!"
                color: palette.windowText
            }
            Text {
                text: "Save tutorial as PNG file!"
                color: palette.windowText
            }
            Text {
                text: "Load the tutorial from a JSON file!"
                color: palette.windowText
            }
            Text {
                text: "Clear the tutorial!"
                color: palette.windowText
            }
        }
    }
}
