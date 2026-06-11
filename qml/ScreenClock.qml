import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import "."

WatchBezel {
    id: root

    property int currentIndex: 0
    clip: true

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFF8EF" }
            GradientStop { position: 1.0; color: "#FFE7C8" }
        }
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 0
        width: parent.width
        height: 190
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFF6E8" }
            GradientStop { position: 1.0; color: "#FFD6EC" }
        }
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 188
        width: parent.width
        height: 114
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFE6B8" }
            GradientStop { position: 1.0; color: "#FFC97B" }
        }
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 184
        width: parent.width
        height: 8
        color: Theme.orange
        opacity: 0.18
        z: 0
    }

    Rectangle {
        x: 18
        y: 96
        width: 64
        height: 64
        radius: 22
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#9BE2FF" }
            GradientStop { position: 1.0; color: "#6EC8FF" }
        }
        border.color: Theme.white
        border.width: 4
        z: 1

        Rectangle {
            anchors.centerIn: parent
            width: 4
            height: 48
            radius: 2
            color: Theme.white
        }

        Rectangle {
            anchors.centerIn: parent
            width: 48
            height: 4
            radius: 2
            color: Theme.white
        }
    }

    Rectangle {
        x: 162
        y: 96
        width: 52
        height: 52
        radius: 26
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFF" }
            GradientStop { position: 1.0; color: "#FFEAF4" }
        }
        border.color: Theme.pink
        border.width: 4
        z: 1
    }

    Shape {
        x: 188
        y: 122
        width: 28
        height: 28
        z: 1
        antialiasing: true

        ShapePath {
            strokeColor: Theme.ink
            strokeWidth: 3
            fillColor: "transparent"
            startX: 0
            startY: 0
            PathLine { x: -8; y: -2 }
        }

        ShapePath {
            strokeColor: Theme.ink
            strokeWidth: 3
            fillColor: "transparent"
            startX: 0
            startY: 0
            PathLine { x: 1; y: -12 }
        }
    }

    Repeater {
        model: [
            { x: 176, y: 54, color: Theme.pink, scale: 1.0 },
            { x: 146, y: 70, color: Theme.violet, scale: 0.8 },
            { x: 66, y: 52, color: Theme.mint, scale: 0.9 }
        ]

        Item {
            x: modelData.x
            y: modelData.y
            width: 16
            height: 16
            z: 1
            scale: modelData.scale

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    fillColor: modelData.color
                    strokeWidth: 0
                    startX: 8
                    startY: 0
                    PathLine { x: 10; y: 5 }
                    PathLine { x: 16; y: 6 }
                    PathLine { x: 11; y: 10 }
                    PathLine { x: 12; y: 16 }
                    PathLine { x: 8; y: 12 }
                    PathLine { x: 4; y: 16 }
                    PathLine { x: 5; y: 10 }
                    PathLine { x: 0; y: 6 }
                    PathLine { x: 6; y: 5 }
                    PathLine { x: 8; y: 0 }
                }
            }
        }
    }

    Rectangle {
        x: 53
        y: 217
        width: 132
        height: 24
        radius: 16
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFB1D3" }
            GradientStop { position: 1.0; color: "#FF7EB6" }
        }
        opacity: 0.14
        z: 1
    }

    CatSitting {
        id: cat
        width: 146
        height: 154
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        z: 2
    }

    Item {
        id: contentOverlay
        anchors.fill: parent
        z: 3

        Column {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 26
            spacing: 4

            Text {
                text: watchBackend.timeText
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Theme.fontDisplay
                font.weight: Font.DemiBold
                font.pixelSize: Theme.fontSizeTime
                color: Theme.ink
                renderType: Text.NativeRendering
            }

            Text {
                text: "Pokoj kotka"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Theme.fontDisplay
                font.weight: Font.Medium
                font.pixelSize: Theme.fontSizeLabel
                color: Theme.inkSoft
                renderType: Text.NativeRendering
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 246
            width: 78
            height: 36
            radius: 20
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFF" }
                GradientStop { position: 1.0; color: "#E8F6FF" }
            }
            border.color: Theme.blue
            border.width: 3

            Text {
                anchors.centerIn: parent
                text: watchBackend.weekdayText
                font.family: Theme.fontBody
                font.weight: Font.Bold
                font.pixelSize: Theme.fontSizeBody
                color: Theme.ink
                renderType: Text.NativeRendering
            }
        }

        PageDots {
            currentIndex: root.currentIndex
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        PauseAnimation { duration: 4000 }

        NumberAnimation { target: cat; property: "eyeScaleY"; from: 1; to: 0; duration: 80 }
        NumberAnimation { target: cat; property: "eyeScaleY"; from: 0; to: 1; duration: 80 }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        NumberAnimation { target: cat; property: "tailRotation"; to: 10; duration: 1200; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "tailRotation"; to: -10; duration: 1200; easing.type: Easing.InOutSine }
    }
}
