import QtQuick
import QtQuick.Controls
import PolyQ.Theme

Page {
    id: root

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.colors.backgroundTop }
            GradientStop { position: 1.0; color: Theme.colors.backgroundBottom }
        }
    }
}