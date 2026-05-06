
# PolyQ

![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg) ![C++17](https://img.shields.io/badge/C%2B%2B-17-%23007ACC.svg) ![Qt](https://img.shields.io/badge/Qt-6.x-41B0F1.svg) ![CMake](https://img.shields.io/badge/CMake-3.16%2B-6D4C41.svg) ![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)

Modern, gamified language learning — built with C++ & Qt/QML

PolyQ is a lightweight, developer-friendly prototype of a gamified flashcard app. It combines a QML-first UI with a small C++ core (controllers, view-models and repository abstractions) to deliver a modular starting point for language-learning apps using spaced repetition and rating-based reviews.

> Note: This repository contains a functional UI, view-models and a mock repository (in-memory). Persistent storage and advanced SRS/analytics are intentionally scaffolded and planned as next steps.

Badges
- Qt: 6.x (project configured for Qt 6.10+)
- C++: C++17
- License: Apache-2.0 (see `LICENSE`)

Screenshots / Preview
---------------------

TODO: add sample screenshots to `assets/` and reference them here.

Key Features (implemented / scaffolded)
--------------------------------------
- Flashcard & deck data model (`src/Model/Flashcard.h`, `src/Model/Deck.h`)
- View models: `FlashcardListModel` and `DeckModel` exposed to QML for declarative lists
- `FlashcardController` — C++ controller exposed to QML (`PolyQ.Controllers`) that drives review flow and deck management
- Repository abstraction `IDeckRepository` with an in-memory `MockDeckRepository` for rapid development and testing (`src/Repository`)
- QML-first UI organized into modules: `PolyQ` (app), `PolyQ.Components`, `PolyQ.Theme`, `PolyQ.Pages`
- Modern themed QML components and layout primitives (`qml/components`, `qml/theme`)
- Rating-based review API (reviewAgain, reviewHard, reviewGood, reviewEasy) — hooks for an SRS algorithm
- Modular CMake + Qt setup ready for extension to real persistence (SQLite/JSON) and services

Tech stack
----------
- Language: C++17
- UI: Qt Quick / QML (Qt 6)
- Build system: CMake (minimum 3.16) — project uses `qt_add_qml_module` and `qt_add_executable`
- Runtime: Qt 6 Quick
- Persistence: currently mocked (`MockDeckRepository`) — intended migration to SQLite or JSON

Project layout (overview)
-------------------------

Top-level
- `CMakeLists.txt` — build and QML module configuration
- `README.md` — this file
- `LICENSE` — Apache-2.0

Primary folders
- `src/` — C++ sources and headers
  - `Controllers/` — `FlashcardController` (exposed to QML)
  - `ViewModel/` — `DeckModel`, `FlashcardListModel`
  - `Repository/` — `IDeckRepository`, `MockDeckRepository` (in-memory sample data)
  - `Model/` — `Deck`, `Flashcard` structs
- `qml/` — QML UI, split into pages and components
  - `qml/pages/` — top-level pages (`HomePage.qml`, `DeckPage.qml`, `ReviewPage.qml`, `SettingsPage.qml`)
  - `qml/components/` — reusable UI widgets (buttons, cards, tab bar)
  - `qml/theme/` — theme singletons (`Theme.qml`, `PastelTheme.qml`, `DarkTheme.qml`)

Getting started (developer)
---------------------------

Prerequisites
- Qt 6 (6.10 or later recommended)
- CMake 3.16+
- Ninja (project configured for Ninja generator)
- A C++17-capable compiler (MSVC / clang / gcc)

Clone
```bash
git clone --depth 1 .
```

Build with CMake (CLI)
```bash
# from repository root
cmake -B build -S . -G "Ninja" -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# On Windows the executable will be in build/ (e.g. build/appPolyQ.exe)
# On macOS/Linux run the generated binary from the build directory.
```

Open in Qt Creator
1. Launch Qt Creator
2. Open `CMakeLists.txt` from the repository root
3. Configure kit (Qt 6) and build/run the `appPolyQ` target

Running
- Use the Qt Creator run action or execute the built binary directly from the `build/` directory.
- The QML entrypoint is configured at `qml/Main.qml` and registered via CMake (`qt_add_qml_module`).

Mobile & packaging
------------------

PolyQ is designed with mobile deployment in mind (Android and iOS). The project uses Qt Quick and CMake which work well with Qt's mobile toolchains. Typical workflow:

- Android (recommended workflow):
  - Install Qt for Android (Qt 6 Android kits), Android SDK, NDK and a JDK.
  - Configure Android kits in Qt Creator and select an Android kit for the project.
  - Build and deploy from Qt Creator to an emulator or device; Qt Creator handles packaging into an APK.

- iOS (macOS required):
  - Use a macOS host with Xcode and Qt for iOS installed.
  - Configure an iOS kit in Qt Creator, then build and run on simulator or device. Code signing and provisioning profiles are required for device deployment.

Notes:
- Use Qt Creator for first-time packaging — it abstracts much of the platform setup. The CMake/Ninja workflow continues to work under the selected kit.
- For CI or automated builds, consider using Qt's tooling for Android/iOS or platform-specific build runners on macOS for iOS.

Usage (overview)
-----------------

- Creating decks and cards
  - The repository exposes `FlashcardController.createDeck(name)` and `createCard(front, back)` which are wired to the UI. The current default repository is a mock (in-memory) implementation: `src/Repository/MockDeckRepository.*`.

- Reviewing
  - The review flow is controlled by `FlashcardController` and exposes rating methods:
    - `reviewAgain()`
    - `reviewHard()`
    - `reviewGood()`
    - `reviewEasy()`
  - These functions are currently hooks for a spaced repetition system (SRS). A basic next-card rotation is implemented; an advanced scheduling strategy is planned.

- UI
  - Pages live in `qml/pages/` and use components in `qml/components/` and theme values from `qml/theme/`.
  - The app registers `PolyQ.Controllers.FlashcardController` for use in QML (`src/main.cpp`).

Architecture overview
---------------------

- Controller / ViewModel / Repository separation:
  - `FlashcardController` acts as the application-level controller and binds C++ models to QML.
  - `FlashcardListModel` and `DeckModel` implement QAbstractItemModel-based view models for declarative QML lists.
  - `IDeckRepository` abstracts persistence; `MockDeckRepository` is the current implementation for development and testing.

- QML modularization:
  - The app is packaged as multiple QML modules (`PolyQ`, `PolyQ.Components`, `PolyQ.Theme`, `PolyQ.Pages`) via CMake to keep UI code organized and reusable.

- Persistence & SRS:
  - Persistence is currently mocked. The repository API is intentionally small and easy to replace with a real backend (SQLite, JSON file, or remote service).
  - Review rating API provides clear hooks for integrating a full SRS algorithm (e.g. SM-2 or custom scheduling).

Roadmap (planned / suggested)
----------------------------

- Persistent local storage (SQLite or JSON-backed repository implementation)
- Real spaced repetition implementation (SM-2 or custom algorithm, per-card scheduling)
- Enhanced statistics/dashboards and progress visualizations
- Gamification: XP, levels, streaks
- Optional speech/pronunciation review mode (speech recognition integration)
- Mobile packaging & platform-specific touches (iOS / Android via Qt)
- Cloud sync & account system (opt-in)

Contributing
------------

Short guide:
- Open an issue to discuss significant changes or features.
- Fork the repository and create feature branches for PRs.
- Follow existing style: modern C++ (C++17), Qt & QML for UI, keep ViewModel code in `src/ViewModel` and UI in `qml/`.
- Keep changes focused and add small, reviewable commits.

If you want to help implement persistence or SRS features, open an issue to coordinate.

License
-------

This project is licensed under the Apache License 2.0 — see `LICENSE` in the repository root.

Maintainer
----------

Repository maintained by the project owner. See repository metadata for contact and contribution details.

Further reading / reference files
--------------------------------
- `CMakeLists.txt` — build configuration and QML module registration
- `src/Controllers/FlashcardController.*` — controller + review hooks
- `src/Repository/IDeckRepository.h` — repository interface
- `src/Repository/MockDeckRepository.*` — in-memory sample repository
- `qml/pages/DeckPage.qml`, `qml/pages/ReviewPage.qml` — example pages and UX patterns

Thank you for checking out PolyQ. Contributions, issues and feature ideas are welcome.

