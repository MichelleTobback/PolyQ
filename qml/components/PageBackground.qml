import QtQuick
import Qt5Compat.GraphicalEffects

import PolyQ.Theme

Item {
    id: root

    anchors.fill: parent
    clip: true

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            orientation: Gradient.Vertical

            GradientStop {
                position: 0.0
                color: Qt.lighter(Theme.colors.backgroundTop, 1.03)
            }

            GradientStop {
                position: 0.5
                color: Theme.colors.background
            }

            GradientStop {
                position: 1.0
                color: Qt.darker(Theme.colors.backgroundBottom, 1.02)
            }
        }
    }

    Item {
        id: blobs
        anchors.fill: parent
        visible: false

        Rectangle {
            id: topBlob

            width: root.width * 0.95
            height: width
            radius: width / 2

            x: -width * 0.45
            y: -height * 0.28

            color: Theme.colors.primary
            opacity: 0.18

            SequentialAnimation on x {
                loops: Animation.Infinite

                NumberAnimation {
                    to: root.width * 0.08
                    duration: 22000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: -topBlob.width * 0.45
                    duration: 22000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on y {
                loops: Animation.Infinite

                NumberAnimation {
                    to: root.height * 0.12
                    duration: 26000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: -topBlob.height * 0.28
                    duration: 26000
                    easing.type: Easing.InOutSine
                }
            }
        }

        Rectangle {
            id: bottomBlob

            width: root.width * 0.85
            height: width
            radius: width / 2

            x: root.width * 0.58
            y: root.height * 0.68

            color: Theme.colors.primaryPressed
            opacity: 0.16

            SequentialAnimation on x {
                loops: Animation.Infinite

                NumberAnimation {
                    to: root.width * 0.10
                    duration: 24000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: root.width * 0.58
                    duration: 24000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on y {
                loops: Animation.Infinite

                NumberAnimation {
                    to: root.height * 0.42
                    duration: 28000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: root.height * 0.68
                    duration: 28000
                    easing.type: Easing.InOutSine
                }
            }
        }

        Rectangle {
            id: middleBlob

            width: root.width * 0.62
            height: width
            radius: width / 2

            x: root.width * 0.22
            y: root.height * 0.30

            color: Theme.colors.surfaceSoft
            opacity: 0.20

            SequentialAnimation on x {
                loops: Animation.Infinite

                NumberAnimation {
                    to: root.width * 0.55
                    duration: 20000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: root.width * 0.22
                    duration: 20000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on y {
                loops: Animation.Infinite

                NumberAnimation {
                    to: root.height * 0.18
                    duration: 24000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: root.height * 0.46
                    duration: 24000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: root.height * 0.30
                    duration: 24000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite

                NumberAnimation {
                    to: 0.10
                    duration: 12000
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: 0.24
                    duration: 12000
                    easing.type: Easing.InOutSine
                }
            }
        }
    }

    FastBlur {
        anchors.fill: parent

        source: blobs
        radius: 140

        transparentBorder: true
        cached: true
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.surfaceSoft
        opacity: 0.025
    }
}