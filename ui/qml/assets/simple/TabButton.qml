import QtQuick 2.15
import QtQuick.Controls 2.15 as T

import "../../style"

T.TabButton {
    id: creator
    text: qsTr("Creator")
    font.family: "Roboto"
    font.pixelSize: AppStyle.spacing
    contentItem.horizontalAlignment: Text.AlignHCenter
    contentItem.verticalAlignment: Text.AlignVCenter
}
