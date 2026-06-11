import QtQuick
import QtQuick.Shapes
import "."

Item {
    id: root
    width: 150
    height: 158

    property bool lookUp: false
    property real eyeScaleY: 1.0
    property real tailRotation: 0.0
    property real leftEarRotation: 0.0
    property real rightEarRotation: 0.0

    readonly property real sx: width / 200
    readonly property real sy: height / 210

    Item {
        anchors.fill: parent
        scale: Math.min(root.sx, root.sy)
        transformOrigin: Item.TopLeft

        Item {
            width: 200
            height: 210
            transform: Rotation {
                origin.x: 154
                origin.y: 176
                angle: root.tailRotation
            }

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: Theme.catDark
                    strokeWidth: 16
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: 154
                    startY: 176
                    PathCubic {
                        control1X: 192
                        control1Y: 142
                        control2X: 202
                        control2Y: 90
                        x: 176
                        y: 62
                    }
                }
            }
        }

        Rectangle {
            x: 58
            y: 112
            width: 88
            height: 82
            radius: 41
            color: Theme.cat
        }

        Rectangle {
            x: 77
            y: 138
            width: 46
            height: 54
            radius: 23
            color: Theme.catBelly
        }

        Rectangle {
            x: 64
            y: 181
            width: 24
            height: 16
            radius: 8
            color: Theme.cat
        }

        Rectangle {
            x: 112
            y: 181
            width: 24
            height: 16
            radius: 8
            color: Theme.cat
        }

        Item {
            x: 61
            y: 30
            width: 34
            height: 38
            rotation: root.leftEarRotation
            transformOrigin: Item.Bottom

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    fillColor: Theme.cat
                    strokeWidth: 0
                    startX: 17
                    startY: 0
                    PathLine { x: 0; y: 38 }
                    PathLine { x: 34; y: 38 }
                    PathLine { x: 17; y: 0 }
                }

                ShapePath {
                    fillColor: Theme.pink
                    strokeWidth: 0
                    startX: 17
                    startY: 9
                    PathLine { x: 7; y: 30 }
                    PathLine { x: 27; y: 30 }
                    PathLine { x: 17; y: 9 }
                }
            }
        }

        Item {
            x: 105
            y: 30
            width: 34
            height: 38
            rotation: root.rightEarRotation
            transformOrigin: Item.Bottom

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    fillColor: Theme.cat
                    strokeWidth: 0
                    startX: 17
                    startY: 0
                    PathLine { x: 0; y: 38 }
                    PathLine { x: 34; y: 38 }
                    PathLine { x: 17; y: 0 }
                }

                ShapePath {
                    fillColor: Theme.pink
                    strokeWidth: 0
                    startX: 17
                    startY: 9
                    PathLine { x: 7; y: 30 }
                    PathLine { x: 27; y: 30 }
                    PathLine { x: 17; y: 9 }
                }
            }
        }

        Rectangle {
            x: 57
            y: 48
            width: 86
            height: 76
            radius: 38
            color: Theme.cat
        }

        Repeater {
            model: [72, 128]

            Rectangle {
                x: modelData
                y: 90
                width: 14
                height: 14
                radius: 7
                color: Theme.pink
                opacity: 0.42
            }
        }

        Item {
            x: 76
            y: 72
            width: 18
            height: 16
            scale: root.eyeScaleY
            transformOrigin: Item.Center

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: Theme.white
            }

            Rectangle {
                x: 6
                y: root.lookUp ? 2 : 5
                width: 6
                height: 8
                radius: 3
                color: Theme.ink
            }
        }

        Item {
            x: 108
            y: 72
            width: 18
            height: 16
            scale: root.eyeScaleY
            transformOrigin: Item.Center

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: Theme.white
            }

            Rectangle {
                x: 6
                y: root.lookUp ? 2 : 5
                width: 6
                height: 8
                radius: 3
                color: Theme.ink
            }
        }

        Shape {
            x: 88
            y: 95
            width: 24
            height: 16
            antialiasing: true

            ShapePath {
                fillColor: Theme.heart
                strokeWidth: 0
                startX: 12
                startY: 13
                PathLine { x: 4; y: 6 }
                PathLine { x: 20; y: 6 }
                PathLine { x: 12; y: 13 }
            }
        }

        Shape {
            x: 88
            y: 106
            width: 24
            height: 16
            antialiasing: true

            ShapePath {
                strokeColor: Theme.ink
                strokeWidth: 2.2
                fillColor: "transparent"
                startX: 12
                startY: 0
                PathQuad { x: 3; y: 8; controlX: 4; controlY: 8 }
            }

            ShapePath {
                strokeColor: Theme.ink
                strokeWidth: 2.2
                fillColor: "transparent"
                startX: 12
                startY: 0
                PathQuad { x: 21; y: 8; controlX: 20; controlY: 8 }
            }
        }

        Repeater {
            model: [
                { x: 60, y: 96, startX: 30, endX: 0, endY: 3 },
                { x: 60, y: 106, startX: 30, endX: 0, endY: 9 },
                { x: 110, y: 96, startX: 0, endX: 30, endY: 3 },
                { x: 110, y: 106, startX: 0, endX: 30, endY: 9 }
            ]

            Shape {
                x: modelData.x
                y: modelData.y
                width: 32
                height: 12
                antialiasing: true
                opacity: 0.55

                ShapePath {
                    strokeColor: Theme.ink
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    startX: modelData.startX
                    startY: 6
                    PathLine { x: modelData.endX; y: modelData.endY }
                }
            }
        }
    }
}
