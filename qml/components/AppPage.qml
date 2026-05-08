import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PolyQ.Theme
import PolyQ.Components

Page {
    id: root

    property string pageTitle: ""
    property color titleColor: Theme.colors.textOnPrimary
    property int titleSize: Theme.fontTitle

    property bool showBackButton: false
    property int contentSpacing: Theme.spacing

    signal backClicked()

    default property alias content: contentColumn.data
    property alias headerRight: headerRightContainer.data

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: root.contentSpacing

        // Header
        Rectangle {
            Layout.fillWidth: true

            color: Theme.colors.header

            radius: 0

            implicitHeight: headerContainer.implicitHeight + 20

            // subtle bottom separator
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: 1
                color: Qt.rgba(1, 1, 1, 0.05)
            }

            ColumnLayout {
                id: headerContainer

                anchors.fill: parent

                anchors.leftMargin: Theme.pageMargin
                anchors.rightMargin: Theme.pageMargin
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    // Back button
                    AppIconButton {
                        visible: root.showBackButton

                        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Return.svg"
                        iconColor: Theme.colors.textOnPrimary

                        showBackground: false
                        showBorder: false

                        width: 40
                        height: 40

                        backgroundColor: Qt.rgba(1, 1, 1, 0.06)
                        pressedColor: Qt.rgba(1, 1, 1, 0.12)

                        onClicked: root.backClicked()
                    }

                    // Title section
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: root.pageTitle

                            font.pixelSize: root.titleSize
                            font.bold: true

                            color: root.titleColor

                            elide: Text.ElideRight

                            Layout.fillWidth: true
                        }
                    }

                    // Right-side actions
                    RowLayout {
                        id: headerRightContainer

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        spacing: 6
                    }
                }
            }
        }

        // Page content
        ColumnLayout {
            id: contentColumn

            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: Theme.pageMargin
            Layout.rightMargin: Theme.pageMargin
            Layout.bottomMargin: Theme.pageMargin

            spacing: Theme.spacing
        }
    }
}