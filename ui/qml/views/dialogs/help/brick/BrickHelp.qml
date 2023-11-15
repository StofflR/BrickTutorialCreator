import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    infoText: "Click or hover component to learn more!"
    image: Component {
        Image {
            anchors.fill: parent
            source: "qrc:/help/resources/help/brick_creator.png"
        }
    }
    MouseArea {
        id: name
        //color: "transparent"
        //border.color: "red"
        y: frame.height / 20
        width: frame.width / 1.82
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: name.containsMouse
        ToolTip.text: "Naming bricks"
        onClicked: frame.clicked(1)
    }
    MouseArea {
        id: edit
        //color: "transparent"
        //border.color: "yellow"
        anchors.top: name.bottom
        y: frame.height / 20
        width: frame.width
        height: frame.height / 2.4
        hoverEnabled: true
        ToolTip.visible: edit.containsMouse
        ToolTip.text: "Modifying bricks"
        onClicked: frame.clicked(3)
    }
    MouseArea {
        id: brick
        // color: "transparent"
        // border.color: "green"
        anchors.top: edit.bottom
        y: frame.height / 20
        width: frame.width
        height: frame.height - edit.height - name.height - 10
        hoverEnabled: true
        ToolTip.visible: brick.containsMouse
        ToolTip.text: "Creating bricks"
        onClicked: frame.clicked(4)
    }
    MouseArea {
        id: save
        // color: "transparent"
        //border.color: "orange"
        y: frame.height / 20
        anchors.left: name.right
        width: frame.width - name.width
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: save.containsMouse
        ToolTip.text: "Saving bricks"
        onClicked: frame.clicked(2)
    }
    MouseArea {
        id: save2
        //color: "transparent"
        // border.color: "blue"
        y: frame.height / 20
        anchors.right: brick.right
        anchors.top: brick.top
        width: frame.width / 4
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: save2.containsMouse
        ToolTip.text: "Saving bricks"
        onClicked: frame.clicked(2)
    }
}
