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
    property int index: -2
    property var model: selection.model
    Keys.onPressed: console.log("asd")
    FocusScope {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            HelpSelection {
                id: selection
                width: parent.width
                visible: index == -1
                onModelChanged: index = index + 1
                height: parent.height - AppStyle.defaultHeight
                anchors.top: helpPopup.top
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
                }
            }
            Row {
                anchors.bottom: parent.bottom
                spacing: 10

                Button {
                    id: nextButton
                    text: "Next"
                    onClicked: index = index + 1
                    enabled: model && index < model?.count - 1
                }
                Button {
                    id: previousButton
                    text: "Previous"
                    enabled: index > -1
                    onClicked: index = index - 1
                }
                Button {
                    text: "Selection"
                    onClicked: index = -1
                }

                Text {
                    text: index
                }
            }
        }
    }
}
