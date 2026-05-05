import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme

Page {
    id: root

    signal back()

    background: Rectangle {
        color: Theme.colors.background
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.spacing

        AppBackButton {
            onClicked: root.back()
        }

        Text {
            text: "Appearance"
            font.pixelSize: Theme.fontTitle
            font.bold: true
            color: Theme.colors.textPrimary
        }

        Text {
            text: "Choose your theme"
            font.pixelSize: Theme.fontBody
            color: Theme.colors.textSecondary
        }

        AppButton {
            text: Theme.currentTheme === "pastel" ? "Pastel Pink" : "Pastel Pink"
            Layout.fillWidth: true
            onClicked: Theme.setTheme("pastel")
        }

        AppButton {
            text: Theme.currentTheme === "dark" ? "Dark" : "Dark"
            Layout.fillWidth: true
            onClicked: Theme.setTheme("dark")
        }

        Item {
            Layout.fillHeight: true
        }
    }
}