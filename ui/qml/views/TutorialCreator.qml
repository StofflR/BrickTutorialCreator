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
import TutorialSourceManager 1.0

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
            width: parent.width
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
    }
    Rectangle {
        anchors.right: parent.right
        width: parent.width / 2
        height: item.height
        Rectangle {
            id: control
            height: parent.height
            width: AppStyle.defaultHeight
            anchors.top: parent.top
            anchors.left: parent.left
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
        ListView {
            id: availableSources
            anchors.top: sourceButtons.bottom
            anchors.left: control.right
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            height: parent.height / 3 < availableSources.count
                    * 40 ? parent.height / 3 : availableSources.count * 40
            delegate: Component {
                MouseArea {
                    onClicked: availableSources.currentIndex = index
                    height: 40
                    width: availableSources.width

                    property var content: path
                    Text {
                        id: contactInfo
                        width: parent.width
                        text: path
                        elide: Text.ElideLeft
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
        TutorialSourceManager {
            id: manager
        }

        UsableBrickView {
            id: usableBrickView
            anchors.top: optionField.bottom
            anchors.left: control.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            availableBricks: manager.model
            onAddBrick: file => {
                            tutorialManager.addBrick(file)
                        }
        }
        Rectangle {
            id: sourceButtons
            anchors.left: control.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            height: addPathButton.height
            Button {
                id: addPathButton
                anchors.left: sourceButtons.left
                width: (sourceButtons.width - AppStyle.spacing) / 2
                text: qsTr("Add path")
                onPressed: folderDialog.open()
            }
            Button {
                id: removePathButton
                anchors.margins: AppStyle.spacing
                width: addPathButton.width
                anchors.left: addPathButton.right
                text: qsTr("Remove path")
                enabled: availableSources.currentIndex > -1
                onPressed: {
                    manager.removePath(
                                availableSources.itemAtIndex(
                                    availableSources.currentIndex).content)
                    availableSourcesModel.remove(availableSources.currentIndex,
                                                 1)
                }
            }
        }

        Rectangle {
            id: optionField
            anchors.top: availableSources.bottom
            anchors.left: control.right
            anchors.right: parent.right
            anchors.margins: AppStyle.spacing
            height: refreshButton.height
            Field {
                // TODO: implement filtering for content
                anchors.left: optionField.left
                anchors.right: refreshButton.left
                anchors.margins: AppStyle.spacing
                width: 0
                visible: false
            }
            IconButton {
                id: refreshButton
                anchors.right: optionField.right
                width: height
                icon.source: "qrc:/bricks/resources/refresh_black_24dp.svg"
                onClicked: manager.refresh(true)
            }
        }
        FolderDialog {
            id: folderDialog
            function find(model, folder) {
                for (var i = 0; i < model.count; ++i)
                    if (model.get(i).path === folder)
                        return model.get(i)
                return null
            }
            onAccepted: {
                if (!(folderDialog.find(availableSourcesModel, folder))) {
                    availableSourcesModel.append({
                                                     "path": folder
                                                 })
                }
                manager.addPath(folder)
            }
        }
    }
}
