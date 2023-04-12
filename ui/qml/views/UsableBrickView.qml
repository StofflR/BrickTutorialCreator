import QtQuick 2.15
import QtQuick.Controls 2.15

import "../style"

Item {
    id: root
    signal addBrick(string file)
    property var availableBricks
    property bool groupedView
    ScrollView {
        id: scrollview
        anchors.left: root.left
        anchors.right: root.right
        anchors.top: name.bottom
        anchors.bottom: root.bottom
        anchors.margins: AppStyle.spacing
        ScrollBar.vertical.snapMode: ScrollBar.SnapAlways
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ListView {
            id: view
            anchors.top: scrollview.bottom
            anchors.bottom: scrollview.bottom
            anchors.left: scrollview.left
            anchors.right: scrollview.right
            anchors.margins: AppStyle.spacing
            delegate: Rectangle {
                id: source
                width: view.width
                height: expand ? sourceImage.height + recta.height : sourceImage.height
                color: Qt.lighter(AppStyle.color.window)
                property bool expand: false

                MouseArea {
                    id: mouseArea
                    anchors.left: source.left
                    anchors.top: source.top
                    width: sourceImage.width
                    height: sourceImage.height
                    onClicked: if (root.groupedView)
                                   expand = !expand

                    onDoubleClicked: if (!root.groupedView)
                                         root.addBrick(sourceImage.source)
                    Image {
                        id: sourceImage
                        fillMode: Image.PreserveAspectFit
                        width: source.width
                        Text {
                            anchors.centerIn: parent
                            visible: groupedView
                            font.bold: true
                            font.pointSize: 12
                            text: "Click to " + (expand ? "collapse" : "expand") + "!"
                        }
                        source: "file:///" + view.model[index].path
                    }
                }
                Rectangle {
                    id: recta
                    width: view.width
                    anchors.top: mouseArea.bottom
                    anchors.left: mouseArea.left
                    height: expand ? viewExpand.contentHeight + 2 * AppStyle.spacing : 0
                    color: Qt.lighter(AppStyle.color.window)

                    ListView {
                        id: viewExpand
                        anchors.fill: recta
                        anchors.margins: AppStyle.spacing
                        model: groupedView ? view.model[index].elements : []
                        interactive: false
                        delegate: Rectangle {
                            id: sourceExpand
                            width: viewExpand.width
                            height: sourceImageExpand.height

                            MouseArea {
                                id: mouseAreaExpand
                                anchors.left: sourceExpand.left
                                anchors.top: sourceExpand.top
                                width: sourceImageExpand.width
                                height: sourceImageExpand.height

                                onDoubleClicked: root.addBrick(
                                                     sourceImageExpand.source)
                                Image {
                                    id: sourceImageExpand
                                    fillMode: Image.PreserveAspectFit
                                    width: recta.width
                                    source: "file:///" + viewExpand.model[index].path
                                }
                            }
                        }
                    }
                }
            }
            model: availableBricks
        }
    }
    Rectangle {
        id: name
        anchors.left: scrollview.left
        width: view.width
        anchors.margins: AppStyle.spacing
        height: text.height + AppStyle.spacing
        color: AppStyle.color.window
        Text {
            id: text
            anchors.left: name.left
            anchors.verticalCenter: name.verticalCenter
            text: qsTr("Available Bricks")
            color: AppStyle.color.text
        }
    }
}
