import QtQuick
import QtQuick.Effects
import PolyQ.Theme

Item {
    id: root

    default property alias content: contentItem.data

    property real radius: Theme.radiusCard
    property color color: Theme.colors.surface

    Rectangle {
        id: card
        anchors.fill: parent
        radius: root.radius
        color: root.color
        border.width: 1
        border.color: Theme.colors.border
    }

    MultiEffect {
        anchors.fill: card
        source: card
        shadowEnabled: true
        shadowColor: Theme.colors.shadow
        shadowBlur: 0.45
        shadowVerticalOffset: 8
        shadowHorizontalOffset: 0
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}