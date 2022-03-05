import QtQuick 2.0

Item {
    property var boldFont: bold.font.name
    property var lightFont: bold.light.name
    FontLoader {
        id: bold
        source: "Roboto-Bold.ttf"
    }
    FontLoader {
        id: light
        source: "Roboto-Light.ttf"
    }
}
