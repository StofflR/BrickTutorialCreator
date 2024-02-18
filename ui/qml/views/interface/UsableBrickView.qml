import QtQuick 2.15
import QtQuick.Controls 2.15

import "../../style"

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
        ScrollBar.vertical.snapMode: ScrollBar.SnapAlways
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ListView {
            id: view
            anchors.fill: parent
            clip: true
            delegate: Item {
                id: source
                width: view.width
                height: expand ? sourceImage.height + recta.height : sourceImage.height
                property bool expand: false

                MouseArea {
                    id: mouseArea
                    anchors.left: source.left
                    anchors.top: source.top
                    width: sourceImage.width
                    height: sourceImage.height
                    onClicked: if (root.groupedView) {
                                   expand = !expand
                               }
                    onDoubleClicked: if (!root.groupedView) {
                                         root.addBrick(sourceImage.source)
                                     }

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
                        source: decodeURIComponent((groupedView ? baseFolder + "/" : fileStub) + view.model[index].path)
                    }
                }
                Item {
                    id: recta
                    width: view.width
                    anchors.top: mouseArea.bottom
                    anchors.left: mouseArea.left
                    height: expand ? viewExpand.contentHeight + 2 * AppStyle.spacing : 0

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
                            radius: 5

                            Image {
                                id: sourceImageExpand
                                fillMode: Image.PreserveAspectFit
                                width: recta.width
                                source: fileStub + viewExpand.model[index].path
                                MouseArea {
                                    id: mouseAreaExpand
                                    anchors.fill: sourceImageExpand
                                    onDoubleClicked: root.addBrick(
                                                         sourceImageExpand.source)
                                }
                            }
                        }
                    }
                }
            }
            model: availableBricks
        }
    }
    Item {
        id: name
        anchors.left: scrollview.left
        width: view.width
        anchors.margins: AppStyle.spacing
        height: text.height + AppStyle.spacing
        Label {
            id: text
            anchors.left: name.left
            anchors.verticalCenter: name.verticalCenter
            text: qsTr("Available Bricks")
        }
    }
}
