import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import "."

WatchBezel {
    id: sosScreen

    property int currentIndex: 0
    property bool callingActive: false
    property real shakeOffset: 0

    clip: true

    function triggerSOS() {
        particleCanvas.burst(width / 2, height * 0.30)
        shakeAnim.stop()
        shakeAnim.start()
        callDelayTimer.restart()
    }

    function cancelSOS() {
        callDelayTimer.stop()
        callingActive = false
        callingState.visible = false
        sosButton.visible = true
        if (particleTimer.running) {
            particleTimer.stop()
        }
        particleCanvas.opacity = 0
        particleCanvas.particles = []
    }

    Rectangle {
        anchors.fill: parent
        color: "#FF4757"
        z: 0
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height * 0.4
        color: "#CC0000"
        z: 1

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "ALARM SOS"
                font.family: Theme.fontDisplay
                font.weight: Font.DemiBold
                font.pixelSize: 28
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter
                transform: Translate { x: sosScreen.shakeOffset }
            }

            Text {
                text: "Nacisnij i przytrzymaj\naby anulowac"
                font.family: Theme.fontBody
                font.pixelSize: 16
                color: "#FFFFFF"
                opacity: 0.75
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                renderType: Text.NativeRendering
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: sosScreen.cancelSOS()
        }
    }

    Item {
        id: topZone
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * 0.6
        z: 2

        Rectangle {
            id: sosButton
            width: 128
            height: 128
            radius: 64
            color: "#FFFFFF"
            border.color: "#FF4757"
            border.width: 6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: pulseRing
                anchors.centerIn: parent
                width: 128
                height: 128
                radius: 64
                color: "transparent"
                border.color: "#FFFFFF"
                border.width: 4
                opacity: 0

                SequentialAnimation on scale {
                    running: sosButton.visible
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.5; duration: 1000; easing.type: Easing.OutCubic }
                    PauseAnimation { duration: 400 }
                }

                SequentialAnimation on opacity {
                    running: sosButton.visible
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.0; to: 0.6; duration: 200 }
                    NumberAnimation { from: 0.6; to: 0.0; duration: 800; easing.type: Easing.OutCubic }
                    PauseAnimation { duration: 400 }
                }
            }

            Text {
                anchors.centerIn: parent
                text: "SOS"
                font.family: Theme.fontDisplay
                font.weight: Font.DemiBold
                font.pixelSize: 42
                color: "#FF4757"
                renderType: Text.NativeRendering
            }

            MouseArea {
                anchors.fill: parent
                onClicked: sosScreen.triggerSOS()
            }
        }

        Canvas {
            id: particleCanvas
            anchors.fill: parent
            opacity: 0
            z: 10

            property var particles: []

            function burst(cx, cy) {
                particles = []
                for (var i = 0; i < 32; i++) {
                    var angle = Math.random() * Math.PI * 2
                    var speed = 2 + Math.random() * 5
                    particles.push({
                        x: cx, y: cy,
                        vx: Math.cos(angle) * speed,
                        vy: Math.sin(angle) * speed,
                        r: 3 + Math.random() * 5,
                        life: 1.0,
                        decay: 0.018 + Math.random() * 0.014,
                        color: ["#FFFFFF", "#FFD24D", "#FCE0C6", "#F39DAE"][Math.floor(Math.random() * 4)]
                    })
                }
                opacity = 1
                requestPaint()
                particleTimer.start()
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                for (var i = 0; i < particles.length; i++) {
                    var p = particles[i]
                    if (p.life <= 0)
                        continue
                    ctx.globalAlpha = p.life
                    ctx.fillStyle = p.color
                    ctx.beginPath()
                    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
                    ctx.fill()
                }
            }

            Timer {
                id: particleTimer
                interval: 16
                repeat: true
                onTriggered: {
                    var alive = false
                    for (var i = 0; i < particleCanvas.particles.length; i++) {
                        var p = particleCanvas.particles[i]
                        p.x += p.vx
                        p.y += p.vy
                        p.vy += 0.12
                        p.life -= p.decay
                        if (p.life > 0)
                            alive = true
                    }
                    particleCanvas.requestPaint()
                    if (!alive) {
                        stop()
                        particleCanvas.opacity = 0
                    }
                }
            }
        }

        Item {
            id: callingState
            visible: false
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height

            Shape {
                anchors.centerIn: parent
                width: 80
                height: 80
                antialiasing: true

                ShapePath {
                    strokeColor: "#FFFFFF"
                    strokeWidth: 6
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    startX: 22
                    startY: 14
                    PathCubic { control1X: 22; control1Y: 6; control2X: 34; control2Y: 2; x: 38; y: 6 }
                    PathCubic { control1X: 42; control1Y: 10; control2X: 40; control2Y: 20; x: 34; y: 22 }
                    PathLine { x: 30; y: 26 }
                    PathCubic { control1X: 28; control1Y: 30; control2X: 44; control2Y: 46; x: 52; y: 52 }
                    PathLine { x: 56; y: 48 }
                    PathCubic { control1X: 60; control1Y: 42; control2X: 68; control2Y: 40; x: 72; y: 44 }
                    PathCubic { control1X: 76; control1Y: 48; control2X: 74; control2Y: 58; x: 66; y: 58 }
                    PathCubic { control1X: 38; control1Y: 72; control2X: 8; control2Y: 42; x: 22; y: 14 }
                }
            }

            Repeater {
                model: 3

                Item {
                    anchors.centerIn: parent
                    width: 80
                    height: 80

                    Rectangle {
                        anchors.centerIn: parent
                        width: 80
                        height: 80
                        radius: 40
                        color: "transparent"
                        border.color: "#FFFFFF"
                        border.width: 2
                        opacity: 0

                        SequentialAnimation {
                            running: sosScreen.callingActive
                            loops: Animation.Infinite
                            PauseAnimation { duration: index * 320 }
                            ParallelAnimation {
                                NumberAnimation { target: parent; property: "scale"; from: 1.0; to: 2.2; duration: 960; easing.type: Easing.OutCubic }
                                NumberAnimation { target: parent; property: "opacity"; from: 0.7; to: 0.0; duration: 960 }
                            }
                        }
                    }
                }
            }

            Text {
                text: "Dzwonie 112..."
                font.family: Theme.fontDisplay
                font.weight: Font.Medium
                font.pixelSize: Theme.fontSizeLabel
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12
                renderType: Text.NativeRendering

                SequentialAnimation on opacity {
                    running: callingState.visible
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 600 }
                    NumberAnimation { to: 1.0; duration: 600 }
                }
            }
        }
    }

    Timer {
        id: callDelayTimer
        interval: 600
        onTriggered: {
            callingState.visible = true
            sosButton.visible = false
            callingActive = true
        }
    }

    SequentialAnimation on shakeOffset {
        id: shakeAnim
        running: false
        loops: 3
        NumberAnimation { to: 8; duration: 60 }
        NumberAnimation { to: -8; duration: 60 }
        NumberAnimation { to: 0; duration: 60 }
    }

    Item {
        anchors.fill: parent
        z: 3

        PageDots {
            currentIndex: root.currentIndex
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
        }
    }
}
