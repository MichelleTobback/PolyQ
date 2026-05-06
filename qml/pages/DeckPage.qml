import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Page {
    id: root

    property FlashcardController flashcardController

    signal back()
    signal startReview()

    background: Rectangle {
        color: Theme.colors.background
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.spacing

        RowLayout {
            Layout.fillWidth: true

            AppBackButton {
                onClicked: root.back()
            }

            Item {
                Layout.fillWidth: true
            }

            AppIconButton {
                text: "✏"
            }
        }

        Text {
            text: flashcardController.currentDeck.title
            font.pixelSize: Theme.fontTitle
            font.bold: true
            color: Theme.colors.textPrimary
            Layout.fillWidth: true
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

            Layout.leftMargin: -Theme.pageMargin
            Layout.rightMargin: -Theme.pageMargin

            Layout.fillWidth: true
            clip: true

            currentIndex: tabBar.currentIndex
            onCurrentIndexChanged: tabBar.currentIndex = currentIndex

            DeckOverviewTab {
                flashcardController: root.flashcardController
                onStartReview: root.startReview()
            }

            DeckWordListTab {
                flashcardController: root.flashcardController
            }

            DeckStatsTab {}
        }
    }
}