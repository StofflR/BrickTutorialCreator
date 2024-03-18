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
            source: "qrc:/help/resources/help/translator_normal.png"
        }
    }
    MouseArea {
        id: element
        y: frame.height / 20
        width: frame.width / 1.66
        height: frame.height / 10
        hoverEnabled: true
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
                text: "Use buttons to select the source and target folder of the translation!"
                color: palette.windowText
            }
            Text {
                text: "<b>Note:</b> By default the source folder is ./resources/out and the target folder is ./resources/out/export"
                color: palette.windowText
            }
            Text {
                text: "<b>Note:</b> If the source and target folder, the modified files will be overwritten!"
                color: palette.windowText
            }
        }
    }
}
