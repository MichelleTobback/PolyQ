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
    property var acceptedAnswers: []
    property var acceptedAnswerFields: []

    readonly property bool isEditing: cardId >= 0

    signal back()

    onBackClicked: root.back()

    Component.onCompleted: root.loadAcceptedAnswers()
    onAcceptedAnswersChanged: root.loadAcceptedAnswers()

    function clearAcceptedAnswerFields() {
        for (let i = 0; i < root.acceptedAnswerFields.length; ++i) {
            const item = root.acceptedAnswerFields[i]

            if (item)
                item.destroy()
        }

        root.acceptedAnswerFields = []
    }

    function loadAcceptedAnswers() {
        root.clearAcceptedAnswerFields()

        for (let i = 0; i < root.acceptedAnswers.length; ++i)
            root.addAcceptedAnswerField(root.acceptedAnswers[i])
    }

    function collectAcceptedAnswers() {
        let answers = []
        let seen = {}

        const mainAnswerKey = backField.text.trim().toLocaleLowerCase()

        for (let i = 0; i < root.acceptedAnswerFields.length; ++i) {
            const item = root.acceptedAnswerFields[i]

            if (!item)
                continue

            const text = item.answerText.trim()
            const key = text.toLocaleLowerCase()

            if (text.length <= 0)
                continue

            if (key === mainAnswerKey)
                continue

            if (seen[key] === true)
                continue

            answers.push(text)
            seen[key] = true
        }

        return answers
    }

    function addAcceptedAnswerField(text = "") {
        const item = acceptedAnswerFieldComponent.createObject(
            acceptedAnswersColumn
        )

        if (!item)
            return

        item.answerText = text
        root.acceptedAnswerFields =
                root.acceptedAnswerFields.concat([item])
    }

    Component {
        id: acceptedAnswerFieldComponent

        RowLayout {
            property alias answerText: answerField.text

            Layout.fillWidth: true
            spacing: 8

            AppTextArea {
                id: answerField

                Layout.fillWidth: true
                Layout.preferredHeight: 54

                animatedPlaceholder: "Alternative answer"
            }

            AppIconButton {
                Layout.preferredWidth: Theme.buttonHeight
                Layout.preferredHeight: Theme.buttonHeight
                Layout.alignment: Qt.AlignTop

                iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Bin.svg"
                iconColor: Theme.colors.danger

                showBackground: true
                showBorder: true

                onClicked: {
                    const index = root.acceptedAnswerFields.indexOf(parent)

                    if (index >= 0)
                        root.acceptedAnswerFields.splice(index, 1)

                    root.acceptedAnswerFields = root.acceptedAnswerFields

                    parent.destroy()
                }
            }
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
                animatedPlaceholder: "Main answer or translation"
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.colors.borderSoft
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Accepted answers"
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textSecondary
                    }

                    Text {
                        text: "Optional alternatives like romaji, synonyms or spelling variants."
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textMuted
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }

                AppIconButton {
                    Layout.preferredWidth: Theme.buttonHeight
                    Layout.preferredHeight: Theme.buttonHeight

                    iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Add.svg"
                    iconColor: Theme.colors.primary

                    showBackground: true
                    showBorder: true

                    onClicked: root.addAcceptedAnswerField()
                }
            }

            ColumnLayout {
                id: acceptedAnswersColumn

                Layout.fillWidth: true
                spacing: 8
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
            const answers = root.collectAcceptedAnswers()

            if (root.isEditing) {
                root.flashcardController.updateCard(
                    root.cardId,
                    frontField.text,
                    backField.text,
                    answers
                )
            } else {
                root.flashcardController.createCard(
                    frontField.text,
                    backField.text,
                    answers
                )
            }

            root.back()
        }
    }
}