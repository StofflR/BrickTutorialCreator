pragma Singleton

import QtQuick

QtObject {
    property double defaultHeight: 40
    property double propertyHeight: 30
    property double defaultWidth: 200
    property double spacing: 10
    property double pointsizeSpacing: spacing

    property double iconSize: 24
    property double iconSizeLarge: 48

    property double borderRadius: 4

    property var color: SystemPalette {
        id: myPalette
        colorGroup: SystemPalette.Active
    }

    property var icons: QtObject {
        id: icons
        property string add_black_24dp: "qrc:/app/resources/add_black_24dp.svg"
        property string add_brick: "qrc:/app/resources/add_brick.svg"
        property string add_circle_black_24dp: "qrc:/app/resources/add_circle_black_24dp.svg"
        property string add_circle_outline_black_24dp: "qrc:/app/resources/add_circle_outline_black_24dp.svg"
        property string arrow_back_ios_black_24dp: "qrc:/app/resources/arrow_back_ios_black_24dp.svg"
        property string arrow_forward_ios_black_24dp: "qrc:/app/resources/arrow_forward_ios_black_24dp.svg"
        property string base_0h_collapsed: "qrc:/app/resources/base_0h_collapsed.svg"
        property string base_1h_control: "qrc:/app/resources/base_1h_control.svg"
        property string base_1h: "qrc:/app/resources/base_1h.svg"
        property string base_2h_control: "qrc:/app/resources/base_2h_control.svg"
        property string base_2h: "qrc:/app/resources/base_2h.svg"
        property string base_3h: "qrc:/app/resources/base_3h.svg"
        property string basic_brick_generator: "qrc:/app/resources/resources/basic_brick_generator.py"
        property string build_black_24dp: "qrc:/app/resources/build_black_24dp.svg"
        property string cancel_black_24dp: "qrc:/app/resources/cancel_black_24dp.svg"
        property string ccbysa: "qrc:/app/resources/ccbysa.svg"
        property string check_circle_black_24dp: "qrc:/app/resources/check_circle_black_24dp.svg"
        property string close_black_24dp: "qrc:/app/resources/close_black_24dp.svg"
        property string create_black_24dp: "qrc:/app/resources/create_black_24dp.svg"
        property string delete_black_24dp: "qrc:/app/resources/delete_black_24dp.svg"
        property string disabled_by_default_black_24dp: "qrc:/app/resources/disabled_by_default_black_24dp.svg"
        property string done_black_24dp: "qrc:/app/resources/done_black_24dp.svg"
        property string download: "qrc:/app/resources/download.svg"
        property string file_open_black_24dp: "qrc:/app/resources/file_open_black_24dp.svg"
        property string folder_open_black_24dp: "qrc:/app/resources/folder_open_black_24dp.svg"
        property string help_outline_black_24dp: "qrc:/app/resources/help_outline_black_24dp.svg"
        property string icon_ico: "qrc:/app/resources/icon.ico"
        property string icon_png: "qrc:/app/resources/icon.png"
        property string icon_svg: "qrc:/app/resources/icon.svg"
        property string image_black: "qrc:/app/resources/image_black.svg"
        property string more_vert_black_24dp: "qrc:/app/resources/more_vert_black_24dp.svg"
        property string refresh_black_24dp: "qrc:/app/resources/refresh_black_24dp.svg"
        property string remove_black_24dp: "qrc:/app/resources/remove_black_24dp.svg"
        property string remove_circle_black_24dp: "qrc:/app/resources/remove_circle_black_24dp.svg"
        property string remove_circle_outline_black_24dp: "qrc:/app/resources/remove_circle_outline_black_24dp.svg"
        property string reply_black_24dp: "qrc:/app/resources/reply_black_24dp.svg"
        property string restore_black_24dp: "qrc:/app/resources/restore_black_24dp.svg"
        property string save_black_24dp: "qrc:/app/resources/save_black_24dp.svg"
        property string settings_black_24dp: "qrc:/app/resources/settings_black_24dp.svg"
        property string splitscreen: "qrc:/app/resources/splitscreen.svg"
        property string text_snippet_black_24dp: "qrc:/app/resources/text_snippet_black_24dp.svg"
        property string upload: "qrc:/app/resources/upload.svg"
        property string color_palette_24dp: "qrc:/app/resources/palette_24dp.svg"
    }

    property var sideMenu: QtObject {
        id: sideMenu
        property double collapsedWidth: 50
        property double expandedWidth: 200
    }

    property var statusbar: QtObject {
        id: statusbar
        property int duration: 5000
    }
}
