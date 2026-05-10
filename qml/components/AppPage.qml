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

    property bool showHeader: true
    property bool showBackButton: false
    property int contentSpacing: Theme.spacing

    signal backClicked()

    default property alias content: pageContent.data
    property alias headerRight: headerRightContainer.data
    property alias overlay: overlayLayer.data

    background: Rectangle {
        color: "transparent"
    }

    focus: true

    ColumnLayout {
        anchors.fill: parent
        spacing: root.contentSpacing

        Rectangle {
            id: header

            Layout.fillWidth: true

            Layout.preferredHeight: root.showHeader
                                    ? headerContainer.implicitHeight
                                      + SafeArea.margins.top
                                      + 20
                                    : 0

            visible: true
            clip: true
            opacity: root.showHeader ? 1 : 0

            color: Theme.colors.header
            radius: 0

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: 1
                color: Qt.rgba(1, 1, 1, 0.05)
            }

            ColumnLayout {
                id: headerContainer

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                anchors.leftMargin: Theme.pageMargin
                anchors.rightMargin: Theme.pageMargin
                anchors.bottomMargin: 10

                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

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

                    RowLayout {
                        id: headerRightContainer

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        spacing: 6
                    }
                }
            }
        }

        Item {
            id: contentWrapper

            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: Theme.pageMargin
            Layout.rightMargin: Theme.pageMargin
            Layout.bottomMargin: Theme.pageMargin

            ColumnLayout {
                id: pageContent

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                spacing: Theme.spacing
            }
        }
    }

    Item {
        id: overlayLayer

        anchors.fill: parent
        z: 1000
    }
}