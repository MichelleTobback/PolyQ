import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    pageTitle: flashcardController.currentDeck.title
    showBackButton: true
    showHeader: !root.showEndScreen

    property FlashcardController flashcardController

    readonly property bool showEndScreen: root.flashcardController.reviewFinished
                                          || root.flashcardController.reviewTotalCount === 0

    signal back()

    onBackClicked: root.back()

    RowLayout {
        visible: !root.showEndScreen

        Layout.fillWidth: true

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: root.flashcardController.reviewedCount
                  + " / "
                  + root.flashcardController.reviewTotalCount

            font.pixelSize: Theme.fontBody
            color: Theme.colors.textSecondary

            Layout.alignment: Qt.AlignTop | Qt.AlignRight
        }
    }

    FlashcardView {
        visible: !root.showEndScreen

        Layout.fillWidth: true
        Layout.fillHeight: true

        controller: root.flashcardController
    }

    Loader {
        visible: !root.showEndScreen

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignBottom

        sourceComponent: root.flashcardController.reviewMode === 0
                         ? endlessControlsComponent
                         : ratingControlsComponent
    }

    overlay: ReviewEndScreen {
        visible: root.showEndScreen

        anchors.fill: parent
        z: 1000

        flashcardController: root.flashcardController

        onDone: root.back()

        onReviewAgain: {
            root.flashcardController.startDueReview()
        }
    }

    Component {
        id: ratingControlsComponent

        RatingReviewControls {
            flashcardController: root.flashcardController
        }
    }

    Component {
        id: endlessControlsComponent

        EndlessReviewControls {
            flashcardController: root.flashcardController
        }
    }
}