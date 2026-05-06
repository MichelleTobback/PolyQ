import QtQuick
import QtQuick.Controls

TabBar {
    id: root

    spacing: 8

    background: Rectangle {
        color: "transparent"
    }

    contentItem: ListView {
        model: root.contentModel
        currentIndex: root.currentIndex

        spacing: root.spacing
        orientation: ListView.Horizontal

        boundsBehavior: Flickable.StopAtBounds
        interactive: false
    }
}