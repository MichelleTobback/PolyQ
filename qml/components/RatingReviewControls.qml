import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Theme
import PolyQ.Controllers 1.0

ColumnLayout {
    id: root

    property FlashcardController flashcardController

    AppButton {
        visible: !root.flashcardController.showingAnswer

        text: "Show answer"

        Layout.fillWidth: true

        onClicked: root.flashcardController.showAnswer()
    }

    AppButton {
            visible: root.flashcardController.showReviewFeedback

            text: "Next"

            Layout.fillWidth: true

            onClicked: root.flashcardController.nextCard() 
        }

    RowLayout {
        visible: root.flashcardController.showingAnswer && !root.flashcardController.showReviewFeedback 

        Layout.fillWidth: true
        spacing: 6

        AppButton {
            text: "Again"

            buttonColor: Theme.colors.danger
            pressedColor: Theme.colors.dangerPressed
            textSize: Theme.fontSmall

            padding: 0

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewAgain()
        }

        AppButton {
            text: "Hard"

            buttonColor: Theme.colors.warning
            pressedColor: Theme.colors.warningPressed
            textSize: Theme.fontSmall

            padding: 0

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewHard()
        }

        AppButton {
            text: "Good"

            Layout.fillWidth: true
            textSize: Theme.fontSmall
            padding: 0

            onClicked: root.flashcardController.reviewGood()
        }

        AppButton {
            text: "Easy"

            buttonColor: Theme.colors.success
            pressedColor: Theme.colors.successPressed
            textSize: Theme.fontSmall
            padding: 0

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewEasy()
        }
    }
}