import QtQuick
import QtQuick.Layouts

import PolyQ.Theme
import PolyQ.Controllers 1.0

Rectangle {
    id: root

    signal clicked()

    property FlashcardController controller

    property string front: root.controller.currentCard.front;
    property string back: root.controller.currentCard.back;
    property bool showingAnswer: root.controller.showingAnswer;

    onClicked: root.controller.showAnswer()

    radius: Theme.radiusCard
    color: Theme.colors.surface

    border.width: 1
    border.color: Theme.colors.border

    scale: mouseArea.pressed ? 0.985 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutQuad
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 24

        Item {
            Layout.fillHeight: true
        }

        Text {
            text: root.front
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pixelSize: 38
            font.bold: true
            color: Theme.colors.textPrimary
        }

        Text {
            visible: root.showingAnswer
            text: root.back
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pixelSize: 26
            color: Theme.colors.textSecondary
            opacity: root.showingAnswer ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.animationMedium
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}