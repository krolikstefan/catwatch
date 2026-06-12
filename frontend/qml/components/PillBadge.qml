import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import KotekWatch

Rectangle {
    id: root

    property url iconSource
    property color accentColor: Theme.blekit
    property color textColor: Theme.granat
    property string text: ""
    property real iconSize: 22

    radius: height / 2
    color: Qt.rgba(1, 1, 1, 0.82)
    border.color: Qt.lighter(accentColor, 1.25)
    border.width: 2
    implicitWidth: content.implicitWidth + 26
    implicitHeight: 56

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 34
            Layout.preferredHeight: 34
            radius: 17
            color: accentColor

            Image {
                anchors.centerIn: parent
                width: root.iconSize
                height: root.iconSize
                source: root.iconSource
                fillMode: Image.PreserveAspectFit
            }
        }

        Text {
            text: root.text
            color: root.textColor
            font.family: Theme.bodyFont
            font.pixelSize: 20
            font.weight: Font.DemiBold
        }
    }
}
