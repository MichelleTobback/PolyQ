import QtQuick
import QtQuick.Layouts

import PolyQ.Theme
import PolyQ.Controllers 1.0

Rectangle {
    id: root

    signal clicked()

    property FlashcardController controller

    property string front: root.controller.currentCard.front
    property string back: root.controller.currentCard.back
    property bool showingAnswer: root.controller.showingAnswer

    property int answerState: root.controller.lastAnswerState
    property bool showReviewFeedback: root.controller.showReviewFeedback
    property string ratingText: root.controller.lastReviewRatingText
    property string dueText: root.controller.lastReviewDueText

    readonly property bool isWrong: root.answerState === 2
    readonly property bool isCorrect: root.answerState === 1

    readonly property bool hasAnswerFeedback: root.answerState !== 0
    readonly property bool hasRatingFeedback: root.showReviewFeedback && root.ratingText.length > 0
    readonly property bool hasFeedback: root.hasAnswerFeedback || root.hasRatingFeedback

    readonly property color ratingColor: {
        switch (root.ratingText) {
        case "Again":
            return Theme.colors.danger
        case "Hard":
            return Theme.colors.warning
        case "Good":
            return Theme.colors.success
        case "Easy":
            return Theme.colors.success
        default:
            return Theme.colors.primary
        }
    }

    readonly property color feedbackColor: root.hasRatingFeedback
                                      ? root.ratingColor
                                      : root.hasAnswerFeedback
                                        ? (root.isCorrect ? Theme.colors.success : Theme.colors.danger)
                                        : Theme.colors.border

    readonly property color feedbackSoftColor: root.hasAnswerFeedback
                                          ? (root.isCorrect ? Theme.colors.successSoft : Theme.colors.dangerSoft)
                                          : root.hasRatingFeedback
                                            ? Theme.colors.surfaceSoft
                                            : Theme.colors.surface

    onClicked: root.controller.showAnswer()

    radius: Theme.radiusCard
    color: root.hasFeedback ? root.feedbackSoftColor : Theme.colors.surface

    border.width: root.hasFeedback ? 2 : 1
    border.color: root.hasFeedback ? root.feedbackColor : Theme.colors.border

    scale: mouseArea.pressed ? 0.985 : root.hasFeedback ? 1.01 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animationFast
            easing.type: Easing.OutQuad
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 220
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 220
        }
    }

    Behavior on border.width {
        NumberAnimation {
            duration: 160
        }
    }

    Rectangle {
        id: feedbackBadge

        visible: root.hasFeedback
        opacity: root.hasFeedback ? 1.0 : 0.0

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 18

        radius: height / 2
        color: root.feedbackColor

        implicitWidth: badgeText.implicitWidth + 30
        implicitHeight: badgeText.implicitHeight + 12

        Text {
            id: badgeText

            anchors.centerIn: parent

            text: root.hasRatingFeedback
                  ? root.ratingText
                  : (root.isCorrect ? "Correct" : "Try again")

            font.pixelSize: Theme.fontBody
            font.bold: true
            color: Theme.colors.textOnPrimary
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.animationFast
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 18

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
            visible: root.showingAnswer || root.hasFeedback
            text: root.back

            Layout.fillWidth: true

            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap

            font.pixelSize: 26
            color: Theme.colors.textSecondary
            opacity: visible ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.animationMedium
                }
            }
        }

        Text {
            visible: root.hasRatingFeedback && root.dueText.length > 0
            text: root.dueText

            Layout.fillWidth: true

            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap

            font.pixelSize: Theme.fontBody
            font.bold: true
            color: root.feedbackColor
            opacity: visible ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.animationFast
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

        //onClicked: root.clicked()
    }
}