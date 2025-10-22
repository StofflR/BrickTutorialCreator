import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

import app

ApplicationWindow {
    id: root
    width: 960
    height: 640
    visible: true
    title: qsTr("Brick Creator")

    BrickUtility {
        id: utility
    }

    FolderDialog {
        id: folderDialog
        title: qsTr("Select Folder")
        currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
        onAccepted: {
            StatusHandler.statusMessage = qsTr("Selected folder: %1").arg(folderDialog.selectedFolder);
            if (basicBricksMenuItem.active) {
                utility.generateBasicBricks(folderDialog.selectedFolder);
                basicBricksMenuItem.active = false;
            } else if (drawableBricksMenuItem.active) {
                utility.generateDrawableBricks(folderDialog.selectedFolder);
                drawableBricksMenuItem.active = false;
            } else if (referenceBricksMenuItem.active) {
                utility.generateReferenceBricks(folderDialog.selectedFolder, FontStyle.bold.font);
                referenceBricksMenuItem.active = false;
            }
        }
        onRejected: {
            StatusHandler.statusMessage = qsTr("Folder selection canceled");
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                visible: stack.currentIndex > 0
                text: qsTr("‹")
                onClicked: stack.setCurrentItem(stack.currentIndex - 1)
            }
            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                text: stack.children[stack.currentIndex].title
                elide: Label.ElideRight
                font: FontStyle.light.font
            }
            ToolButton {
                Layout.fillHeight: true

                text: qsTr("⋮")
                onClicked: sideMenuDrawer.open()
                font: FontStyle.light.font
            }
            Label {
                id: extendedInfo
                Layout.preferredWidth: root.width - AppStyle.sideMenu.expandedWidth
                Layout.fillHeight: true

                verticalAlignment: Qt.AlignVCenter
                text: mainArea.extendedInfo
                font: FontStyle.light.font
            }
        }
    }

    Drawer {
        id: sideMenuDrawer
        width: AppStyle.sideMenu.expandedWidth
        height: root.height
        ColumnLayout {
            id: menu

            Label {
                Layout.fillWidth: true
                padding: AppStyle.spacing
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Menu")
                font: FontStyle.bold.font
            }

            MenuSeparator {
                padding: 0
                contentItem: Rectangle {
                    implicitWidth: sideMenuDrawer.width
                    implicitHeight: 1
                    color: "#1E000000"
                }
            }

            Repeater {
                model: stack.children
                MenuItem {
                    required property var modelData
                    text: modelData.title
                    font: FontStyle.light.font
                    onTriggered: modelData.setCurrentItem()
                }
            }

            MenuSeparator {
                padding: 0
                contentItem: Rectangle {
                    implicitWidth: sideMenuDrawer.width
                    implicitHeight: 1
                    color: "#1E000000"
                }
            }

            MenuItem {
                id: basicBricksMenuItem
                text: qsTr("Generate Basic Bricks")
                font: FontStyle.light.font
                property bool active: false
                onTriggered: {
                    active = true;
                    drawableBricksMenuItem.active = false;
                    referenceBricksMenuItem.active = false;
                    folderDialog.open();
                    sideMenuDrawer.close();
                }
            }

            MenuItem {
                id: drawableBricksMenuItem
                text: qsTr("Generate Drawable Bricks")
                font: FontStyle.light.font
                property bool active: false
                onTriggered: {
                    active = true;
                    basicBricksMenuItem.active = false;
                    referenceBricksMenuItem.active = false;
                    folderDialog.open();
                    sideMenuDrawer.close();
                }
            }

            MenuItem {
                id: referenceBricksMenuItem
                text: qsTr("Generate All Reference Bricks")
                font: FontStyle.light.font
                property bool active: false
                onTriggered: {
                    active = true;
                    basicBricksMenuItem.active = false;
                    drawableBricksMenuItem.active = false;
                    folderDialog.open();
                    sideMenuDrawer.close();
                }
            }
        }
    }
    StackLayout {
        id: stack

        width: parent.width - (sideMenuDrawer.width * sideMenuDrawer.position)
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        currentIndex: 0

        function setCurrentItem(index) {
            if (index >= 0 && index < stack.children.length) {
                stack.currentIndex = index;
                sideMenuDrawer.close();
            }
        }

        BrickCreator {
            id: mainArea
            property string title: "Brick Creator"
            function setCurrentItem() {
                stack.setCurrentItem(StackLayout.index);
            }
        }
        Rectangle {
            id: secondArea
            property string title: "Second Area"
            color: "yellow"
            function setCurrentItem() {
                stack.setCurrentItem(StackLayout.index);
            }
            RowLayout {
                anchors.fill: parent
                Button {
                    text: "Add Tutorial Brick"
                    onClicked: {
                        tutorialViewModel.addBrick();
                    }
                }
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: TutorialViewModel {
                        id: tutorialViewModel
                    }
                    delegate: Item {
                        width: parent.width
                        height: 40
                        Text {
                            text: "Tutorial Item" + element
                        }
                    }
                }
            }
        }
    }
    footer: Label {
        id: appStatusbar
        property bool keepVisible: false
        width: parent.width
        height: 24
        text: StatusHandler.statusMessage
        padding: AppStyle.spacing
        verticalAlignment: Qt.AlignVCenter
        font: FontStyle.light.font

        onTextChanged: statusbarTimer.restart()

        Timer {
            id: statusbarTimer
            interval: AppStyle.statusbar.duration
            onTriggered: {
                if (!appStatusbar.keepVisible) {
                    StatusHandler.statusMessage = "";
                }
            }
        }
    }
}
