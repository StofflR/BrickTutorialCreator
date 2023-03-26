import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import LanguageManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Item {
    id: root
    signal update
    signal updateStatusMessage(string text)
    onUpdate: {
        translationList.model = languageManager.sourceModel(textMetrics.text)
        language.comboBox.currentIndex = -1
    }
    anchors.fill: parent
    width: parent.width
    Rectangle {
        id: layout
        width: parent.width
        height: path.height + addLanguage.height + 20

        ButtonField {
            id: path
            button_label: "Translation folder"
            field.placeholderText: "Current folder …"
            field.text: textMetrics.elidedText
            anchors.top: layout.top
            anchors.left: parent.left
            width: layout.width / 2
            field.readOnly: true

            anchors.margins: AppStyle.spacing
            button.onPressed: folderDialog.open()
        }
        FolderDialog {
            id: folderDialog
            folder: tempFolder
            TextMetrics {
                id: textMetrics
                font.family: Font.boldFont ? Font.boldFont : -1
                elide: Text.ElideLeft
                elideWidth: path.field.width
                text: folderDialog.folder
            }
            onAccepted: {
                textMetrics.text = folder
            }
        }
        LanguageManager {
            id: languageManager
        }
        LabelComboBox {
            id: language
            signal updateListView
            label: "Available languages:"
            anchors.top: layout.top
            anchors.left: path.right
            anchors.right: deleteLanguage.left
            anchors.margins: AppStyle.spacing
            comboBox.model: languageManager.languages(textMetrics.text)
            comboBox.onModelChanged: comboBox.currentIndex = -1
            comboBox.onCurrentIndexChanged: {
                if (comboBox.currentIndex + 1 === comboBox.model.length) {
                    comboBox.currentIndex = -1
                    comboBox.enabled = false
                    visible = false
                    addLanguage.field.forceActiveFocus()
                } else {
                    languageManager.currentIndex = comboBox.currentIndex
                }
            }
            comboBox.onCurrentTextChanged: updateListView()
            function open() {
                comboBox.currentIndex = -1
                comboBox.enabled = true
                visible = true
            }
        }
        IconButton {
            id: deleteLanguage
            anchors.top: layout.top
            enabled: language.comboBox.currentIndex >= 0
                     && language.comboBox.enabled
            anchors.right: layout.right
            anchors.margins: AppStyle.spacing
            width: height
            icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Clear current brick content!")
            onPressed: deleteDialog.open()
        }
        Popup {
            id: deleteDialog
            x: (root.width - 500) / 2
            y: (root.height - 150) / 2
            width: 500
            height: 150
            modal: true
            focus: true
            contentItem: Rectangle {
                anchors.fill: parent
                Text {
                    anchors.centerIn: parent
                    text: "WARNING!\nRemoving: " + language.comboBox.currentText
                          + " will delete all associated files with the translation!\nDo you wish to continue anyway?"
                }
                Rectangle {
                    id: deleteButtons
                    width: parent.width / 2
                    height: AppStyle.defaultHeight + AppStyle.spacing
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    Button {
                        width: parent.width / 2
                        dangerButton: true
                        text: "Continue"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            languageManager.delete(
                                        textMetrics.text,
                                        language.comboBox.currentText)
                            deleteDialog.close()
                            language.comboBox.model = languageManager.languages(
                                        textMetrics.text)
                            root.update()
                        }
                    }
                }

                Rectangle {
                    width: parent.width / 2
                    height: AppStyle.defaultHeight + AppStyle.spacing
                    anchors.left: deleteButtons.right
                    anchors.bottom: parent.bottom
                    Button {
                        width: parent.width / 2
                        text: "Abort"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: deleteDialog.close()
                    }
                }
            }
        }
        ButtonField {
            id: addLanguage
            anchors.top: layout.top
            anchors.left: path.right
            anchors.right: layout.right
            visible: !language.visible
            anchors.margins: AppStyle.spacing
            button_label: qsTr("Add language …")
            field.placeholderText: qsTr("Enter new translation language …")
            button.enabled: field.text
            field.validator: RegularExpressionValidator {
                regularExpression: /\w+/
            }
            function add() {
                languageManager.new(textMetrics.text, addLanguage.field.text)
                language.comboBox.model = languageManager.languages(
                            textMetrics.text)
                updateStatusMessage(
                            "INFO: Added " + addLanguage.field.text + " as a new language!")
                addLanguage.field.clear()
                language.open()
            }

            button.onPressed: addLanguage.add()
            field.onEditingFinished: {
                addLanguage.add()
            }

            field.anchors.right: abort.left
            IconButton {
                id: abort
                icon.source: "qrc:/bricks/resources/arrow_back_ios_black_24dp.svg"
                onClicked: language.open()
                width: height
                anchors.right: addLanguage.right
            }
        }
    }
    ListView {
        id: translationList
        visible: language.comboBox.currentIndex > -1
        signal closeOpenEditor
        width: root.width
        reuseItems: false
        anchors.top: layout.bottom
        anchors.bottom: bottomLayout.top
        model: languageManager.sourceModel(textMetrics.text)
        z: layout.z - 1
        delegate: TranslationDelegate {
            id: delegate
            onEditPressed: {
                translationList.closeOpenEditor()
                bottomLayout.visible = true
                editor.open()
            }
            onResetPressed: {
                editor.resetLanguage()
            }
            Brick {
                id: brick
                signal updateBricks
                onUpdateBricks: update()
                Component.onCompleted: {
                    language.updateListView.connect(brick.updateBricks)
                    language.update()
                }
                function update() {
                    brick.fromSVG(
                                textMetrics.text + "/" + translationList.model[index])
                    sourcePath = brick.path()
                    if (language.comboBox.currentText === "New …")
                        return
                    var targetPath = textMetrics.text + "/" + language.comboBox.currentText
                    var targetFile = targetPath + "/" + translationList.model[index]

                    if (brick.exists(targetFile)) {
                        brick.fromSVG(targetFile)
                    } else {

                        brick.fromSVG(
                                    textMetrics.text + "/" + translationList.model[index])
                        brick.saveSVG(targetPath, translationList.model[index])
                    }
                    delegate.targetPath = targetFile
                }
            }
            SmallEditor {
                id: editor
                anchors.right: parent.right
                width: parent.width / 2 - 30
                height: parent.height
                signal close
                signal open
                Component.onCompleted: {
                    translationList.closeOpenEditor.connect(editor.close)
                }
                onOpen: {
                    editor.visible = true
                    brick.fromSVG(
                                brick.fromSVG(
                                    textMetrics.text + "/" + translationList.model[index]))
                }
                onClose: {
                    editor.visible = false
                }

                onAbortPressed: {
                    bottomLayout.visible = false
                    editor.close()
                }
                onAdvancedPressed: {
                    bottomLayout.visible = false
                    editor.close()
                }
                onResetLanguage: {
                    var targetPath = textMetrics.text + "/" + language.comboBox.currentText
                    var targetFile = targetPath + "/" + translationList.model[index]

                    brick.fromSVG(
                                textMetrics.text + "/" + translationList.model[index])
                    brick.saveSVG(targetPath, translationList.model[index])
                    delegate.targetPath = brick.path()
                    bottomLayout.visible = false
                    editor.close()
                }

                onOkPressed: content => {
                                 var targetPath = textMetrics.text + "/"
                                 + language.comboBox.currentText
                                 var targetFile = targetPath + "/" + translationList.model[index]
                                 brick.updateBrickContent(content)
                                 brick.saveSVG(targetPath,
                                               translationList.model[index])
                                 delegate.targetPath = brick.path()
                                 bottomLayout.visible = false
                                 editor.close()
                             }

                onContentChanged: content => {
                                      brick.updateBrickContent(content)
                                      svgPreview.source = brick.path()
                                  }
                // update svgPreview -> use loader for updating ListView
            }
        }
    }

    Rectangle {
        id: bottomLayout
        visible: false
        height: visible ? label.height + svgPreview.height : 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "white"

        Label {
            id: label
            text: "Translated Brick:"
            anchors.bottom: svgPreview.top
        }

        Image {
            id: svgPreview
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
}
