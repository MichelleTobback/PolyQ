import QtQuick
import QtQuick.Controls

import PolyQ.Pages
import PolyQ.Components
import PolyQ.Theme

import PolyQ.Controllers 1.0

ApplicationWindow {
    id: window

    width: 405
    height: 900
    visible: true
    title: "PolyQ"
    color: Theme.background
    topPadding: 0

    Shortcut {
        sequences: [StandardKey.Back, "Esc"]

        onActivated: {
            if (stack.depth > 1)
                stack.pop()
        }
    }

    FlashcardController {
        id: flashController
    }

    Loader {
        id: backgroundLoader

        anchors {
            fill: parent

            topMargin: -SafeArea.margins.top
            bottomMargin: -SafeArea.margins.bottom
        }

        z: -1

        sourceComponent: Theme.colors.backgroundType === 1
            ? solidBackgroundComponent
            : animatedBackgroundComponent
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

            onStartDueReview: {
                flashController.startDueReview()
                stack.push(reviewPageComponent)
            }

            onStartEndlessReview: {
                flashController.startEndlessReview()
                stack.push(reviewPageComponent)
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

    Component {
        id: solidBackgroundComponent

        Rectangle {
            color: Theme.colors.background
        }
    }

    Component {
        id: animatedBackgroundComponent

        PageBackground {
        }
    }

    Component {
        id: reviewModeSelectionPageComponent

        ReviewModeSelectionPage {
            onBack: stack.pop()
            onStartReview: stack.replace(reviewPageComponent)
        }
    }

    function openReviewModeSelection(sessionMode) {
        stack.push(reviewModeSelectionPageComponent, {
            flashcardController: flashController,
            sessionMode: sessionMode
        })
    }
}