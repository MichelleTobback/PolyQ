import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme

AppPage {
    id: root

    pageTitle: "Appearance"
    showBackButton: true

    signal back()

    onBackClicked: root.back()

    Text {
        text: "Choose your theme"
        font.pixelSize: Theme.fontBody
        color: Theme.colors.textSecondary
    }

    AppButton {
        text: Theme.currentTheme === "pastel"
              ? "✓ Pastel Pink"
              : "Pastel Pink"

        Layout.fillWidth: true

        onClicked: Theme.setTheme("pastel")
    }

    AppButton {
        text: Theme.currentTheme === "dark"
              ? "✓ Dark"
              : "Dark"

        Layout.fillWidth: true

        onClicked: Theme.setTheme("dark")
    }

    Item {
        Layout.fillHeight: true
    }
}