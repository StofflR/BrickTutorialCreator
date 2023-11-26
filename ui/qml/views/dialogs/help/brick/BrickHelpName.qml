import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    property bool displayInfo: element.containsMouse || textarea.containsMouse

    onDisplayInfoChanged: if (displayInfo) {
                              infotext.open()
                          } else {
                              infotext.close()
                          }
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
        y: frame.height / 20
        height: frame.height / 10
        width: frame.width / 1.82
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
                text: "The file name by default is generated using the brick content."
                color: palette.windowText
            }
            Text {
                text: "Enabeling the auto-save option allows the filename to be modified by hand."
                color: palette.windowText
            }
            Text {
                text: "<b>Button: </b> Allows defining the output folder for the brick on saving them."
                color: palette.windowText
            }
        }
    }
}
