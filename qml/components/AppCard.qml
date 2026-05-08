import QtQuick
import QtQuick.Effects

import PolyQ.Theme

Item {
    id: root

    default property alias content: contentItem.data

    property real radius: Theme.radiusCard
    property color color: Theme.colors.surface
    property real padding: Theme.cardPadding

    property color borderColor: Theme.colors.border
    property int borderWidth: 1

    property bool autoWidthToContent: false
    property bool autoHeightToContent: false

    implicitWidth: autoWidthToContent
        ? contentItem.implicitWidth + padding * 2
        : 0

    implicitHeight: autoHeightToContent
        ? contentItem.implicitHeight + padding * 2
        : 0
        

    Rectangle {
        id: card
        anchors.fill: parent
        radius: root.radius
        color: root.color
        border.width: root.borderWidth
        border.color: root.borderColor
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

        x: root.padding
        y: root.padding

        width: root.autoWidthToContent
            ? implicitWidth
            : Math.max(0, root.width - root.padding * 2)

        height: root.autoHeightToContent
            ? implicitHeight
            : Math.max(0, root.height - root.padding * 2)

        implicitWidth: children.length > 0 ? children[0].implicitWidth : 0
        implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
    }
}