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

    AppItemList {
        anchors.fill: parent

        model: root.flashcardController.cards
        idRoleName: "cardId"
        allItemIds: root.cardIds()

        onAddClicked: root.addCard()

        onDeleteRequested: function(ids) {
            root.flashcardController.deleteCards(ids)
        }

        itemContent: Component {
            RowLayout {
                property var itemModel
                property int itemId
                property bool selected
                property bool selectionMode
                property var list

                anchors.fill: parent
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    spacing: 2

                    Text {
                        text: itemModel.front
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textPrimary
                        
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }

                    Text {
                        text: itemModel.back
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textSecondary
                        
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    spacing: 2
                    Layout.minimumWidth: 0
                    visible: !selectionMode

                    Text {
                        text: root.reviewTimeText(itemModel.dueAt)
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textMuted
                    }

                    AppIconButton {
                        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Edit.svg"
                        iconColor: Theme.colors.primary
                        showBackground: false
                        showBorder: false

                        onClicked: root.editCard(
                            itemModel.cardId,
                            itemModel.front,
                            itemModel.back
                        )
                    }
                }
            }
        }

        normalToolbar: Component {
            AppButton {
                property var list

                text: "Add card"
                anchors.fill: parent

                onClicked: list.addClicked()
            }
        }

        selectionToolbar: Component {
            RowLayout {
                property var list

                anchors.fill: parent
                spacing: 8

                AppButton {
                    text: "Select all"
                    Layout.fillWidth: true

                    onClicked: list.selectAll()
                }

                AppButton {
                    text: "Deselect all"
                    Layout.fillWidth: true

                    onClicked: list.clearSelection()
                }

                AppIconButton {
                    iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Bin.svg"
                    iconColor: Theme.colors.error
                    showBackground: false
                    showBorder: false

                    onClicked: list.requestDeleteSelected()
                }
            }
        }
    }

    function cardIds() {
        const ids = []

        for (let i = 0; i < root.flashcardController.cards.rowCount(); ++i) {
            const card = root.flashcardController.cards.get(i)
            ids.push(card.cardId)
        }

        return ids
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