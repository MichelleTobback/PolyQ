import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Theme

Rectangle {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool checked: false

    signal toggled(bool checked)

    radius: Theme.radiusMedium
    color: Theme.colors.surfaceSoft
    border.width: 1
    border.color: root.checked ? Theme.colors.primary : Theme.colors.borderSoft

    implicitHeight: content.implicitHeight + 22

    Behavior on border.color {
        ColorAnimation { duration: Theme.animationFast }
    }

    RowLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3

            Text {
                text: root.title
                font.pixelSize: Theme.fontBody
                font.bold: true
                color: Theme.colors.textPrimary
                Layout.fillWidth: true
            }

            Text {
                text: root.subtitle
                font.pixelSize: Theme.fontSmall
                color: Theme.colors.textSecondary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }

        Switch {
            checked: root.checked

            onToggled: {
                root.checked = checked
                root.toggled(root.checked)
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}