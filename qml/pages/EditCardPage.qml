import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    pageTitle: root.isEditing ? "Edit card" : "Add card"
    showBackButton: true

    property FlashcardController flashcardController

    property int cardId: -1
    property string frontText: ""
    property string backText: ""

    readonly property bool isEditing: cardId >= 0

    signal back()

    onBackClicked: root.back()

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
                Layout.preferredHeight: 80
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
                Layout.preferredHeight: 80
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
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        Layout.preferredWidth: parent.width / 2
        Layout.preferredHeight: Theme.buttonHeight

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