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

    readonly property bool keyboardVisible: Qt.inputMethod.visible
    readonly property real keyboardHeight: root.keyboardVisible
                                       ? Math.min(Qt.inputMethod.keyboardRectangle.height, height * 0.42) : 0

    signal back()

    onBackClicked: root.back()

    ColumnLayout {
        visible: !root.showEndScreen

        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Theme.spacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

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
            Layout.alignment: Qt.AlignTop

            controller: root.flashcardController
        }

        Loader {
            Layout.fillWidth: true
            Layout.preferredHeight: item ? item.implicitHeight : 0

            sourceComponent: root.flashcardController.reviewInputMode === 1
                 ? inputControlsComponent
                 : root.flashcardController.reviewSessionMode === 1 
                    ? ratingControlsComponent 
                    : endlessControlsComponent
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.keyboardHeight

            Behavior on Layout.preferredHeight {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    overlay: Item {
        anchors.fill: parent

        ReviewEndScreen {
            visible: root.showEndScreen

            anchors.fill: parent
            z: 1000

            flashcardController: root.flashcardController

            onDone: root.back()

            onReviewAgain: {
                root.flashcardController.startDueReview()
            }
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

    Component {
        id: inputControlsComponent

        InputReviewControls {
            flashcardController: root.flashcardController
        }
    }
}