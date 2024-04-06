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
        id: settings
        anchors.top: source.bottom
        width: frame.width * 0.9
        height: frame.height / 10
    }
    MouseArea {
        id: element1
        anchors.top: settings.bottom
        width: frame.width / 2
        height: frame.height * 0.7
        hoverEnabled: true

        onContainsMouseChanged: if (containsMouse)
                                    displayTextIndex = 0
        Rectangle {
            anchors.fill: parent
            border.color: "yellow"
            color: "transparent"
        }
    }
    MouseArea {
        id: element2
        anchors.top: settings.bottom
        anchors.left: element1.right
        width: frame.width / 2
        height: frame.height * 0.7
        hoverEnabled: true

        onContainsMouseChanged: if (containsMouse)
                                    displayTextIndex = 1
        Rectangle {
            anchors.fill: parent
            border.color: "yellow"
            color: "transparent"
        }
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
                text: "The source view displays the original brick.<br>When toggeling the view to single view only the target brick is displayed!"
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
                text: "The target brick view. By default this tries loading the target file from the specified output folder!<br>If the brick has previously been translated with the keep filename flag set,<br>the translation will be loaded! Modifying the brick will save it to the specified output folder."
                color: palette.windowText
            }
        }
    }
}
