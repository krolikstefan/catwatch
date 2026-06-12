import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import KotekWatch

Window {
    id: root

    width: 396
    height: 396
    visible: true
    title: "Kotek Watch"
    color: Theme.krem

    property bool debugMenuOpen: false
    property date now: new Date()

    FontLoader {
        source: Qt.resolvedUrl("../assets/fonts/Fredoka-Bold.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("../assets/fonts/Nunito-Regular.ttf")
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.now = new Date()
    }

    Rectangle {
        anchors.fill: parent
        radius: 32
        color: Theme.krem
        border.color: Theme.granica
        border.width: 2
        clip: true

        SwipeView {
            id: sectionView
            anchors.fill: parent
            currentIndex: 0

            ActivityScreen {}

            WeatherScreen {}

            RelaxScreen {}

            onCurrentIndexChanged: {
                if (bottomBar.currentIndex !== currentIndex) {
                    bottomBar.currentIndex = currentIndex
                }
            }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            height: 42
            radius: 21
            color: Qt.rgba(1, 1, 1, 0.8)
            border.color: Qt.rgba(1, 1, 1, 0.55)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 10

                Text {
                    text: Qt.formatTime(root.now, "hh:mm")
                    color: Theme.granat
                    font.family: Theme.headingFont
                    font.pixelSize: 18
                }

                Text {
                    text: apiClient.simulationRunning ? "Sym ON" : "Sym OFF"
                    color: Theme.granat
                    font.family: Theme.bodyFont
                    font.pixelSize: 13
                    opacity: 0.72
                }

                Item {
                    Layout.fillWidth: true
                }

                PillBadge {
                    Layout.alignment: Qt.AlignVCenter
                    implicitHeight: 34
                    text: apiClient.battery + "%"
                    iconSource: Theme.icon("heart")
                    accentColor: Theme.rozowy
                    textColor: Theme.granat
                    iconSize: 16
                }
            }
        }

        Button {
            id: debugButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 18
            anchors.rightMargin: 18
            width: 30
            height: 30
            text: "..."
            onClicked: root.debugMenuOpen = !root.debugMenuOpen

            background: Rectangle {
                radius: 15
                color: Theme.granat
                opacity: 0.9
            }

            contentItem: Text {
                text: debugButton.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Theme.bialy
                font.family: Theme.headingFont
                font.pixelSize: 16
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 14
            color: "transparent"
            implicitHeight: 72

            BottomNavBar {
                id: bottomBar
                anchors.fill: parent
                items: [
                    { "label": "Ruch", "icon": Theme.icon("paw"), "color": Theme.rudyKotek },
                    { "label": "Pogoda", "icon": Theme.icon("sun-happy"), "color": Theme.zoltySloneczny },
                    { "label": "Relaks", "icon": Theme.icon("heart"), "color": Theme.rozowy }
                ]
                onItemSelected: sectionView.currentIndex = index
            }
        }

        Rectangle {
            visible: root.debugMenuOpen
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 56
            anchors.rightMargin: 16
            width: 160
            height: 184
            radius: 24
            color: Qt.rgba(37 / 255, 49 / 255, 79 / 255, 0.93)
            border.color: Qt.rgba(1, 1, 1, 0.18)
            z: 3

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                Text {
                    text: "Debug"
                    color: Theme.bialy
                    font.family: Theme.headingFont
                    font.pixelSize: 20
                }

                PrimaryButton {
                    Layout.fillWidth: true
                    text: "Start"
                    onClicked: apiClient.startSimulation()
                }

                SecondaryButton {
                    Layout.fillWidth: true
                    text: "Stop"
                    onClicked: apiClient.stopSimulation()
                }

                SecondaryButton {
                    Layout.fillWidth: true
                    text: "Reset"
                    onClicked: apiClient.resetActivity()
                }
            }
        }
    }
}
