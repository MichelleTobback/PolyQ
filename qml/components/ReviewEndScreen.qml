import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Item {
    id: root

    property FlashcardController flashcardController
    readonly property int confettiLifetime: 4000
    property bool celebrationFinished: false

    signal done()
    signal reviewAgain()

    Component.onCompleted: {
        if (visible)
            celebrationAnimation.start()
    }

    onVisibleChanged: {
        if (visible)
            celebrationAnimation.restart()
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
        opacity: 0.0
    }

    SequentialAnimation {
        id: celebrationAnimation

        ScriptAction {
            script: {
                root.celebrationFinished = false
                resultCard.opacity = 0
                resultCard.scale = 0.86
                confettiRepeater.model = 0
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: resultCard
                property: "scale"
                from: 0.86
                to: 1.04
                duration: 220
                easing.type: Easing.OutBack
            }

            NumberAnimation {
                target: resultCard
                property: "opacity"
                from: 0
                to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        NumberAnimation {
            target: resultCard
            property: "scale"
            to: 1
            duration: 120
            easing.type: Easing.OutCubic
        }

        ScriptAction {
            script: confettiRepeater.model = 28
        }

        PauseAnimation {
            duration: root.confettiLifetime * 0.3
        }

        ScriptAction {
            script: root.celebrationFinished = true
        }

        PauseAnimation {
            duration: root.confettiLifetime * 0.7
        }

        ScriptAction {
            script: confettiRepeater.model = 0
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.spacing

        Item {
            Layout.fillHeight: true
        }

        AppCard {
            id: resultCard

            z: 2
            opacity: 0
            scale: 0.86

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            autoHeightToContent: true

            ColumnLayout {
                width: parent.width
                spacing: 18

                Text {
                    text: root.flashcardController.reviewTotalCount > 0
                          ? "Review complete"
                          : "Nothing due"

                    font.pixelSize: Theme.fontHeading
                    font.bold: true
                    color: Theme.colors.textPrimary

                    horizontalAlignment: Text.AlignHCenter

                    Layout.fillWidth: true
                }

                Text {
                    text: root.flashcardController.reviewTotalCount > 0
                          ? "Nice work. You reviewed "
                            + root.flashcardController.reviewedCount
                            + " cards."
                          : "You are all caught up for now."

                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textSecondary

                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter

                    Layout.fillWidth: true
                }

                GridLayout {
                    visible: root.flashcardController.reviewTotalCount > 0

                    columns: 2
                    columnSpacing: 12
                    rowSpacing: 12

                    Layout.fillWidth: true

                    ResultStat {
                        label: "Again"
                        value: root.flashcardController.reviewAgainCount
                        color: Theme.colors.danger
                    }

                    ResultStat {
                        label: "Hard"
                        value: root.flashcardController.reviewHardCount
                        color: Theme.colors.warning
                    }

                    ResultStat {
                        label: "Good"
                        value: root.flashcardController.reviewGoodCount
                        color: Theme.colors.primary
                    }

                    ResultStat {
                        label: "Easy"
                        value: root.flashcardController.reviewEasyCount
                        color: Theme.colors.success
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.buttonHeight
            Layout.alignment: Qt.AlignBottom

            AppButton {
                text: "Done"

                enabled: root.celebrationFinished
                opacity: enabled ? 1.0 : 0.45

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                width: parent.width * 0.5
                height: Theme.buttonHeight

                onClicked: root.done()

                Behavior on opacity {
                    NumberAnimation {
                        duration: 180
                    }
                }
            }
        }
    }

    Repeater {
        id: confettiRepeater
        model: 0

        Rectangle {
            required property int index

            z: 10

            readonly property int particleLifetime: root.confettiLifetime
            readonly property real particleSpeed: 1.0
            readonly property real randomSpeed: 0.75 + Math.random() * 0.7

            readonly property real spreadX:
                ((index % 2 === 0 ? 1 : -1)
                * (60 + Math.random() * 180))

            readonly property real launchHeight:
                120 + Math.random() * 180

            readonly property real gravityDrop:
                520 + Math.random() * 180

            readonly property int movementDuration:
                (2400 + Math.random() * 1600) / (particleSpeed * randomSpeed)

            width: 6 + Math.random() * 8
            height: width * (0.5 + Math.random())

            radius: 2

            color: [
                "#FF7AA2",
                "#FFD166",
                "#7BDFF2",
                "#B2F7EF",
                "#CDB4DB"
            ][index % 5]

            x: root.width / 2
            y: root.height / 2

            rotation: Math.random() * 360
            opacity: 0

            SequentialAnimation on opacity {
                running: true

                NumberAnimation {
                    from: 0
                    to: 1
                    duration: 120
                }

                PauseAnimation {
                    duration: particleLifetime * 0.25
                }

                NumberAnimation {
                    from: 1
                    to: 0
                    duration: particleLifetime * 0.75
                    easing.type: Easing.OutQuad
                }
            }

            NumberAnimation on x {
                running: true

                from: root.width / 2
                to: root.width / 2 + spreadX

                duration: movementDuration
                easing.type: Easing.OutQuad
            }

            SequentialAnimation on y {
                running: true

                NumberAnimation {
                    from: root.height / 2
                    to: root.height / 2 - launchHeight

                    duration: movementDuration * 0.3
                    easing.type: Easing.OutQuad
                }

                NumberAnimation {
                    to: root.height / 2 + gravityDrop

                    duration: movementDuration * 0.7
                    easing.type: Easing.InQuad
                }
            }

            NumberAnimation on rotation {
                running: true

                from: rotation
                to: rotation
                    + ((Math.random() > 0.5 ? 1 : -1)
                    * (720 + Math.random() * 720))

                duration: movementDuration
            }

            SequentialAnimation on scale {
                running: true

                NumberAnimation {
                    from: 0.4
                    to: 1
                    duration: 180
                    easing.type: Easing.OutBack
                }

                NumberAnimation {
                    to: 0.7
                    duration: movementDuration
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    component ResultStat: Rectangle {
        property string label
        property int value
        property color color

        Layout.fillWidth: true
        implicitHeight: 82

        radius: Theme.radiusLarge

        color: Theme.colors.surfaceSoft

        border.width: 1
        border.color: Theme.colors.border

        opacity: resultCard.opacity
        scale: resultCard.opacity === 1 ? 1 : 0.92

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2

            Text {
                text: value

                font.pixelSize: Theme.fontHeading
                font.bold: true

                color: parent.parent.color

                horizontalAlignment: Text.AlignHCenter

                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: label

                font.pixelSize: Theme.fontSmall
                color: Theme.colors.textSecondary

                horizontalAlignment: Text.AlignHCenter

                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}