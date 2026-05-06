import QtQuick
import QtQuick.Controls

import PolyQ.Theme

TextArea {
    id: root

    property string animatedPlaceholder: ""

    placeholderText: ""

    wrapMode: TextArea.Wrap

    horizontalAlignment: TextArea.AlignHCenter

    topPadding: Math.max(12, (height - contentHeight) / 2)
    bottomPadding: topPadding
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
        wrapMode: Text.WordWrap

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