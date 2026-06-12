pragma Singleton

import QtQuick

QtObject {
    id: theme

    readonly property color rudyKotek: "#FF9E3D"
    readonly property color brzoskwinia: "#FFD9B5"
    readonly property color zoltySloneczny: "#FFD54F"
    readonly property color rozowy: "#FF8FB1"
    readonly property color blekit: "#A8D8FF"
    readonly property color mieta: "#A8E6C1"
    readonly property color zielen: "#7ED957"
    readonly property color fiolet: "#C9A8FF"
    readonly property color granat: "#25314F"
    readonly property color krem: "#FFF9F2"
    readonly property color bialy: "#FFFFFF"
    readonly property color granica: "#F3E1D3"
    readonly property color cien: "#330F1F3D"

    readonly property string headingFont: "Fredoka"
    readonly property string bodyFont: "Nunito"

    readonly property url bgRain: Qt.resolvedUrl("../assets/backgrounds/bg-rain.png")
    readonly property url bgNight: Qt.resolvedUrl("../assets/backgrounds/bg-night.png")
    readonly property url bgSun: Qt.resolvedUrl("../assets/backgrounds/bg-sun.png")

    function icon(name) {
        return Qt.resolvedUrl("../assets/icons/transparent/" + name + ".png")
    }

    function illustration(name) {
        return Qt.resolvedUrl("../assets/illustrations/transparent/" + name + ".png")
    }
}
