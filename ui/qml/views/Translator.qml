import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import LanguageManager
import Brick

import "../assets/simple"
import "../assets/combined"
import "../views/interface"
import "../style"

Item {
    id: root
    signal update
    signal updateStatusMessage(string text)

    anchors.fill: parent
    width: parent.width
    anchors.margins: AppStyle.spacing

    LabelTextField {

        id: brickName
        anchors.top: root.top
        property string folderPath: tempFolder.replace(fileStub, "")
        width: root.width / 2
        label: "Target folder:"
        field.text: "english"
        field.validator: RegularExpressionValidator {
            regularExpression: /\w+/
        }
        field.hoverEnabled: true
        field.ToolTip.delay: 1000
        field.ToolTip.timeout: 5000
        field.ToolTip.visible: brickName.field.hovered
        field.ToolTip.text: brickName.folderPath
    }
    FolderDialog {
        id: folderDialog
        folder: tempFolder.replace(fileStub, "")
        onAccepted: brickName.folderPath = folder
    }
    IconButton {
        id: path
        icon.source: "qrc:/bricks/resources/folder_open_black_24dp.svg"
        anchors.left: brickName.right
        anchors.top: root.top
        onPressed: folderDialog.open()
        anchors.leftMargin: AppStyle.spacing
        hoverEnabled: true
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.visible: path.hovered
        ToolTip.text: "Set export path …"
    }
    Label {
        id: selectionView
        height: AppStyle.defaultHeight
        anchors.left: path.right
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
        ToolTip.visible: path.hovered
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
        ToolTip.visible: path.hovered
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

    ListView {
        id: translationList
        width: parent.width
        anchors.top: singleViewRadio.bottom
        anchors.margins: AppStyle.spacing
        anchors.bottom: parent.bottom
        reuseItems: false
        model: ["file:///F:/Documents/GIT/BrickTutorialCreator/ui/resources/out/asd_asd_.svg", "file:///F:/Documents/GIT/BrickTutorialCreator/ui/resources/out/asdas_dasd_$asd$_.svg"]
        delegate: TranslationDelegate {
            split: splitViewRadio.checked
            sourcePath: translationList.model[index]
            keepName: keepFilename.checked

            sourceFile: "asd" + index + ".svg"
            targetPath: tempFolder + "/asd"
        }
    }
}
