import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import BrickManager 1.0
import Brick 1.0

import "../assets"
import "../font"
import "../views"
import "../style"

Image {
    id: svgPreview
    property var brickImg
    property var xPos
    property var yPos
    property var contentScale
    property string brickContent: previewContent.text
    property var availableSize
    property var brickPath
    property var brickColor

    property var fileName
    property alias brick: svgBrick

    signal updated
    source: overlay.visible || !svgBrick.path(
                ) ? "qrc:/bricks/base/" + brickImg : svgBrick.path()
    Brick {
        id: svgBrick
    }
    onUpdate: save => {
                  if (!brickPath | !brickColor | !availableSize) {
                      return
                  }
                  console.log("data", brickColor, brickPath, availableSize,
                              brickContent, contentScale, xPos, yPos)
                  svgBrick.updateBrick(brickColor, brickPath, availableSize,
                                       brickContent, contentScale, xPos, yPos)
                  svgPreview.fileName = svgBrick.fileName()
                  svgPreview.updated()
              }

    Column {
        id: overlay
        anchors.fill: previewContent
        visible: previewContent.cursorVisible ? 1 : 0 // TODO: enable on component completion
        onVisibleChanged: svgPreview.update(true)
        Repeater {
            id: repeater
            property int cursorPosition: previewContent.cursorPosition
                                         - previewContent.text.substring(
                                             0,
                                             previewContent.cursorPosition).lastIndexOf(
                                             "\n") - 1
            model: {
                var data = previewContent.getText(0, previewContent.length)
                while (data.indexOf("\n") !== -1) {
                    data = data.replace("\n", "&nbsp;\r")
                }

                while (data.indexOf("$") !== -1) {
                    data = data.replace(
                                "$", "<u style=\"white-space:pre;\">&middot;")
                    data = data.replace("$", "&middot;</u>")
                }
                while (data.indexOf("*") !== -1) {
                    data = data.replace(
                                "*",
                                "<span style=\"text-indent:25px;white-space:pre;\"><small>&middot;")
                    data = data.replace("*", "&middot;</small></span>")
                }
                return data.split("\r")
            }

            TextEdit {
                id: repeaterLine
                width: contentWidth
                height: 12 * previewContent.scale
                text: repeater.model[index]
                padding: 0
                textFormat: TextEdit.AutoText
                z: repeater.model.length - index
                font: previewContent.font
                cursorVisible: index === previewContent.cursorLine
                               && previewContent.cursorVisible
                Binding on cursorPosition {
                    when: onTextChanged || previewContent.text
                          || previewContent.cursorPosition
                    value: repeater.cursorPosition
                }
                onTextChanged: cursorPosition = repeater.cursorPosition
                onCursorPositionChanged: console.log(cursorPosition)
            }
        }
    }
    TextEdit {
        id: previewContent
        anchors.left: svgPreview.left
        anchors.top: svgPreview.top
        width: svgPreview.width - svgPreview.xPos
        height: svgPreview.height - svgPreview.yPos
        anchors.leftMargin: svgPreview.xPos + 74
        anchors.topMargin: svgPreview.yPos

        property int cursorLine: previewContent.text.substring(
                                     0, previewContent.cursorPosition).split(
                                     /\n/).length - 1
        property real scale: svgPreview.paintedWidth / 350
        cursorDelegate: Item {}
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        font.family: "Roboto"
        cursorVisible: false
        wrapMode: TextArea.WordWrap
        font.bold: true
        font.pointSize: 12 * scale < 0 ? 12 : 12 * scale
        opacity: 0
    }
}
