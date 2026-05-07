import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    signal openDeck()
    signal openSettings()

    property FlashcardController flashcardController

    pageTitle: "PolyQ"
    titleColor: Theme.colors.textOnPrimary

    headerRight: AppIconButton {
        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Cog.svg"
        iconColor: Theme.colors.textOnPrimary
        showBackground: false
        showBorder: false
        onClicked: root.openSettings()
    }

    Text {
        text: "Learn smarter, review daily"
        font.pixelSize: Theme.fontBody
        color: Theme.colors.textSecondary
    }

    Text {
        text: "Your decks"
        font.pixelSize: Theme.fontHeading
        font.bold: true
        color: Theme.colors.textPrimary
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Theme.spacing

        model: root.flashcardController.decks

        delegate: DeckCard {
            width: ListView.view.width

            title: model.title
            subtitle: model.subtitle
            enabled: model.enabled
            opacity: model.enabled ? 1.0 : 0.55

            onClicked: {
                root.flashcardController.selectDeck(deckId)
                root.openDeck()
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true

        AppButton {
            Layout.fillWidth: true
            text: "Create"

            onClicked: root.flashcardController.createDeck("New Deck")
        }

        AppButton {
            Layout.fillWidth: true
            text: "Import"

            onClicked: root.flashcardController.importDeck()
        }
    }
}