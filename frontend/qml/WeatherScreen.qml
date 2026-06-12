import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import KotekWatch

Item {
    id: root

    property date now: new Date()
    property var tomorrowParts: {
        const match = apiClient.tomorrowForecast.match(/(-?\d+(?:\.\d+)?)°C \/ (-?\d+(?:\.\d+)?)°C - (.*)/)
        return match ? { min: match[1], max: match[2], desc: match[3] } : { min: "--", max: "--", desc: apiClient.tomorrowForecast }
    }

    function iconForText(text) {
        const value = text.toLowerCase()
        if (value.indexOf("deszcz") >= 0 || value.indexOf("rain") >= 0) {
            return Theme.icon("cloud-rain")
        }
        if (value.indexOf("chmur") >= 0 || value.indexOf("cloud") >= 0) {
            return Theme.icon("cloud-happy")
        }
        return Theme.icon("sun-happy")
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.now = new Date()
    }

    SwipeView {
        id: pages
        anchors.fill: parent
        anchors.topMargin: 58
        anchors.bottomMargin: 86

        Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: 16
                radius: 30
                clip: true

                Image {
                    anchors.fill: parent
                    source: Theme.bgRain
                    fillMode: Image.PreserveAspectCrop
                }

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(1, 1, 1, 0.12)
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: Qt.formatTime(root.now, "hh:mm")
                        color: Theme.bialy
                        font.family: Theme.headingFont
                        font.pixelSize: 52
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Image {
                        source: Theme.illustration("kitten-pointing")
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 150
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    PillBadge {
                        Layout.alignment: Qt.AlignHCenter
                        iconSource: Theme.icon("cloud-rain")
                        accentColor: Theme.blekit
                        text: apiClient.temperature.toFixed(1) + "°C"
                        textColor: Theme.granat
                    }
                }
            }
        }

        Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: 16
                radius: 30
                clip: true

                Image {
                    anchors.fill: parent
                    source: Theme.bgSun
                    fillMode: Image.PreserveAspectCrop
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: apiClient.temperature.toFixed(1) + "°"
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    IconCircle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 86
                        height: 86
                        iconSource: Theme.icon("sun-happy")
                        fillColor: Qt.rgba(1, 1, 1, 0.6)
                        iconSize: 54
                    }

                    Text {
                        text: apiClient.weatherDescription.length > 0 ? apiClient.weatherDescription : "Słonecznie"
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: 16
                radius: 30
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#EEF8FF" }
                    GradientStop { position: 1.0; color: Theme.blekit }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 12

                    Text {
                        text: "Jutro"
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 36
                        Layout.alignment: Qt.AlignHCenter
                    }

                    IconCircle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 88
                        height: 88
                        iconSource: root.iconForText(root.tomorrowParts.desc)
                        fillColor: Qt.rgba(1, 1, 1, 0.65)
                        iconSize: 56
                    }

                    Text {
                        text: root.tomorrowParts.min + "° / " + root.tomorrowParts.max + "°"
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 42
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: root.tomorrowParts.desc
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 18
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    NavDots {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 94
        count: pages.count
        currentIndex: pages.currentIndex
        activeColor: Theme.blekit
    }
}
