import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root
    width: parent.width
    height: parent.height
    property var model: brickStack
    signal clicked(int target)
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
                onClicked: {
                    model = brickStack
                    root.clicked(0)
                }
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Button {
                text: "Translator"
                onClicked: {
                    model = translatorStack
                    root.clicked(0)
                }
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Button {
                text: "TutorialCreator"
                onClicked: {
                    model = tutorialStack
                    root.clicked(0)
                }
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
        ListElement {
            source: "../dialogs/help/translator/TranslatorSource.qml"
        }
        ListElement {
            source: "../dialogs/help/translator/TranslatorViewSettings.qml"
        }
        ListElement {
            source: "../dialogs/help/translator/TranslatorSettings.qml"
        }
        ListElement {
            source: "../dialogs/help/translator/TranslatorView.qml"
        }
    }
    ListModel {
        id: tutorialStack
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelp.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpAvailableBrick.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpBrickFilter.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpBricks.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpControls.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpName.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpPaths.qml"
        }
        ListElement {
            source: "../dialogs/help/tutorial/TutorialHelpTutorial.qml"
        }
    }
}
