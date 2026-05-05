import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Page {
    id: root

    signal back()

    property FlashcardController flashcardController

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.colors.backgroundTop }
            GradientStop { position: 1.0; color: Theme.colors.backgroundBottom }
        }
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

            Text {
                text: (root.flashcardController.cardIndex + 1) + " / " + root.flashcardController.cardCount
                font.pixelSize: Theme.fontBody
                color: Theme.colors.textSecondary
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
            onClicked: root.showingAnswer = true
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
}