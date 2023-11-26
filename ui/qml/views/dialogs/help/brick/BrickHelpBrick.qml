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
            anchors.fill: parent
            source: "qrc:/help/resources/help/brick_creator.png"
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
        y: 1.7 * frame.height / 3
        height: frame.height / 2.2
        width: frame.width
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
                text: "<b>Reset default:</b> Restores content scale and text positioning to default values"
                color: palette.windowText
            }
            Text {
                text: "<b>Content scale:</b> Control the size of the displayed text of the brick"
                color: palette.windowText
            }
            Text {
                text: "<b>Position sliders:</b> Position of the displayed text on the brick"
                color: palette.windowText
            }
            Text {
                text: "<b>Buttons:</b><li><b>• Reset: </b></li> <li>Reset the content of the brick</li> <li><b>• Load from file: </b></li> <li>Load previously created brick from svg or json files</li> <li><b>• Save: </b></li> <li>Save the brick to the selected file formats (JSON/PNG/SVG)</li>"
                color: palette.windowText
            }
            Text {
                text: "To create a underlined variable surround the variable with $*signs. E.g. *variable*"
                color: palette.windowText
            }
            Text {
                text: "To create a drop down variable surround the variable with $-signs. E.g. $variable$"
                color: palette.windowText
            }
        }
    }
}
