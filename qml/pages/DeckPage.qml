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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.spacing

        AppBackButton {
            onClicked: root.back()
        }

        Text {
            text: "French Basics"
            font.pixelSize: Theme.fontTitle
            font.bold: true
            color: Theme.colors.textPrimary
            Layout.fillWidth: true
        }

        Text {
            text: "Review vocabulary using spaced repetition."
            font.pixelSize: Theme.fontBody
            color: Theme.colors.textSecondary
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        AppCard {
            Layout.fillWidth: true
            Layout.preferredHeight: 130

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.cardPadding
                spacing: 8

                Text {
                    text: "Today"
                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textSecondary
                }

                Text {
                    text: "3 cards due"
                    font.pixelSize: 30
                    font.bold: true
                    color: Theme.colors.textPrimary
                }
            }
        }

        AppButton {
            text: "Start review"
            Layout.fillWidth: true
            onClicked: root.startReview()
        }

        Item {
            Layout.fillHeight: true
        }
    }
}