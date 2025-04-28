import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    image: Component {
        Image {
            source: "qrc:/help/resources/help/tutorial.png"
        }
    }
    MouseArea {
        id: name
        y: frame.height / 20
        width: 3 * frame.width / 4
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: name.containsMouse
        ToolTip.text: "Naming Tutorial"
        onClicked: frame.clicked(5)
    }
    MouseArea {
        id: edit
        anchors.top: name.bottom
        y: frame.height / 20
        width: frame.width / 2
        height: frame.height - name.height
        hoverEnabled: true
        ToolTip.visible: edit.containsMouse
        ToolTip.text: "Editing tutorial"
        onClicked: frame.clicked(7)
    }
    MouseArea {
        id: control
        anchors.top: edit.top
        anchors.left: edit.right
        width: frame.width / 15
        height: edit.height
        hoverEnabled: true
        ToolTip.visible: control.containsMouse
        ToolTip.text: "Tutorial controls"
        onClicked: frame.clicked(4)
    }
    MouseArea {
        id: brick_selection
        anchors.left: control.right
        anchors.top: control.top
        width: frame.width - control.width - edit.width
        height: control.height
        hoverEnabled: true
        ToolTip.visible: brick_selection.containsMouse
        ToolTip.text: "Brick selection"
        onClicked: frame.clicked(3)
    }
    MouseArea {
        id: brick_filter
        y: brick_selection.y + frame.height / 10
        anchors.left: brick_selection.left
        width: brick_selection.width
        height: frame.height / 4
        hoverEnabled: true
        ToolTip.visible: brick_filter.containsMouse
        ToolTip.text: "Filter bricks"
        onClicked: frame.clicked(2)
    }
    MouseArea {
        id: available_bricks
        anchors.top: brick_filter.bottom
        anchors.left: brick_selection.left
        width: brick_selection.width
        height: frame.height / 2
        hoverEnabled: true
        ToolTip.visible: available_bricks.containsMouse
        ToolTip.text: "Available bicks"
        onClicked: frame.clicked(1)
    }
}
