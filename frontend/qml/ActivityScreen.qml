import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import KotekWatch

Item {
    id: root

    property date now: new Date()
    property string headlineNotification: apiClient.notifications.length > 0
        ? apiClient.notifications[0].message
        : "Każdy krok liczy się dzisiaj!"

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
                color: Theme.zoltySloneczny

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: Qt.formatTime(root.now, "hh:mm")
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 56
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: root.headlineNotification
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 16
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Image {
                        source: Theme.illustration("kitten-waving")
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
                        iconSource: Theme.icon("paw")
                        accentColor: Theme.brzoskwinia
                        text: Qt.locale().toString(apiClient.steps)
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
                    GradientStop { position: 0.0; color: Theme.brzoskwinia }
                    GradientStop { position: 1.0; color: "#FFF2E6" }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 6

                    Text {
                        text: "Kalorie"
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6

                        Text {
                            text: apiClient.calories
                            color: Theme.granat
                            font.family: Theme.headingFont
                            font.pixelSize: 62
                            font.weight: Font.Bold
                        }

                        Text {
                            text: "kcal"
                            color: Theme.granat
                            font.family: Theme.bodyFont
                            font.pixelSize: 24
                            font.weight: Font.Bold
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Image {
                        source: Theme.illustration("kitten-paws-up")
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
                        iconSource: Theme.icon("flame")
                        accentColor: Theme.rudyKotek
                        text: apiClient.calories + " kcal"
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
                    GradientStop { position: 0.0; color: "#EFFFF2" }
                    GradientStop { position: 1.0; color: Theme.mieta }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: "Cel dzienny"
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 28
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Tętno " + apiClient.heartRate + " bpm"
                        color: Theme.granat
                        opacity: 0.72
                        font.family: Theme.bodyFont
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    CircularProgress {
                        Layout.alignment: Qt.AlignHCenter
                        progress: apiClient.goalPercent / 100
                        centerText: apiClient.goalPercent + "%"
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    PillBadge {
                        Layout.alignment: Qt.AlignHCenter
                        iconSource: Theme.icon("star")
                        accentColor: Theme.zoltySloneczny
                        text: "Cel " + apiClient.goalPercent + "%"
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
        activeColor: Theme.rudyKotek
    }
}
