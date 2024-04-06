import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    property bool displayInfo: element1.containsMouse || element2.containsMouse
                               || textarea1.containsMouse
                               || textarea2.containsMouse
    property int displayTextIndex: 0

    onDisplayInfoChanged: if (displayInfo) {
                              if (displayTextIndex === 0)
                                  infotext1.open()
                              else if (displayTextIndex === 1)
                                  infotext2.open()
                          } else {
                              infotext1.close()
                              infotext2.close()
                          }
    image: Component {
        Image {
            anchors.fill: parent
            source: "qrc:/help/resources/help/brick_creator.png"
        }
    }
    MouseArea {
        id: element1
        Rectangle {
            color: "transparent"
            border.color: "yellow"
            anchors.fill: parent
        }
        y: frame.height / 20
        x: frame.width / 1.82
        width: frame.width / 3
        height: frame.height / 12
        hoverEnabled: true
        onContainsMouseChanged: if (containsMouse)
                                    displayTextIndex = 0
    }
    MouseArea {
        id: element2
        Rectangle {
            color: "transparent"
            border.color: "yellow"
            anchors.fill: parent
        }
        anchors.right: frame.right
        y: 4 * frame.height / 7
        height: frame.height / 12
        width: frame.width / 4
        hoverEnabled: true
        onContainsMouseChanged: if (containsMouse)
                                    displayTextIndex = 1
    }
    Popup {
        id: infotext1
        MouseArea {
            id: textarea1
            anchors.fill: parent
            hoverEnabled: true
        }
        anchors.centerIn: frame
        opacity: 0.8
        width: frame.width * 0.8
        height: frame.height * 0.8
        ColumnLayout {
            Text {
                text: "Select in which file formats the brick shopuld be saved in."
                color: palette.windowText
            }
            Text {
                text: "The brick filename used will be the name displayed in the neame field and use the respective file extensions"
                color: palette.windowText
            }
        }
    }
    Popup {
        id: infotext2
        MouseArea {
            id: textarea2
            anchors.fill: parent
            hoverEnabled: true
        }
        anchors.centerIn: frame
        opacity: 0.8
        width: frame.width * 0.8
        height: frame.height * 0.8
        ColumnLayout {
            Text {
                text: "<b>Auto-Save:</b> When enabeling this optin the name of the file no longer updates<br>according to the content of the brick."
                color: palette.windowText
            }
            Text {
                text: "Choosing this option allows to modify the name of the exported brick by hand."
                color: palette.windowText
            }
            Text {
                text: "Any changes to the brick, causes the files to be automatically saved."
                color: palette.windowText
            }
        }
    }
}
