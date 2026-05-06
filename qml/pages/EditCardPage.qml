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

                TextArea {
                    id: frontField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 120

                    text: root.frontText
                    placeholderText: "Question, word or phrase"

                    wrapMode: TextArea.Wrap
                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textPrimary

                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter

                    background: Rectangle {
                        radius: Theme.radiusMedium
                        color: Theme.colors.surfaceSoft
                        border.width: 1
                        border.color: frontField.activeFocus ? Theme.colors.primary : Theme.colors.border
                    }
                }

                Text {
                    text: "Back"
                    font.pixelSize: Theme.fontBody
                    font.bold: true
                    color: Theme.colors.textSecondary
                }

                TextArea {
                    id: backField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 120

                    text: root.backText
                    placeholderText: "Answer or translation"

                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter

                    wrapMode: TextArea.Wrap
                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textPrimary

                    background: Rectangle {
                        radius: Theme.radiusMedium
                        color: Theme.colors.surfaceSoft
                        border.width: 1
                        border.color: backField.activeFocus ? Theme.colors.primary : Theme.colors.border
                    }
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