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
        visible: root.flashcardController.decks.rowCount() === 0

        text: "No decks yet. Create your first deck to get started."

        font.pixelSize: Theme.fontBody
        color: Theme.colors.textSecondary
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    AppItemList {
        visible: root.flashcardController.decks.rowCount() > 0

        Layout.fillWidth: true
        Layout.fillHeight: true

        model: root.flashcardController.decks
        idRoleName: "deckId"

        itemHeight: 92
        itemSpacing: Theme.spacing

        allItemIds: root.deckIds()

        onDeleteRequested: function(ids) { 
            root.flashcardController.deleteDecks(ids)
        }
        onItemClicked: function(id) {
                root.flashcardController.selectDeck(id)
                root.openDeck()
            }

        itemContent: Component {
            RowLayout {
                property var itemModel
                property int itemId
                property bool selected
                property bool selectionMode
                property var list

                anchors.fill: parent
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    spacing: 2

                    Text {
                        text: itemModel.title
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textPrimary
                        
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }

                    Text {
                        text: itemModel.subtitle
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textSecondary
                        
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }
                }
            }
        }

        normalToolbar: Component {
            Item {
            }
        }

        selectionToolbar: Component {
            RowLayout {
                property var list

                anchors.fill: parent
                spacing: 8

                AppButton {
                    text: "Select all"
                    Layout.fillWidth: true

                    onClicked: list.selectAll()
                }

                AppButton {
                    text: "Deselect all"
                    Layout.fillWidth: true

                    onClicked: list.clearSelection()
                }

                

                AppIconButton {
                    iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Bin.svg"
                    iconColor: Theme.colors.error
                    showBackground: false
                    showBorder: false

                    onClicked: list.requestDeleteSelected()
                }
            }
        }
    }

    function deckIds() {
        const ids = []
        const decks = root.flashcardController.decks

        if (!decks)
            return ids

        for (let i = 0; i < decks.rowCount(); ++i) {
            const deck = decks.get(i)

            if (deck)
                ids.push(deck.deckId)
        }

        return ids
    }
}