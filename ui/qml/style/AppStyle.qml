pragma Singleton

import QtQuick 2.15

Item {
    property double defaultHeight: 40
    property double defaultWidth: 200
    property double spacing: 10
    property alias color: myPalette
    property double pointsizeSpacing: spacing

    property string blue: "408ac5"
    property string blue_shade: "27567c"

    property string cyan: "26a6ae"
    property string cyan_shade: "2e7078"

    property string dark_blue: "395cab"
    property string dark_blue_shade: "395cab"

    property string gold: "95750c"
    property string gold_shade: "57452c"

    property string dark_green: "305716"
    property string dark_green_shade: "173718"

    property string green: "6b9c49"
    property string green_shade: "486822"

    property string light_orange: "f99761"
    property string light_orange_shade: "a86d45"

    property string olive: "aea626"
    property string olive_shade: "7e7a30"

    property string orange: "cf5717"
    property string orange_shade: "7a3a18"

    property string yellow: "fccb41"
    property string yellow_shade: "aa8832"

    property string violet: "8f4cba"
    property string violet_shade: "5d2d7c"

    property string pink: "cf7aa6"
    property string pink_shade: "935e7b"

    property string red: "f24e50"
    property string red_shade: "ae2f2f"

    property string white: "95750c"
    property string white_shade: "57452c"
    property string white_border: "274383"

    property string default_border: "383838"

    SystemPalette {
        id: myPalette
        colorGroup: SystemPalette.Active
    }
}
