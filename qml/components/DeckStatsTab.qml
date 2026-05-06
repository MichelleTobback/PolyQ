import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Theme

Item {
    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - Theme.spacing * 2

        spacing: 8

        Text {
            text: "Stats coming soon"
            font.pixelSize: Theme.fontHeading
            font.bold: true
            color: Theme.colors.textPrimary

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            wrapMode: Text.WordWrap
        }

        Text {
            text: "Progress, streaks and review history will appear here."
            font.pixelSize: Theme.fontBody
            color: Theme.colors.textSecondary

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            wrapMode: Text.WordWrap
        }
    }
}