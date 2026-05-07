import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Item {
    id: root

    signal addCard()
    signal editCard(int cardId, string front, string back)

    property FlashcardController flashcardController

    ListView {
        anchors.fill: parent
        anchors.margins: Theme.spacing
        spacing: 10
        clip: true

        model: root.flashcardController.cards

        delegate: AppCard {
            width: ListView.view.width
            height: 76
            autoWidthToContent: false

            RowLayout {
                anchors.fill: parent
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    spacing: 2

                    Text {
                        text: model.front
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textPrimary

                        Layout.fillWidth: true
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }

                    Text {
                        text: model.back
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textSecondary

                        Layout.fillWidth: true
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    spacing: 2
                    Layout.minimumWidth: 0

                    Text {
                        text: root.reviewTimeText(model.dueAt)
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textMuted
                    }

                    AppIconButton {
                        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Edit.svg"
                        iconColor: Theme.colors.primary
                        showBackground: false
                        showBorder: false
                        onClicked: root.editCard(model.cardId, model.front, model.back)
                    }
                }
            }
        }
    }

    AppButton {
        text: "Add card"

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.spacing

        onClicked: root.addCard()
    }

    function reviewTimeText(dueAt) {
        const due = new Date(dueAt)
        const now = new Date()
        const diffMs = due.getTime() - now.getTime()

        if (diffMs <= 0)
            return "Due now"

        const diffMinutes = Math.ceil(diffMs / 60000)

        if (diffMinutes < 60)
            return "Due in " + diffMinutes + " min"

        const diffHours = Math.ceil(diffMinutes / 60)

        if (diffHours < 24)
            return "Due in " + diffHours + " h"

        const diffDays = Math.ceil(diffHours / 24)
        return "Due in " + diffDays + " d"
    }
}