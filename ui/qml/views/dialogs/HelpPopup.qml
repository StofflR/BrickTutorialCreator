import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models

import "help"

Popup {
    id: helpPopup
    x: 100
    y: 100
    width: parent.width - 200
    height: parent.height - 200
    modal: true
    focus: true
    property int index: -1
    property var model: selection.model

    Column {
        anchors.fill: parent
        HelpSelection {
            id: selection
            width: parent.width
            visible: index == -1
            onModelChanged: index = index + 1
        }
        Loader {
            width: parent.width
            id: loader
            visible: active
            active: index > -1
            source: index >= 0 ? selection.model?.get(
                                     index)?.source : selection.model?.get(
                                     0)?.source
        }
        Row {
            spacing: 10
            Button {
                text: "Push"
                onClicked: index = index + 1
                enabled: model && index < model?.count - 1
            }
            Button {
                text: "Pop"
                enabled: index > -1
                onClicked: index = index - 1
            }
            Button {
                text: "Root"
                onClicked: index = -1
            }

            Text {
                text: index
            }
        }
    }
}
