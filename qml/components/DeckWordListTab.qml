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

    property bool selectionMode: false
    property var selectedCardIds: ({})

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
            borderColor: root.isSelected(model.cardId)
             ? Theme.colors.primary
             : Theme.colors.border
             borderWidth: root.isSelected(model.cardId)
             ? 2
             : 1

            scale: cardTouch.pressed ? 0.97 : 1.0
            transformOrigin: Item.Center

            Behavior on scale {
                NumberAnimation {
                    duration: Theme.animationFast
                    easing.type: Easing.OutCubic
                }
            }

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
                        visible: !root.selectionMode
                        text: root.reviewTimeText(model.dueAt)
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textMuted
                    }

                    Rectangle {
                        visible: root.selectionMode

                        Layout.alignment: Qt.AlignVCenter

                        width: 24
                        height: 24
                        radius: width / 2

                        color: root.isSelected(model.cardId)
                               ? Theme.colors.primary
                               : "transparent"

                        border.width: 2
                        border.color: root.isSelected(model.cardId)
                                      ? Theme.colors.primary
                                      : Theme.colors.border

                        Image {
                            anchors.centerIn: parent

                            visible: root.isSelected(model.cardId)

                            width: 14
                            height: 14

                            source: "qrc:/qt/qml/PolyQ/resources/icons/Check.svg"

                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                        }
                    }

                    AppIconButton {
                        visible: !root.selectionMode
                        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Edit.svg"
                        iconColor: Theme.colors.primary
                        showBackground: false
                        showBorder: false
                        onClicked: root.editCard(model.cardId, model.front, model.back)
                    }
                }
            }

            TapHandler {
                id: cardTouch

                acceptedButtons: Qt.LeftButton

                onTapped: {
                    if (root.selectionMode)
                        root.toggleSelection(model.cardId)
                }

                onLongPressed: {
                    root.enterSelectionMode(model.cardId)
                }
            }
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.spacing

        height: Theme.buttonHeight

        AppButton {
            visible: !root.selectionMode

            anchors.fill: parent

            text: "Add card"

            onClicked: root.addCard()
        }

        RowLayout {
            visible: root.selectionMode

            anchors.fill: parent
            spacing: 8

            AppButton {
                text: "Select all"
                Layout.fillWidth: true

                onClicked: root.selectAll()
            }

            AppButton {
                text: "Deselect all"
                Layout.fillWidth: true

                onClicked: root.clearSelection()
            }

            AppIconButton {
                iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Bin.svg"
                iconColor: Theme.colors.error
                showBackground: false
                showBorder: false
                onClicked: root.deleteSelected()
            }
        }
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

    function isSelected(cardId) {
        return selectedCardIds[cardId] === true
    }

    function enterSelectionMode(cardId) {
        selectionMode = true

        const updated = Object.assign({}, selectedCardIds)
        updated[cardId] = true
        selectedCardIds = updated
    }

    function toggleSelection(cardId) {
        if (!selectionMode)
            return

        const updated = Object.assign({}, selectedCardIds)

        if (updated[cardId])
            delete updated[cardId]
        else
            updated[cardId] = true

        selectedCardIds = updated

        if (Object.keys(selectedCardIds).length === 0)
            selectionMode = false
    }

    function selectAll() {
        const updated = {}

        for (let i = 0; i < root.flashcardController.cards.rowCount(); ++i) {
            const card = root.flashcardController.cards.get(i)
            updated[card.cardId] = true
        }

        selectedCardIds = updated
        selectionMode = Object.keys(selectedCardIds).length > 0
    }

    function clearSelection() {
        selectedCardIds = ({})
        selectionMode = false
    }

    function selectedIdsArray() {
        return Object.keys(selectedCardIds).map(id => Number(id))
    }

    function deleteSelected() {
        const ids = selectedIdsArray()

        if (ids.length === 0)
            return

        root.flashcardController.deleteCards(ids)

        selectedCardIds = ({})
        selectionMode = false
    }
}