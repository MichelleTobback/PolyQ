import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Page {
    id: root

    property FlashcardController flashcardController

    property int cardId: -1
    property string frontText: ""
    property string backText: ""

    readonly property bool isEditing: cardId >= 0

    signal back()

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

            Text {
                text: root.isEditing ? "Edit card" : "Add card"
                font.pixelSize: Theme.fontHeading
                font.bold: true
                color: Theme.colors.textPrimary
                Layout.fillWidth: true
            }
        }

        AppCard {
            Layout.fillWidth: true
            autoHeightToContent: true

            ColumnLayout {
                width: parent.width
                spacing: 14

                Text {
                    text: "Front"
                    font.pixelSize: Theme.fontBody
                    font.bold: true
                    color: Theme.colors.textSecondary
                }

                AppTextArea {
                    id: frontField
                    Layout.fillWidth: true
                    text: root.frontText
                    animatedPlaceholder: "Question, word or phrase"
                }

                Text {
                    text: "Back"
                    font.pixelSize: Theme.fontBody
                    font.bold: true
                    color: Theme.colors.textSecondary
                }

                AppTextArea {
                    id: backField
                    Layout.fillWidth: true
                    text: root.backText
                    animatedPlaceholder: "Answer or translation"
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        AppButton {
            text: root.isEditing ? "Save changes" : "Create card"
            Layout.fillWidth: true

            onClicked: {
                if (root.isEditing) {
                    root.flashcardController.updateCard(
                        root.cardId,
                        frontField.text,
                        backField.text
                    )
                } else {
                    root.flashcardController.createCard(
                        frontField.text,
                        backField.text
                    )
                }

                root.back()
            }
        }
    }
}