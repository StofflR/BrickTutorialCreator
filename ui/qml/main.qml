import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import "assets"
import "font"
import "views"
import "views/interface"
import "style"
import "views/dialogs"

ApplicationWindow {
    id: root
    width: 960
    height: 640
    minimumWidth: 600
    minimumHeight: Math.max(
                       500,
                       brickCreator.minimumHeight + menuBar.height + statusbar.height)
    visible: true
    title: qsTr("Brick Creator")
    font.family: "Roboto"
    font.pointSize: AppStyle.pointsizeSpacing
    property string statusText: ""
    function updateStatusMessage(text) {
        statusText = text
    }

    menuBar: MenuBar {
        Menu {
            id: file
            title: qsTr("File")
            font.family: "Roboto"
            font.pointSize: AppStyle.pointsizeSpacing

            MenuItem {
                onTriggered: help.open()
                contentItem: Text {
                    text: qsTr("Help")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
            }

            MenuItem {
                contentItem: Text {
                    text: qsTr("About")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
                onTriggered: about.open()
            }

            MenuSeparator {}
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (JSON → SVG)")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
                onTriggered: brickConverter.fromJSONtoSVG()
            }
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (SVG → PNG)")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
                onTriggered: brickConverter.fromSVGtoPNG()
            }
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (JSON → PNG)")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
                onTriggered: brickConverter.fromJSONtoPNG()
            }
            MenuItem {
                contentItem: Text {
                    text: qsTr("Convert Folder (Tutorial → PNG)")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
                onTriggered: brickConverter.fromTutorialtoPNG()
            }
            MenuSeparator {}
            MenuItem {
                contentItem: Text {
                    text: qsTr("Update existing bricks")
                    font.family: "Roboto"
                    font.pointSize: AppStyle.pointsizeSpacing
                }
                onTriggered: brickConverter.updateExisting()
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
        onConverted: value => root.updateStatusMessage(
                         "INFO: Converted " + value)
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
                id: brickCreator
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
                id: creator
                onUpdateStatusMessage: text => root.updateStatusMessage(text)
            }
        }
    }
    Rectangle {
        id: statusbar
        anchors.bottom: parent.bottom
        height: 20
        width: parent.width
        color: palette.window

        RowLayout {
            anchors.fill: parent
            Label {
                height: statusbar.height
                text: root.statusText
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
        }
    }
    HelpPopup {
        id: help
    }
}
