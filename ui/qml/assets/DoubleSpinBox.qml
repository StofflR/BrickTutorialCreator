import QtQuick 2.12
import QtQuick.Controls 2.0 as T
import QtQml 2.12

import "../assets"
import "../font"

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
    contentItem: TextInput {
        rightPadding: spinbox.indicator.width + spinbox.spacing

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: spinbox.displayText
        font.family: Font.boldFont ? Font.boldFont : -1
        font.pixelSize: 10
        color: "black"
        readOnly: !spinbox.editable
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }
    up.indicator: Rectangle {
        x: spinbox.mirrored ? 0 : parent.width - width
        height: parent.height
        width: height / 2
        implicitWidth: 40
        implicitHeight: 40
        color: spinbox.up.pressed ? "dimgray" : "white"
        border.color: "black"

        Text {
            text: "+"
            font.family: Font.boldFont ? Font.boldFont : -1
            font.pixelSize: spinbox.font.pixelSize * 2
            color: "black"
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
        implicitWidth: 40
        implicitHeight: 20
        color: spinbox.down.pressed ? "dimgray" : "white"
        border.color: "black"

        Text {
            text: "-"
            font.family: Font.boldFont ? Font.boldFont : -1
            font.pixelSize: spinbox.font.pixelSize * 2
            color: "black"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        border.color: spinbox.pressed ? "dimgray" : "black"
        border.width: spinbox.visualFocus ? 2 : 1
        radius: 2
    }
}
