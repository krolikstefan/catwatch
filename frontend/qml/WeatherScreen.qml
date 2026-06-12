import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: "Pogoda"
            font.pixelSize: 24
        }

        Label {
            text: "Dziś: " + apiClient.temperature.toFixed(1) + "°C"
        }

        Label {
            text: apiClient.weatherDescription
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Label {
            text: "Jutro"
            font.pixelSize: 20
        }

        Label {
            text: apiClient.tomorrowForecast
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
    }
}
