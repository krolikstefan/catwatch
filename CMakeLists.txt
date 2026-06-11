cmake_minimum_required(VERSION 3.16)

project(KotekWatch LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick QuickControls2)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick QuickControls2)

set(KOTEKWATCH_QML_FILES
    qml/main.qml
    qml/Theme.qml
    qml/WatchBezel.qml
    qml/ScreenClock.qml
    qml/ScreenSteps.qml
    qml/ScreenWeather.qml
    qml/CatSitting.qml
    qml/CatWalking.qml
    qml/PageDots.qml
    qml/qmldir
)

add_executable(KotekWatch
    main.cpp
    watchbackend.cpp
    watchbackend.h
    qml.qrc
)

target_compile_definitions(KotekWatch PRIVATE
    QT_DEPRECATED_WARNINGS
    KOTEKWATCH_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
)

target_link_libraries(KotekWatch PRIVATE
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::QuickControls2
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(KotekWatch)
endif()
