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

    transformOrigin: Item.Center
    scale: root.down ? 0.94 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutCubic
        }
    }

    background: Rectangle {
        id: backgroundRect

        radius: Theme.radiusMedium
        scale: 1.0
        transformOrigin: Item.Center

        color: root.enabled
               ? root.down ? root.pressedColor : root.buttonColor
               : root.dissabledColor

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }

        SequentialAnimation {
            id: scaleShakeAnimation
            running: false

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 1.06
                duration: 95
                easing.type: Easing.OutBack
            }

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 0.985
                duration: 85
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 1.025
                duration: 75
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: backgroundRect
                property: "scale"
                to: 1.0
                duration: 110
                easing.type: Easing.OutCubic
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

    onReleased: {
        if (root.enabled) {
            scaleShakeAnimation.restart()
        }
    }
}