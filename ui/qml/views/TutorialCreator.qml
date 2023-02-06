import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import "../assets"
import "../font"
import "../views"
import "../style"

import TutorialManager 1.0

Item {
    id: item
    anchors.fill: parent
    signal updateStatusMessage(string text)
    TutorialManager {
        id: tutorialManager
    }
    Rectangle {
        width: parent.width / 2
        height: item.height
        ScrollView {
            id: scrollview
            clip: true
            anchors.left: parent.left
            anchors.right: control.left
            anchors.top: parent.top
            anchors.margins: AppStyle.spacing
            height: parent.height

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            ListView {
                id: timeline
                signal remove(int index)
                onRemove: index => {
                              tutorialManager.removeBrick(index)
                          }

                snapMode: ListView.SnapToItem
                anchors.topMargin: AppStyle.spacing
                anchors.fill: scrollview

                orientation: ListView.Vertical
                model: TutorialView {
                    id: proxyModel
                    model: tutorialManager.model
                    onModelUpdated: {
                        var updatedModel = []
                        for (var i = 0; i < proxyModel.items.count; i++)
                            updatedModel.push(proxyModel.items.get(
                                                  i).model.modelData)
                        if (updatedModel == [])
                            return
                        tutorialManager.model = updatedModel
                        //console.log(updatedModel) // Update python model
                    }
                }
                Component.onCompleted: proxyModel.removed.connect(
                                           timeline.remove)
                moveDisplaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: 200
                    }
                }
            }
        }
        Rectangle {
            id: control
            height: parent.height
            width: AppStyle.defaultHeight
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            ColumnLayout {
                width: parent.width
                IconButton {
                    FileDialog {
                        id: brickSaveDialog
                        folder: tempFolder
                        nameFilters: ["PNG files (*.png)"]
                        fileMode: FileDialog.SaveFile
                        onAccepted: {
                            tutorialManager.saveTutorial(currentFile)
                            root.updateStatusMessage(
                                        "INFO: Saved tutorial to " + currentFile)
                        }
                    }
                    icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
                    width: height
                    enabled: tutorialManager.model.length > 0
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onPressed: brickSaveDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: qsTr("Save tutorial")
                }
                IconButton {
                    FileDialog {
                        id: brickOpenDialog
                        folder: tempFolder
                        nameFilters: ["SVG files (*.svg)", "JSON files (*.json)"]
                        fileMode: FileDialog.OpenFiles
                        onAccepted: {
                            tutorialManager.addBrick(currentFile)
                        }
                    }
                    icon.source: "qrc:/bricks/resources/add_circle_black_24dp.svg"
                    width: height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onPressed: brickOpenDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: qsTr("Add existing brick")
                }
                IconButton {
                    FileDialog {
                        id: fileSaveDialog
                        folder: tempFolder
                        nameFilters: ["JSON files (*.json)"]
                        fileMode: FileDialog.SaveFile
                        onAccepted: {
                            tutorialManager.toJSON(currentFile)
                            root.updateStatusMessage(
                                        "INFO: Saved tutorial to " + currentFile)
                        }
                    }
                    icon.source: "qrc:/bricks/resources/text_snippet_black_24dp.svg"
                    width: height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onPressed: fileSaveDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: qsTr("Save tutorial to JSON")
                }
                IconButton {
                    FileDialog {
                        id: fileOpenDialog
                        folder: tempFolder
                        nameFilters: ["JSON files (*.json)"]
                        fileMode: FileDialog.OpenFile
                        onAccepted: {
                            tutorialManager.fromJSON(currentFile)
                            root.updateStatusMessage(
                                        "INFO: Loaded tutorial from " + currentFile)
                        }
                    }
                    icon.source: "qrc:/bricks/resources/file_open_black_24dp.svg"
                    width: height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onPressed: fileOpenDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: qsTr("Load tutorial from JSON")
                }
            }
        }
    }
    Rectangle {
        anchors.right: parent.right
        width: parent.width / 2
        height: item.height

        ListView {
            id: availableSources
            anchors.top: addPathButton.bottom
            anchors.left: addPathButton.left
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            height: parent.height / 3 < availableSources.count
                    * 40 ? parent.height / 3 : availableSources.count * 40
            delegate: Component {
                MouseArea {
                    onClicked: availableSources.currentIndex = index
                    height: 40
                    width: availableSources.width

                    Text {
                        id: contactInfo
                        width: parent.width
                        text: path
                        elide: Text.ElideLeft

                        color: wrapper.ListView.isCurrentItem ? "red" : "black"
                    }
                }
            }
            highlight: Rectangle {
                color: "lightsteelblue"
                radius: 5
            }
            focus: true
            model: ListModel {
                id: availableSourcesModel
            }
        }
        Button {
            id: addPathButton
            anchors.left: parent.left
            width: parent.width / 2 - 2 * AppStyle.spacing
            anchors.margins: AppStyle.spacing
            text: qsTr("Add path")
            onPressed: folderDialog.open()
        }
        Button {
            id: removePathButton
            anchors.margins: AppStyle.spacing
            anchors.right: parent.right
            anchors.left: addPathButton.right
            text: qsTr("Remove path")
            enabled: availableSources.currentIndex > -1
            onPressed: availableSourcesModel.remove(
                           availableSources.currentIndex, 1)
        }

        UsableBrickView {
            id: usableBrickView
            anchors.top: availableSources.bottom
            anchors.margins: AppStyle.spacing
            brickSources: []
        }

        FolderDialog {
            id: folderDialog
            onAccepted: {
                availableSourcesModel.append({
                                                 "path": folder
                                             })
            }
        }
    }
}
