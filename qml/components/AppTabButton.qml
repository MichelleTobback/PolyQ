import QtQuick
import QtQuick.Controls

import PolyQ.Theme

TabButton {
    id: root

    property bool selected: TabBar.tabBar
                            && TabBar.tabBar.currentIndex === TabBar.index
    
    scale: root.down ? 0.82 : 1.0
    implicitHeight: 42

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutCubic
        }
    }

    background: Rectangle {
        id: backgroundRect

        radius: Theme.radiusMedium

        color: root.selected
            ? Theme.colors.primary
            : Theme.colors.surface

        border.width: root.selected ? 0 : 2
        border.color: Theme.colors.border

        scale: root.targetScale

        Behavior on scale {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }

        SequentialAnimation {
            id: scaleShakeAnimation

            running: root.selected
            loops: 1

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 0.92
                duration: 60
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 1.08
                duration: 90
                easing.type: Easing.OutBack
            }

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 0.97
                duration: 70
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 1.0
                duration: 90
                easing.type: Easing.OutElastic
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

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }
    }
}