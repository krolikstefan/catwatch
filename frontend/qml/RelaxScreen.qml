import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import KotekWatch

Item {
    id: root

    property date now: new Date()
    readonly property int completedExercises: {
        let count = 0
        for (let i = 0; i < apiClient.exercises.length; ++i) {
            if (apiClient.exercises[i].completed) {
                count += 1
            }
        }
        return count
    }
    readonly property bool relaxCompleted: apiClient.exercises.length > 0 && completedExercises === apiClient.exercises.length
    readonly property var nextExercise: {
        for (let i = 0; i < apiClient.exercises.length; ++i) {
            if (!apiClient.exercises[i].completed) {
                return apiClient.exercises[i]
            }
        }
        return apiClient.exercises.length > 0 ? apiClient.exercises[apiClient.exercises.length - 1] : null
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.now = new Date()
    }

    Connections {
        target: apiClient
        function onRelaxChanged() {
            if (root.relaxCompleted) {
                pages.currentIndex = 2
            }
        }
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
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#E7F7FF" }
                    GradientStop { position: 1.0; color: Theme.mieta }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: Qt.formatTime(root.now, "hh:mm")
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 52
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: apiClient.relaxStatus
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Image {
                        source: Theme.illustration("kitten-meditating")
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 170
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    PillBadge {
                        Layout.alignment: Qt.AlignHCenter
                        iconSource: Theme.icon("heart")
                        accentColor: Theme.rozowy
                        text: "Oddychamy spokojnie"
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
                    GradientStop { position: 0.0; color: "#D9F0FF" }
                    GradientStop { position: 1.0; color: Theme.blekit }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 8

                    Text {
                        text: "Oddychaj głęboko"
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 34
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.nextExercise ? root.nextExercise.name : "Wszystkie ćwiczenia gotowe"
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 18
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Image {
                        source: Theme.illustration("kitten-tea")
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 138
                        Layout.fillWidth: true
                    }

                    PillBadge {
                        Layout.alignment: Qt.AlignHCenter
                        iconSource: Theme.icon("music-note")
                        accentColor: Theme.fiolet
                        text: root.nextExercise ? root.nextExercise.durationSeconds + " s" : "Gotowe"
                    }

                    PrimaryButton {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.nextExercise && !root.nextExercise.completed ? "Ukończ ćwiczenie" : "Wróć"
                        onClicked: {
                            if (root.nextExercise && !root.nextExercise.completed) {
                                apiClient.completeExercise(root.nextExercise.id)
                            } else {
                                pages.currentIndex = 0
                            }
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 8
                        model: apiClient.exercises

                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 56
                            radius: 22
                            color: Qt.rgba(1, 1, 1, 0.6)
                            border.color: modelData.completed ? Theme.zielen : Qt.rgba(1, 1, 1, 0.9)
                            border.width: 2

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: Theme.granat
                                    font.family: Theme.bodyFont
                                    font.pixelSize: 16
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.durationSeconds + " s"
                                    color: Theme.granat
                                    opacity: 0.72
                                    font.family: Theme.bodyFont
                                    font.pixelSize: 14
                                }
                            }
                        }
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
                    GradientStop { position: 0.0; color: "#FFF4F8" }
                    GradientStop { position: 1.0; color: Theme.rozowy }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 10

                    Text {
                        text: "Świetna robota!"
                        color: Theme.granat
                        font.family: Theme.headingFont
                        font.pixelSize: 34
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.relaxCompleted ? "Sesja zakończona." : "Jeszcze chwila relaksu."
                        color: Theme.granat
                        font.family: Theme.bodyFont
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Image {
                        source: Theme.illustration("kitten-heart")
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 158
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10

                        IconCircle {
                            iconSource: Theme.icon("heart")
                            fillColor: Theme.rozowy
                        }

                        IconCircle {
                            iconSource: Theme.icon("moon")
                            fillColor: Theme.fiolet
                        }
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
        activeColor: Theme.rozowy
    }
}
