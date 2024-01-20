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
    required property string targetPath

    required property bool keepName
    required property bool split
    required property int index

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

        content.onCursorVisibleChanged: saveBrick()

        function saveBrick() {
            if (keepName) {
                target.brick.saveSVG(targetPath, sourceFile)
            } else {
                target.brick.saveSVG(targetPath)
            }
            modified = false
        }
        Keys.onPressed: event => {
                            if (event.matches(StandardKey.Save)) {
                                root.forceActiveFocus()
                                saveBrick()
                            } else if (event.matches(StandardKey.Cancel)) {
                                root.forceActiveFocus()
                                saveBrick()
                            }
                        }

        Component.onCompleted: {
            target.loadFromFile(sourcePath)
            saveBrick()
        }
    }
}
