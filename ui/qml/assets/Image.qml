import QtQuick 2.0 as T

T.Image {
    signal update(bool enable)
    sourceSize.width: width
    smooth: true
    fillMode: Image.PreserveAspectFit
}
