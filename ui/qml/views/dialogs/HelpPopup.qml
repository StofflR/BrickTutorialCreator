import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models

import "help"
import "../../style"

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
        spacing: 10
        HelpSelection {
            id: selection
            width: parent.width
            visible: index == -1
            height: parent.height - AppStyle.defaultHeight
            anchors.top: helpPopup.top
            onClicked: target => {
                           index = target
                       }
        }
        Loader {
            id: loader
            visible: active
            active: index > -1
            source: index >= 0 ? selection.model?.get(
                                     index)?.source : selection.model?.get(
                                     0)?.source
            onLoaded: {
                item.width = Qt.binding(function () {
                    return selection.width
                })
                item.height = Qt.binding(function () {
                    return selection.height
                })
                item.clicked.connect(target => {
                                         index = target
                                     })
            }
        }
        RowLayout {
            spacing: 10
            Button {
                id: previousButton
                text: index == 0 ? "Help Selection" : "Previous"
                enabled: index > -1
                onClicked: index = index - 1
            }
            Button {
                id: nextButton
                text: "Next"
                onClicked: index = index + 1
                enabled: model && index < model?.count - 1
            }
            Button {
                text: "Component Selection"
                onClicked: index = 0
            }
            Button {
                text: "Help Selection"
                visible: index > 0
                onClicked: index = -1
            }
            Text {
                text: index
            }
        }
    }
}
