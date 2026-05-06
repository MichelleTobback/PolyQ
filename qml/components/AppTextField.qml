import QtQuick
import QtQuick.Controls

import PolyQ.Theme

TextField {
    id: root

    property string animatedPlaceholder: ""

    placeholderText: ""

    horizontalAlignment: TextField.AlignHCenter
    verticalAlignment: TextField.AlignVCenter

    leftPadding: 12
    rightPadding: 12

    font.pixelSize: Theme.fontBody
    color: Theme.colors.textPrimary

    Text {
        anchors.centerIn: parent
        width: parent.width - 24

        text: root.animatedPlaceholder

        visible: opacity > 0
        opacity: root.text.length === 0 && !root.activeFocus ? 1 : 0

        scale: root.activeFocus ? 0.96 : 1.0

        font: root.font
        color: Theme.colors.textMuted

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }
    }

    background: Rectangle {
        implicitHeight: 44

        radius: Theme.radiusMedium
        color: Theme.colors.surfaceVariant

        border.width: 1
        border.color: root.activeFocus
                      ? Theme.colors.primary
                      : Theme.colors.border

        Behavior on border.color {
            ColorAnimation {
                duration: 120
            }
        }
    }
}