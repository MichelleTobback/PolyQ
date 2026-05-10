import QtQuick

QtObject {
    
    // ===== BACKGROUND =====
    readonly property int backgroundType: 1
    readonly property color background: "#17141C"
    readonly property color backgroundTop: "#1D1924"
    readonly property color backgroundBottom: "#141018"

    // ===== SURFACES =====
    readonly property color header: "#322c38"

    readonly property color surface: "#241F2B"
    readonly property color surfaceAlt: "#2B2533"
    readonly property color surfaceSoft: "#312A3A"
    readonly property color surfacePressed: "#3A3244"
    readonly property color surfaceDisabled: "#221D28"

    readonly property color border: "#3E3447"
    readonly property color borderSoft: "#4A3E56"

    // ===== PRIMARY =====
    readonly property color primary: "#F29DBB"
    readonly property color primaryHover: "#F6AEC8"
    readonly property color primaryPressed: "#D97C9F"

    // ===== SECONDARY =====
    readonly property color secondary: "#B7A8F2"
    readonly property color secondaryPressed: "#9789DA"

    // ===== STATUS =====
    readonly property color danger: "#F08AA7"
    readonly property color dangerPressed: "#D46C89"
    readonly property color dangerSoft: "#FFE7EB"

    readonly property color warning: "#F0B07A"
    readonly property color warningPressed: "#D7955E"

    readonly property color success: "#79C7AD"
    readonly property color successPressed: "#5FAF95"
    readonly property color successSoft: "#E7F8ED"

    // ===== TEXT =====
    readonly property color textPrimary: "#F5EEF5"
    readonly property color textSecondary: "#C8B7C4"
    readonly property color textMuted: "#8E7E8A"
    readonly property color textOnPrimary: "#FFFFFF"

    // ===== EFFECTS =====
    readonly property color shadow: "#50000000"
}