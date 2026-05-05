import QtQuick
import QtQuick.Controls

import PolyQ.Theme

Button {
    id: root

    width: 48
    height: 48

    background: Rectangle {
        radius: 24
        color: root.down ? Theme.colors.surfacePressed : Theme.colors.surface
    }

    contentItem: Text {
        text: root.text
        color: Theme.colors.textPrimary
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}