pragma Singleton

import QtQuick 2.15

Item {
    property double defaultHeight: 40
    property double defaultWidth: 200
    property double spacing: 10
    property alias color: myPalette
    SystemPalette {
        id: myPalette
        colorGroup: SystemPalette.Active
    }
}
