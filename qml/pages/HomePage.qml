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
    contentSpacing: 0

    headerRight: AppIconButton {
        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Cog.svg"
        iconColor: Theme.colors.textOnPrimary
        showBackground: false
        showBorder: false

        onClicked: root.openSettings()
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 4
    }

    AppCard {
        Layout.fillWidth: true
        autoHeightToContent: true
        padding: 14

        ColumnLayout {
            width: parent.width
            spacing: 10

            Text {
                text: "Welcome back"
                font.pixelSize: Theme.fontHeading
                font.bold: true
                color: Theme.colors.textPrimary

                Layout.fillWidth: true
            }

            Text {
                text: "Review your decks and keep your streak alive."
                font.pixelSize: Theme.fontBody
                color: Theme.colors.textSecondary
                wrapMode: Text.WordWrap

                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                AppButton {
                    Layout.fillWidth: true
                    text: "Create deck"

                    onClicked: root.flashcardController.createDeck("New Deck")
                }

                AppButton {
                    Layout.fillWidth: true
                    text: "Import"

                    buttonColor: Theme.colors.surface
                    pressedColor: Theme.colors.surfaceVariant
                    textColor: Theme.colors.textPrimary

                    onClicked: root.flashcardController.importDeck()
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: "Your decks"
                font.pixelSize: Theme.fontHeading
                font.bold: true
                color: Theme.colors.textPrimary
            }

            Text {
                text: "Choose a deck to start reviewing"
                font.pixelSize: Theme.fontSmall
                color: Theme.colors.textSecondary
            }
        }
    }

    Text {
        visible: deckList.count === 0
        text: "No decks yet. Create your first deck to get started."
        font.pixelSize: Theme.fontBody
        color: Theme.colors.textSecondary
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    ListView {
        id: deckList

        visible: count > 0

        Layout.fillWidth: true
        Layout.fillHeight: true

        spacing: Theme.spacing
        clip: true

        model: root.flashcardController.decks

        delegate: DeckCard {
            width: deckList.width

            title: model.title
            subtitle: model.subtitle
            enabled: model.enabled
            opacity: model.enabled ? 1.0 : 0.55
            

            onClicked: {
                root.flashcardController.selectDeck(model.deckId)
                root.openDeck()
            }
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOff
        }

        add: Transition {
            NumberAnimation {
                properties: "opacity"
                from: 0
                to: 1
                duration: 180
            }

            NumberAnimation {
                properties: "scale"
                from: 0.96
                to: 1.0
                duration: 180
            }
        }

        displaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: 180
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 4
    }
}