import QtQuick
import Qt5Compat.GraphicalEffects
import PolyQ.Theme

Item {
    id: root
    anchors.fill: parent
    clip: true

    property color backgroundColor: Theme.colors.background
    property color gradientTop: Theme.colors.backgroundTop
    property color gradientBottom: Theme.colors.backgroundBottom
    property color blobPrimary: Theme.colors.background2
    property color blobSecondary: Theme.colors.background3

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.35

        gradient: Gradient {
            GradientStop { position: 0.0; color: root.gradientTop }
            GradientStop { position: 0.55; color: root.backgroundColor }
            GradientStop { position: 1.0; color: root.gradientBottom }
        }
    }

    Repeater {
        model: 10

        RadialGradient {
            id: blob

            property color blobColor: index % 2 === 0 ? root.blobPrimary : root.blobSecondary
            property real blobAlpha: 0.18 + Math.random() * 0.18
            property real targetX: 0
            property real targetY: 0

            property int startDelay: index * 900 + Math.random() * 1800
            property int moveDuration: 16000 + Math.random() * 12000
            property int fadeDuration: 4500 + Math.random() * 3500
            property int pauseDuration: 1500 + Math.random() * 5000

            width: 420 + Math.random() * 280
            height: width

            x: Math.random() * Math.max(1, root.width - width)
            y: Math.random() * Math.max(1, root.height - height)
            opacity: 0.0

            horizontalRadius: width * 0.5
            verticalRadius: height * 0.5

            function chooseNextPosition() {
                targetX = Math.random() * Math.max(1, root.width - width)
                targetY = Math.random() * Math.max(1, root.height - height)
                blobAlpha = 0.18 + Math.random() * 0.18
            }

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(blob.blobColor.r, blob.blobColor.g, blob.blobColor.b, blob.blobAlpha)
                }

                GradientStop {
                    position: 0.75
                    color: Qt.rgba(blob.blobColor.r, blob.blobColor.g, blob.blobColor.b, blob.blobAlpha * 0.45)
                }

                GradientStop {
                    position: 1.0
                    color: Qt.rgba(blob.blobColor.r, blob.blobColor.g, blob.blobColor.b, 0.0)
                }
            }

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation { duration: blob.startDelay }

                ScriptAction { script: blob.chooseNextPosition() }

                ParallelAnimation {
                    NumberAnimation {
                        target: blob
                        property: "opacity"
                        from: 0.0
                        to: 1.0
                        duration: blob.fadeDuration
                        easing.type: Easing.InOutSine
                    }

                    NumberAnimation {
                        target: blob
                        property: "x"
                        to: blob.targetX
                        duration: blob.moveDuration
                        easing.type: Easing.InOutSine
                    }

                    NumberAnimation {
                        target: blob
                        property: "y"
                        to: blob.targetY
                        duration: blob.moveDuration
                        easing.type: Easing.InOutSine
                    }
                }

                PauseAnimation { duration: blob.pauseDuration }

                NumberAnimation {
                    target: blob
                    property: "opacity"
                    from: 1.0
                    to: 0.0
                    duration: blob.fadeDuration
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}