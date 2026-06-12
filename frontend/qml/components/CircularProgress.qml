import QtQuick
import KotekWatch

Item {
    id: root

    property real progress: 0
    property color progressColor: Theme.zielen
    property color trackColor: Qt.rgba(1, 1, 1, 0.5)
    property url iconSource: Theme.icon("star")
    property string centerText: Math.round(progress * 100) + "%"
    property real strokeWidth: 22

    implicitWidth: 210
    implicitHeight: 210

    Canvas {
        id: ring
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const size = Math.min(width, height)
            const center = size / 2
            const radius = center - root.strokeWidth
            const start = Math.PI * 0.75
            const span = Math.PI * 1.5

            ctx.lineCap = "round"
            ctx.lineWidth = root.strokeWidth

            ctx.beginPath()
            ctx.strokeStyle = root.trackColor
            ctx.arc(center, center, radius, start, start + span, false)
            ctx.stroke()

            ctx.beginPath()
            ctx.strokeStyle = root.progressColor
            ctx.arc(center, center, radius, start, start + span * Math.max(0, Math.min(root.progress, 1)), false)
            ctx.stroke()
        }

        Connections {
            target: root
            function onProgressChanged() { ring.requestPaint() }
            function onProgressColorChanged() { ring.requestPaint() }
            function onTrackColorChanged() { ring.requestPaint() }
            function onStrokeWidthChanged() { ring.requestPaint() }
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.centerText
        color: Theme.granat
        font.family: Theme.headingFont
        font.pixelSize: 42
        font.weight: Font.Bold
    }

    IconCircle {
        width: 54
        height: 54
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        fillColor: Theme.zoltySloneczny
        iconSource: root.iconSource
        iconSize: 26
    }
}
