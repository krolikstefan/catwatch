import QtQuick
import QtQuick.Layouts
import KotekWatch

RowLayout {
    id: root

    property int count: 0
    property int currentIndex: 0
    property color activeColor: Theme.rudyKotek
    property color inactiveColor: Qt.rgba(1, 1, 1, 0.45)

    spacing: 8

    Repeater {
        model: root.count

        Rectangle {
            required property int index
            width: root.currentIndex === index ? 20 : 9
            height: 9
            radius: 5
            color: root.currentIndex === index ? root.activeColor : root.inactiveColor

            Behavior on width {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }
}
