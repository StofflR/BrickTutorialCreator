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
        translationList.model = languageManager.sourceModel
        language.comboBox.currentIndex = -1
    }
    anchors.fill: parent
    width: parent.width
    Rectangle {
        id: layout
        width: parent.width
        height: path.height + addLanguage.height + 20
        color: AppStyle.color.window
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
            path: textMetrics.text
        }
        LabelComboBox {
            id: language
            label: "Available languages:"
            anchors.top: layout.top
            anchors.left: path.right
            anchors.right: addLanguage.left
            anchors.margins: AppStyle.spacing
            comboBox.model: languageManager.languages
            comboBox.onModelChanged: comboBox.currentIndex = -1
        }
        LabelTextField {
            id: newLanguage
            visible: !language.visible
            label: "Add languages:"
            field.placeholderText: "Enter new Language!"
            anchors.top: layout.top
            anchors.left: path.right
            anchors.right: addLanguage.left
            anchors.margins: AppStyle.spacing
        }
        IconButton {
            id: addLanguage
            anchors.top: layout.top
            anchors.right: removeLanguage.left
            anchors.margins: AppStyle.spacing
            icon.source: language.visible ? "qrc:/bricks/resources/add_black_24dp.svg" : "qrc:/bricks/resources/check_circle_black_24dp.svg"
            onClicked: {
                if (newLanguage.visible)
                    languageManager.newLanguage(newLanguage.field.text)
                language.visible = !language.visible
            }
        }
        IconButton {
            id: removeLanguage
            anchors.top: layout.top
            anchors.right: layout.right
            anchors.margins: AppStyle.spacing
            icon.source: "qrc:/bricks/resources/delete_black_24dp.svg"
            enabled: language.comboBox.currentIndex != -1
            onClicked: deleteDialog.open()
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
                    text: "WARNING!\nRemoving: " + languageManager.currentLanguage
                          + " will delete all associated files with the translation!\nDo you wish to continue anyway?"
                    font: Font.lightFont
                    color: AppStyle.color.text
                }
                color: AppStyle.color.window
                Rectangle {
                    id: deleteButtons
                    width: parent.width / 2
                    height: AppStyle.defaultHeight + AppStyle.spacing
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    color: AppStyle.color.window
                    Button {
                        width: parent.width / 2
                        dangerButton: true
                        text: "Continue"
                        font: Font.lightFont
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            languageManager.delete(
                                        language.comboBox.currentText)
                            deleteDialog.close()
                            root.update()
                        }
                    }
                }

                Rectangle {
                    width: parent.width / 2
                    height: AppStyle.defaultHeight + AppStyle.spacing
                    anchors.left: deleteButtons.right
                    anchors.bottom: parent.bottom
                    color: AppStyle.color.window
                    Button {
                        width: parent.width / 2
                        text: "Abort"
                        font: Font.lightFont
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: deleteDialog.close()
                    }
                }
            }
        }
    }
    ListView {
        id: translationList
        visible: language.comboBox.currentIndex > -1
        signal closeOpenEditor
        width: root.width
        anchors.top: layout.bottom
        anchors.bottom: bottomLayout.top
        reuseItems: false
        model: languageManager.sourceModel
        z: layout.z - 1
        clip: true
        enabled: model.length > 0
        delegate: TranslationDelegate {
            id: delegate
            sourceFolder: textMetrics.text
            sourcePath: modelData
            targetFolder: language.comboBox.currentText
        }
        onVisibleChanged: updateStatusMessage("")
        cacheBuffer: visible ? 400 : 0
    }

    Rectangle {
        id: bottomLayout
        visible: false
        height: visible ? label.height + svgPreview.height : 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: AppStyle.color.window

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
