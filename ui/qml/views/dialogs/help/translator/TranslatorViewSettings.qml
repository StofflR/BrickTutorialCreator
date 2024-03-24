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
    property bool toggle: true
    image: Component {
        Image {
            source: toggle ? "qrc:/help/resources/help/translator_extended.png" : "qrc:/help/resources/help/translator_normal.png"
        }
    }
    MouseArea {
        id: source
        y: frame.height / 20
        width: frame.width / 1.66
        height: frame.height / 10
    }
    MouseArea {
        id: element
        y: frame.height / 20
        anchors.left: source.right
        width: frame.width / 5
        height: frame.height / 10
        hoverEnabled: true
        onClicked: toggle = !toggle
        Rectangle {
            anchors.fill: parent
            border.color: "yellow"
            color: "transparent"
        }
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
                text: "Use buttons to switch between source-target view and target-only view!"
                color: palette.windowText
            }
            Text {
                text: "<b>Note:</b> Click to toggle!"
                color: palette.windowText
            }
        }
    }
}
