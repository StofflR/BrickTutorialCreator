import QtQuick 2.12
import QtQuick.Controls 2.0 as T
import QtQml 2.12

import "../assets"
import "../font"
import "../style"

T.SpinBox {
    id: spinbox
    from: 0
    value: 100
    to: 100
    stepSize: 3

    property int decimals: 0
    property real realValue: value

    validator: IntValidator {
        bottom: Math.min(spinbox.from, spinbox.to)
        top: Math.max(spinbox.from, spinbox.to)
    }

    textFromValue: function (value, locale) {
        return Number(value).toLocaleString(locale, 'f', spinbox.decimals)
    }

    valueFromText: function (text, locale) {
        return Number.fromLocaleString(locale, text)
    }
    up.indicator: Rectangle {
        x: spinbox.mirrored ? 0 : parent.width - width
        height: parent.height
        width: height / 2
        implicitWidth: AppStyle.defaultHeight
        implicitHeight: AppStyle.defaultHeight
        color: spinbox.up.pressed ? Qt.darker(
                                        AppStyle.color.window) : AppStyle.color.window
        border.color: Qt.darker(AppStyle.color.window)

        Text {
            text: "+"
            font.family: "Roboto"
            font.pointSize: spinbox.font.pointSize * 2
            color: AppStyle.color.text
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        x: spinbox.mirrored ? parent.width - width : 0
        height: parent.height
        width: height / 2
        implicitWidth: AppStyle.defaultHeight
        implicitHeight: AppStyle.defaultHeight
        color: spinbox.down.pressed ? Qt.darker(
                                          AppStyle.color.window) : AppStyle.color.window
        border.color: Qt.darker(AppStyle.color.window)

        Text {
            text: "-"
            font.family: "Roboto"
            font.pointSize: spinbox.font.pointSize * 2
            color: AppStyle.color.text
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    contentItem: TextInput {
        anchors.right: up.indicator.left
        anchors.left: down.indicator.right
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: spinbox.displayText
        font.family: "Roboto"
        font.pointSize: AppStyle.pointsizeSpacing
        color: AppStyle.color.text
        readOnly: !spinbox.editable
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }
    background: Rectangle {
        implicitWidth: 120
        implicitHeight: AppStyle.defaultHeight
        border.color: Qt.darker(AppStyle.color.window)
        border.width: spinbox.visualFocus ? 2 : 1
        radius: 2
        color: AppStyle.color.light
    }
}
