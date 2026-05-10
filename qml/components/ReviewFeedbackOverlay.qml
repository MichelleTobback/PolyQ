import QtQuick
import QtQuick.Layouts

import PolyQ.Theme

Rectangle {
    id: root

    property string ratingText: ""
    property string dueText: ""
    property bool active: false

    visible: opacity > 0
    opacity: root.active ? 1.0 : 0.0

    width: parent ? parent.width * 0.72 : 280
    height: content.implicitHeight + 28

    radius: Theme.radiusCard
    color: Theme.colors.surface
    border.width: 1
    border.color: Theme.colors.border

    anchors.centerIn: parent

    scale: root.active ? 1.0 : 0.92

    Behavior on opacity {
        NumberAnimation { duration: 180 }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutBack
        }
    }

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 14
        spacing: 6

        Text {
            text: root.ratingText
            Layout.fillWidth: true

            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontHeading
            font.bold: true
            color: Theme.colors.textPrimary
        }

        Text {
            text: root.dueText
            visible: text.length > 0

            Layout.fillWidth: true

            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontBody
            color: Theme.colors.textSecondary
        }
    }
}