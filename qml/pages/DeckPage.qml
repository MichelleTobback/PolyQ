import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

Page {
    id: root

    property FlashcardController flashcardController

    signal back()
    signal startReview()

    background: Rectangle {
        color: Theme.colors.background
    }

    ColumnLayout {
    anchors.fill: parent
    anchors.margins: Theme.pageMargin
    spacing: Theme.spacing

    // Header
    RowLayout {
        Layout.fillWidth: true

        AppBackButton {
            onClicked: root.back()
        }

        Item {
            Layout.fillWidth: true
        }

        AppIconButton {
            text: "✏"
        }
    }

    Text {
        text: flashcardController.currentDeck.title
        font.pixelSize: Theme.fontTitle
        font.bold: true
        color: Theme.colors.textPrimary
        Layout.fillWidth: true
    }

    // Tabs
    AppTabBar {
        id: tabBar
    
        Layout.fillWidth: true
    
        AppTabButton { text: "Overview" }
        AppTabButton { text: "Word list" }
        AppTabButton { text: "Stats" }
    }

    SwipeView {
        id: swipeView
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: tabBar.currentIndex

        onCurrentIndexChanged: tabBar.currentIndex = currentIndex

        // Overview tab
        Item {
            Flickable {
                anchors.fill: parent
                clip: true

                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds

                contentWidth: width
                contentHeight: contentColumn.implicitHeight

                ColumnLayout {
                    id: contentColumn
                    width: parent.width
                    spacing: Theme.spacing

                    AppCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        Layout.minimumHeight: 150

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.cardPadding
                            spacing: 14

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: "Info"
                                    font.pixelSize: Theme.fontBody
                                    font.bold: true
                                    color: Theme.colors.textSecondary
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    width: 76
                                    height: 76
                                    radius: 24
                                    color: Theme.colors.surfaceVariant

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 0

                                        Text {
                                            text: flashcardController.currentDeck.cardCount
                                            font.pixelSize: 30
                                            font.bold: true
                                            color: Theme.colors.textPrimary
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }

                                        Text {
                                            text: "cards"
                                            font.pixelSize: Theme.fontSmall
                                            color: Theme.colors.textSecondary
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
                                }
                            }

                            Item{
                            Layout.fillHeight: true
                            }

                            Text {
                                text: flashcardController.currentDeck.subtitle
                                font.pixelSize: Theme.fontBody
                                color: Theme.colors.textSecondary
                                wrapMode: Text.WordWrap
                                lineHeight: 1.15
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // Quick stats card
                    AppCard {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 150
        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.cardPadding
                            spacing: 14
        
                            Text {
                                text: "Quick stats"
                                font.pixelSize: Theme.fontBody
                                font.bold: true
                                color: Theme.colors.textSecondary
                            }
        
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Theme.spacing
        
                                Rectangle {
                                    Layout.fillWidth: true
                                    implicitHeight: 90
                                    radius: Theme.radiusMedium
                                    color: Theme.colors.surfaceVariant
        
                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 4
        
                                        Text {
                                            text: flashcardController.currentDeck.cardCount
                                            font.pixelSize: 24
                                            font.bold: true
                                            color: Theme.colors.textPrimary
        
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
        
                                        Text {
                                            text: "Total cards"
                                            font.pixelSize: Theme.fontSmall
                                            color: Theme.colors.textSecondary
        
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
                                }
        
                                Rectangle {
                                    Layout.fillWidth: true
                                    implicitHeight: 90
                                    radius: Theme.radiusMedium
                                    color: Theme.colors.surfaceVariant
        
                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 4
        
                                        Text {
                                            text: "0"
                                            font.pixelSize: 24
                                            font.bold: true
                                            color: Theme.colors.textPrimary
        
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
        
                                        Text {
                                            text: "Streak"
                                            font.pixelSize: Theme.fontSmall
                                            color: Theme.colors.textSecondary
        
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
                                }
                            }
                        }
                    }

                    AppCard {
                        Layout.fillWidth: true
                        //Layout.preferredHeight: 170
                        Layout.minimumHeight: 170
                        Layout.fillHeight: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.cardPadding
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

                                Rectangle {
                                    width: 50
                                    height: 50
                                    radius: 24
                                    color: Theme.colors.surfaceVariant

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 0

                                        Text {
                                            text: flashcardController.currentDeck.cardCount
                                            font.pixelSize: 30
                                            font.bold: true
                                            color: Theme.colors.textPrimary
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }

                                        Text {
                                            text: "cards"
                                            font.pixelSize: Theme.fontSmall
                                            color: Theme.colors.textSecondary
                                            horizontalAlignment: Text.AlignHCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
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
                        }
                    }

                    AppButton {
                        text: "Start review"
                        Layout.fillWidth: true
                        onClicked: root.startReview()
                    }
                }
            }
        }

        // Word list tab
        Item {
            ListView {
                anchors.fill: parent
                anchors.margins: Theme.spacing
                spacing: 10
                clip: true

                model: flashcardController.cards

                delegate: AppCard {
                    width: ListView.view.width
                    height: 76

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.cardPadding
                        spacing: 12

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: front
                                font.pixelSize: Theme.fontBody
                                font.bold: true
                                color: Theme.colors.textPrimary
                            }

                            Text {
                                text: back
                                font.pixelSize: Theme.fontSmall
                                color: Theme.colors.textSecondary
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        AppIconButton {
                            text: "✏"
                        }
                    }
                }
            }
        }

        // Stats tab
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8
                anchors.margins: Theme.spacing

                Text {
                    text: "Stats coming soon"
                    font.pixelSize: Theme.fontHeading
                    font.bold: true
                    color: Theme.colors.textPrimary
                }

                Text {
                    text: "Progress, streaks and review history will appear here."
                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textSecondary
                }
            }
        }
    }
}
}