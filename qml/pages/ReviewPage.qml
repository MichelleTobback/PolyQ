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

    property FlashcardController flashcardController

    signal back()

    onBackClicked: root.back()

    RowLayout {
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
        Layout.fillWidth: true
        Layout.fillHeight: true

        controller: root.flashcardController
    }

    Loader {
        Layout.fillWidth: true

        sourceComponent: root.flashcardController.reviewMode === 0
                         ? endlessControlsComponent
                         : ratingControlsComponent
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