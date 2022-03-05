import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import "assets"
import "font"
import "views"

ApplicationWindow {
    id: root
    width: 960
    height: 640
    minimumWidth: 500
    minimumHeight: 500
    visible: true
    title: qsTr("Brick Creator")
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pixelSize: 10
    menuBar: MenuBar {
        Menu {
            id: file
            title: qsTr("&File")
            font.family: Font.boldFont ? Font.boldFont : -1
            font.pixelSize: 10
            MenuItem {
                text: qsTr("&Load from JSON / SVG")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
            }
            MenuItem {
                text: qsTr("&Save")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
            }

            MenuItem {
                text: qsTr("&Help")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
            }

            MenuItem {
                text: qsTr("&About")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("&Convert Folder")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
            }
        }
    }
    TabBar {
        id: bar
        width: parent.width
        height: 30
        TabButton {
            height: parent.height
            anchors.top: parent.top
            text: qsTr("Bricks")
            onReleased: {
                root.width = 960
                root.height = 640
            }
        }
        TabButton {
            height: parent.height
            anchors.top: parent.top
            text: qsTr("Translate")
            onReleased: {
                translator.update()
                root.width = 960
                root.height = 640
            }
        }
        TabButton {
            height: parent.height
            anchors.top: parent.top
            text: qsTr("Tutorials")
            onReleased: {
                root.width = root.minimumWidth
            }
        }
    }

    StackLayout {
        width: parent.width
        currentIndex: bar.currentIndex
        anchors.top: bar.bottom
        anchors.bottom: parent.bottom
        Item {
            BrickCreator {}
        }
        Item {
            Translator {
                id: translator
            }
        }
        Item {
            TutorialCreator {
                width: parent.width
                height: parent.height - 20
            }
        }
    }
}
