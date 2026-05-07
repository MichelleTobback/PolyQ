import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    pageTitle: flashcardController.currentDeck.title
    showBackButton: true

    property FlashcardController flashcardController

    signal back()
    signal editDeck()
    signal addCard()
    signal editCard(int cardId, string front, string back)
    signal startDueReview()
    signal startEndlessReview()

    onBackClicked: root.back()

    headerRight: AppIconButton {
        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Edit.svg"
        onClicked: root.editDeck()
    }

    AppTabBar {
        id: tabBar
        Layout.fillWidth: true

        AppTabButton { text: "Overview" }
        AppTabButton { text: "Word list" }
        AppTabButton { text: "Stats" }
    }

    SwipeView {
        id: swipeView

        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.leftMargin: -Theme.pageMargin
        Layout.rightMargin: -Theme.pageMargin

        clip: true

        currentIndex: tabBar.currentIndex
        onCurrentIndexChanged: tabBar.currentIndex = currentIndex

        DeckOverviewTab {
            flashcardController: root.flashcardController
            onStartDueReview: root.startDueReview()
            onStartEndlessReview: root.startEndlessReview()
        }

        DeckWordListTab {
            flashcardController: root.flashcardController
            onAddCard: root.addCard()
            onEditCard: function(cardId, front, back) {
                root.editCard(cardId, front, back)
            }
        }

        DeckStatsTab {}
    }
}