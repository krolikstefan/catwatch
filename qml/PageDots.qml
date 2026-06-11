import QtQuick
import "."

Row {
    spacing: 9

    property int currentIndex: 0

    Repeater {
        model: 4

        Rectangle {
            width: currentIndex === index ? 11 : 9
            height: width
            radius: width / 2
            color: currentIndex === index
                   ? (index === 3 ? "#FF4757" : Theme.ink)
                   : Theme.dotIdle

            Behavior on width {
                SmoothedAnimation { duration: 150 }
            }
        }
    }
}
