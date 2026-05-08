import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import PolyQ.Components
import PolyQ.Theme
import PolyQ.Controllers 1.0

AppPage {
    id: root

    pageTitle: "Edit deck"
    showBackButton: true

    property FlashcardController flashcardController

    signal back()

    onBackClicked: root.back()

    AppCard {
        Layout.fillWidth: true
        autoHeightToContent: true

        ColumnLayout {
            width: parent.width
            spacing: 14

            Text {
                text: "Deck info"
                font.pixelSize: Theme.fontBody
                font.bold: true
                color: Theme.colors.textSecondary
            }

            AppTextField {
                id: titleField
                Layout.fillWidth: true
                text: root.flashcardController.currentDeck.title
                animatedPlaceholder: "Deck title"
            }

            AppTextArea {
                id: subtitleField
                Layout.fillWidth: true
                text: root.flashcardController.currentDeck.subtitle
                animatedPlaceholder: "Subtitle or description"
            }
        }
    }

    AppCard {
        Layout.fillWidth: true
        autoHeightToContent: true

        ColumnLayout {
            width: parent.width
            spacing: 14

            Text {
                text: "Settings"
                font.pixelSize: Theme.fontBody
                font.bold: true
                color: Theme.colors.textSecondary
            }

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Enabled"
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        color: Theme.colors.textPrimary
                    }

                    Text {
                        text: "Include this deck in reviews"
                        font.pixelSize: Theme.fontSmall
                        color: Theme.colors.textSecondary
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Switch {
                    id: enabledSwitch

                    checked: root.flashcardController.currentDeck.enabled
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    indicator: Rectangle {
                        implicitWidth: 52
                        implicitHeight: 30
                        radius: height / 2

                        color: enabledSwitch.checked
                               ? Theme.colors.primary
                               : Theme.colors.surfaceDisabled

                        border.width: 1
                        border.color: enabledSwitch.checked
                                      ? Theme.colors.primary
                                      : Theme.colors.border

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12

                            y: 3
                            x: enabledSwitch.checked ? parent.width - width - 3 : 3

                            color: "#FFFFFF"

                            border.width: 1
                            border.color: Theme.colors.border

                            Behavior on x {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }

    AppButton {
        text: "Save changes"

        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        Layout.preferredWidth: parent.width / 2
        Layout.preferredHeight: Theme.buttonHeight

        onClicked: {
            root.flashcardController.updateDeck(
                titleField.text,
                subtitleField.text,
                enabledSwitch.checked
            )

            root.back()
        }
    }
}