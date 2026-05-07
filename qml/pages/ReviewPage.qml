import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    pageTitle: flashcardController.currentDeck.title
    showBackButton: true

    property FlashcardController flashcardController

    signal back()

    onBackClicked: root.back()

    RowLayout {
        Layout.fillWidth: true

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: (root.flashcardController.cardIndex + 1)
                  + " / "
                  + root.flashcardController.currentDeck.cardCount

            font.pixelSize: Theme.fontBody
            color: Theme.colors.textSecondary

            Layout.alignment: Qt.AlignTop | Qt.AlignRight
        }
    }

    FlashcardView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        controller: root.flashcardController
    }

    AppButton {
        id: revealButton

        visible: !root.flashcardController.showingAnswer

        text: "Show answer"

        Layout.fillWidth: true

        onClicked: root.flashcardController.showingAnswer = true
    }

    RowLayout {
        visible: root.flashcardController.showingAnswer

        Layout.fillWidth: true
        spacing: 8

        AppButton {
            text: "Again"

            buttonColor: Theme.colors.danger
            pressedColor: Theme.colors.dangerPressed

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewAgain()
        }

        AppButton {
            text: "Hard"

            buttonColor: Theme.colors.warning
            pressedColor: Theme.colors.warningPressed

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewHard()
        }

        AppButton {
            text: "Good"

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewGood()
        }

        AppButton {
            text: "Easy"

            buttonColor: Theme.colors.success
            pressedColor: Theme.colors.successPressed

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewEasy()
        }
    }
}