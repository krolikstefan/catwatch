import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import KotekWatch

Rectangle {
    id: root

    property int currentIndex: 0
    property var items: []
    signal itemSelected(int index)

    radius: 28
    color: Qt.rgba(1, 1, 1, 0.92)
    border.color: Theme.granica
    border.width: 2
    implicitHeight: 70

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Repeater {
            model: root.items

            delegate: ItemDelegate {
                required property int index
                required property var modelData

                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    radius: 22
                    color: root.currentIndex === index ? Qt.rgba(168 / 255, 216 / 255, 1, 0.22) : "transparent"
                }
                onClicked: root.itemSelected(index)

                contentItem: Column {
                    spacing: 3
                    anchors.centerIn: parent

                    IconCircle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 38
                        height: 38
                        iconSource: modelData.icon
                        fillColor: root.currentIndex === index ? modelData.color : Qt.rgba(0.96, 0.96, 0.98, 1)
                        iconSize: 20
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.label
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 12
                        font.weight: root.currentIndex === index ? Font.Bold : Font.DemiBold
                    }
                }
            }
        }
    }
}
