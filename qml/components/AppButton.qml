import QtQuick
import QtQuick.Controls

import PolyQ.Theme

Button {
    id: root

    property color buttonColor: Theme.colors.primary
    property color pressedColor: Theme.colors.primaryPressed
    property color textColor: Theme.colors.textOnPrimary

    height: Theme.buttonHeight

    background: Rectangle {
        radius: Theme.radiusMedium
        color: root.down ? root.pressedColor : root.buttonColor

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }
    }

    contentItem: Text {
        text: root.text
        color: root.textColor
        font.pixelSize: Theme.fontBody
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}