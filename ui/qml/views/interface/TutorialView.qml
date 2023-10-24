import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import QtQml 2.12

import "../../style"

DelegateModel {
    id: visualModel
    delegate: timelineDelegate
    property int selectedIndex: -1
    signal focus

    Component {
        id: timelineDelegate

        MouseArea {
            id: dragArea
            z: dragArea.DelegateModel.itemsIndex
            width: parent ? parent.width : 0
            height: content.height - (width / 55) > 0 ? content.height - (width / 55) : 0
            property bool held: false
            pressAndHoldInterval: 1
            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis
            onPressAndHold: held = true
            onReleased: {
                held = false
                visualModel.selectedIndex = dragArea.DelegateModel.itemsIndex
                visualModel.focus()
            }
            Item {
                id: content
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: parent.width
                height: image.height

                Image {
                    id: image
                    width: content.width - 20
                    source: modelData
                }
                Rectangle {
                    width: 10
                    height: image.height - image.width * 0.018
                    color: Qt.lighter(AppStyle.color.highlight)
                    opacity: dragArea.DelegateModel.itemsIndex === visualModel.selectedIndex ? 1 : 0
                    anchors.left: image.right
                    anchors.margins: 5
                    radius: 5
                }

                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: State {
                    when: dragArea.held
                    ParentChange {
                        target: content
                        parent: timeline
                    }
                    AnchorChanges {
                        target: content
                        anchors {
                            horizontalCenter: undefined
                            verticalCenter: undefined
                        }
                    }
                }
            }

            DropArea {
                anchors.fill: parent
                onEntered: drag => {
                               visualModel.items.move(
                                   drag.source.DelegateModel.itemsIndex,
                                   dragArea.DelegateModel.itemsIndex)
                               if (dragArea.moveRight)
                               timeline.currentIndex = dragArea.DelegateModel.itemsIndex + 1
                               else
                               timeline.currentIndex = dragArea.DelegateModel.itemsIndex - 1
                           }
            }
        }
    }
}
