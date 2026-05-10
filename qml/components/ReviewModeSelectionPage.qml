import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    property FlashcardController flashcardController
    property int sessionMode: 0

    signal back()
    signal startReview()

    pageTitle: "Review setup"
    showBackButton: true

    onBackClicked: root.back()

    function startSelectedMode() {
        root.flashcardController.configureReviewSettings(
            root.sessionMode,
            modeTabs.currentIndex, // 0 = normal, 1 = text input
            strictnessBox.currentIndex,
            caseSensitiveToggle.checked,
            ignoreAccentsToggle.checked,
            ignorePunctuationToggle.checked
        )

        root.flashcardController.startConfiguredReview()
        root.startReview()
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Theme.spacing

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            contentWidth: width
            contentHeight: contentColumn.implicitHeight

            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick

            ColumnLayout {
                id: contentColumn

                width: parent.width
                spacing: Theme.spacing

                AppCard {
                    Layout.fillWidth: true
                    autoHeightToContent: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 16

                        Text {
                            text: "How do you want to review?"
                            font.pixelSize: Theme.fontHeading
                            font.bold: true
                            color: Theme.colors.textPrimary

                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }

                        AppTabBar {
                            id: modeTabs

                            Layout.fillWidth: true
                            Layout.preferredHeight: 46
                            currentIndex: 0

                            AppTabButton {
                                text: "Normal"
                                width: (modeTabs.width - modeTabs.spacing) / 2
                            }

                            AppTabButton {
                                text: "Text input"
                                width: (modeTabs.width - modeTabs.spacing) / 2
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: modeDescription.implicitHeight + 24

                            radius: Theme.radiusMedium
                            color: Theme.colors.surfaceSoft

                            border.width: 1
                            border.color: Theme.colors.borderSoft

                            Text {
                                id: modeDescription

                                anchors.fill: parent
                                anchors.margins: 12

                                text: modeTabs.currentIndex === 0
                                      ? "Reveal the answer, then choose Again, Hard, Good, or Easy."
                                      : "Type the answer and PolyQ checks your spelling automatically."

                                font.pixelSize: Theme.fontBody
                                color: Theme.colors.textSecondary
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                AppCard {
                    visible: root.sessionMode === 1
                    Layout.fillWidth: true
                    autoHeightToContent: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 14

                        Text {
                            text: "How spaced repetition works"
                            font.pixelSize: Theme.fontHeading
                            font.bold: true
                            color: Theme.colors.textPrimary

                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }

                        Text {
                            text: "PolyQ schedules cards based on how well you remembered them. Easier cards move further into the future, while difficult cards return sooner."
                            font.pixelSize: Theme.fontBody
                            color: Theme.colors.textSecondary

                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Loader {
                                Layout.fillWidth: true
                                sourceComponent: ratingInfoRowComponent

                                onLoaded: {
                                    item.rating = "Again"
                                    item.accentColor = Theme.colors.danger
                                    item.description =
                                            "You forgot it. Ease goes down, and the card comes back instantly."
                                }
                            }

                            Loader {
                                Layout.fillWidth: true
                                sourceComponent: ratingInfoRowComponent

                                onLoaded: {
                                    item.rating = "Hard"
                                    item.accentColor = Theme.colors.warning
                                    item.description =
                                            "You remembered with effort. Ease goes down. New cards return in 5 minutes; older cards grow by about 1.2×."
                                }
                            }

                            Loader {
                                Layout.fillWidth: true
                                sourceComponent: ratingInfoRowComponent

                                onLoaded: {
                                    item.rating = "Good"
                                    item.accentColor = Theme.colors.success
                                    item.description =
                                            "You remembered it. New cards return in 10 minutes; older cards grow by their current ease factor."
                                }
                            }

                            Loader {
                                Layout.fillWidth: true
                                sourceComponent: ratingInfoRowComponent

                                onLoaded: {
                                    item.rating = "Easy"
                                    item.accentColor = Theme.colors.primary
                                    item.description =
                                            "You knew it quickly. Ease increases. New cards move to 1 day; older cards get a larger interval boost."
                                }
                            }
                        }
                    }
                }

                AppCard {
                    visible: modeTabs.currentIndex === 1
                    Layout.fillWidth: true
                    autoHeightToContent: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 14

                        Text {
                            text: "Answer checking"
                            font.pixelSize: Theme.fontHeading
                            font.bold: true
                            color: Theme.colors.textPrimary

                            Layout.fillWidth: true
                        }

                        Text {
                            text: "Tune how strict PolyQ should be when checking typed answers."
                            font.pixelSize: Theme.fontBody
                            color: Theme.colors.textSecondary

                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: strictnessContent.implicitHeight + 24

                            radius: Theme.radiusMedium
                            color: Theme.colors.surfaceSoft

                            border.width: 1
                            border.color: Theme.colors.borderSoft

                            ColumnLayout {
                                id: strictnessContent

                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.margins: 12

                                spacing: 10

                                Text {
                                    text: "Spelling forgiveness"
                                    font.pixelSize: Theme.fontBody
                                    font.bold: true
                                    color: Theme.colors.textPrimary

                                    Layout.fillWidth: true
                                }

                                ComboBox {
                                    id: strictnessBox

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 42

                                    model: [
                                        "Exact",
                                        "Forgiving",
                                        "Very forgiving"
                                    ]

                                    currentIndex: 1
                                }
                            }
                        }

                        SettingToggle {
                            id: caseSensitiveToggle

                            Layout.fillWidth: true
                            title: "Case sensitive"
                            subtitle: "Require exact uppercase and lowercase letters."
                            checked: false
                        }

                        SettingToggle {
                            id: ignoreAccentsToggle

                            Layout.fillWidth: true
                            title: "Ignore accents"
                            subtitle: "Treat e and é as the same answer."
                            checked: true
                        }

                        SettingToggle {
                            id: ignorePunctuationToggle

                            Layout.fillWidth: true
                            title: "Ignore punctuation"
                            subtitle: "Ignore commas, dots, quotes, and symbols."
                            checked: true
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredHeight: 12
                }
            }
        }

        AppButton {
            text: modeTabs.currentIndex === 0
                  ? "Start normal review"
                  : "Start text input review"

            Layout.fillWidth: true

            onClicked: root.startSelectedMode()
        }
    }

    Component {
        id: ratingInfoRowComponent

        Rectangle {
            id: ratingRow

            property string rating: ""
            property string description: ""
            property color accentColor: Theme.colors.primary

            Layout.fillWidth: true
            implicitHeight: content.implicitHeight + 18

            radius: Theme.radiusMedium
            color: Theme.colors.surfaceSoft

            border.width: 1
            border.color: Theme.colors.borderSoft

            RowLayout {
                id: content

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10

                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 72
                    Layout.preferredHeight: 30

                    radius: height / 2
                    color: ratingRow.accentColor

                    Text {
                        anchors.centerIn: parent

                        text: ratingRow.rating
                        font.pixelSize: Theme.fontSmall
                        font.bold: true
                        color: Theme.colors.textOnPrimary
                    }
                }

                Text {
                    text: ratingRow.description

                    Layout.fillWidth: true

                    font.pixelSize: Theme.fontSmall
                    color: Theme.colors.textSecondary
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}