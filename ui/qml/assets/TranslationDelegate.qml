import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.1
import "../font"
import "../views"
import "../style"

ItemDelegate {
    id: root
    property string sourcePath
    property string sourceFolder
    property string targetFolder
    property alias translationBrick: target

    onTargetFolderChanged: reload()
    onSourceFolderChanged: reload()

    width: parent ? parent.width : 0
    height: target.height

    function reload() {
        if (languageManager.exists(targetFolder + "/" + sourcePath))
            target.loadFromFile(targetFolder + "/" + sourcePath)
        else
            target.loadFromFile(sourceFolder + "/" + sourcePath)
        target.dataChanged()
    }

    Image {
        id: sourceImage
        anchors.left: root.left
        width: root.width / 2
        height: target.height
        source: sourceFolder + "/" + sourcePath
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: sourcePath
        asynchronous: true
    }

    EditableBrick {
        id: target
        anchors.right: root.right
        width: root.width / 2
        loadButton.enabled: false
        saveButton.enabled: false
        clearButton.enabled: false
        IconButton {
            id: clearButton
            anchors.top: target.top
            anchors.right: target.right
            anchors.margins: enabled ? AppStyle.spacing : 0
            height: enabled ? width : 0
            icon.source: "qrc:/bricks/resources/done_black_24dp.svg"
            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Clear current brick content!")
        }
        onDataChanged: target.brick.saveSVG(targetFolder, sourcePath)

        Component.onCompleted: reload()
    }
}
