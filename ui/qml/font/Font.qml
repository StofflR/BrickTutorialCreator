import QtQuick 2.0

Item {
    property var boldFont: bold.font.name
    property var lightFont: light.font.name
    property var laoded: bold.status == FontLoader.Ready && light.status == FontLoader.Ready
    FontLoader {
        id: bold
        source: "Roboto-Bold.ttf"
    }
    FontLoader {
        id: light
        source: "Roboto-Light.ttf"
    }
}
