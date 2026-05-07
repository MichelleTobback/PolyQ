import QtQuick
import QtQuick.Controls

import PolyQ.Theme

Button {
    id: root

    property color buttonColor: Theme.colors.primary
    property color pressedColor: Theme.colors.primaryPressed
    property color dissabledColor: Theme.colors.surfaceDisabled
    property color textColor: Theme.colors.textOnPrimary
    property int textSize: Theme.fontBody
    property int minimumTextSize: 10

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

        color: root.enabled
               ? root.textColor
               : Theme.colors.textMuted

        font.bold: true

        font.pixelSize: root.textSize
        fontSizeMode: Text.Fit
        minimumPixelSize: root.minimumTextSize

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        anchors.fill: parent

        elide: Text.ElideNone
    }
}