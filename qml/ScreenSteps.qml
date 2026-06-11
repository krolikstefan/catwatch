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
            GradientStop { position: 0.0; color: "#F3FDFF" }
            GradientStop { position: 1.0; color: "#D7FAFF" }
        }
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 0
        width: parent.width
        height: 196
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#A3E6FF" }
            GradientStop { position: 1.0; color: "#71CCFF" }
        }
        opacity: 0.34
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 198
        width: parent.width
        height: 102
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#C8FFD6" }
            GradientStop { position: 1.0; color: "#89F0AC" }
        }
        radius: 28
        z: 0
    }

    Rectangle {
        x: 0
        y: 224
        width: parent.width
        height: 76
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#9EF089" }
            GradientStop { position: 1.0; color: "#6BDB5A" }
        }
        radius: 28
        z: 0
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 48
        width: 42
        height: 42
        z: 1

        Shape {
            anchors.fill: parent
            antialiasing: true

            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 21; y: -2 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 37; y: 5 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 44; y: 21 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 37; y: 37 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 21; y: 44 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 5; y: 37 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: -2; y: 21 } }
            ShapePath { strokeColor: Theme.sunRay; strokeWidth: 4; capStyle: ShapePath.RoundCap; fillColor: "transparent"; startX: 21; startY: 21; PathLine { x: 5; y: 5 } }

            ShapePath {
                fillColor: Theme.sun
                strokeWidth: 0
                startX: 21
                startY: 0
                PathQuad { x: 42; y: 21; controlX: 42; controlY: 0 }
                PathQuad { x: 21; y: 42; controlX: 42; controlY: 42 }
                PathQuad { x: 0; y: 21; controlX: 0; controlY: 42 }
                PathQuad { x: 21; y: 0; controlX: 0; controlY: 0 }
            }
        }

        RotationAnimator on rotation {
            running: !Application.styleHints.reducedMotion
            from: 0
            to: 360
            duration: 8000
            loops: Animation.Infinite
        }
    }

    Item {
        x: 16
        y: 86
        width: 58
        height: 30
        z: 1

            Rectangle { x: 0; y: 12; width: 28; height: 16; radius: 8; color: Theme.white }
            Rectangle { x: 14; y: 4; width: 22; height: 18; radius: 10; color: Theme.white }
            Rectangle { x: 28; y: 10; width: 30; height: 16; radius: 8; color: Theme.white }
    }

    Shape {
        x: 0
        y: 214
        width: 204
        height: 26
        z: 1
        antialiasing: true

        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 0; startY: 26; PathQuad { x: 8; y: 4; controlX: 5; controlY: 15 } PathQuad { x: 16; y: 26; controlX: 12; controlY: 15 } PathQuad { x: 24; y: 7; controlX: 20; controlY: 17 } PathQuad { x: 30; y: 26; controlX: 26; controlY: 15 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 24; startY: 26; PathQuad { x: 32; y: 3; controlX: 28; controlY: 14 } PathQuad { x: 40; y: 26; controlX: 36; controlY: 15 } PathQuad { x: 48; y: 6; controlX: 44; controlY: 17 } PathQuad { x: 54; y: 26; controlX: 50; controlY: 15 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 48; startY: 26; PathQuad { x: 56; y: 5; controlX: 52; controlY: 15 } PathQuad { x: 64; y: 26; controlX: 60; controlY: 16 } PathQuad { x: 72; y: 8; controlX: 68; controlY: 18 } PathQuad { x: 78; y: 26; controlX: 74; controlY: 16 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 72; startY: 26; PathQuad { x: 80; y: 4; controlX: 76; controlY: 15 } PathQuad { x: 88; y: 26; controlX: 84; controlY: 15 } PathQuad { x: 96; y: 7; controlX: 92; controlY: 18 } PathQuad { x: 102; y: 26; controlX: 98; controlY: 15 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 96; startY: 26; PathQuad { x: 104; y: 3; controlX: 100; controlY: 15 } PathQuad { x: 112; y: 26; controlX: 108; controlY: 15 } PathQuad { x: 120; y: 6; controlX: 116; controlY: 18 } PathQuad { x: 126; y: 26; controlX: 122; controlY: 15 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 120; startY: 26; PathQuad { x: 128; y: 5; controlX: 124; controlY: 15 } PathQuad { x: 136; y: 26; controlX: 132; controlY: 16 } PathQuad { x: 144; y: 7; controlX: 140; controlY: 18 } PathQuad { x: 150; y: 26; controlX: 146; controlY: 15 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 144; startY: 26; PathQuad { x: 152; y: 4; controlX: 148; controlY: 15 } PathQuad { x: 160; y: 26; controlX: 156; controlY: 15 } PathQuad { x: 168; y: 8; controlX: 164; controlY: 18 } PathQuad { x: 174; y: 26; controlX: 170; controlY: 15 } }
        ShapePath { fillColor: Theme.grassDark; strokeWidth: 0; startX: 168; startY: 26; PathQuad { x: 176; y: 3; controlX: 172; controlY: 14 } PathQuad { x: 184; y: 26; controlX: 180; controlY: 15 } PathQuad { x: 192; y: 6; controlX: 188; controlY: 18 } PathQuad { x: 198; y: 26; controlX: 194; controlY: 15 } }
    }

    Repeater {
        model: [
            { x: 24, y: 250, color: Theme.orange },
            { x: 180, y: 254, color: Theme.pink },
            { x: 52, y: 236, color: Theme.violet },
            { x: 162, y: 236, color: Theme.orange }
        ]

        Item {
            x: modelData.x
            y: modelData.y
            width: 12
            height: 12
            z: 1

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    fillColor: modelData.color
                    strokeWidth: 0
                    startX: 6
                    startY: 0
                    PathLine { x: 7.5; y: 3.5 }
                    PathLine { x: 12; y: 4.5 }
                    PathLine { x: 8.5; y: 7.5 }
                    PathLine { x: 9; y: 12 }
                    PathLine { x: 6; y: 9.3 }
                    PathLine { x: 3; y: 12 }
                    PathLine { x: 3.5; y: 7.5 }
                    PathLine { x: 0; y: 4.5 }
                    PathLine { x: 4.5; y: 3.5 }
                    PathLine { x: 6; y: 0 }
                }
            }
        }
    }

    CatWalking {
        id: cat
        width: 148
        height: 108
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 38
        z: 2
    }

    Item {
        anchors.fill: parent
        z: 3

        Column {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 24
            spacing: 3

            Text {
                text: watchBackend.stepCount
                font.family: Theme.fontDisplay
                font.weight: Font.DemiBold
                font.pixelSize: Theme.fontSizeMetric
                color: Theme.ink
                renderType: Text.NativeRendering
            }

            Text {
                text: "Parkowa przygoda"
                font.family: Theme.fontDisplay
                font.weight: Font.Medium
                font.pixelSize: Theme.fontSizeLabel
                color: Theme.inkSoft
                renderType: Text.NativeRendering
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 110
            width: 96
            height: 26
            radius: 15
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFDF8" }
                GradientStop { position: 1.0; color: "#EFFFF4" }
            }
            border.color: Theme.orange
            border.width: 3

            Text {
                anchors.centerIn: parent
                text: watchBackend.stepGoalText
                font.family: Theme.fontBody
                font.weight: Font.Bold
                font.pixelSize: Theme.fontSizeSub
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

        NumberAnimation { target: cat; property: "bodyOffsetY"; from: -4; to: 0; duration: 500; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "bodyOffsetY"; from: 0; to: -4; duration: 500; easing.type: Easing.InOutSine }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        NumberAnimation { target: cat; property: "frontLegRotation"; to: 12; duration: 400; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "frontLegRotation"; to: -12; duration: 400; easing.type: Easing.InOutSine }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        NumberAnimation { target: cat; property: "backLegRotation"; to: -12; duration: 400; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "backLegRotation"; to: 12; duration: 400; easing.type: Easing.InOutSine }
    }

    SequentialAnimation {
        running: !Application.styleHints.reducedMotion
        loops: Animation.Infinite

        NumberAnimation { target: cat; property: "tailRotation"; to: 10; duration: 1200; easing.type: Easing.InOutSine }
        NumberAnimation { target: cat; property: "tailRotation"; to: -10; duration: 1200; easing.type: Easing.InOutSine }
    }
}
