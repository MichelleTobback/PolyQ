import QtQuick
import QtQuick.Controls

import PolyQ.Pages

import PolyQ.Controllers 1.0

ApplicationWindow {
    id: window

    width: 405
    height: 900
    visible: true
    title: "PolyQ"

    FlashcardController {
    id: flashController
}

    StackView {
        id: stack
        anchors.fill: parent

        initialItem: HomePage {
            flashcardController: flashController
            onOpenDeck: stack.push(deckPageComponent)
            onOpenSettings: stack.push(settingsPageComponent)
        }
    }

    Component {
        id: deckPageComponent

        DeckPage {
            flashcardController: flashController

            onBack: stack.pop()
            onStartReview: stack.push(reviewPageComponent)
            onEditDeck: stack.push(editDeckComponent)

            onAddCard: stack.push(editCardComponent, {
                flashcardController: flashController,
                cardId: -1,
                frontText: "",
                backText: ""
            })

            onEditCard: function(cardId, front, back) {
                stack.push(editCardComponent, {
                    flashcardController: flashController,
                    cardId: cardId,
                    frontText: front,
                    backText: back
                })
            }
        }
    }

    Component {
        id: reviewPageComponent

        ReviewPage {
            flashcardController: flashController
            onBack: stack.pop()
        }
    }

    Component {
        id: settingsPageComponent

        SettingsPage {
            onBack: stack.pop()
        }
    }

    Component {
        id: editDeckComponent

        EditDeckPage {
            flashcardController: flashController
            onBack: stack.pop()
        }
    }

    Component {
        id: editCardComponent

        EditCardPage {
            flashcardController: flashController
            onBack: stack.pop()
        }
    }
}