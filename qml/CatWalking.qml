import QtQuick
import QtQuick.Shapes
import "."

Item {
    id: root
    width: 162
    height: 118

    property real bodyOffsetY: 0.0
    property real frontLegRotation: 0.0
    property real backLegRotation: 0.0
    property real tailRotation: 0.0

    readonly property real sx: width / 220
    readonly property real sy: height / 160
    readonly property color bodyColor: "#E8943A"
    readonly property color bellyColor: "#F7E8CC"

    Item {
        anchors.fill: parent
        scale: Math.min(root.sx, root.sy)
        transformOrigin: Item.TopLeft

        Item {
            width: 220
            height: 160
            transform: Rotation {
                origin.x: 44
                origin.y: 92
                angle: root.tailRotation
            }

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: bodyColor
                    strokeWidth: 16
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: 56
                    startY: 86
                    PathCubic {
                        control1X: 26
                        control1Y: 74
                        control2X: 18
                        control2Y: 30
                        x: 44
                        y: 18
                    }
                }
            }
        }

        Rectangle {
            x: 48
            y: 58 + root.bodyOffsetY
            width: 96
            height: 50
            radius: 25
            color: bodyColor
        }

        Rectangle {
            x: 78
            y: 72 + root.bodyOffsetY
            width: 42
            height: 22
            radius: 11
            color: bellyColor
        }

        Rectangle {
            x: 128
            y: 36 + root.bodyOffsetY
            width: 42
            height: 42
            radius: 21
            color: bodyColor
        }

        Rectangle {
            x: 118
            y: 54 + root.bodyOffsetY
            width: 24
            height: 20
            radius: 10
            color: bodyColor
        }

        Rectangle {
            x: 152
            y: 24 + root.bodyOffsetY
            width: 14
            height: 18
            radius: 9
            color: bodyColor
            rotation: 18
        }

        Rectangle {
            x: 142
            y: 22 + root.bodyOffsetY
            width: 14
            height: 18
            radius: 8
            color: bodyColor
            rotation: -12
        }

        Rectangle {
            x: 144
            y: 50 + root.bodyOffsetY
            width: 7
            height: 7
            radius: 3.5
            color: Theme.white
        }

        Rectangle {
            x: 155
            y: 51 + root.bodyOffsetY
            width: 7
            height: 7
            radius: 3.5
            color: Theme.white
        }

        Rectangle {
            x: 146
            y: 52 + root.bodyOffsetY
            width: 3
            height: 5
            radius: 1.5
            color: Theme.ink
        }

        Rectangle {
            x: 157
            y: 53 + root.bodyOffsetY
            width: 3
            height: 5
            radius: 1.5
            color: Theme.ink
        }

        Rectangle {
            x: 132
            y: 64 + root.bodyOffsetY
            width: 10
            height: 5
            radius: 2.5
            color: Theme.heart
        }

        Shape {
            x: 133
            y: 66 + root.bodyOffsetY
            width: 16
            height: 10
            antialiasing: true

            ShapePath {
                strokeColor: Theme.ink
                strokeWidth: 1.8
                fillColor: "transparent"
                startX: 1
                startY: 1
                PathQuad { x: 14; y: 2; controlX: 8; controlY: 8 }
            }
        }

        Repeater {
            model: [
                { x: 52, y: 92, rotationSign: -1, link: "backLegRotation" },
                { x: 74, y: 92, rotationSign: 1, link: "backLegRotation" },
                { x: 102, y: 90, rotationSign: 1, link: "frontLegRotation" },
                { x: 122, y: 90, rotationSign: -1, link: "frontLegRotation" }
            ]

            Item {
                x: modelData.x
                y: modelData.y + root.bodyOffsetY
                width: 16
                height: 36
                rotation: modelData.rotationSign * root[modelData.link]
                transformOrigin: Item.Top

                Rectangle {
                    anchors.fill: parent
                    radius: 7
                    color: bodyColor
                }
            }
        }

        Repeater {
            model: [
                { x: 130, y: 48, dx: 18, dy: -4 },
                { x: 130, y: 56, dx: 18, dy: 2 }
            ]

            Shape {
                x: modelData.x
                y: modelData.y + root.bodyOffsetY
                width: 22
                height: 10
                antialiasing: true
                opacity: 0.5

                ShapePath {
                    strokeColor: Theme.ink
                    strokeWidth: 1.6
                    fillColor: "transparent"
                    startX: 0
                    startY: 5
                    PathLine { x: modelData.dx; y: 5 + modelData.dy }
                }
            }
        }
    }
}
