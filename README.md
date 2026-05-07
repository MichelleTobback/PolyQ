# PolyQ

<div align="center">

![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![C++17](https://img.shields.io/badge/C%2B%2B-17-%23007ACC.svg)
![Qt](https://img.shields.io/badge/Qt-6.x-41B0F1.svg)
![CMake](https://img.shields.io/badge/CMake-3.16%2B-6D4C41.svg)
![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20Linux%20%7C%20Android-lightgrey.svg)

### Modern, gamified language learning — built with C++ & Qt/QML

PolyQ is a modern flashcard and language-learning application focused on clean architecture, polished UI/UX and scalable review systems.

</div>

---

# ✨ Features

## Currently implemented

- Modern Qt Quick / QML UI
- Reusable themed component system
- Deck & flashcard management
- SQLite-backed persistent storage
- Spaced repetition review system
- Endless review mode
- Rating-based reviews (`Again`, `Hard`, `Good`, `Easy`)
- Theme system with multiple themes
- Cross-platform CMake setup
- Android builds through Qt Creator
- Mobile-friendly UI architecture
- Review progress tracking

## In progress / planned

- Typed-answer review mode
- Configurable typo forgiveness
- Flashcard editing & management
- Learning statistics & progress tracking
- XP, streaks and progression systems
- iOS deployment support
- Speech/pronunciation-assisted reviews
- Cloud sync & accounts
- Downloadable/shareable themes
- Advanced analytics & dashboards

---

# 📸 Screenshots

> TODO: Add screenshots and previews


---


## Core architecture principles

- Modular QML-first UI
- Reusable components & layouts
- Decoupled persistence layer
- Clean separation of concerns
- Mobile-ready structure
- Scalable review systems

---

# 📁 Project Structure

```text
PolyQ/
├── CMakeLists.txt
├── LICENSE
├── README.md
│
├── src/
│   ├── Controllers/
│   ├── Model/
│   ├── Repository/
│   ├── Review/
│   └── ViewModel/
│
├── qml/
│   ├── components/
│   ├── pages/
│   └── theme/
│
└── resources/
```

---

# 🧠 Review System

PolyQ includes a spaced repetition review system built around rating-based review actions:

- `Again`
- `Hard`
- `Good`
- `Easy`

The review architecture is designed to remain modular and extensible for future experimentation with scheduling algorithms and review modes.

## Planned review modes

- Typed-answer review mode
- Endless review mode improvements
- Pronunciation/speech-assisted review
- Configurable typo tolerance

---

# 🎨 UI System

The UI is built entirely with reusable QML components and shared theme systems.

## QML Modules

| Module | Purpose |
|---|---|
| `PolyQ` | Main application |
| `PolyQ.Components` | Reusable UI components |
| `PolyQ.Pages` | Top-level screens/pages |
| `PolyQ.Theme` | Shared themes & styling |

---

# ⚙️ Tech Stack

| Category | Technology |
|---|---|
| Language | C++17 |
| UI | Qt Quick / QML |
| Framework | Qt 6 |
| Build System | CMake |
| Models | QAbstractListModel |
| Persistence | SQLite |
| Platforms | Windows / Linux / Android |
| Planned Mobile | iOS |

---

# 🚀 Getting Started

## Prerequisites

- Qt 6.10+
- CMake 3.16+
- Ninja
- C++17 compiler

Supported compilers:

- MSVC
- Clang
- GCC

---

## Clone

```bash
git clone <repository-url>
cd PolyQ
```

---

## Build

### Using CMake

```bash
cmake -B build -S . -G "Ninja" -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

### Run

```bash
./build/appPolyQ
```

On Windows:

```bash
build/appPolyQ.exe
```

---

## Open in Qt Creator

1. Open Qt Creator
2. Open `CMakeLists.txt`
3. Select a Qt 6 kit
4. Build & run `appPolyQ`

---

# 📱 Android Support

PolyQ already supports Android builds through Qt Creator and Qt's Android toolchain.

## Android workflow

1. Install:
   - Qt for Android
   - Android SDK
   - Android NDK
   - JDK

2. Configure Android kits inside Qt Creator

3. Build and deploy directly to:
   - Android devices
   - Android emulators

The UI architecture is designed to remain responsive and mobile-friendly across different screen sizes.

---

# 💾 Persistence

PolyQ uses SQLite for persistent local storage.

Current persistence includes:

- Deck storage
- Flashcard storage
- Repository abstraction layer
- SQLite-backed repository implementation

The persistence layer is intentionally modular to support future:

- Cloud sync
- JSON import/export
- Backup systems
- Multi-device synchronization

---

# 📊 Planned Systems

## Learning & Progression

- XP system
- Learning streaks
- Session tracking
- Study analytics
- Progress graphs

## Review Systems

- Typed reviews
- Pronunciation reviews
- Advanced scheduling experiments
- Endless review improvements

## Customization

- Shareable themes
- Downloadable themes
- UI customization
- Accessibility settings

---

# 🧩 Important Files

| File | Purpose |
|---|---|
| `src/Controllers/FlashcardController.*` | Main application controller |
| `src/ViewModel/DeckModel.*` | Deck list model |
| `src/ViewModel/FlashcardListModel.*` | Flashcard list model |
| `src/Repository/IDeckRepository.h` | Persistence abstraction |
| `qml/Main.qml` | QML entrypoint |
| `qml/pages/ReviewPage.qml` | Review UI |
| `qml/theme/Theme.qml` | Shared theme system |

---

# 🤝 Contributing

Contributions, ideas and feedback are welcome.

## Guidelines

- Keep architecture modular
- Prefer reusable components
- Keep UI logic in QML
- Keep business logic in C++
- Keep commits focused and reviewable

## Development focus areas

- Review algorithms
- Mobile support
- Performance improvements
- UI polish
- Statistics & analytics
- Accessibility

---

# 📄 License

Licensed under the Apache License 2.0.

See [`LICENSE`](LICENSE) for details.

---

# 👤 Maintainer

Maintained by the project owner.

GitHub: https://github.com/MichelleTobback

---

<div align="center">

### Built with Qt, QML and modern C++

PolyQ is actively evolving into a polished, scalable and cross-platform language-learning platform.

</div>