import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Item {
    id: root

    property FlashcardController flashcardController

    signal startReview()

    Flickable {
        anchors.fill: parent
        clip: true

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: width
        contentHeight: contentColumn.implicitHeight

        anchors.margins: Theme.spacing

        ColumnLayout {
            id: contentColumn

            width: parent.width
            spacing: Theme.spacing

            AppCard {
                Layout.fillWidth: true
                autoHeightToContent: true

                ColumnLayout {
                    width: parent.width
                    spacing: 14

                    Text {
                        text: "Info"
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textSecondary
                    }

                    Text {
                        text: root.flashcardController.currentDeck.subtitle
                        font.pixelSize: Theme.fontBody
                        color: Theme.colors.textSecondary
                        wrapMode: Text.WordWrap
                        lineHeight: 1.15
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacing

                        StatTile {
                            value: root.flashcardController.currentDeck.cardCount
                            label: "Total cards"
                        }

                        StatTile {
                            value: "0"
                            label: "Learned"
                        }

                        StatTile {
                            value: "0"
                            label: "Streak"
                        }
                    }
                }
            }

            AppCard {
                Layout.fillWidth: true
                Layout.minimumHeight: 170
                autoHeightToContent: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 14

                    RowLayout {
                        Layout.fillWidth: true

                        ColumnLayout {
                            spacing: 4

                            Text {
                                text: "Today"
                                font.pixelSize: Theme.fontBody
                                font.bold: true
                                color: Theme.colors.textSecondary
                            }

                            Text {
                                text: "Ready to review"
                                font.pixelSize: Theme.fontHeading
                                font.bold: true
                                color: Theme.colors.textPrimary
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        StatTile {
                            value: root.flashcardController.currentDeck.dueCount
                            label: "Cards"
                            labelSize: Theme.fontBody
                        }
                    }

                    Text {
                        text: "Review your due vocabulary using spaced repetition and keep your memory fresh."
                        font.pixelSize: Theme.fontBody
                        color: Theme.colors.textSecondary
                        wrapMode: Text.WordWrap
                        lineHeight: 1.15
                        Layout.fillWidth: true
                    }

                    AppButton {
                        text: "Start review"
                        Layout.fillWidth: true
                        onClicked: root.startReview()
                    }
                }
            }
        }
    }

    component StatTile: Rectangle {
        property string value
        property string label
        property int valueSize: 24
        property int labelSize: Theme.fontSmall

        Layout.fillWidth: true
        implicitHeight: 45
        radius: Theme.radiusMedium
        color: Theme.colors.surface

        Column {
            anchors.centerIn: parent
            spacing: 4

            Text {
                text: value
                font.pixelSize: valueSize
                font.bold: true
                color: Theme.colors.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: label
                font.pixelSize: labelSize
                color: Theme.colors.textSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}