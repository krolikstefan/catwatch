import QtQuick
import QtQuick.Controls
import KotekWatch

Button {
    id: control

    implicitHeight: 52
    implicitWidth: Math.max(152, contentItem.implicitWidth + 34)

    background: Rectangle {
        radius: height / 2
        color: Qt.rgba(1, 1, 1, 0.9)
        border.color: Theme.blekit
        border.width: 2
    }

    contentItem: Text {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Theme.blekit
        font.family: Theme.bodyFont
        font.pixelSize: 18
        font.weight: Font.Bold
    }
}
