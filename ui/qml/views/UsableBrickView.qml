import QtQuick 2.15
import QtQuick.Controls 2.15

import "../style"

Item {
    id: root
    signal addBrick(string file)
    property var availableBricks
    ListView {
        id: view
        anchors.top: name.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: AppStyle.spacing
        delegate: Rectangle {
            id: source
            width: view.width
            height: sourceImage.height
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: root.addBrick(sourceImage.source)
                Image {
                    id: sourceImage
                    fillMode: Image.PreserveAspectFit
                    width: source.width
                    source: "file:///" + view.model[index].path
                    Component.onCompleted: {
                        if (!view.model[index].is_brick
                                && height > root.height / 4)
                            sourceImage.height = root.height / 4
                    }
                }
            }
        }
        model: availableBricks
        onModelChanged: console.log(model[0].path)
    }
    Rectangle {
        id: name
        anchors.left: root.left
        width: view.width
        anchors.margins: AppStyle.spacing
        height: text.height + AppStyle.spacing
        Text {
            id: text
            anchors.left: name.left
            text: qsTr("Available Bricks")
        }
    }
}
