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

    background: Rectangle {
        color: Theme.colors.background
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.pageMargin
        spacing: Theme.spacing

        RowLayout {
            Layout.fillWidth: true

            AppBackButton {
                onClicked: root.back()
            }

            Text {
                text: "Edit deck"
                font.pixelSize: Theme.fontHeading
                font.bold: true
                color: Theme.colors.textPrimary
                Layout.fillWidth: true
            }
        }

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

                TextField {
                    id: titleField

                    Layout.fillWidth: true
                    text: root.flashcardController.currentDeck.title
                    placeholderText: "Deck title"

                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textPrimary

                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter

                    background: Rectangle {
                        implicitHeight: 44
                        radius: Theme.radiusMedium
                        color: Theme.colors.surfaceVariant
                        border.width: 1
                        border.color: titleField.activeFocus ? Theme.colors.primary : Theme.colors.border
                    }
                }

                TextArea {
                    id: subtitleField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 110

                    text: root.flashcardController.currentDeck.subtitle
                    placeholderText: "Subtitle or description"

                    wrapMode: TextArea.Wrap
                    font.pixelSize: Theme.fontBody
                    color: Theme.colors.textPrimary

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    background: Rectangle {
                        radius: Theme.radiusMedium
                        color: Theme.colors.surfaceVariant
                        border.width: 1
                        border.color: subtitleField.activeFocus ? Theme.colors.primary : Theme.colors.border
                    }
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

                    Switch {
                        id: enabledSwitch

                        checked: root.flashcardController.currentDeck.enabled

                        indicator: Rectangle {
                            implicitWidth: 52
                            implicitHeight: 30
                            radius: height / 2

                            color: enabledSwitch.checked
                                   ? Theme.colors.primary
                                   : Theme.colors.surfaceVariant

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
            Layout.fillWidth: true

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
}