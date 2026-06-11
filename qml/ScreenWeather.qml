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
            GradientStop { position: 0.0; color: "#F6FCFF" }
            GradientStop { position: 1.0; color: "#DAF1FF" }
        }
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 0
        width: parent.width
        height: 220
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#9BE0FF" }
            GradientStop { position: 1.0; color: "#CBBEFF" }
        }
        opacity: 0.26
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 246
        width: parent.width
        height: 54
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#CFFCDC" }
            GradientStop { position: 1.0; color: "#8DF0AF" }
        }
        radius: 28
        z: 0
    }

    Repeater {
        model: [
            { x: 20, y: 84, w: 40, h: 20 },
            { x: 154, y: 74, w: 46, h: 22 },
            { x: 44, y: 118, w: 52, h: 24 }
        ]

        Item {
            x: modelData.x
            y: modelData.y
            width: modelData.w
            height: modelData.h
            z: 1

            Rectangle { x: 0; y: 8; width: parent.width * 0.52; height: 12; radius: 8; color: Theme.white }
            Rectangle { x: parent.width * 0.22; y: 0; width: parent.width * 0.38; height: 16; radius: 10; color: Theme.white }
            Rectangle { x: parent.width * 0.46; y: 6; width: parent.width * 0.54; height: 14; radius: 9; color: Theme.white }
        }
    }

    Item {
        id: sun
        anchors.horizontalCenter: parent.horizontalCenter
        y: 86
        width: 68
        height: 68
        z: 1

        Shape {
            anchors.fill: parent
            antialiasing: true

            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 34; y: 4 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 55; y: 13 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 64; y: 34 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 55; y: 55 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 34; y: 64 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 13; y: 55 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 4; y: 34 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 5; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 34; startY: 34; PathLine { x: 13; y: 13 } }

            ShapePath {
                fillColor: Theme.sun
                strokeWidth: 0
                startX: 34
                startY: 12
                PathQuad { x: 56; y: 34; controlX: 56; controlY: 12 }
                PathQuad { x: 34; y: 56; controlX: 56; controlY: 56 }
                PathQuad { x: 12; y: 34; controlX: 12; controlY: 56 }
                PathQuad { x: 34; y: 12; controlX: 12; controlY: 12 }
            }
        }

        Rectangle {
            x: 24
            y: 24
            width: 6
            height: 6
            radius: 3
            color: Theme.ink
        }

        Rectangle {
            x: 38
            y: 24
            width: 6
            height: 6
            radius: 3
            color: Theme.ink
        }

        Shape {
            x: 21
            y: 34
            width: 26
            height: 16
            antialiasing: true

            ShapePath {
                strokeColor: Theme.ink
                strokeWidth: 2.2
                fillColor: "transparent"
                startX: 2
                startY: 4
                PathQuad { x: 24; y: 4; controlX: 13; controlY: 12 }
            }
        }

        RotationAnimator on rotation {
            running: !Application.styleHints.reducedMotion
            from: 0
            to: 360
            duration: 10000
            loops: Animation.Infinite
        }
    }

    Repeater {
        model: [
            { x: 28, y: 184, color: Theme.violet },
            { x: 186, y: 176, color: Theme.pink }
        ]

        Item {
            x: modelData.x
            y: modelData.y
            width: 14
            height: 14
            z: 1

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    fillColor: modelData.color
                    strokeWidth: 0
                    startX: 7
                    startY: 13
                    PathCubic { control1X: -1; control1Y: 8; control2X: 1; control2Y: 0; x: 7; y: 4 }
                    PathCubic { control1X: 13; control1Y: 0; control2X: 15; control2Y: 8; x: 7; y: 13 }
                }
            }
        }
    }

    CatSitting {
        id: cat
        width: 144
        height: 152
        lookUp: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        z: 2
    }

    Item {
        anchors.fill: parent
        z: 3

        Column {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 24
            spacing: 2

            Text {
                text: watchBackend.temperatureText
                font.family: Theme.fontDisplay
                font.weight: Font.DemiBold
                font.pixelSize: Theme.fontSizeTemp
                color: Theme.ink
                renderType: Text.NativeRendering
            }

            Text {
                text: "Niebo i slonce"
                font.family: Theme.fontDisplay
                font.weight: Font.Medium
                font.pixelSize: Theme.fontSizeWeather
                color: Theme.inkSoft
                renderType: Text.NativeRendering
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 226
            width: 116
            height: 28
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFF" }
                GradientStop { position: 1.0; color: "#EAF8FF" }
            }
            border.color: Theme.blue
            border.width: 3

            Text {
                anchors.centerIn: parent
                text: watchBackend.weatherText
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

        NumberAnimation { target: sun; property: "scale"; from: 1; to: 1.08; duration: 1000; easing.type: Easing.InOutSine }
        NumberAnimation { target: sun; property: "scale"; from: 1.08; to: 1; duration: 1000; easing.type: Easing.InOutSine }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        NumberAnimation { target: cat; property: "leftEarRotation"; to: 3; duration: 900; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "leftEarRotation"; to: -3; duration: 900; easing.type: Easing.InOutSine }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        NumberAnimation { target: cat; property: "rightEarRotation"; to: -3; duration: 900; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "rightEarRotation"; to: 3; duration: 900; easing.type: Easing.InOutSine }
    }
}
