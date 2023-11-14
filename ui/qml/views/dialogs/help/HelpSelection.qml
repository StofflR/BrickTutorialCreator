import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    width: parent.width
    height: 100
    color: "red"
    property var model: brickStack
    RowLayout {
        Button {
            text: "BrickCreator"
            onClicked: model = brickStack
        }

        Button {
            text: "Translator"
            onClicked: model = translatorStack
        }

        Button {
            text: "TutorialCreator"
            onClicked: model = tutorialStack
        }
    }
    ListModel {
        id: brickStack
        ListElement {
            source: "../dialogs/help/brick/BrickHelp.qml"
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
