pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import app

ListView {
    id: settingsList

    clip: true
    snapMode: ListView.SnapToItem
    boundsBehavior: Flickable.StopAtBounds
    ScrollIndicator.vertical: ScrollIndicator {}

    delegate: Loader {
        id: settingsDelegate
        required property int index

        required property var model

        required property string settingName
        required property string settingValue
        required property string settingType
        required property bool enabled

        active: enabled

        width: ListView.view.width
        height: AppStyle.propertyHeight
        source: {
            if (settingsDelegate.settingType == SettingsModel.Boolean) {
                return "SettingsCheckBox.qml";
            } else if (settingsDelegate.settingType == SettingsModel.Integer) {
                return "SettingsSpinBox.qml";
            } else if (settingsDelegate.settingType == SettingsModel.String) {
                return "SettingsTextField.qml";
            } else if (settingsDelegate.settingType == SettingsModel.FolderDialog) {
                return "SettingsFolderDialog.qml";
            } else if (settingsDelegate.settingType == SettingsModel.FileDialog) {
                return "SettingsFileDialog.qml";
            }
        }
        onLoaded: {
            if (settingsDelegate.status != Loader.Ready)
                return;
            settingsDelegate.item.value = model.settingValue;
            model.settingValue = Qt.binding(function () {
                return settingsDelegate.item.value;
            });
        }
    }
}
