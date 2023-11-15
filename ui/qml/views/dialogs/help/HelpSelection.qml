import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Item {
    width: parent.width
    height: parent.height
    property var model: brickStack
    ColumnLayout {
        anchors.fill: parent
        Label {
            text: "Help selection:"
            Layout.fillWidth: true
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Button {
                text: "BrickCreator"
                onClicked: model = brickStack
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Button {
                text: "Translator"
                onClicked: model = translatorStack
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Button {
                text: "TutorialCreator"
                onClicked: model = tutorialStack
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
    ListModel {
        id: brickStack
        ListElement {
            source: "../dialogs/help/brick/BrickHelp.qml"
        }
        ListElement {
            source: "../dialogs/help/brick/BrickHelpName.qml"
        }
        ListElement {
            source: "../dialogs/help/brick/BrickHelpSave.qml"
        }
        ListElement {
            source: "../dialogs/help/brick/BrickHelpColor.qml"
        }
        ListElement {
            source: "../dialogs/help/brick/BrickHelpBrick.qml"
        }
    }
    ListModel {
        id: translatorStack
        ListElement {
            source: "../dialogs/help/translator/TranslatorHelp.qml"
        }
    }
    ListModel {
        id: tutorialStack
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelp.qml"
        }
    }
}
