import QtQuick
import Qt5Compat.GraphicalEffects
import PolyQ.Theme

Item {
    id: root
    anchors.fill: parent
    clip: true

    property color backgroundColor: Theme.colors.background
    property color gradientTop: Theme.colors.backgroundTop
    property color gradientBottom: Theme.colors.backgroundBottom
    property color blobPrimary: Theme.colors.backgroundTop
    property color blobSecondary: Theme.colors.backgroundBottom

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.45

        gradient: Gradient {
            GradientStop { position: 0.0; color: root.gradientTop }
            GradientStop { position: 0.55; color: root.backgroundColor }
            GradientStop { position: 1.0; color: root.gradientBottom }
        }
    }
}