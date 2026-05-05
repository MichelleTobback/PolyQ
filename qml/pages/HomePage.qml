import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Page {
    id: root

    signal openDeck()
    signal openSettings()

    property FlashcardController flashcardController

    background: Rectangle {
        color: Theme.colors.background
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "PolyQ"
                    font.pixelSize: Theme.fontTitle
                    font.bold: true
                    color: Theme.colors.textPrimary
                }

                Text {
                    text: "Learn smarter, review daily"
                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textSecondary
                }
            }

            AppIconButton {
                text: "⚙"
                onClicked: root.openSettings()
            }
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
                    flashcardController.selectDeck(deckId)
                    openDeck()
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
}