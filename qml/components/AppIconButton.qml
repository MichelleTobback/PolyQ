import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl

import PolyQ.Theme

Button {
    id: root

    property url iconSource: ""
    property color iconColor: Theme.colors.textPrimary
    property int iconSize: 22

    property bool showBackground: true
    property bool showBorder: true

    implicitWidth: 44
    implicitHeight: 44

    background: Rectangle {
        radius: Theme.radiusMedium

        color: root.showBackground
               ? (root.down ? Theme.colors.surfacePressed : Theme.colors.surface)
               : "transparent"

        border.width: root.showBorder ? 1 : 0
        border.color: Theme.colors.border
    }

    contentItem: Item {
        anchors.fill: parent

        IconImage {
            anchors.centerIn: parent
            visible: root.iconSource !== ""

            width: root.iconSize
            height: root.iconSize

            source: root.iconSource
            color: root.iconColor
        }

        Text {
            anchors.centerIn: parent
            visible: root.iconSource === ""

            text: root.text
            font.pixelSize: Theme.fontBody
            color: Theme.colors.textPrimary
        }
    }
}