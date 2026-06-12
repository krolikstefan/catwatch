import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: "Relaks"
            font.pixelSize: 24
        }

        Label {
            text: apiClient.relaxStatus
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: apiClient.exercises
            spacing: 8

            delegate: Frame {
                required property var modelData
                width: ListView.view.width

                RowLayout {
                    anchors.fill: parent

                    ColumnLayout {
                        Layout.fillWidth: true

                        Label {
                            text: modelData.name
                            wrapMode: Text.Wrap
                        }

                        Label {
                            text: modelData.durationSeconds + " s"
                        }
                    }

                    Button {
                        enabled: !modelData.completed
                        text: modelData.completed ? "Gotowe" : "Ukończ"
                        onClicked: apiClient.completeExercise(modelData.id)
                    }
                }
            }
        }
    }
}
