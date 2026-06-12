import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: "Aktywność"
            font.pixelSize: 24
        }

        Label {
            text: "Kroki: " + apiClient.steps
        }

        Label {
            text: "Kalorie: " + apiClient.calories
        }

        Label {
            text: "Tętno: " + apiClient.heartRate + " bpm"
        }

        ProgressBar {
            Layout.fillWidth: true
            from: 0
            to: 100
            value: apiClient.goalPercent
        }

        Label {
            text: "Cel: " + apiClient.goalPercent + "%"
        }

        Label {
            text: apiClient.notifications.length > 0
                ? apiClient.notifications[0].message
                : "Brak nowych powiadomień"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
    }
}
