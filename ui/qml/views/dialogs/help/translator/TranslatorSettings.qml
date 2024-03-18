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
        id: source
        y: frame.height / 20
        width: frame.width / 1.66
        height: frame.height / 10
    }
    MouseArea {
        id: element
        anchors.top: source.bottom
        width: frame.width * 0.9
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
                text: "Keep filename: Enabeling this option keeps the source file name.<br>If it is unchecked the name is generated from the brick content!"
                color: palette.windowText
            }
            Text {
                text: "Load files recursive: Enabeling this options checks for bricks in subdirectories and adds them to the editing list!"
                color: palette.windowText
            }
            Text {
                text: "Load SVG/JSON: Specifies which file formats should be laoded!"
                color: palette.windowText
            }
            Text {
                text: "Save SVG/JSON/PNG: Specifies which file format the output files should have!"
                color: palette.windowText
            }
        }
    }
}
