import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.1

import "../../font"
import "../../style"

ItemDelegate {
    id: root
    property string sourcePath
    property string sourceFolder
    property string targetFolder
    property alias translationBrick: target

    width: parent ? parent.width : 0
    height: target.height + target.height
            < AppStyle.defaultHeight ? AppStyle.defaultHeight : target.height

    onTargetFolderChanged: reload()

    function reload() {
        var folder = targetFolder
        var targetPath = sourceFolder + "/" + folder + "/" + sourcePath
        var source = sourceFolder + "/" + sourcePath
        if (languageManager.exists(targetPath)) {
            return target.loadFromFile(targetPath)
        }
        if (folder != "") {
            console.log(source)
            target.loadFromFile(source)
            target.brick.saveSVG(sourceFolder + "/" + folder, sourcePath)
        }
    }
    Rectangle {
        anchors.fill: sourceImage
        radius: 5
        color: palette.midlight
    }
    Rectangle {
        anchors.fill: target
        radius: 5
        color: palette.midlight
    }

    Image {
        id: sourceImage
        anchors.left: root.left
        source: sourceFolder + "/" + sourcePath
        width: root.width / 2
        height: target.height
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: sourcePath
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: root
        onClicked: root.forceActiveFocus()
    }
    EditableBrick {
        id: target
        anchors.right: root.right
        width: root.width / 2
        loadButton.enabled: false
        saveButton.enabled: false
        clearButton.enabled: false
        onDataChanged: if (modified) {
                           target.brick.saveSVG(
                                       sourceFolder + "/" + targetFolder,
                                       sourcePath)
                           modified = false
                       }
    }
}
