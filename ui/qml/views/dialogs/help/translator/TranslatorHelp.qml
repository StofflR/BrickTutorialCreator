import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import ".."

HelpFrame {
    id: frame
    infoText: "Click or hover component to learn more!"
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
        hoverEnabled: true
        ToolTip.visible: source.containsMouse
        ToolTip.text: "Setting source and target"
        onClicked: frame.clicked(1)
        //        Rectangle {
        //            anchors.fill: parent
        //            border.color: "yellow"
        //            color: "transparent"
        //        }
    }
    MouseArea {
        id: view
        y: frame.height / 20
        anchors.left: source.right
        width: frame.width / 5
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: view.containsMouse
        ToolTip.text: "Setting translation view"
        onClicked: frame.clicked(2)
        //        Rectangle {
        //            anchors.fill: parent
        //            border.color: "yellow"
        //            color: "transparent"
        //        }
    }
    MouseArea {
        id: settings
        anchors.top: source.bottom
        width: frame.width * 0.9
        height: frame.height / 10
        hoverEnabled: true
        ToolTip.visible: settings.containsMouse
        ToolTip.text: "Output settings"
        onClicked: frame.clicked(3)
        //        Rectangle {
        //            anchors.fill: parent
        //            border.color: "yellow"
        //            color: "transparent"
        //        }
    }
    MouseArea {
        id: sourceView
        anchors.top: settings.bottom
        width: frame.width / 2
        height: frame.height * 0.7
        hoverEnabled: true
        ToolTip.visible: sourceView.containsMouse
        ToolTip.text: "Source view"
        onClicked: frame.clicked(4)
        //        Rectangle {
        //            anchors.fill: parent
        //            border.color: "yellow"
        //            color: "transparent"
        //        }
    }
    MouseArea {
        id: targetView
        anchors.top: settings.bottom
        anchors.left: sourceView.right
        width: frame.width / 2
        height: frame.height * 0.7
        hoverEnabled: true
        ToolTip.visible: targetView.containsMouse
        ToolTip.text: "Target view"
        onClicked: frame.clicked(4)
        //        Rectangle {
        //            anchors.fill: parent
        //            border.color: "yellow"
        //            color: "transparent"
        //        }
    }
}
