import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick 2.0

Rectangle {
    id: editor
    visible: false

    signal abortPressed
    signal okPressed(string content)
    signal advancedPressed
    signal resetPressed
    signal contentChanged(string content)

    Area {
        id: brickContent
        font.pixelSize: 30
        anchors.top: editor.top
        anchors.bottom: editor.bottom
        anchors.left: editor.left
        anchors.right: advancedTranslation.left
        placeholderText: qsTr("Enter brick content …")
        verticalAlignment: TextField.AlignTop
        inputMethodHints: Qt.ImhMultiLine
        onTextChanged: contentChanged(text)
        ToolTip.visible: hovered
        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Variables:\n$ some sample var $\nNew Line:\n\\\\\nDropdown:\n* some sample var *")
    }
    IconButton {
        id: advancedTranslation
        property int translationIndex

        function update(index) {
            bottomLayout.visible = true
        }

        onPressed: editor.advancedPressed()

        display: AbstractButton.IconOnly
        icon.source: "qrc:/bricks/resources/settings_black_24dp.svg"
        icon.color: down ? "dimgray" : "black"
        width: height
        height: editor.height / 2
        anchors.top: editor.top
        anchors.right: saveTranslation.left
        anchors.rightMargin: 10
    }
    IconButton {
        id: resetTranslation
        property int translationIndex

        function update(index) {
            bottomLayout.visible = true
        }

        onPressed: {
            brickContent.clear()
            editor.resetPressed()
        }

        display: AbstractButton.IconOnly
        icon.source: "qrc:/bricks/resources/restore_black_24dp.svg"
        icon.color: down ? "dimgray" : "black"
        width: height
        height: editor.height / 2
        anchors.top: advancedTranslation.bottom
        anchors.right: saveTranslation.left
        anchors.rightMargin: 10
    }
    IconButton {
        id: saveTranslation
        property int translationIndex

        function update(index) {
            bottomLayout.visible = true
        }

        onPressed: editor.okPressed(brickContent.text)

        display: AbstractButton.IconOnly
        icon.source: "qrc:/bricks/resources/save_black_24dp.svg"
        icon.color: down ? "dimgray" : "black"
        width: height
        height: editor.height / 2
        anchors.top: editor.top
        anchors.right: editor.right
    }
    IconButton {
        id: abortTranslation
        property int translationIndex

        function update(index) {
            bottomLayout.visible = true
        }

        onPressed: editor.abortPressed()
        display: AbstractButton.IconOnly
        icon.source: "qrc:/bricks/resources/close_black_24dp.svg"
        icon.color: down ? "dimgray" : "black"
        width: height
        height: editor.height / 2
        anchors.right: editor.right
        anchors.bottom: editor.bottom
    }
}
