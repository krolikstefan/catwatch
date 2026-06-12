import QtQuick
import QtQuick.Controls
import KotekWatch

Button {
    id: control

    implicitHeight: 52
    implicitWidth: Math.max(152, contentItem.implicitWidth + 34)

    background: Rectangle {
        radius: height / 2
        color: Theme.blekit
        border.color: Qt.lighter(Theme.blekit, 1.15)
        border.width: 2
    }

    contentItem: Text {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Theme.bialy
        font.family: Theme.bodyFont
        font.pixelSize: 18
        font.weight: Font.Bold
    }
}
