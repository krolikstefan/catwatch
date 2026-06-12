import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 396
    height: 396
    visible: true
    title: "Kotek Watch"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Bateria: " + apiClient.battery + "%"
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: apiClient.simulationRunning ? "Symulacja: ON" : "Symulacja: OFF"
            }
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true

            ActivityScreen {
            }

            WeatherScreen {
            }

            RelaxScreen {
            }
        }

        PageIndicator {
            Layout.alignment: Qt.AlignHCenter
            count: swipeView.count
            currentIndex: swipeView.currentIndex
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Start"
                onClicked: apiClient.startSimulation()
            }

            Button {
                text: "Stop"
                onClicked: apiClient.stopSimulation()
            }

            Button {
                text: "Reset"
                onClicked: apiClient.resetActivity()
            }
        }
    }
}
