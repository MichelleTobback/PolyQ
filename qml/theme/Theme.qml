pragma Singleton

import QtQuick

QtObject {
    id: root

    property string currentTheme: "pastel"

    property var pastel: PastelTheme {}
    property var dark: DarkTheme {}

    readonly property var colors: currentTheme === "dark" ? dark : pastel

    function setTheme(name) {
        if (name !== "pastel" && name !== "dark")
            return

        currentTheme = name
    }

    readonly property int pageMargin: 12
    readonly property int spacing: 12
    readonly property int cardPadding: 18

    readonly property int radiusMedium: 18
    readonly property int radiusLarge: 24
    readonly property int radiusCard: 32

    readonly property int fontTitle: 36
    readonly property int fontHeading: 26
    readonly property int fontBody: 16
    readonly property int fontSmall: 14

    readonly property int buttonHeight: 48

    readonly property int animationFast: 120
    readonly property int animationMedium: 200
    readonly property int animationSlow: 500
}