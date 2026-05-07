import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
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
            text: "Next"

            Layout.fillWidth: true

            onClicked: root.flashcardController.reviewGood()
        }
    }
}