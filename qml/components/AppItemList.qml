import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.impl

import PolyQ.Components
import PolyQ.Theme

Item {
    id: root

    signal addClicked()
    signal deleteRequested(var ids)
    signal itemClicked(var id)

    property var model
    property string idRoleName: "id"
    property var allItemIds: []

    property Component itemContent
    property Component normalToolbar
    property Component selectionToolbar

    property bool selectionMode: false
    property var selectedItemIds: ({})

    property int itemHeight: 76
    property int itemSpacing: 10

    ListView {
        id: listView

        anchors.fill: parent
        anchors.margins: Theme.spacing
        anchors.bottomMargin: Theme.spacing + Theme.buttonHeight + Theme.spacing

        spacing: root.itemSpacing
        clip: true
        model: root.model

        delegate: AppCard {
            id: card

            width: ListView.view.width
            height: root.itemHeight
            autoWidthToContent: false

            readonly property int itemId: model[root.idRoleName]

            readonly property real visibleTop: listView.contentY
            readonly property real visibleBottom: listView.contentY + listView.height

            readonly property real visibleHeight: Math.max(
                0,
                Math.min(y + height, visibleBottom) - Math.max(y, visibleTop)
            )

            readonly property real visibleRatio: Math.max(
                0,
                Math.min(1, visibleHeight / height)
            )

            opacity: visibleRatio

            borderColor: root.isSelected(card.itemId)
                         ? Theme.colors.primary
                         : Theme.colors.border
            borderWidth: root.isSelected(card.itemId) ? 2 : 1

            scale: cardTouch.pressed ? 0.97 : 1.0
            transformOrigin: Item.Center

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.animationFast
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: Theme.animationFast
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 8

                Loader {
                    id: contentLoader

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0

                    sourceComponent: root.itemContent

                    onLoaded: {
                        item.itemModel = model
                        item.itemId = card.itemId
                        item.list = root
                    }
                }

                Binding {
                    target: contentLoader.item
                    property: "selected"
                    value: root.isSelected(card.itemId)
                    when: contentLoader.status === Loader.Ready
                }

                Binding {
                    target: contentLoader.item
                    property: "selectionMode"
                    value: root.selectionMode
                    when: contentLoader.status === Loader.Ready
                }

                Rectangle {
                    visible: root.selectionMode

                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24

                    radius: width / 2

                    color: root.isSelected(card.itemId)
                           ? Theme.colors.primary
                           : "transparent"

                    border.width: 2
                    border.color: root.isSelected(card.itemId)
                                  ? Theme.colors.primary
                                  : Theme.colors.border

                    IconImage {
                        anchors.centerIn: parent
                        visible: root.isSelected(card.itemId)

                        width: 14
                        height: 14

                        source: "qrc:/qt/qml/PolyQ/resources/icons/Check.svg"
                        color: Theme.colors.textPrimary
                    }
                }
            }

            TapHandler {
                id: cardTouch

                acceptedButtons: Qt.LeftButton

                onTapped: {
                    if (root.selectionMode)
                        root.toggleSelection(card.itemId)
                    else 
                        root.itemClicked(card.itemId)
                }

                onLongPressed: {
                    root.enterSelectionMode(card.itemId)
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

        Loader {
            anchors.fill: parent
            visible: !root.selectionMode
            sourceComponent: root.normalToolbar

            onLoaded: item.list = root
        }

        Loader {
            anchors.fill: parent
            visible: root.selectionMode
            sourceComponent: root.selectionToolbar

            onLoaded: item.list = root
        }
    }

    function isSelected(itemId) {
        return selectedItemIds[itemId] === true
    }

    function enterSelectionMode(itemId) {
        selectionMode = true

        const updated = Object.assign({}, selectedItemIds)
        updated[itemId] = true
        selectedItemIds = updated
    }

    function toggleSelection(itemId) {
        if (!selectionMode)
            return

        const updated = Object.assign({}, selectedItemIds)

        if (updated[itemId])
            delete updated[itemId]
        else
            updated[itemId] = true

        selectedItemIds = updated

        if (Object.keys(selectedItemIds).length === 0)
            selectionMode = false
    }

    function selectAll() {
        const ids = root.allItemIds || []
        const updated = {}

        for (let i = 0; i < ids.length; ++i)
            updated[ids[i]] = true

        selectedItemIds = updated
        selectionMode = Object.keys(selectedItemIds).length > 0
    }

    function clearSelection() {
        selectedItemIds = ({})
        selectionMode = false
    }

    function selectedIdsArray() {
        return Object.keys(selectedItemIds).map(id => Number(id))
    }

    function requestDeleteSelected() {
        const ids = selectedIdsArray()

        if (ids.length === 0)
            return

        root.deleteRequested(ids)
        clearSelection()
    }
}