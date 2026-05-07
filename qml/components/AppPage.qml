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

    signal backClicked()

    default property alias content: contentColumn.data
    property alias headerRight: headerRightContainer.data

    background: Loader {
        sourceComponent: Theme.colors.backgroundType === 1
                         ? solidBackgroundComponent
                         : animatedBackgroundComponent
    }

    Component {
        id: solidBackgroundComponent

        Rectangle {
            color: Theme.colors.background
        }
    }

    Component {
        id: animatedBackgroundComponent

        PageBackground {
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacing

        Rectangle {
            Layout.fillWidth: true

            color: Theme.colors.header

            implicitHeight: headerLayout.implicitHeight + 12

            ColumnLayout {
                id: headerLayout

                anchors.fill: parent

                anchors.leftMargin: Theme.pageMargin
                anchors.rightMargin: Theme.pageMargin
                anchors.topMargin: 6
                anchors.bottomMargin: 10

                spacing: 2

                RowLayout {
                    Layout.fillWidth: true

                    AppIconButton {
                        opacity: root.showBackButton ? 1.0 : 0.0
                        enabled: root.showBackButton

                        iconSource: "qrc:/qt/qml/PolyQ/resources/icons/Return.svg"
                        iconColor: Theme.colors.textOnPrimary

                        showBackground: false
                        showBorder: false

                        onClicked: root.backClicked()
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        id: headerRightContainer

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                        implicitWidth: children.length > 0
                                       ? children[0].implicitWidth
                                       : 0

                        implicitHeight: children.length > 0
                                        ? children[0].implicitHeight
                                        : 0
                    }
                }

                Text {
                    text: root.pageTitle

                    font.pixelSize: root.titleSize
                    font.bold: true

                    color: root.titleColor

                    Layout.fillWidth: true
                }
            }
        }

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