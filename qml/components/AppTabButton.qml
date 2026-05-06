import QtQuick
import QtQuick.Controls

import PolyQ.Theme

TabButton {
    id: root

    property bool selected: TabBar.tabBar && TabBar.tabBar.currentIndex === TabBar.index

    implicitHeight: 42

    background: Rectangle {
        radius: Theme.radiusMedium

        color: root.selected
            ? Theme.colors.primary
            : Theme.colors.surface

        border.width: root.selected ? 0 : 1
        border.color: Theme.colors.outline

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }
    }

    contentItem: Text {
        text: root.text
        font.pixelSize: Theme.fontBody
        font.bold: root.selected

        color: root.selected
            ? Theme.colors.textOnPrimary
            : Theme.colors.textPrimary

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}