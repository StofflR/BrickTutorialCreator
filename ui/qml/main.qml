import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtWebEngine 1.10

import "assets"
import "font"
import "views"
import "style"

ApplicationWindow {
    id: root
    width: 960
    height: 640
    minimumWidth: 500
    minimumHeight: 500
    visible: true
    title: qsTr("Brick Creator")
    font.family: Font.boldFont ? Font.boldFont : -1
    font.pointSize: AppStyle.spacing * 8 / 6
    property string statusText: ""
    function updateStatusMessage(text) {
        statusText = text
    }

    menuBar: MenuBar {

        Menu {
            id: file
            title: qsTr("File")
            font.family: Font.boldFont ? Font.boldFont : -1
            font.pointSize: AppStyle.spacing * 4 / 6

            MenuItem {
                onTriggered: help.open()
                contentItem: Text {
                    text: qsTr("Help")
                    font.family: Font.boldFont ? Font.boldFont : -1
                    font.pointSize: AppStyle.spacing * 4 / 6
                    color: AppStyle.color.text
                }
                background: Rectangle {
                    color: parent.highlighted ? AppStyle.color.light : AppStyle.color.window
                }
            }

            MenuItem {
                contentItem: Text {
                    text: qsTr("About")
                    font.family: Font.boldFont ? Font.boldFont : -1
                    font.pointSize: AppStyle.spacing * 4 / 6
                    color: AppStyle.color.text
                }
                onTriggered: about.open()
                background: Rectangle {
                    color: parent.highlighted ? AppStyle.color.light : AppStyle.color.window
                }
            }
            MenuSeparator {}
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (JSON → SVG)")
                    font.family: Font.boldFont ? Font.boldFont : -1
                    font.pointSize: AppStyle.spacing * 4 / 6
                    color: AppStyle.color.text
                }
                onTriggered: brickConverter.fromJSONtoSVG()
                background: Rectangle {
                    color: parent.highlighted ? AppStyle.color.light : AppStyle.color.window
                }
            }
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (SVG → PNG)")
                    font.family: Font.boldFont ? Font.boldFont : -1
                    font.pointSize: AppStyle.spacing * 4 / 6
                    color: AppStyle.color.text
                }
                onTriggered: brickConverter.fromSVGtoPNG()
                background: Rectangle {
                    color: parent.highlighted ? AppStyle.color.light : AppStyle.color.window
                }
            }
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (JSON → PNG)")
                    font.family: Font.boldFont ? Font.boldFont : -1
                    font.pointSize: AppStyle.spacing * 4 / 6
                    color: AppStyle.color.text
                }
                onTriggered: brickConverter.fromJSONtoPNG()
                background: Rectangle {
                    color: parent.highlighted ? AppStyle.color.light : AppStyle.color.window
                }
            }
            MenuSeparator {}
            MenuItem {
                contentItem: Text {
                    text: qsTr("Update existing bricks")
                    font.family: Font.boldFont ? Font.boldFont : -1
                    font.pointSize: AppStyle.spacing * 4 / 6
                    color: AppStyle.color.text
                }
                onTriggered: brickConverter.updateExisting()
                background: Rectangle {
                    color: parent.highlighted ? AppStyle.color.light : AppStyle.color.window
                }
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
        }
        TabButton {
            height: parent.height
            anchors.top: parent.top
            text: qsTr("Translate")
        }
        TabButton {
            height: parent.height
            anchors.top: parent.top
            text: qsTr("Tutorials")
        }
    }
    ConverterManager {
        id: brickConverter
        anchors.centerIn: layout
        onConverted: count => root.updateStatusMessage(
                         "INFO: Converted " + count + " files!")
    }
    StackLayout {
        id: layout
        width: parent.width
        currentIndex: bar.currentIndex
        anchors.top: bar.bottom
        anchors.bottom: statusbar.top
        onCurrentIndexChanged: translator.update()
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
        width: parent.width
        color: AppStyle.color.window
        RowLayout {
            anchors.fill: parent
            Label {
                height: statusbar.height
                text: root.statusText
                color: AppStyle.color.text
            }
        }
    }

    Popup {
        id: about
        x: 100
        y: 100
        width: root.width - 200
        height: root.height - 200
        modal: true
        focus: true
        contentItem: Rectangle {
            anchors.fill: parent
            WebEngineView {
                anchors.fill: parent
                url: "qrc:/about.html"
            }
        }
    }
    Popup {
        id: help
        x: 100
        y: 100
        width: root.width - 200
        height: root.height - 200
        modal: true
        focus: true
        contentItem: Rectangle {
            anchors.fill: parent
            WebEngineView {
                anchors.fill: parent
                url: "qrc:/help.html"
            }
        }
    }
}
