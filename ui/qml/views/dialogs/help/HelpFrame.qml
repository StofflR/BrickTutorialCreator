import QtQuick 2.15
import QtQuick.Controls

Item {
    required property var image
    property alias infoText: text.text
    signal clicked(int index)
    Column {
        anchors.fill: parent
        Label {
            id: text
            text: "Hover for info!"
        }
        Loader {
            width: parent.width
            height: parent.height - text.height
            sourceComponent: image
        }
    }
}
