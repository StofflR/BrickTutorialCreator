import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    signal addBrick(string file)
    property var availableBricks
    Text {
        id: name
        text: qsTr("Available Bricks")
    }
    ListView {
        id: view
        anchors.top: name.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        delegate: Rectangle {
            id: source
            width: root.width
            height: sourceImage.height
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: root.addBrick(sourceImage.source)
                Image {
                    id: sourceImage
                    width: source.width
                    source: "file:///" + view.model[index]
                }
            }
        }
        model: availableBricks
        onModelChanged: console.log(model)
    }
}
