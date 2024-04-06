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
        y: frame.height / 8
        width: frame.width / 2
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
                text: "Tutorial bricks can be rearanged by drag and drop!<br>Inserting new bricks by double clicking inserts them at the current selection!<br>Bricks can be removed by pressing 'Delete' on the keyboard!"
                color: palette.windowText
            }
        }
    }
}
