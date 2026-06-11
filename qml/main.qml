import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Window {
    id: window
    width: Screen.width
    height: Screen.height
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint
    title: "Kotek Watch"

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#89DCFF" }
            GradientStop { position: 0.32; color: "#C8BBFF" }
            GradientStop { position: 0.68; color: "#FF8BC1" }
            GradientStop { position: 1.0; color: "#FFC45C" }
        }

        Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            opacity: 0.08
        }

        Repeater {
            model: [
                { x: width * -0.02, y: height * 0.04, w: width * 0.34, h: height * 0.22, color: "#FFFFFF", opacity: 0.18 },
                { x: width * 0.74, y: height * 0.06, w: width * 0.24, h: height * 0.18, color: "#FFF7E8", opacity: 0.16 },
                { x: width * 0.06, y: height * 0.72, w: width * 0.28, h: height * 0.16, color: "#86EFAC", opacity: 0.18 },
                { x: width * 0.7, y: height * 0.74, w: width * 0.26, h: height * 0.17, color: "#FFB84D", opacity: 0.15 },
                { x: width * 0.36, y: height * 0.12, w: width * 0.18, h: height * 0.11, color: "#FF7EB6", opacity: 0.12 }
            ]

            Rectangle {
                x: modelData.x
                y: modelData.y
                width: modelData.w
                height: modelData.h
                radius: Math.min(width, height) / 2
                color: modelData.color
                opacity: modelData.opacity
            }
        }

        Repeater {
            model: [
                { x: width * 0.1, y: height * 0.18, w: 92, h: 40 },
                { x: width * 0.76, y: height * 0.22, w: 84, h: 34 },
                { x: width * 0.18, y: height * 0.82, w: 102, h: 42 }
            ]

            Item {
                x: modelData.x
                y: modelData.y
                width: modelData.w
                height: modelData.h
                opacity: 0.88

                Rectangle {
                    x: 0
                    y: height * 0.36
                    width: parent.width * 0.46
                    height: parent.height * 0.34
                    radius: height / 2
                    color: "#FFFFFF"
                }

                Rectangle {
                    x: parent.width * 0.18
                    y: 0
                    width: parent.width * 0.36
                    height: parent.height * 0.48
                    radius: height / 2
                    color: "#FFFFFF"
                }

                Rectangle {
                    x: parent.width * 0.42
                    y: parent.height * 0.22
                    width: parent.width * 0.5
                    height: parent.height * 0.4
                    radius: height / 2
                    color: "#FFFFFF"
                }
            }
        }

        Repeater {
            model: [
                { x: width * 0.18, y: height * 0.1, size: 26, color: "#FFB84D", rotation: -12 },
                { x: width * 0.83, y: height * 0.12, size: 22, color: "#FF7EB6", rotation: 16 },
                { x: width * 0.14, y: height * 0.68, size: 20, color: "#C4B5FD", rotation: -8 },
                { x: width * 0.86, y: height * 0.66, size: 28, color: "#86EFAC", rotation: 10 }
            ]

            Item {
                x: modelData.x
                y: modelData.y
                width: modelData.size
                height: modelData.size
                rotation: modelData.rotation
                opacity: 0.9

                Shape {
                    anchors.fill: parent
                    antialiasing: true

                    ShapePath {
                        fillColor: modelData.color
                        strokeWidth: 0
                        startX: width / 2
                        startY: 0
                        PathLine { x: width * 0.62; y: height * 0.34 }
                        PathLine { x: width; y: height * 0.38 }
                        PathLine { x: width * 0.72; y: height * 0.62 }
                        PathLine { x: width * 0.78; y: height }
                        PathLine { x: width / 2; y: height * 0.76 }
                        PathLine { x: width * 0.22; y: height }
                        PathLine { x: width * 0.28; y: height * 0.62 }
                        PathLine { x: 0; y: height * 0.38 }
                        PathLine { x: width * 0.38; y: height * 0.34 }
                        PathLine { x: width / 2; y: 0 }
                    }
                }
            }
        }

        Repeater {
            model: [
                { x: width * 0.08, y: height * 0.34, size: 40, color: "#FFFFFF", opacity: 0.16, rotation: -16 },
                { x: width * 0.82, y: height * 0.38, size: 34, color: "#FFF7E8", opacity: 0.14, rotation: 12 },
                { x: width * 0.22, y: height * 0.9, size: 32, color: "#C4B5FD", opacity: 0.16, rotation: -10 },
                { x: width * 0.74, y: height * 0.86, size: 38, color: "#86EFAC", opacity: 0.14, rotation: 8 }
            ]

            Item {
                x: modelData.x
                y: modelData.y
                width: modelData.size
                height: modelData.size
                rotation: modelData.rotation
                opacity: modelData.opacity

                Rectangle {
                    x: width * 0.34
                    y: height * 0.42
                    width: width * 0.32
                    height: height * 0.28
                    radius: width * 0.14
                    color: modelData.color
                }

                Repeater {
                    model: [
                        { x: 0.08, y: 0.28 },
                        { x: 0.28, y: 0.06 },
                        { x: 0.5, y: 0.02 },
                        { x: 0.7, y: 0.18 }
                    ]

                    Rectangle {
                        x: parent.width * modelData.x
                        y: parent.height * modelData.y
                        width: parent.width * 0.22
                        height: parent.width * 0.22
                        radius: width / 2
                        color: parent.parent.modelData.color
                    }
                }
            }
        }

        Repeater {
            model: [
                { x: width * 0.3, y: height * 0.24, size: 14, color: "#FF7EB6", opacity: 0.3, rotation: -10 },
                { x: width * 0.68, y: height * 0.28, size: 12, color: "#FFFFFF", opacity: 0.24, rotation: 14 },
                { x: width * 0.1, y: height * 0.56, size: 16, color: "#FFB84D", opacity: 0.24, rotation: -8 },
                { x: width * 0.88, y: height * 0.58, size: 12, color: "#C4B5FD", opacity: 0.24, rotation: 10 },
                { x: width * 0.32, y: height * 0.78, size: 13, color: "#FFFFFF", opacity: 0.22, rotation: -18 },
                { x: width * 0.64, y: height * 0.8, size: 15, color: "#FF7EB6", opacity: 0.26, rotation: 16 }
            ]

            Item {
                x: modelData.x
                y: modelData.y
                width: modelData.size
                height: modelData.size
                rotation: modelData.rotation
                opacity: modelData.opacity

                Shape {
                    anchors.fill: parent
                    antialiasing: true

                    ShapePath {
                        fillColor: modelData.color
                        strokeWidth: 0
                        startX: width / 2
                        startY: height
                        PathCubic { control1X: -2; control1Y: height * 0.68; control2X: width * 0.08; control2Y: 0; x: width / 2; y: height * 0.3 }
                        PathCubic { control1X: width * 0.92; control1Y: 0; control2X: width + 2; control2Y: height * 0.68; x: width / 2; y: height }
                    }
                }
            }
        }
    }

    Rectangle {
        id: appFrame
        width: 540
        height: 665
        anchors.centerIn: parent
        border.color: "#22366F"
        border.width: 4
        clip: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFDFB" }
            GradientStop { position: 1.0; color: "#FDEEFF" }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 10
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFF" }
                GradientStop { position: 1.0; color: "#FFF7E8" }
            }
            opacity: 0.24
        }

        Item {
            id: appViewport
            width: 240
            height: 300
            anchors.centerIn: parent
            scale: Math.min((appFrame.width - 40) / width, (appFrame.height - 40) / height)
            transformOrigin: Item.Center

            SwipeView {
                id: swipeView
                anchors.fill: parent
                interactive: true
                orientation: Qt.Horizontal
                clip: true

                ScreenClock { currentIndex: swipeView.currentIndex }
                ScreenSteps { currentIndex: swipeView.currentIndex }
                ScreenWeather { currentIndex: swipeView.currentIndex }
                ScreenSOS { currentIndex: swipeView.currentIndex }

                Component.onCompleted: {
                    if (contentItem && contentItem.highlightMoveDuration !== undefined) {
                        contentItem.highlightMoveDuration = 280
                        contentItem.highlightMoveVelocity = -1
                    }
                }
            }
        }
    }
}
