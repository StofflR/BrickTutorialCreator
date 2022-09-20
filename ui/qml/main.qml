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
    property string statusText: ""
    function updateStatusMessage(text) {
        statusText = text
    }

    menuBar: MenuBar {
        Menu {
            id: file
            title: qsTr("&File")
            font.family: Font.boldFont ? Font.boldFont : -1
            font.pixelSize: 10

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
                text: qsTr("&Convert Folder (JSON → SVG)")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
                onTriggered: brickConverter.fromJSONtoSVG()
            }
            MenuItem {
                text: qsTr("&Convert Folder (SVG → PNG)")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
                onTriggered: brickConverter.fromSVGtoPNG()
            }
            MenuItem {
                text: qsTr("&Convert Folder (JSON → PNG)")
                font.family: Font.boldFont ? Font.boldFont : -1
                font.pixelSize: 10
                onTriggered: brickConverter.fromJSONtoPNG()
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
    ConverterManager {
        id: brickConverter
        onConverted: count => root.updateStatusMessage(
                         "INFO: Converted " + count + " files!")
    }
    StackLayout {
        width: parent.width
        currentIndex: bar.currentIndex
        anchors.top: bar.bottom
        anchors.bottom: statusbar.top
        Item {
            BrickCreator {
                onUpdateStatusMessage: text => root.updateStatusMessage(text)
            }
        }
        Item {
            Translator {
                id: translator
                onUpdateStatusMessage: text => root.updateStatusMessage(text)
            }
        }
        Item {
            TutorialCreator {
                width: parent.width
                height: parent.height - 20
                onUpdateStatusMessage: text => root.updateStatusMessage(text)
            }
        }
    }
    Rectangle {
        id: statusbar
        anchors.bottom: parent.bottom
        height: 20
        RowLayout {
            anchors.fill: parent
            Label {
                height: statusbar.height
                text: root.statusText
            }
        }
    }
}
