import QtQuick
import QtQuick.Controls

import PolyQ.Theme

Button {
    id: root

    property color buttonColor: Theme.colors.primary
    property color pressedColor: Theme.colors.primaryPressed
    property color dissabledColor: Theme.colors.surfaceDisabled
    property color textColor: Theme.colors.textOnPrimary

    height: Theme.buttonHeight

    scale: root.down ? 0.96 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutCubic
        }
    }

    background: Rectangle {
        radius: Theme.radiusMedium
        color: root.enabled
               ? root.down ? root.pressedColor : root.buttonColor
               : root.dissabledColor

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }
    }

    contentItem: Text {
        text: root.text
        color: root.enabled ? root.textColor : Theme.colors.textMuted
        font.pixelSize: Theme.fontBody
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}