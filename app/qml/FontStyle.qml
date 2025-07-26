pragma Singleton

import QtQuick

QtObject {
    property var bold: FontLoader {
        id: bold
        source: "qrc:/app/resources/Roboto-Bold.ttf"
    }
    property var light: FontLoader {
        id: light
        source: "qrc:/app/resources/Roboto-Light.ttf"
    }
}
