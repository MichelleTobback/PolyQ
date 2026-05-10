import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property var flashcardController

    property bool canContinue: true

    readonly property bool keyboardVisible: Qt.inputMethod.visible

    signal continueRequested()

    function continueReview() {
        if (!canContinue)
            return

        continueRequested()
    }

    function showAnswer() {
        root.flashcardController.showAnswer()
    }

    spacing: Theme.spacing
}