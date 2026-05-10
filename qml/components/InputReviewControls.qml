import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Theme
import PolyQ.Controllers 1.0

ColumnLayout {
    id: root

    property FlashcardController flashcardController

    AppTextArea {
        id: userAnswer
        readOnly: root.flashcardController.showingAnswer
        anchors.left: parent.left
        anchors.right: parent.right
        Layout.preferredHeight: 80
        animatedPlaceholder: "Type your answer here."
    }

    AppButton {
        text: !root.flashcardController.showingAnswer ? "Show answer" : "Next"
        enabled: userAnswer.text.length > 0
        Layout.fillWidth: true

        onClicked: { 
        if (!root.flashcardController.showingAnswer)
            root.flashcardController.checkResults(userAnswer.text)
        else {
                userAnswer.text = ""
                root.flashcardController.nextCard() 
            }
        }
    }
}