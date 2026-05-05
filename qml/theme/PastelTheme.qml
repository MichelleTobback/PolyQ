import QtQuick

QtObject {

    // ===== BACKGROUND =====
    readonly property color background: "#FFF7FB"
    readonly property color backgroundTop: "#FFF9FC"
    readonly property color backgroundBottom: "#F5EEFF"

    // ===== SURFACES =====
    readonly property color surface: "#FFFFFF"
    readonly property color surfaceAlt: "#FFFAFD"
    readonly property color surfaceSoft: "#FFF4F8"
    readonly property color surfacePressed: "#FDEAF2"
    readonly property color surfaceDisabled: "#F6EDF2"

    readonly property color border: "#EED6E2"
    readonly property color borderSoft: "#F5E3EC"

    // ===== PRIMARY =====
    readonly property color primary: "#F6A5C0"
    readonly property color primaryHover: "#F8B6CC"
    readonly property color primaryPressed: "#E07A9C"

    // ===== SECONDARY =====
    readonly property color secondary: "#C6B7F5"
    readonly property color secondaryPressed: "#A99BE8"

    // ===== STATUS =====
    readonly property color danger: "#F28CA5"
    readonly property color dangerPressed: "#D96E88"

    readonly property color warning: "#F5B27A"
    readonly property color warningPressed: "#D99A5F"

    readonly property color success: "#7BC6AE"
    readonly property color successPressed: "#5DAE95"

    // ===== TEXT =====
    readonly property color textPrimary: "#2F2328"
    readonly property color textSecondary: "#8E6F7C"
    readonly property color textMuted: "#C1A3AF"
    readonly property color textOnPrimary: "#FFFFFF"

    // ===== EFFECTS =====
    readonly property color shadow: "#14000000"  // softer shadow (important!)
}