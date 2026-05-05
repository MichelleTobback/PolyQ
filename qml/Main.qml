import QtQuick
import QtQuick.Controls

import PolyQ.Pages

import PolyQ.Controllers 1.0

ApplicationWindow {
    id: window

    width: 390
    height: 844
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
}