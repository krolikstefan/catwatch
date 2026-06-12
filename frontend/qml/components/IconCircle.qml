import QtQuick
import KotekWatch

Rectangle {
    id: root

    property url iconSource
    property color fillColor: Theme.zoltySloneczny
    property real iconSize: 30

    implicitWidth: 62
    implicitHeight: 62
    radius: width / 2
    color: fillColor
    border.color: Qt.rgba(1, 1, 1, 0.65)
    border.width: 2

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: root.iconSource
        fillMode: Image.PreserveAspectFit
    }
}
