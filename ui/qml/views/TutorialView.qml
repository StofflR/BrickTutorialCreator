import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import QtQml 2.12
import "../assets"
import "../font"
import "../views"
import "../style"

DelegateModel {
    id: visualModel
    delegate: timelineDelegate
    signal removed(int index)
    Component {
        id: timelineDelegate

        MouseArea {
            id: dragArea
            z: parent.z + dragArea.DelegateModel.itemsIndex
            width: parent ? parent.width : 0
            height: content.height - (width / 55) > 0 ? content.height - (width / 55) : 0
            property bool held: false
            pressAndHoldInterval: 1
            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis

            onPressAndHold: held = true
            onReleased: held = false

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
                    width: parent.width
                    source: modelData
                    IconButton {
                        id: remove
                        opacity: 0.4
                        icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
                        onPressed: visualModel.removed(index)
                        anchors.right: image.right
                        anchors.margins: AppStyle.spacing
                        anchors.top: image.top
                        width: AppStyle.defaultHeight
                        height: width
                    }
                }
                opacity: dragArea.held ? 0.8 : 1.0

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
