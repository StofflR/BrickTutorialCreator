import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import QtQuick 2.15

import "../views/interface"
import "../assets/simple"
import "../assets/combined"
import "../style"

import TutorialManager 1.0
import TutorialSourceManager 1.0

Item {
    id: root
    LabelTextField {
        id: tutorialName
        anchors.top: root.top
        anchors.topMargin: AppStyle.spacing
        property string folderPath: tempFolder.replace(fileStub, "")
        width: root.width / 2
        label: "Name:"
        field.text: "new_tutorial"
        field.enabled: true
        field.validator: RegularExpressionValidator {
            regularExpression: /\w+/
        }
        field.hoverEnabled: true
        field.ToolTip.delay: 1000
        field.ToolTip.timeout: 5000
        field.ToolTip.visible: tutorialName.field.hovered
        field.ToolTip.text: tutorialName.folderPath
    }
    Button {
        text: "Change export path ..."
        onClicked: exportPathDialog.open()
        anchors.left: tutorialName.right
        anchors.top: tutorialName.top
        width: (sourceButtons.width - AppStyle.spacing) / 2
        FolderDialog {
            id: exportPathDialog
            onAccepted: {
                tutorialName.folderPath = folder.toString().replace(fileStub,
                                                                    "")
            }
        }
    }
    signal updateStatusMessage(string text)
    signal deletePressed
    FocusScope {
        id: item
        anchors.top: tutorialName.bottom
        width: root.width
        height: root.height - tutorialName.height
        TutorialManager {
            id: tutorialManager
            onCcByChanged: addCCBYSorting.checked = tutorialManager.enableCCBY
        }
        Keys.enabled: true
        Keys.onDeletePressed: {
            if (proxyModel.selectedIndex != -1) {
                tutorialManager.removeBrick(proxyModel.selectedIndex)
                proxyModel.selectedIndex = -1
            }
        }
        onVisibleChanged: proxyModel.selectedIndex = -1

        Item {
            width: parent.width / 2
            height: item.height
            ScrollView {
                id: scrollview
                clip: true
                anchors.left: parent.left
                width: parent.width
                anchors.top: parent.top
                height: parent.height
                ToolTip.visible: hovered
                ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                ToolTip.text: qsTr("Press 'Delete' to remove selected item!")

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ListView {
                    id: timeline
                    signal remove(int index)
                    onRemove: index => {
                                  tutorialManager.removeBrick(index)
                                  proxyModel.selectedIndex = -1
                              }
                    snapMode: ListView.SnapToItem
                    anchors.topMargin: AppStyle.spacing
                    anchors.fill: scrollview
                    orientation: ListView.Vertical
                    model: TutorialView {
                        onFocus: item.forceActiveFocus()
                        id: proxyModel
                        model: tutorialManager?.model
                        onModelUpdated: {
                            var updatedModel = []
                            for (var i = 0; i < proxyModel.items.count; i++)
                                updatedModel.push(proxyModel.items.get(
                                                      i).model.modelData)
                            if (updatedModel == [])
                                return
                            if (tutorialManager)
                                tutorialManager.model = updatedModel
                        }
                    }
                    moveDisplaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 200
                        }
                    }
                }
            }
        }
        Item {
            anchors.right: parent.right
            width: parent.width / 2
            height: parent.height
            Item {
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
                            folder: fileStub + tutorialName.folderPath
                            nameFilters: ["Any (*.json *.png)", "PNG files(*.png)", "JSON files (*.json)"]
                            fileMode: FileDialog.SaveFile
                            onAccepted: {
                                var filename = tutorialManager.saveTutorial(
                                            currentFile)
                                if (!filename)
                                    return root.updateStatusMessage(
                                                "INFO: Could not save tutorial to " + currentFile)
                                tutorialName.field.text = filename
                                root.updateStatusMessage(
                                            "INFO: Saved tutorial to " + currentFile)
                            }
                        }
                        icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
                        width: height
                        enabled: tutorialManager?.model?.length > 0
                                 && tutorialName.field.text
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        onPressed: brickSaveDialog.open()
                        ToolTip.visible: hovered
                        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                        ToolTip.text: qsTr("Save tutorial as ... (*.png/ *.json)")
                    }
                    IconButton {
                        FileDialog {
                            id: brickOpenDialog
                            folder: fileStub + tutorialName.folderPath
                            nameFilters: ["Any (*.svg *.json)", "SVG files (*.svg)", "JSON files (*.json)"]
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
                        property string currentFile: tutorialName.folderPath + "/"
                                                     + tutorialName.field.text
                        icon.source: "qrc:/bricks/resources/text_snippet_black_24dp.svg"
                        width: height
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        enabled: tutorialManager?.model?.length > 0
                                 && tutorialName.field.text
                        onPressed: {
                            tutorialManager.toJSON(currentFile)
                            root.updateStatusMessage(
                                        "INFO: Saved tutorial to " + currentFile + ".json")
                        }
                        ToolTip.visible: hovered
                        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                        ToolTip.text: qsTr("Save tutorial to JSON")
                    }
                    IconButton {
                        property string currentFile: tutorialName.folderPath + "/"
                                                     + tutorialName.field.text
                        icon.source: "qrc:/bricks/resources/image_black.svg"
                        width: height
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        enabled: tutorialManager?.model?.length > 0
                                 && tutorialName.field.text
                        onPressed: {
                            tutorialManager.toPNG(currentFile)
                            root.updateStatusMessage(
                                        "INFO: Saved tutorial to " + currentFile + ".png")
                        }
                        ToolTip.visible: hovered
                        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                        ToolTip.text: qsTr("Save tutorial to PNG")
                    }
                    IconButton {
                        FileDialog {
                            id: fileOpenDialog
                            folder: fileStub + tutorialName.folderPath
                            nameFilters: ["JSON files (*.json)"]
                            fileMode: FileDialog.OpenFile
                            defaultSuffix: "json"
                            onAccepted: {
                                tutorialName.field.text = tutorialManager.fromJSON(
                                            currentFile)
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
                    IconButton {
                        icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
                        width: height
                        enabled: tutorialManager?.model?.length > 0
                                 && tutorialName.field.text
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        onPressed: tutorialManager.clear()
                        ToolTip.visible: hovered
                        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                        ToolTip.text: qsTr("Clear Tutorial")
                    }
                }
            }
            Item {
                anchors.fill: availableSourceScrollview
            }

            ScrollView {
                id: availableSourceScrollview
                anchors.top: sourceButtons.bottom
                anchors.left: control.right
                anchors.right: parent.right
                ScrollBar.vertical.snapMode: ScrollBar.SnapAlways
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                anchors.margins: AppStyle.spacing
                height: parent.height / 4 < availableSources.count
                        * 40 ? parent.height / 4 : availableSources.count * 40

                ListView {
                    id: availableSources
                    width: availableSourceScrollview.width

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
                                anchors.centerIn: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideLeft
                            }
                        }
                    }
                    highlight: Rectangle {
                        radius: 5
                        color: palette.midlight
                    }
                    focus: true
                    model: ListModel {
                        id: availableSourcesModel
                    }
                }
            }
            TutorialSourceManager {
                id: manager
            }

            Item {
                id: sourceButtons
                anchors.left: control.right
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: AppStyle.spacing
                height: 2 * AppStyle.defaultHeight + AppStyle.spacing
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
                        availableSourcesModel.remove(
                                    availableSources.currentIndex, 1)
                    }
                }
                CheckBox {
                    id: enableForeign
                    anchors.top: addPathButton.bottom
                    anchors.margins: AppStyle.spacing
                    text: "Legacy bricks"
                    onCheckedChanged: {
                        manager.allowForeign = enableForeign.checked
                        manager.refresh()
                    }
                }
                CheckBox {
                    id: enableSorting
                    anchors.top: addPathButton.bottom
                    anchors.left: enableForeign.right
                    anchors.margins: AppStyle.spacing
                    text: "Sort bricks"
                    onCheckedChanged: {
                        manager.sorted = enableSorting.checked
                        manager.refresh()
                    }
                }
                CheckBox {
                    id: addCCBYSorting
                    anchors.top: addPathButton.bottom
                    anchors.left: enableSorting.right
                    anchors.right: sourceButtons.right
                    anchors.margins: AppStyle.spacing
                    text: "Add CC-BY-SA 4.0"
                    onCheckedChanged: tutorialManager.enableCCBY = addCCBYSorting.checked
                }
            }

            Item {
                id: optionField
                anchors.top: availableSourceScrollview.bottom
                anchors.left: control.right
                anchors.right: parent.right
                anchors.margins: AppStyle.spacing
                height: refreshButton.height
                Field {
                    anchors.left: optionField.left
                    anchors.right: refreshButton.left
                    anchors.margins: AppStyle.spacing
                    onTextChanged: manager.setFilter(text)
                }
                IconButton {
                    id: refreshButton
                    anchors.right: optionField.right
                    width: height
                    icon.source: "qrc:/bricks/resources/refresh_black_24dp.svg"
                    onClicked: manager.refresh()
                }
            }
            UsableBrickView {
                id: usableBrickView
                anchors.top: optionField.bottom
                anchors.left: control.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                availableBricks: manager?.model
                groupedView: enableSorting.checked
                onAddBrick: file => {
                                tutorialManager.addBrick(file)
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
                    var path = folder.toString().replace(fileStub, "")
                    if (!(folderDialog.find(availableSourcesModel, path))) {
                        availableSourcesModel.append({
                                                         "path": path
                                                     })
                    }
                    manager.addPath(folder)
                }
            }
        }
    }
}
