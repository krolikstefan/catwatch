cmake_minimum_required(VERSION 3.21)

project(KotekWatchFrontend LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Network Quick QuickControls2)

qt_standard_project_setup()

qt_add_executable(kotekwatch-frontend
    src/main.cpp
    src/ApiClient.cpp
    src/ApiClient.h
)

set_source_files_properties(qml/Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(kotekwatch-frontend
    URI KotekWatch
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Theme.qml
        qml/ActivityScreen.qml
        qml/WeatherScreen.qml
        qml/RelaxScreen.qml
        qml/components/PillBadge.qml
        qml/components/PrimaryButton.qml
        qml/components/SecondaryButton.qml
        qml/components/CircularProgress.qml
        qml/components/NavDots.qml
        qml/components/IconCircle.qml
        qml/components/BottomNavBar.qml
    RESOURCES
        assets/icons/sun-happy.png
        assets/icons/star.png
        assets/icons/cloud-rain.png
        assets/icons/music-note.png
        assets/icons/moon.png
        assets/icons/heart.png
        assets/icons/cloud-happy.png
        assets/icons/flame.png
        assets/icons/paw.png
        assets/backgrounds/bg-rain.png
        assets/backgrounds/bg-night.png
        assets/backgrounds/bg-sun.png
        assets/illustrations/kitten-watermelon.png
        assets/illustrations/kitten-tea.png
        assets/illustrations/kitten-paws-up.png
        assets/illustrations/kitten-pointing.png
        assets/illustrations/kitten-heart.png
        assets/illustrations/kitten-headphones.png
        assets/illustrations/kitten-waving.png
        assets/illustrations/kitten-meditating.png
        assets/icons/transparent/sun-happy.png
        assets/icons/transparent/star.png
        assets/icons/transparent/cloud-rain.png
        assets/icons/transparent/music-note.png
        assets/icons/transparent/moon.png
        assets/icons/transparent/heart.png
        assets/icons/transparent/cloud-happy.png
        assets/icons/transparent/flame.png
        assets/icons/transparent/paw.png
        assets/illustrations/transparent/kitten-watermelon.png
        assets/illustrations/transparent/kitten-tea.png
        assets/illustrations/transparent/kitten-paws-up.png
        assets/illustrations/transparent/kitten-pointing.png
        assets/illustrations/transparent/kitten-heart.png
        assets/illustrations/transparent/kitten-headphones.png
        assets/illustrations/transparent/kitten-waving.png
        assets/illustrations/transparent/kitten-meditating.png
        assets/fonts/README.md
)

target_link_libraries(kotekwatch-frontend PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Network
    Qt6::Quick
    Qt6::QuickControls2
)

target_compile_definitions(kotekwatch-frontend PRIVATE QT_QML_DEBUG)

set_target_properties(kotekwatch-frontend PROPERTIES
    OUTPUT_NAME "kotekwatch-frontend"
)
