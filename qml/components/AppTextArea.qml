import QtQuick
import QtQuick.Controls

import PolyQ.Theme

Item {
    id: root

    property alias text: editor.text
    property alias animatedPlaceholder: placeholder.text
    property alias readOnly: editor.readOnly

    readonly property bool editorActiveFocus: editor.activeFocus

    clip: true

    Rectangle {
        anchors.fill: parent

        radius: Theme.radiusMedium
        color: Theme.colors.surfaceAlt

        border.width: 1
        border.color: editor.activeFocus
                      ? Theme.colors.primary
                      : Theme.colors.border

        Behavior on border.color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        clip: true

        contentWidth: width
        contentHeight: editor.height

        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height

        TextArea {
            id: editor

            width: flickable.width
            height: Math.max(implicitHeight, flickable.height)

            background: null
            placeholderText: ""

            wrapMode: TextArea.Wrap

            horizontalAlignment: TextArea.AlignHCenter
            verticalAlignment: TextArea.AlignVCenter

            leftPadding: 12
            rightPadding: 12
            topPadding: 12
            bottomPadding: 12

            font.pixelSize: Theme.fontBody
            color: Theme.colors.textPrimary

            selectByMouse: true
            persistentSelection: true

            onCursorRectangleChanged: {
                const margin = 24

                if (cursorRectangle.y < flickable.contentY + margin) {
                    flickable.contentY = Math.max(
                                0,
                                cursorRectangle.y - margin)
                } else if (cursorRectangle.y + cursorRectangle.height
                           > flickable.contentY + flickable.height - margin) {
                    flickable.contentY = Math.min(
                                flickable.contentHeight - flickable.height,
                                cursorRectangle.y
                                + cursorRectangle.height
                                - flickable.height
                                + margin)
                }
            }

            Text {
                id: placeholder

                anchors.centerIn: parent
                width: parent.width - 24

                text: root.animatedPlaceholder

                visible: opacity > 0
                opacity: editor.text.length === 0
                         && !editor.activeFocus
                         ? 1
                         : 0

                scale: editor.activeFocus ? 0.96 : 1.0

                font: editor.font
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
        }
    }
}