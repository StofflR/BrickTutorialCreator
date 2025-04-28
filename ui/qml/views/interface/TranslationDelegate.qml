import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models

import "../../font"
import "../../style"

ItemDelegate {
    id: root
    required property string sourcePath
    required property string sourceFile
    required property string targetFolder
    required property string targetPath

    required property bool keepName
    required property bool split
    required property int index

    required property bool saveSVG
    required property bool savePNG
    required property bool saveJSON

    property bool enabled: false

    function loadBrick() {
        if (root.sourcePath != "" && root.enabled)
            target.loadFromFile(
                        (root.targetPath == "") ? root.sourcePath : root.targetPath)
    }

    onTargetFolderChanged: loadBrick()
    onEnabledChanged: loadBrick()

    height: source.height > 0 ? source.height : target.height
    width: parent?.width
    Image {
        id: source
        asynchronous: true
        width: split ? parent.width / 2 - AppStyle.spacing : 0
        visible: split
        source: sourcePath
        fillMode: Image.PreserveAspectFit
        anchors.left: root.left
        sourceSize.width: width
        smooth: true
        cache: true
    }
    EditableBrick {
        id: target
        width: split ? parent.width / 2 : parent.width
        anchors.right: root.right
        loadButton.enabled: false
        saveButton.enabled: false
        clearButton.enabled: false

        function saveBrick() {
            if (keepName) {
                if (saveSVG)
                    target.brick.saveSVG(targetFolder, sourceFile)
                if (savePNG)
                    target.brick.savePNG(targetFolder, sourceFile)
                if (saveJSON)
                    target.brick.saveJSON(targetFolder, sourceFile)
            } else {
                if (saveSVG)
                    target.brick.saveSVG(targetFolder)
                if (savePNG)
                    target.brick.savePNG(targetFolder)
                if (saveJSON)
                    target.brick.saveJSON(targetFolder)
            }
        }
        Component.onCompleted: root.enabled = true

        Keys.onPressed: event => {
                            if (event.matches(StandardKey.Save)) {
                                root.forceActiveFocus()
                                saveBrick()
                            } else if (event.matches(StandardKey.Cancel)) {
                                root.forceActiveFocus()
                                saveBrick()
                            }
                        }
    }
}
