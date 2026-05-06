import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Item {
    id: root

    property FlashcardController flashcardController

    ListView {
        anchors.fill: parent
        anchors.margins: Theme.spacing
        spacing: 10
        clip: true

        model: root.flashcardController.cards

        delegate: AppCard {
            width: ListView.view.width
            height: 76
            autoWidthToContent: false

            RowLayout {
                anchors.fill: parent
                spacing: 12
            
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
            
                    Text {
                        text: front
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textPrimary
                    }
            
                    Text {
                        text: back
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textSecondary
                    }
                }
            
                AppIconButton {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    text: "✏"
                }
            }
        }
    }
}