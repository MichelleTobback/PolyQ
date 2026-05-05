cmake_minimum_required(VERSION 3.16)

project(PolyQ VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appPolyQ
    src/main.cpp
    src/Controllers/FlashcardController.cpp
    src/Controllers/FlashcardController.h
    src/Model/Deck.h
    src/ViewModel/DeckModel.h
)

qt_add_qml_module(appPolyQ
    URI PolyQ
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/PolyQ
    QML_FILES
        qml/Main.qml
)

qt_add_qml_module(appPolyQComponents
    URI PolyQ.Components
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/PolyQ/Components
    QML_FILES
        qml/components/AppButton.qml
        qml/components/AppIconButton.qml
        qml/components/AppBackButton.qml
        qml/components/AppCard.qml
        qml/components/AppPage.qml
        qml/components/DeckCard.qml
        qml/components/FlashcardView.qml
)

set(qml_singletons
    qml/theme/Theme.qml
)
set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appPolyQTheme
    URI PolyQ.Theme
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/PolyQ/Theme
    QML_FILES
        ${qml_singletons}
        qml/theme/PastelTheme.qml
        qml/theme/DarkTheme.qml
)

qt_add_qml_module(appPolyQPages
    URI PolyQ.Pages
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/PolyQ/Pages
    QML_FILES
        qml/pages/HomePage.qml
        qml/pages/DeckPage.qml
        qml/pages/ReviewPage.qml
        qml/pages/SettingsPage.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPolyQ PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPolyQ
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPolyQ
    PRIVATE Qt6::Quick
)

install(TARGETS appPolyQ
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
