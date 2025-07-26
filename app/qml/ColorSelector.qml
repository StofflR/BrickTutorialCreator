pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import app

ListView {
    id: root
    model: BrickColorModel {
        id: colorModel
    }
    headerPositioning: ListView.OverlayHeader
    clip: true
    snapMode: ListView.SnapToItem
    boundsBehavior: Flickable.StopAtBounds

    ScrollIndicator.vertical: ScrollIndicator {}

    function setColors(fill, shade, border, text) {
        root.currentIndex = colorModel.setColors(fill, shade, border, text);
    }

    delegate: ItemDelegate {
        id: colorDelegate

        required property int index

        required property string name
        required property var fillColor
        required property var borderColor
        required property var shadeColor
        required property var textColor
        required property bool editable

        hoverEnabled: true
        down: (hovered || pressed) && !highlighted

        implicitWidth: ListView.view.width
        implicitHeight: AppStyle.propertyHeight

        highlighted: ListView.isCurrentItem
        onClicked: root.currentIndex = index

        contentItem: RowLayout {
            width: colorDelegate.width
            height: colorDelegate.height
            TextInput {
                id: nameInput
                text: colorDelegate.name
                Layout.fillHeight: true
                Layout.fillWidth: true
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                font: FontStyle.light.font
                readOnly: !colorDelegate.editable
                onAccepted: {
                    root.model.renameColor(colorDelegate.index, nameInput.text);
                }
                onActiveFocusChanged: {
                    if (activeFocus) {
                        root.currentIndex = colorDelegate.index;
                    }
                }
                Button {
                    id: deleteButton
                    width: colorDelegate.height
                    height: colorDelegate.height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: AppStyle.icons.delete_black_24dp
                    visible: colorDelegate.editable
                    onClicked: root.model.removeColor(colorDelegate.index)
                }
            }
            Rectangle {
                implicitWidth: colorDelegate.width / 6
                Layout.fillHeight: true
                color: colorDelegate.fillColor
                TapHandler {
                    enabled: colorDelegate.editable
                    onTapped: fillDialog.open()
                }
                ColorDialog {
                    id: fillDialog
                    onAccepted: {
                        root.model.addColor(nameInput.text, colorDelegate.borderColor, fillDialog.selectedColor, colorDelegate.shadeColor, colorDelegate.textColor);
                    }
                }
                border.color: "black"
            }
            Rectangle {
                implicitWidth: colorDelegate.width / 6
                Layout.fillHeight: true
                color: colorDelegate.borderColor
                border.color: "black"
                TapHandler {
                    enabled: colorDelegate.editable
                    onTapped: borderDialog.open()
                }
                ColorDialog {
                    id: borderDialog
                    onAccepted: {
                        root.model.addColor(nameInput.text, borderDialog.selectedColor, colorDelegate.fillColor, colorDelegate.shadeColor, colorDelegate.textColor);
                    }
                }
            }
            Rectangle {
                implicitWidth: colorDelegate.width / 6
                Layout.fillHeight: true
                color: colorDelegate.shadeColor
                border.color: "black"
                TapHandler {
                    enabled: colorDelegate.editable
                    onTapped: shadeDialog.open()
                }
                ColorDialog {
                    id: shadeDialog
                    onAccepted: {
                        root.model.addColor(nameInput.text, colorDelegate.borderColor, colorDelegate.fillColor, shadeDialog.selectedColor, colorDelegate.textColor);
                    }
                }
            }
            Rectangle {
                implicitWidth: colorDelegate.width / 6
                Layout.fillHeight: true
                color: colorDelegate.textColor
                border.color: "black"
                TapHandler {
                    enabled: colorDelegate.editable
                    onTapped: textDialog.open()
                }
                ColorDialog {
                    id: textDialog
                    onAccepted: {
                        root.model.addColor(nameInput.text, colorDelegate.borderColor, colorDelegate.fillColor, colorDelegate.shadeColor, textDialog.selectedColor);
                    }
                }
            }
        }
    }
    header: Rectangle {
        z: 3
        color: AppStyle.color.window
        implicitHeight: AppStyle.defaultHeight
        implicitWidth: ListView.view.width
        RowLayout {
            id: header
            anchors.fill: parent
            Label {
                text: qsTr("Brick Colors")
                Layout.fillHeight: true
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font: FontStyle.bold.font
            }
            Label {
                text: qsTr("Fill")
                Layout.fillHeight: true
                Layout.preferredWidth: header.width / 6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: FontStyle.bold.font
            }
            Label {
                text: qsTr("Border")
                Layout.fillHeight: true
                Layout.preferredWidth: header.width / 6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: FontStyle.bold.font
            }
            Label {
                text: qsTr("Shade")
                Layout.fillHeight: true
                Layout.preferredWidth: header.width / 6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: FontStyle.bold.font
            }
            Label {
                text: qsTr("Text")
                Layout.fillHeight: true
                Layout.preferredWidth: header.width / 6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: FontStyle.bold.font
            }
        }
    }
}
