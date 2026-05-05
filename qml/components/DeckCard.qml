import QtQuick
import QtQuick.Layouts

import PolyQ.Theme

Rectangle {
    id: root

    signal clicked()

    property string title: ""
    property string subtitle: ""

    Layout.fillWidth: true
    height: 112
    radius: Theme.radiusLarge
    color: Theme.colors.surface

    border.width: 1
    border.color: Theme.colors.border

    scale: mouseArea.pressed ? 0.98 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutQuad
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.cardPadding
        spacing: 6

        Text {
            text: root.title
            font.pixelSize: 22
            font.bold: true
            color: Theme.colors.textPrimary
        }

        Text {
            text: root.subtitle
            font.pixelSize: Theme.fontSmall
            color: Theme.colors.textSecondary
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        onClicked: root.clicked()
    }
}