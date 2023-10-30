import QtQuick 2.12
import QtQuick.Controls 2.0 as T
import QtQml 2.12

import "../../style"

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

        Text {
            text: "+"
            font.family: "Roboto"
            font.pointSize: spinbox.font.pointSize * 2
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

        Text {
            text: "-"
            font.family: "Roboto"
            font.pointSize: spinbox.font.pointSize * 2
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    contentItem.horizontalAlignment: Qt.AlignHCenter
    contentItem.verticalAlignment: Qt.AlignVCenter

    background.implicitWidth: 120
    background.implicitHeight: AppStyle.defaultHeight
}
