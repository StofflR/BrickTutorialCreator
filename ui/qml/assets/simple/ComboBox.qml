import QtQuick 2.12
import QtQuick.Controls 2.0 as T
import QtQml 2.12

import "../../style"

T.ComboBox {
    id: control

    delegate: T.ItemDelegate {
        id: delegate
        width: control.width
        contentItem: T.Label {
            text: modelData
            color: AppStyle.color.text
            font.family: "Roboto"
            font.pointSize: AppStyle.pointsizeSpacing
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            width: control.width
            color: delegate.highlighted ? Qt.lighter(
                                              AppStyle.color.window) : AppStyle.color.window
        }
        highlighted: control.highlightedIndex == index
        required property int index
        required property string modelData
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() {
                canvas.requestPaint()
            }
        }

        onPaint: {
            context.reset()
            context.moveTo(0, 0)
            context.lineTo(width, 0)
            context.lineTo(width / 2, height)
            context.closePath()
            context.fillStyle = control.pressed ? "dimgray" : "darkgray"
            context.fill()
        }
    }

    contentItem: Text {
        leftPadding: AppStyle.spacing
        rightPadding: control.indicator.width + control.spacing

        text: displayText
        font.family: "Roboto"
        font.pointSize: AppStyle.pointsizeSpacing
        color: AppStyle.color.text
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: AppStyle.defaultHeight
        border.color: Qt.darker(AppStyle.color.window)
        border.width: control.visualFocus ? 2 : 1
        color: AppStyle.color.light
        radius: 2
    }

    popup: T.Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
        }

        background: Rectangle {
            border.color: Qt.darker(AppStyle.color.window)
            radius: 2
        }
    }
}
