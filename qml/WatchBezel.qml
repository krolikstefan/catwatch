import QtQuick
import "."

Item {
    id: root
    width: 240
    height: 300

    default property alias contentData: viewport.data

    Rectangle {
        id: viewport
        anchors.fill: parent
        color: "transparent"
        clip: true
    }
}
