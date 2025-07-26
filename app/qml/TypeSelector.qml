pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import app

ListView {
    id: sizeList


    model: BrickSizeModel {
        id: brickSizeModel
        Component.onCompleted: {
            sizeList.currentIndex = defaultIndex;
        }
    }

    function setTypeAndSize(type, size) {
        sizeList.currentIndex = brickSizeModel.setTypeAndSize(type, size);
    }

    headerPositioning: ListView.OverlayHeader
    clip: true
    snapMode: ListView.SnapToItem
    boundsBehavior: Flickable.StopAtBounds

    ScrollIndicator.vertical: ScrollIndicator {}
    delegate: ItemDelegate {
        id: sizeDelegate
        required property int index

        required property string name
        required property string size
        required property string type

        hoverEnabled: true
        down: (hovered || pressed) && !highlighted

        implicitWidth: ListView.view.width
        implicitHeight: AppStyle.defaultHeight

        highlighted: ListView.isCurrentItem
        onClicked: sizeList.currentIndex = index

        contentItem: Label {
            text: sizeDelegate.name
            height: sizeDelegate.height
            width: sizeDelegate.width
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignLeft
        font: FontStyle.light.font
        }
    }
    header: Rectangle {
        color: AppStyle.color.window
        width: sizeList.width
        height: AppStyle.defaultHeight
        z: 3
        Label {
            text: "Brick Type"
            font: FontStyle.bold.font
            padding: 4
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
