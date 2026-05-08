import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl

import PolyQ.Theme

Button {
    id: root

    property url iconSource: ""
    property color iconColor: Theme.colors.textPrimary
    property int iconSize: 22

    property bool showBackground: false
    property bool showBorder: true

    property color backgroundColor: Theme.colors.surface
    property color pressedColor: Theme.colors.surfacePressed
    property color hoverColor: Theme.colors.surfaceHover
    property color borderColor: Theme.colors.border
    property color textColor: Theme.colors.textPrimary

    implicitWidth: 44
    implicitHeight: 44

    padding: 0
    hoverEnabled: true

    scale: root.down ? 0.92 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutCubic
        }
    }

    background: Rectangle {
        radius: Theme.radiusMedium

        color: !root.showBackground
               ? "transparent"
               : root.down
                 ? root.pressedColor
                 : root.hovered
                   ? root.hoverColor
                   : root.backgroundColor

        border.width: root.showBorder ? 1 : 0
        border.color: root.borderColor

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }

        Behavior on border.color {
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
                duration: 112
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

    contentItem: Item {
        anchors.fill: parent

        IconImage {
            anchors.centerIn: parent
            visible: root.iconSource !== ""

            width: root.iconSize
            height: root.iconSize

            source: root.iconSource
            color: root.iconColor

            opacity: root.enabled ? 1.0 : 0.4
        }

        Text {
            anchors.centerIn: parent
            visible: root.iconSource === ""

            text: root.text
            font.pixelSize: Theme.fontBody
            font.bold: true
            color: root.textColor

            opacity: root.enabled ? 1.0 : 0.4
        }
    }

    onReleased: {
        if (root.enabled) {
            scaleShakeAnimation.restart()
        }
    }
}