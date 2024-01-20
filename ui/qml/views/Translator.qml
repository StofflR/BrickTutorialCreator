import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import LanguageManager 1.0

import "../assets/simple"
import "../assets/combined"
import "../views/interface"
import "../style"

Item {
    id: root
    signal update
    signal updateStatusMessage(string text)

    onUpdate: languageManager.refreshModel()

    anchors.fill: parent
    width: parent.width
    anchors.margins: AppStyle.spacing

    LabelTextField {
        id: brickName
        anchors.top: root.top
        property string folderPath: tempFolder.replace(fileStub, "")
        width: root.width / 2
        label: "Target folder:"
        field.text: tempFolder
        field.validator: RegularExpressionValidator {
            regularExpression: /\w+/
        }

        field.enabled: false
        field.hoverEnabled: true
        field.ToolTip.delay: 1000
        field.ToolTip.timeout: 5000
        field.ToolTip.visible: brickName.field.hovered
        field.ToolTip.text: "Source: " + brickName.folderPath
    }
    FolderDialog {
        id: folderDialog
        property bool source: false
        folder: tempFolder.replace(fileStub, "")
        onAccepted: if (source) {
                        brickName.folderPath = folder
                    } else {
                        brickName.field.text = folder
                    }
    }
    IconButton {
        id: exportpath
        icon.source: "qrc:/bricks/resources/upload.svg"
        anchors.left: brickName.right
        anchors.top: root.top
        onPressed: {
            folderDialog.source = false
            folderDialog.open()
        }
        anchors.leftMargin: AppStyle.spacing
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: exportpath.hovered
        ToolTip.text: "Set export path …"
    }
    IconButton {
        id: sourcepath
        icon.source: "qrc:/bricks/resources/download.svg"
        anchors.left: exportpath.right
        anchors.top: root.top
        onPressed: {
            folderDialog.source = true
            folderDialog.open()
        }
        anchors.leftMargin: AppStyle.spacing
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: sourcepath.hovered
        ToolTip.text: "Set source path …"
    }
    Label {
        id: selectionView
        height: AppStyle.defaultHeight
        anchors.left: sourcepath.right
        font.family: "Roboto"
        anchors.top: parent.top
        anchors.leftMargin: AppStyle.spacing
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: "View: "
    }

    IconButton {
        id: splitViewRadio
        icon.source: "qrc:/bricks/resources/splitscreen.svg"
        anchors.left: selectionView.right
        anchors.top: root.top
        transform: Rotation {
            origin.x: splitViewRadio.width / 2
            origin.y: splitViewRadio.height / 2
            axis {
                x: 0
                y: 0
                z: 1
            }
            angle: 90
        }
        anchors.leftMargin: AppStyle.spacing
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: splitViewRadio.hovered
        ToolTip.text: "Splitview"
        autoExclusive: true
        checkable: true
        checked: true
    }
    IconButton {
        id: singleViewRadio
        icon.source: "qrc:/bricks/resources/splitscreen.svg"

        anchors.left: splitViewRadio.right
        anchors.top: root.top
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: singleViewRadio.hovered
        ToolTip.text: "Singleview"
        autoExclusive: true
        checkable: true
    }
    CheckBox {
        id: keepFilename
        anchors.left: singleViewRadio.right
        text: "Keep filename"
        checked: true
    }
    IconButton {
        id: refresh
        icon.source: "qrc:/bricks/resources/refresh_black_24dp.svg"
        onPressed: languageManager.refreshModel()
        anchors.left: keepFilename.right
        anchors.top: root.top
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: refresh.hovered
        ToolTip.text: "Reload files"
        autoExclusive: true
    }
    LanguageManager {
        id: languageManager
        sourceFolder: brickName.folderPath
    }

    ListView {
        id: translationList
        width: parent.width
        anchors.top: singleViewRadio.bottom
        anchors.margins: AppStyle.spacing
        anchors.bottom: parent.bottom

        clip: true
        model: languageManager.model
        delegate: TranslationDelegate {
            split: splitViewRadio.checked
            sourcePath: translationList.model[index]["sourcePath"]
            keepName: keepFilename.checked

            sourceFile: translationList.model[index]["sourceFile"]
            targetPath: brickName.field.text
        }
    }
}
